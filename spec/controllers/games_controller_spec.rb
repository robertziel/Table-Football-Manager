require 'rails_helper'



RSpec.describe GamesController, type: :controller do


  let(:valid_attributes) {
    {team1_id: 1, team2_id: 2}
  }

  let(:invalid_attributes) {
  }


  let(:valid_session) { {} }


  context "user is signed in" do

    before "Test user" do
      user = create(:user)
      sign_in user
      controller.stub(:user_signed_in?).and_return(true)
      controller.stub(:current_user).and_return(user)
      controller.stub(:authenticate_user!).and_return(user)
    end




    describe 'GET index' do
      it 'successful load' do
        get :index, {}, valid_session
        expect(response).to be_successful
      end
    end

    describe 'GET index' do
      it 'exposes all games' do
        game = Game.create! valid_attributes
        get :index, {}, valid_session
        expect(Game.all).to eq([game])
      end
    end

    describe 'POST create' do
      it 'creates game when user has no game' do
        controller.current_user.stub(game_id?: nil)
        expect {post :create, format: 'json'}.to change(Game, :count).by(1)
        expect {post :create, format: 'json'}.to change(Team, :count).by(2)
      end
    end

    describe 'PUT update' do
      it 'joins current_user to game' do
        post :create, format: 'json'
        controller.current_user.stub(game_id?: nil)
        put :update, :id=> Game.last.id, format: 'json'
        expect(User.last.game_id).to eq(Game.last.id)
      end
    end

    describe 'POST destroy' do

      it 'destroys game if there is one user in game' do
        post :create, format: 'json'
        expect {delete :destroy, :id=> Game.last.id, format: 'json'}.to change(Game, :count).by(-1)
      end

      it 'destroys game\'s 2 teams if there is one user in game' do
        post :create, format: 'json'
        expect {delete :destroy, :id=> Game.last.id, format: 'json'}.to change(Team, :count).by(-2)
      end

      it 'not destroy game if there is one user in game' do
        post :create, format: 'json'
        user = create(:user)
        user.game_id = Game.last.id
        user.save
        expect {delete :destroy, :id=> Game.last.id, format: 'json'}.to change(Game, :count).by(0)
      end

      it 'not destroy game\'s 2 teams if there is one user in game' do
        post :create, format: 'json'
        user = create(:user)
        user.game_id = Game.last.id
        user.save
        expect {delete :destroy, :id=> Game.last.id, format: 'json'}.to change(Team, :count).by(0)
      end
    end

    describe 'PUT lottery' do

      it 'not create team when less than 4 users' do
        post :create, format: 'json'
        user = create(:user)
        user.game_id = Game.last.id
        user.save
        put :lottery, :game=> Game.last.id, format: 'json'
        expect(User.last.team_id).to eq(nil)
      end

      it 'create team when minimum 4 users' do
        post :create, format: 'json'
        $i = 0
        while $i < 3  do
          user = create(:user)
          user.game_id = Game.last.id
          user.save
          $i += 1
        end
        put :lottery, :game=> Game.last.id, format: 'json'
        expect(User.last.team_id).to be_between(Game.last.team1_id, Game.last.team2_id)
      end
    end
  end
end
