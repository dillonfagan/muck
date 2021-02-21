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

get "/:stash" do |env|
  stash_name = env.params.url["stash"]
  stash.in(stash_name).get_all.to_json
end

get "/:stash/:key" do |env|
  stash_name = env.params.url["stash"]
  key = env.params.url["key"]
  stash.in(stash_name).get(key).to_json
end

put "/:stash" do |env|
  stash_name = env.params.url["stash"]
  entry = Entry.from_json env.request.body.not_nil!
  stash.in(stash_name).add(entry).to_json
end

patch "/:stash/:key" do |env|
  stash_name = env.params.url["stash"]
  key = env.params.url["key"]
  value = env.params.json["value"].as(String)

  before = stash.in(stash_name).update key, value
  after = stash.in(stash_name).get key
  Message::Patch.new(before, after).to_json
end

delete "/:stash/:key" do |env|
  stash_name = env.params.url["stash"]
  key = env.params.url["key"]
  entry = stash.in(stash_name).delete key
  Message::Delete.new(entry).to_json
end

Kemal.run