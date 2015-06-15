module MongoidTransaction
  class Transaction
    def self.transaction(isolation_level = "mvcc", &block)
      @session =  Mongoid.default_session
      @isolation_level = isolation_level
      raise 'Invalid isolation level' unless ['mvcc','serializable','readUncommitted'].include? @isolation_level
      yield(block) and return unless transaction_supported?
      begin
        yield(block)
        commit_transaction
        true
      rescue Exception => e
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
    end

    def self.commit_transaction
      @session.command({"commitTransaction" => 1})
    end

    def self.rollback_transaction
      @session.command({"rollbackTransaction" => 1})
    end
  end
end
