class TrainRouteStationsController < ApplicationController
  before_action :set_train_route_station, only: [:show, :edit, :update, :destroy]


  def sort
    train_route_station = TrainRouteStation.find(params[:train_route_station_id])
    train_route_station.update(train_route_station_params)
    render nothing: true
  end
  
  # GET /train_route_stations
  # GET /train_route_stations.json
  def index
    @train_route_stations = TrainRouteStation.all
  end

  # GET /train_route_stations/1
  # GET /train_route_stations/1.json
  def show
  end

  # GET /train_route_stations/new
  def new
    @train_route_station = TrainRouteStation.new
  end

  # GET /train_route_stations/1/edit
  def edit
  end

  # POST /train_route_stations
  # POST /train_route_stations.json
  def create
    @train_route_station = TrainRouteStation.new(train_route_station_params)

    respond_to do |format|
      if @train_route_station.save
        format.html { redirect_to @train_route_station, notice: 'Train route station was successfully created.' }
        format.json { render :show, status: :created, location: @train_route_station }
      else
        format.html { render :new }
        format.json { render json: @train_route_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /train_route_stations/1
  # PATCH/PUT /train_route_stations/1.json
  def update
    respond_to do |format|
      if @train_route_station.update(train_route_station_params)
        format.html { redirect_to @train_route_station, notice: 'Train route station was successfully updated.' }
        format.json { render :show, status: :ok, location: @train_route_station }
      else
        format.html { render :edit }
        format.json { render json: @train_route_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /train_route_stations/1
  # DELETE /train_route_stations/1.json
  def destroy
    @train_route_station.destroy
    respond_to do |format|
      format.html { redirect_to train_route_stations_url, notice: 'Train route station was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_train_route_station
      @train_route_station = TrainRouteStation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def train_route_station_params
      params.require(:train_route_station).permit(:train_route_id, :station_id, :distance, :row_order_position)
    end
end
