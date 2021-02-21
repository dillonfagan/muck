require "kemal"
require "json"
require "./entry"

class DeleteMessage
  include JSON::Serializable
  property deleted : Entry?

  def initialize(@deleted : Entry?)
  end
end

store = Hash(String, String).new

store["username"] = "bob"
store["password"] = "Pa$$w0rd"

get "/" do |env|
  env.response.content_type = "application/json"
  store.to_json
end

get "/:key" do |env|
  key = env.params.url["key"]
  env.response.content_type = "application/json"
  Entry.new(key, store[key]).to_json
end

put "/" do |env|
  entry = Entry.from_json env.request.body.not_nil!
  store[entry.key] = entry.value

  env.response.content_type = "application/json"
  entry.to_json
end

patch "/:key" do |env|
  key = env.params.url["key"]
  store[key] = env.params.json["value"].as(String)

  env.response.content_type = "application/json"
  Entry.new(key, store[key]).to_json
end

delete "/:key" do |env|
  key = env.params.url["key"]
  entry = remove_entry store, key

  env.response.content_type = "application/json"
  DeleteMessage.new(entry).to_json
end

def remove_entry(store : Hash(String, String), key : String) : Entry | Nil
  value = store.delete key
  return nil if value.nil?
  return Entry.new(key, value.as(String))
end

Kemal.run