module Mongoid
  class Transaction

    #Tokumx supports 3 isolation levels. default is mvcc
    ISOLATIOAN_LEVELS = ['mvcc', 'serializable', 'readUncommitted']
    def self.execute(isolation_level = "mvcc", &block)
      session =  Mongoid.default_session
      isolation_level = isolation_level
      raise 'Invalid isolation level' unless ISOLATIOAN_LEVELS.include? isolation_level
      # If transaction is not supported excute queries by default behaviour of
      # mongo
      yield(block) and return unless transaction_supported?(session, isolation_level)
      begin
        # Transaction is started when we called transaction_supported? so yield
        # block here
        yield(block)
        commit_transaction(session)
        true
      rescue Exception => e
        p e
        rollback_transaction(session)
        false
      end
    end

    def self.transaction_supported?(session, isolation_level)
      begin
        begin_transaction(session, isolation_level)
        true
      rescue Exception => e
        p e
        false
      end
    end

    def self.begin_transaction(session, isolation_level)
      message= session.command({"beginTransaction" => 1, isolation: isolation_level})
      p message
    end

    def self.commit_transaction session
      message = session.command({"commitTransaction" => 1})
      p message
    end

    def self.rollback_transaction session
      message = session.command({"rollbackTransaction" => 1})
      p message
    end
  end
end
