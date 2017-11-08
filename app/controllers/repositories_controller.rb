require 'net/http'
class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :update, :destroy]

  # GET /repositories
  def index
    @repositories = Repository.all

    render json: @repositories.to_json(:only => [:id, :name])
  end

  # GET /repositories/1
  def show
    render json: @repository
  end

  # POST /repositories
  def create
    @repository = Repository.new(repository_params)

    if @repository.save
      render json: @repository, status: :created, location: @repository
    else
      render json: @repository.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /repositories/1
  def update
    if @repository.update(repository_params)
      render json: @repository
    else
      render json: @repository.errors, status: :unprocessable_entity
    end
  end

  # DELETE /repositories/1
  def destroy
    @repository.destroy
  end

  #GET REPOSITORIES FROM GITHUB
  def get_from_github()
    puts 'Requesting to fga-gpp-mds...'
    @saved_repos = []
    @index = 1
    loop do
      @url = URI.parse('https://api.github.com/orgs/fga-gpp-mds/repos?page=' + @index.to_s)
      @request = Net::HTTP::Get.new(@url.to_s)
      @request.add_field("Authorization", "token " + request.headers['Authorization'])


      @result = Net::HTTP.start(@url.host, @url.port, :use_ssl => true) do |http|
        http.request(@request)
      end

      @objects = JSON.parse @result.body

      if @objects.empty?
        break
      end

      @objects.each do |object|
        @new_repo = Repository.new(:name => object['full_name'])
        if @new_repo.save
          @saved_repos.push(object['full_name'])
        end
      end
      @index = @index + 1
    end
      render json: {'new_repos': @saved_repos}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def repository_params
      params.require(:repository).permit(:name)
    end
end
