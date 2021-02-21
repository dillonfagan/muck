require "kemal"
require "json"
require "./entry"
require "./message"
require "./stash"

DEF = "default"

stash = Stash.new
stash.create DEF

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do |env|
  stash.in(DEF).get_all.to_json
end

get "/:key" do |env|
  key = env.params.url["key"]
  stash.in(DEF).get(key).to_json
end

put "/" do |env|
  entry = Entry.from_json env.request.body.not_nil!
  stash.in(DEF).add(entry).to_json
end

patch "/:key" do |env|
  key = env.params.url["key"]
  value = env.params.json["value"].as(String)
  before = stash.in(DEF).update key, value
  after = stash.in(DEF).get key
  Message::Patch.new(before, after).to_json
end

delete "/:key" do |env|
  key = env.params.url["key"]
  entry = stash.in(DEF).delete key
  Message::Delete.new(entry).to_json
end

Kemal.run