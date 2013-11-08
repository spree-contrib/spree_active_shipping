$ ->
  ($ '#new_product_package_link').click (event) ->
    event.preventDefault()

    ($ '.no-objects-found').hide()

    ($ this).hide()
    $.ajax
      type: 'GET'
      url: @href
      data: (
        authenticity_token: AUTH_TOKEN
      )
      success: (r) ->
        ($ '#product_packages').html r

  ($ 'a.edit').click (event) ->
    event.preventDefault()

    ($ '#product_packages').html('')
    $.ajax
      type: 'GET'
      url: @href
      data: (
        authenticity_token: AUTH_TOKEN
      )
      success: (r) ->
        ($ '#product_packages').html r
