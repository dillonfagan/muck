require "./spec_helper"

describe "Muck" do
  it "GET / returns default store" do
    get "/"
    response.body.should eq "[\"default\"]"
  end
end
