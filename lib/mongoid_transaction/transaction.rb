module MongoidTransaction
  class Transaction
    def self.transaction(&block)
      @client =  Mongoid.default_client
      yield(block) and return unless transaction_supported?
      begin
        yield(block)
        commit_transaction
        p "commited"
        true
      rescue Exception => e
        rollback_transaction
        p e
        p "rollbacked"
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
      @client.command({"beginTransaction" => 1})
    end

    def self.commit_transaction
      @client.command({"commitTransaction" => 1})
    end

    def self.rollback_transaction
      @client.command({"rollbackTransaction" => 1})
    end
  end
end
