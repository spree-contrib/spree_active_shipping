($ '#cancel_link').click (event) ->
  event.preventDefault()

  ($ '.no-objects-found').show()

  ($ '#new_product_package_link').show()
  ($ '#product_packages').html('')
