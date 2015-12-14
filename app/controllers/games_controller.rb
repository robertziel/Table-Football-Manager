class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :edit, :update, :destroy]


  # GET /games
  # GET /games.json
  def index
    gon.yourID = current_user.id
    current_user.game == nil ? @games = Game.all : @games = Game.find(current_user.game.id)
    @team1 = @games.team1.users if @games.try :team1
    @team2 = @games.team2.users if @games.try :team2
    respond_to do |format|
      format.html
      format.json { render :json => { :games => @games.to_json(:include => [:users]),
        :user => current_user.game,
        :will => current_user.will,
        :team1 => @team1,
        :team2 => @team2 } }
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
      User.update(current_user.id, :game_id => @game.id, :admin => true)
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
    @admin = current_user.admin
    User.update(current_user.id, :game_id => nil, :team_id => nil, :admin => false)
    if @game.users.length == 0
      Team.find(@game.team1.id).destroy
      Team.find(@game.team2.id).destroy
      @game.destroy
    elsif @admin
      User.update(@game.users[0].id, :admin => true)
    end
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def lottery
    @game = Game.find(params[:game])
    if current_user.id == @game.users.where(:admin => true).take.id and @game.users.length >= 2
      @users = @game.users.sort_by &:last_played
      @users = @users.sort_by &:will
      @users.each { |x| User.update(x.id, :team_id => nil)}
      @choosed = @users[0..3].shuffle
      @choosed[0..1].each { |x| User.update(x.id, :team_id => @game.team1.id, :last_played => DateTime.now)}
      @choosed[2..3].each { |x| User.update(x.id, :team_id => @game.team2.id, :last_played => DateTime.now)}
    end
    respond_to do |format|
      format.json { head :no_content }
    end
  end


  def will
    current_user.will == false ? User.update(current_user.id, :will => true) : User.update(current_user.id, :will => false)
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params[:game]
    end

end
