(function () {
  var handleProgress = function() {
    var current = 0;
    var list = $('.page-dots');
    var dots = $('.page-dots > li');

    var interval = setInterval(function() {
      dots.removeClass('current');
      list.children('li').eq(current).addClass("current");
      current = current == list.children('li').length - 1 ? 0 : current + 1;
    }, 500);

    $("a[data-remote=true]").on("ajax:beforeSend", function(event, xhr, settings) {
      $(".progress-area").removeClass("hidden");
    }).on("ajax:complete", function(event, xhr, status) {
      $(".progress-area").addClass("hidden");
    });

    $("form[data-remote=true]").on("ajax:beforeSend", function(event, xhr, settings) {
      $(".progress-area").removeClass("hidden");
    }).on("ajax:complete", function(event, xhr, status) {
      $(".progress-area").addClass("hidden");
    });
  };

  $(document).on("ready page:load", handleProgress);
})();
