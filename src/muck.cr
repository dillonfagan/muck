require "kemal"
require "json"
require "./entry"

store = Hash(String, String).new

store["username"] = "bob"
store["password"] = "Pa$$w0rd"

get "/" do |env|
  env.response.content_type = "application/json"
  store.to_json
end

put "/" do |env|
  entry = Entry.from_json env.request.body.not_nil!
  store[entry.key] = entry.value
  entry.to_json
end

Kemal.run