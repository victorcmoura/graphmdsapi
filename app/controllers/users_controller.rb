require 'net/http'
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users.to_json(:only => [:id, :name])
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  #GET USERS FROM GITHUB
  def get_from_github
    puts 'Requesting to fga-gpp-mds repos...'
    @saved_users = []
    @saved_associations = []
    Repository.all.each do |repository|
      @url = URI.parse('https://api.github.com/repos/' + repository.name + '/contributors')
      @request = Net::HTTP::Get.new(@url.to_s)
      @request.add_field("Authorization", "token " + request.headers['Authorization'])

      @result = Net::HTTP.start(@url.host, @url.port, :use_ssl => true) do |http|
        http.request(@request)
      end

      @objects = JSON.parse @result.body

      @objects.each do |object|
        @new_user = User.new(:name => object['login'])

        if @new_user.save
          @saved_users.push(object['login'])
        end

        @new_association = Association.new(:user => User.find_by_name(object['login']), :repository => repository)
        if @new_association.save
          @pair = {repository.name => @new_user.name}
          @saved_associations.push(@pair)
        end
      end
    end
      render json: {'new_users': @saved_users, 'new_associations': @saved_associations}
  end

  def get_repositories_from_users
    puts 'Requesting to fga-gpp-mds repos...'
    @saved_repos = []
    @saved_associations = []
    User.all.each do |user|
      @url = URI.parse('https://api.github.com/users/' + user.name + '/subscriptions')
      @request = Net::HTTP::Get.new(@url.to_s)
      @request.add_field("Authorization", "token " + request.headers['Authorization'])

      @result = Net::HTTP.start(@url.host, @url.port, :use_ssl => true) do |http|
        http.request(@request)
      end

      @objects = JSON.parse @result.body

      @objects.each do |object|
        @new_repo = Repository.new(:name => object['full_name'])

        if @new_repo.save
          @saved_repos.push(object['full_name'])
        end

        @new_association = Association.new(:user => user, :repository => Repository.find_by_name(object['full_name']))
        if @new_association.save
          @pair = {@new_association.repository.name => user.name}
          @saved_associations.push(@pair)
        end
      end
    end
      render json: {'new_repos': @saved_repos, 'new_associations': @saved_associations}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name)
    end
end
