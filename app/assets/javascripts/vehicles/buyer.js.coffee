$(document).ready ->
  buyerForm = new AjaxifyForm 'buyer-form'
  $('#subscriber_email').blur ->
    buyerForm.show_loading()
    $.ajax(
      url: "/subscribers/search"
      data: {email: $(this).val()}
      dataType: 'json'
      success: (data) ->
        $('#subscriber_first_name').val data.first_name
        $('#subscriber_last_name').val data.last_name
        $('#subscriber_phone').val data.phone
      complete: ->
        buyerForm.show_form()
        $('#subscriber_first_name').focus()
    )
