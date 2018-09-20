$(function() {
  $('#new_product_package_link').click(function(event) {
    event.preventDefault()
    $('.no-objects-found').hide()
    $(this).hide()
    $.ajax({
      type: 'GET',
      url: this.href,
      data: {
        authenticity_token: AUTH_TOKEN
      }
    }).done(function(data) {
      $('#product_packages').html(data)
    })
  })
  $('a.edit').click(function(event) {
    event.preventDefault()
    $('#product_packages').html('')
    $.ajax({
      type: 'GET',
      url: this.href,
      data: {
        authenticity_token: AUTH_TOKEN
      }
    }).done(function(data) {
      $('#product_packages').html(data)
    })
  })
})
