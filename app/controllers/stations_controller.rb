class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]
  respond_to :html

  # GET /stations
  # GET /stations.json
  def index
    @stations = Station.all
  end

  # GET /stations/1
  # GET /stations/1.json
  def show
  end

  # GET /stations/new
  def new
    @station = Station.new
  end

  # GET /stations/1/edit
  def edit
  end

  # POST /stations
  # POST /stations.json
  def create
    @station = Station.new(station_params)
    @station.save
    respond_with(@station)
  end

  # PATCH/PUT /stations/1
  # PATCH/PUT /stations/1.json
  def update
    @station.update(station_params)
    respond_with(@station)
  end

  # DELETE /stations/1
  # DELETE /stations/1.json
  def destroy
    @station.destroy
    respond_with(@station, location: stations_url)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def station_params
      params.require(:station).permit(:code, :name, :train_route_ids => [])
    end
end
