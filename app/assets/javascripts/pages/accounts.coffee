class @Account
  constructor: (form) ->
    verify_account_path = $(form).attr("action")

    $(document).on "click", ".js-verify-account-button", (e) ->
      e.preventDefault()

      form = $(this).closest("form")
      username = form.find(".js-username").val()
      email = form.find(".js-email").val()

      verify(username, email)
      return false

    verify = (username, email) ->
      formData = new FormData()
      formData.append("username", username)
      formData.append("email", email)
      $.ajax
        url: verify_account_path
        type: "POST"
        data: formData
        dataType: "json"
        processData: false
        contentType: false
        headers:
          "X-CSRF-Token": $("meta[name=\"csrf-token\"]").attr("content")
        beforeSend: ->
          showSpinner()
        success: (e, textStatus, response) ->
          closeSpinner()
    showSpinner = ->
      $("#js-verify-account-form").addClass("hidden")
      $(".progress-area").removeClass("hidden")
    closeSpinner = ->
      $(".progress-area").addClass("hidden")
      $(".guide-message-check-mail").removeClass("hidden")
