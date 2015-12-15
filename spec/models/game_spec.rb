require 'rails_helper'

  

describe Game do
  describe 'validations' do
    it { should validate_presence_of :team1_id }
    it { should validate_presence_of :team2_id }
  end
end
