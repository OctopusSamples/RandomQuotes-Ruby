require "spec_helper"

describe "Random Quotes" do
  it "should return a quote" do
    get "/api/quote"
    expect(last_response).to be_ok
  end
end