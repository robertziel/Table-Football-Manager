class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :edit, :update, :destroy]


  # GET /games
  # GET /games.json
  def index
    gon.yourID = current_user.id
    current_user.game == nil ? @games = Game.all : @games = Game.find(current_user.game.id)
    respond_to do |format|
      format.html
      format.json { render :json => { :games => @games.to_json(:include => [:team1, :team2, :users]),
        :user => current_user.game } }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    if current_user.game == nil
      team1 = Team.new
      team2 = Team.new
      team1.save
      team2.save
      @game = Game.new(game_params)
      @game.team1_id = team1.id
      @game.team2_id = team2.id
      @game.save
      User.update(current_user.id, :game_id => @game.id)
    end
    respond_to do |format|
      format.json { render :json => @game }
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if User.update(current_user.id, :game_id => params[:id])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    User.update(current_user.id, :game_id => nil, :team_id => nil)
    if @game.users.length == 0
      Team.find(@game.team1.id).destroy
      Team.find(@game.team2.id).destroy
      @game.destroy
    end
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def lottery
    @game = Game.find(params[:gameId])
    if current_user.id == @game.users[0].id
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params[:game]
    end

end
