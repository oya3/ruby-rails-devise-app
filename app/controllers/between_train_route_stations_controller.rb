# coding: utf-8
class BetweenTrainRouteStationsController < ApplicationController
  before_action :set_between_train_route_station, only: [:show, :edit, :update, :destroy]

  # ajax api
  # 駅の線路情報を取得
  def get_railway
    between_train_route_station = BetweenTrainRouteStation.find(params[:between_train_route_station_id])
    # has_many でネスとしている場合は、includeを使う
    render json: between_train_route_station.as_json(
             :include => {
               :railsections => {
                 :include=> {
                   :railways => {
                     :include=> :points
                   }
                 }
               }
             }
           )
  end

  # GET /between_train_route_stations
  # GET /between_train_route_stations.json
  def index
    @between_train_route_stations = BetweenTrainRouteStation.all
  end

  # GET /between_train_route_stations/1
  # GET /between_train_route_stations/1.json
  def show
  end

  # GET /between_train_route_stations/new
  def new
    @between_train_route_station = BetweenTrainRouteStation.new
  end

  # GET /between_train_route_stations/1/edit
  def edit
  end

  # POST /between_train_route_stations
  # POST /between_train_route_stations.json
  def create
    @between_train_route_station = BetweenTrainRouteStation.new(between_train_route_station_params)

    respond_to do |format|
      if @between_train_route_station.save
        format.html { redirect_to @between_train_route_station, notice: 'Between train route station was successfully created.' }
        format.json { render :show, status: :created, location: @between_train_route_station }
      else
        format.html { render :new }
        format.json { render json: @between_train_route_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /between_train_route_stations/1
  # PATCH/PUT /between_train_route_stations/1.json
  def update
    respond_to do |format|
      if @between_train_route_station.update(between_train_route_station_params)
        format.html { redirect_to @between_train_route_station, notice: 'Between train route station was successfully updated.' }
        format.json { render :show, status: :ok, location: @between_train_route_station }
      else
        format.html { render :edit }
        format.json { render json: @between_train_route_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /between_train_route_stations/1
  # DELETE /between_train_route_stations/1.json
  def destroy
    @between_train_route_station.destroy
    respond_to do |format|
      format.html { redirect_to between_train_route_stations_url, notice: 'Between train route station was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_between_train_route_station
      @between_train_route_station = BetweenTrainRouteStation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def between_train_route_station_params
      params.require(:between_train_route_station).permit(:train_route_station1_id, :train_route_station2_id)
    end
end
