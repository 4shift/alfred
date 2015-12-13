(function () {
  var ready = function() {

    $('[data-provider="summernote"]').destroy();
    $('.select2').select2('destroy');

    $('[data-provider="summernote"]').each(function() {
      $(this).summernote({
        height: 200,
    	  focus: true,
    	  shortcuts: true,
        toolbar: [
            ['style', ['style']],
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['fontsize', ['fontsize']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
            ['insert', ['picture', 'link', 'video']],
            ['view', ['fullscreen', 'codeview']],
    		    ['help', ['help']]
        ]
      });
    });

    $('.attachable').appendTo('.note-editor');
    $('[data-contact-wrapper]').appendTo('.note-editor');
    $('.note-statusbar').appendTo('.note-editor');
    $('.select2').select2();

    $(document).on('click', '.status-switcher', function(e) {
      e.preventDefault();
      $('.ticket-status > .menu').addClass('active');
    });

    $(document).on('click', '.priority-switcher', function(e) {
      e.preventDefault();
      $('.ticket-priority > .menu').addClass('active');
    });

    $(document).on('click', '[data-contact-wrapper]', function(e) {
      e.preventDefault();
      $('.ticket-contact-summary').hide();
      $('.ticket-edit-contact').show();
    });

    $("body").click(function() {
      $('.menu').removeClass('active');
      $('.ticket-contact-summary').show();
      $('.ticket-edit-contact').hide();
    });
  };

  $(document).on("ready page:load", ready);
})();
