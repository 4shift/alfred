$ ->
  new Dispatcher()

class Dispatcher
  constructor: () ->
    @initPageScripts()

  initPageScripts: ->
    page = $('body').attr('data-page')

    unless page
      return false

    path = page.split('data-page')
    shortcut_handler = null

    switch page
      when 'pages:show'
        new Account(".js-verify-account-form")
