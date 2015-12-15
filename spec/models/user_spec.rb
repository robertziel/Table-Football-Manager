require 'rails_helper'

RSpec.describe User, type: :model do
  it "validates presence of name" do
    should validate_presence_of :name
  end

  it "by default isn't willing to play" do
    expect(User.new).to_not be_will
  end

  it "by default is waiting" do
    expect(User.new).to be_wait
  end

  it "by default isn't admin of any game" do
    expect(User.new).to_not be_admin
  end

end
