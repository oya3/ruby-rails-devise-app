# nested_form でテーブル追加時に正しくテーブル要素として追加できるようにするスクリプト
# 意味はまったくわからん。。。
window.NestedFormEvents::insertFields = (content, assoc, link) ->
  $tr = $(link).closest('tr')
  $(content).insertBefore $tr

