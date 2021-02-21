require "json"
require "./entry"

module Message
    class Patch
        include JSON::Serializable
        property before : Entry?
        property after : Entry?
    
        def initialize(@before : Entry?, @after : Entry?)
        end
    end

    class Delete
        include JSON::Serializable
        property deleted : Entry?
      
        def initialize(@deleted : Entry?)
        end
    end
end