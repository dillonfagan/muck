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

    def rename_store(store : String, new_name : String) : Store
        swap = @stash[store]
        @stash.delete store
        @stash[new_name] = swap
        return @stash[new_name]
    end
end