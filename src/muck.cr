require "kemal"
require "json"
require "./entry"
require "./message"
require "./store"

store = Store.instance

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do |env|
  store.get_all.to_json
end

get "/:key" do |env|
  key = env.params.url["key"]
  store.get(key).to_json
end

put "/" do |env|
  entry = Entry.from_json env.request.body.not_nil!
  store.add(entry).to_json
end

patch "/:key" do |env|
  key = env.params.url["key"]
  value = env.params.json["value"].as(String)
  before = store.update key, value
  after = store.get key
  Message::Patch.new(before, after).to_json
end

delete "/:key" do |env|
  key = env.params.url["key"]
  entry = store.delete key
  Message::Delete.new(entry).to_json
end

Kemal.run