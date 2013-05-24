$('.existing-photos a.view').click ->
  $('#view-image-modal-image').attr('src', $(this).attr('data-big-url'))