electric_board_canvas = null

update_electric_board = ->
  if electric_board_canvas == null
    electric_board_canvas = $('<canvas>')
  canvas_width = $('.electric_board').width()
  canvas_height = $('.electric_board').height()
  electric_board_canvas.setAttribute 'width', canvas_width
  electric_board_canvas.setAttribute 'height', canvas_height
  context = electric_board_canvas.getContext('2d')
  context.clearRect 0, 0, electric_board_canvas.width, electric_board_canvas.height # 透明な黒でクリアーする意味
  background_color = $('.electric_message').css('background-color')
  context.strokeStyle = 'rgb(51, 51, 51)'
  # 縦棒
  x = 4
  while x < canvas_width
    context.beginPath()
    context.moveTo(x, 0)
    context.lineTo(x, canvas_height)
    if x % 8
      context.moveTo(x+1, 0)
      context.lineTo(x+1, canvas_height)
    context.stroke()
    x += 4
  y = 4
  # 横棒
  while y < canvas_height
    context.beginPath()
    context.moveTo(0, y)
    context.lineTo(canvas_width, y)
    context.moveTo(0, y+1)
    context.lineTo(canvas_width, y+1)
    context.stroke()
    y += 4
  return

window.onload = ->
  if $('.electric_board').length == 0
    return
  $('.electric_board').append $("<canvas class='electric_board_canvas box_curve'></canvas>")
  electric_board_canvas = $('.electric_board_canvas')[0]
  update_electric_board()
  return

$(window).resize ->
  if $('.electric_board').length == 0
    return
  update_electric_board()
  return

