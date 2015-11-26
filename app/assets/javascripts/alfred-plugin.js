(function() {
	var script_tag = jQuery('script[src*="alfred-plugin.js"]');

	function alfred_plugin_init() {

		if (script_tag.data('skip-css') == undefined) {

			var css_url = script_tag.attr('src');
      var bootstrap_url = script_tag.attr('src');

			//css_url = css_url.replace('alfred-plugin.js', 'brimir-plugin.css');
      css_url = css_url.replace('alfred-plugin.js', 'application.css');
      bootstrap_url = bootstrap_url.replace('alfred-plugin.js', 'bootstrap/bootstrap.min.js');

			jQuery('head').append('<link href="' + css_url + '" media="screen" rel="stylesheet" />');
      jQuery('head').append('<script src="' + bootstrap_url + '"></script>');
		}

		if (script_tag.data('skip-tabs') == undefined) {
			jQuery('body').append(
				'<div id="alfred-plugin-container">' +
          '<div class="alfred-plugin-button">' +
            '<div class="alfred-plugin-initials"></div>' +
          '</div>' +
				'</div>'
			);
		}

		// listeners
		jQuery(document).on('click', '.alfred-plugin-button', function(e){
			e.preventDefault();
			alfred_plugin_init_popup();

			var form_url = script_tag.attr('src');
			form_url = form_url.replace('assets/alfred-plugin.js', 'tickets/new?a=');

			if(script_tag.data('prefill-email') != undefined) {
				form_url += '&ticket[from]=' + encodeURIComponent(script_tag.data('prefill-email'));
			}
			if(script_tag.data('prefill-subject') != undefined) {
				form_url += '&ticket[subject]=' + encodeURIComponent(script_tag.data('prefill-subject'));
			}

			jQuery.ajax({
				url: form_url,
				success: alfred_plugin_insert_form
			});

      $('#form-validation-modal').modal('toggle');
		});
	}

	function alfred_plugin_insert_form(data) {
		$('#form-validation-modal form').replaceWith(data);
		$('#form-validation-modal form').on('submit', function(e) {
			e.preventDefault();

			jQuery.ajax({
				url: jQuery(this).attr('action'),
				type: 'post',
				data: jQuery(this).serialize(),
				success: function(data) {
					alert('Ticket created');
          $('#form-validation-modal').modal('toggle');
				},
				error: alfred_plugin_insert_form
			});
		});
	}

	function alfred_plugin_init_popup() {
		if($('#form-validation-modal').size() == 0) {

      $('body').append(
        '<div class="modal fade" id="form-validation-modal" tabindex="-1" role="dialog">' +
          '<div class="modal-dialog">' +
            '<div class="modal-content">' +
              '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
                '<h4 class="modal-title" id="myModalLabel">무엇이든 물어보세요.</h4>' +
              '</div>' +
              '<form></form>' +
            '</div>' +
          '</div>' +
        '</div>'
      );
		}
	}

	if(jQuery != undefined) {
		jQuery(document).ready(alfred_plugin_init);
		/* support turbolinks */
		jQuery(document).on('page:load', alfred_plugin_init);
	}

})();
