$ ->
  $('.table-sortable-nested-form').sortable
    axis: 'y',
    items: '.nested-item',
    update: (e, ui) ->
      # link_to_add で追加したレコードが未入力の場合、
      # row_order_position(.position属性)を変更しないよう（未設定のまま）にする
      order = 0
      $('.nested-item').each ->
        # .form-control 属性が付加されてあるタグが何かしらの入力フィールド
        terget = $(this).find('.form-control')
        len = terget.size()
        terget.each ->
          # 入力フィールドが未設定かを確認
          if $(this).val() == ''
            len -= 1
          return
        
        if len != 0
          $(this).find('.position').val( order )
          order++
        
        return

      # .positon 属性の入力フィールドを０始まりで埋める
      # $('.position').each ->
      #   $(this).val( $('.position').index( $(this) )  )
      #   # $(this).val(0)
