require "json"
require "./entry"

class DeleteMessage
    include JSON::Serializable
    property deleted : Entry?
  
    def initialize(@deleted : Entry?)
    end
  end