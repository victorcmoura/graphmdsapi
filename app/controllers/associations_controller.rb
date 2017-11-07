class AssociationsController < ApplicationController
  before_action :set_association, only: [:show, :update, :destroy]

  # GET /associations
  def index
    @associations = Association.all

    render json: @associations
  end

  # GET /associations/1
  def show
    render json: @association
  end

  # POST /associations
  def create
    @association = Association.new(association_params)

    if @association.save
      render json: @association, status: :created, location: @association
    else
      render json: @association.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /associations/1
  def update
    if @association.update(association_params)
      render json: @association
    else
      render json: @association.errors, status: :unprocessable_entity
    end
  end

  # DELETE /associations/1
  def destroy
    @association.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_association
      @association = Association.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def association_params
      params.fetch(:association, {})
    end
end
