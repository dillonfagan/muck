require "json"
require "./entry"

class PatchMessage
    include JSON::Serializable
    property before : Entry?
    property after : Entry?

    def initialize(@before : Entry?, @after : Entry?)
    end
end