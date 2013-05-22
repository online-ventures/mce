bar = $('.meter')
percent = $('.percent')
status = $('.status')

$('form').ajaxForm {
  beforeSend: ->
    status.html('')
    percentVal = '0%'
    bar.css('width', percentVal)
  uploadProgress: (event, position, total, percentComplete) ->
    percentVal = percentComplete + '%'
    bar.css 'width', percentVal
    console.log percentVal, position, total
  success: ->
    percentVal = '100%'
    bar.width(percentVal)
    percent.html(percentVal)
	complete: (xhr) ->
    status.html xhr.responseText
}