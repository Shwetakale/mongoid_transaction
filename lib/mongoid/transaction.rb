module Mongoid
  class Transaction

    #Tokumx supports 3 isolation levels. default is mvcc
    ISOLATIOAN_LEVELS = ['mvcc', 'serializable', 'readUncommitted']
    def self.execute(isolation_level = "mvcc", &block)
      @session =  Mongoid.default_session
      @isolation_level = isolation_level
      raise 'Invalid isolation level' unless ISOLATIOAN_LEVELS.include? @isolation_level
      # If transaction is not supported excute queries by default behaviour of
      # mongo
      yield(block) and return unless transaction_supported?
      begin
        # Transaction is started when we called transaction_supported? so yield
        # block here
        yield(block)
        commit_transaction
        true
      rescue Exception => e
        p e.to_s
        rollback_transaction
        false
      end
    end

    def self.transaction_supported?
      begin
        begin_transaction
        true
      rescue Exception => e
        false
      end
    end

    def self.begin_transaction
      @session.command({"beginTransaction" => 1, isolation: @isolation_level})
      p "Begin Transaction"
    end

    def self.commit_transaction
      @session.command({"commitTransaction" => 1})
      p "Commit Transaction"
    end

    def self.rollback_transaction
      @session.command({"rollbackTransaction" => 1})
      p "Rollback Transaction"
    end
  end
end
