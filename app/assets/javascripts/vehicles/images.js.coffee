bar = $('.meter')
status = $('.status')

$('#image-upload-form').ajaxForm {
  beforeSend: ->
    status.html('')
    percentVal = '0%'
    bar.css('width', percentVal)
  uploadProgress: (event, position, total, percentComplete) ->
    percentVal = percentComplete + '%'
    bar.css 'width', percentVal
  success: ->
    percentVal = '100%'
    bar.width(percentVal)
	complete: (xhr) ->
    status.html xhr.responseText
}