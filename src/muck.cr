require "kemal"
require "json"
require "./entry"
require "./message"
require "./stash"

stash = Stash.new
stash.add_store "default"

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do |env|
  stash.stores.to_json
end

get "/:store" do |env|
  store = env.params.url["store"]
  stash.in(store).get_all.to_json
end

get "/:store/:key" do |env|
  store = env.params.url["store"]
  key = env.params.url["key"]
  stash.in(store).get(key).to_json
end

put "/:store" do |env|
  store = env.params.url["store"]
  entry = Entry.from_json env.request.body.not_nil!
  stash.in(store).add(entry).to_json
end

patch "/:store/:key" do |env|
  store = env.params.url["store"]
  key = env.params.url["key"]
  value = env.params.json["value"].as(String)

  before = stash.in(store).update key, value
  after = stash.in(store).get key
  Message::Patch.new(before, after).to_json
end

delete "/:store/:key" do |env|
  store = env.params.url["store"]
  key = env.params.url["key"]
  entry = stash.in(store).delete key
  Message::Delete.new(entry).to_json
end

Kemal.run