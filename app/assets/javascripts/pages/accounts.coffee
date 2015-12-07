class @Account
  constructor: (form) ->
    verify_account_path = window.verify_account_path
    console.log(verify_account_path)

    $(document).on "click", ".js-verify-account-button", (e) ->
      e.preventDefault()

      form = $(form).closest("form")
      username = form.find(".js-username").val()
      email = form.find("email").val()
      verify(username, email)
      return false

    verify = (username, email) ->
      formData = new FormData()
      formData.append "account", username, email
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
        success: (e, textStatus, response) ->
          insertToTextArea(response.responseJSON.message)
        error: (respoonse) ->
          showError(response.responseJSON.message)
        complete: ->
          closeSpinner()

    showSpinner = ->
    closeSpinner = ->
