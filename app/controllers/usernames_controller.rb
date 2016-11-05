class UsernamesController < ApplicationController
  before_action :set_username, only: [:show, :edit, :update, :destroy]

  # GET /usernames
  # GET /usernames.json
  def index
    @usernames = Username.all
  end

  # GET /usernames/1
  # GET /usernames/1.json
  def show
  end

  # GET /usernames/new
  def new
    @username = Username.new
  end

  # GET /usernames/1/edit
  def edit
  end

  # POST /usernames
  # POST /usernames.json
  def create
    @username = Username.new(username_params)

    respond_to do |format|
      if @username.save
        format.html { redirect_to @username, notice: 'Username was successfully created.' }
        format.json { render :show, status: :created, location: @username }
      else
        format.html { render :new }
        format.json { render json: @username.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usernames/1
  # PATCH/PUT /usernames/1.json
  def update
    respond_to do |format|
      if @username.update(username_params)
        format.html { redirect_to @username, notice: 'Username was successfully updated.' }
        format.json { render :show, status: :ok, location: @username }
      else
        format.html { render :edit }
        format.json { render json: @username.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usernames/1
  # DELETE /usernames/1.json
  def destroy
    @username.destroy
    respond_to do |format|
      format.html { redirect_to usernames_url, notice: 'Username was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_username
      @username = Username.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def username_params
      params.require(:username).permit(:username)
    end
end
