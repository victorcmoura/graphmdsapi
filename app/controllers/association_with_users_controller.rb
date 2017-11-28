class AssociationWithUsersController < ApplicationController
  before_action :set_association_with_user, only: [:show, :update, :destroy]

  # GET /association_with_users
  def index
    @association_with_users = AssociationWithUser.all

    render json: @association_with_users
  end

  # GET /association_with_users/1
  def show
    render json: @association_with_user
  end

  # POST /association_with_users
  def create
    @association_with_user = AssociationWithUser.new(association_with_user_params)

    if @association_with_user.save
      render json: @association_with_user, status: :created, location: @association_with_user
    else
      render json: @association_with_user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /association_with_users/1
  def update
    if @association_with_user.update(association_with_user_params)
      render json: @association_with_user
    else
      render json: @association_with_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /association_with_users/1
  def destroy
    @association_with_user.destroy
  end

  def create_associations_from_database
    @all_associations = Association.all

    @all_associations.each do |analysed|
      @all_associations.each do |possible_match|
        if analysed.repository == possible_match.repository
          @new_association_with_user = AssociationWithUser.new
          @new_association_with_user.user_one_id = analysed.user.id
          @new_association_with_user.user_two_id = possible_match.user.id
          @new_association_with_user.save
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_association_with_user
      @association_with_user = AssociationWithUser.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def association_with_user_params
      params.fetch(:association_with_user, {})
    end
end
