$ ->
  $('.train-route-select').chosen
    #disable_search_threshold: 2
    allow_single_deselect: true
    # enable_split_word_search: false
    # no_results_text: 'No results matched'
    # width: '200px'
    width: '100%'

  $('.train-route-select').on 'change', (evt, params) ->
    # 以下のＵＲＬでtrain_route_stationsがもらえるはず
    # http://localhost:3000/train_routes/1/get_route_station
    console.log 'select1112 change'
    return
 
