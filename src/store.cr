require "./entry"

class Store
    @@instance : Store?
    @entries : Hash(String, String)

    protected def initialize
        @entries = Hash(String, String).new
    end

    def self.instance : Store
        @@instance = Store.new if @@instance.nil?
        return @@instance.as(Store)
    end

    def get_all : Hash(String, String)
        return @entries
    end

    def get(key : String) : Entry
        return Entry.new(key, @entries[key])
    end

    def add(entry : Entry) : Entry
        @entries[entry.key] = entry.value
        return entry
    end

    def update(key : String, new_value : String) : Entry
        before = Entry.new key, @entries[key]
        @entries[key] = new_value
        return before
    end

    def delete(key : String) : Entry?
        value = @entries.delete key
        return nil if value.nil?
        return Entry.new(key, value.as(String))
    end
end