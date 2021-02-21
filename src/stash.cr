require "./store"

class Stash
    @stash : Hash(String, Store)

    def initialize
        @stash = Hash(String, Store).new
    end

    def in(store : String) : Store
        return @stash[store]
    end

    def create(store : String)
        @stash[store] = Store.new
    end
end