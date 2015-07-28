module Mongoid
  class Transaction

    #Tokumx supports 3 isolation levels. default is mvcc
    ISOLATIOAN_LEVELS = ['mvcc', 'serializable', 'readUncommitted']
    def self.execute(isolation_level = "mvcc", &block)
      session =  Mongoid.default_session
      raise 'Invalid isolation level' unless ISOLATIOAN_LEVELS.include? isolation_level
      # If transaction is not supported excute queries by default behaviour of
      # mongo
      if transaction_supported?(session, isolation_level)
        begin
          # Transaction is started when we called transaction_supported? so yield
          # block here
          yield(block)
          commit_transaction(session)
          true
        rescue Exception => e
          rollback_transaction(session) 
          raise e
        end
      else
        yield(block)  
      end
    end

    private

    def self.transaction_supported?(session, isolation_level)
      begin
        begin_transaction(session, isolation_level)
        true
      rescue Exception => e
        if e.as_json['details']['errmsg'].include? 'no such cmd'
          false
        else
          raise e
        end
      end
    end

    def self.begin_transaction(session, isolation_level)
      message= session.command({beginTransaction: 1, isolation: isolation_level})
    end

    def self.commit_transaction session
      message = session.command({commitTransaction: 1})
    end

    def self.rollback_transaction session
      message = session.command({rollbackTransaction: 1})
    end
  end
end
