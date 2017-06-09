class DistancesController < ApplicationController
  before_action :set_distance, only: [:show, :edit, :update, :destroy]
  respond_to :html

  # GET /distances
  # GET /distances.json
  def index
    @distances = Distance.all
  end

  # GET /distances/1
  # GET /distances/1.json
  def show
  end

  # GET /distances/new
  def new
    @distance = Distance.new
  end

  # GET /distances/1/edit
  def edit
  end

  # POST /distances
  # POST /distances.json
  def create
    @distance = Distance.new(distance_params)
    @distance.save
    respond_with(@distance)
  end

  # PATCH/PUT /distances/1
  # PATCH/PUT /distances/1.json
  def update
    @distance.update(distance_params)
    respond_with(@distance)
  end

  # DELETE /distances/1
  # DELETE /distances/1.json
  def destroy
    @distance.destroy
    respond_with(@distance, location: distances_url)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distance
      @distance = Distance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distance_params
      params.require(:distance).permit(:departure_station_id, :destination_station_id, :distance)
    end
end
