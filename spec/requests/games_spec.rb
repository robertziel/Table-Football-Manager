require 'rails_helper'

RSpec.describe "Games", type: :request do

  it "request get root" do
    get root
    expect(response).to have_http_status(200)
  end

end
