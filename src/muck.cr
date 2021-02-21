require "kemal"
require "json"
require "./entry"
require "./patch_message"
require "./delete_message"

store = Hash(String, String).new

store["username"] = "bob"
store["password"] = "Pa$$w0rd"

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do |env|
  store.to_json
end

get "/:key" do |env|
  key = env.params.url["key"]
  Entry.new(key, store[key]).to_json
end

put "/" do |env|
  entry = Entry.from_json env.request.body.not_nil!
  store[entry.key] = entry.value
  entry.to_json
end

patch "/:key" do |env|
  key = env.params.url["key"]

  before = Entry.new(key, store[key])
  store[key] = env.params.json["value"].as(String)
  after = Entry.new(key, store[key])

  PatchMessage.new(before, after).to_json
end

delete "/:key" do |env|
  key = env.params.url["key"]
  entry = remove_entry store, key
  DeleteMessage.new(entry).to_json
end

def remove_entry(store : Hash(String, String), key : String) : Entry | Nil
  value = store.delete key
  return nil if value.nil?
  return Entry.new(key, value.as(String))
end

Kemal.run