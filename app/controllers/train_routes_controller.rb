# coding: utf-8
class TrainRoutesController < ApplicationController
  before_action :set_train_route, only: [:show, :edit, :update, :destroy]
  respond_to :html

  # GET /train_routes
  # GET /train_routes.json
  def index
    @train_routes = TrainRoute.all
  end

  # GET /train_routes/1
  # GET /train_routes/1.json
  def show
  end

  # GET /train_routes/new
  def new
    @train_route = TrainRoute.new
  end

  # GET /train_routes/1/edit
  def edit
  end

  # POST /train_routes
  # POST /train_routes.json
  def create
    @train_route = TrainRoute.new(train_route_params)
    @train_route.save
    respond_with(@train_route)
  end

  # PATCH/PUT /train_routes/1
  # PATCH/PUT /train_routes/1.json
  def update
    @train_route.update(train_route_params)
    respond_with(@train_route)
  end

  # DELETE /train_routes/1
  # DELETE /train_routes/1.json
  def destroy
    @train_route.destroy
    respond_with(@train_route, location: train_routes_url)
  end

  # ajax api
  # 指定した線路の駅一覧を取得する
  # [
  # {
  #   "id":1,
  #   "train_route_id":1,
  #   "station_id":1,
  #   "row_order":0,
  #   "distance":null,
  #   "created_at":"2017-07-12T14:23:44.758+09:00",
  #  "updated_at":"2017-07-12T14:23:44.758+09:00",
  #  "station":{
  #               "id":1,
  #               "code":1,
  #               "name":"米原",
  #             "created_at":"2017-07-12T14:23:13.497+09:00",
  #             "updated_at":"2017-07-12T14:23:13.497+09:00"
  #             }
  # },
  # {
  #   "id":2,
  #   "train_route_id":1,
  #   "station_id":2,
  #   "row_order":4194304,
  #   "distance":null,
  #   "created_at":"2017-07-12T14:23:44.843+09:00",
  #  "updated_at":"2017-07-12T14:23:44.843+09:00",
  #  "station":{
  #               "id":2,
  #               "code":2,
  #               "name":"彦根",
  #             "created_at":"2017-07-12T14:23:13.505+09:00",
  #             "updated_at":"2017-07-12T14:23:13.505+09:00"
  #             }
  # },
  # ...
  def get_route_station
    train_route = TrainRoute.find(params[:train_route_id])
    # TrainRouteStation.with_train_route.where(..) は配列が戻ってくる
    train_route_stations = TrainRouteStation.with_train_route.where("train_routes.code = ?", train_route.code).order(:row_order)
    # has_many でネスとしている場合は、includeを使う
    render json: train_route_stations.as_json(
             :include => {
               :station => {
                 # :include=> :points
               }
             }
           )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_train_route
      # @train_route = TrainRoute.with_train_route_stations.find(params[:id]).order("train_route_stations.row_order")
      @train_route = TrainRoute.order(:code).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def train_route_params
      params.require(:train_route).permit(:code, :name,
                                          :train_route_stations_attributes => [ :id, :distance, :station_id, :row_order_position, :_destroy])
    end
end
