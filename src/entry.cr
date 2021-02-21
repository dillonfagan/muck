require "json"

class Entry
    include JSON::Serializable
    property key : String, value : String

    def initialize(@key : String, @value : String)
    end
end