require "kemal"
require "json"

store = Hash(String, String).new

store["username"] = "bob"
store["password"] = "Pa$$w0rd"

get "/" do |env|
  env.response.content_type = "application/json"
  store.to_json
end

Kemal.run