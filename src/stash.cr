require "./store"

class Stash
    @stash : Hash(String, Store)

    def initialize
        @stash = Hash(String, Store).new
    end

    def stores
        return @stash.keys
    end

    def in(store : String) : Store
        return @stash[store]
    end

    def add_store(store : String)
        @stash[store] = Store.new
    end
end