require "rails_helper"

RSpec.describe GamesController, type: :routing do
  describe "routing" do

    it "routes to #create" do
      expect(:post => "games").to route_to("games#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "games/1").to route_to("games#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "games/1").to route_to("games#destroy", :id => "1")
    end

    it "routes to #lottery" do
      expect(:put => "lottery").to route_to("games#lottery")
    end

    it "routes to #will" do
      expect(:put => "will").to route_to("games#will")
    end

  end
end
