/* ==============================================================================
// Scripts for the theme
// ============================================================================== */

var ready = function() {

	// sidebar menus
	Sidebar.initialize();

	// build custom selects
	UI.smart_selects();

	// tooltips
	$("[data-toggle='tooltip']").tooltip();

	// retina display
	if(window.devicePixelRatio >= 1.2){
	    $("[data-2x]").each(function(){
	        if(this.tagName == "IMG"){
	            $(this).attr("src",$(this).attr("data-2x"));
	        } else {
	            $(this).css({"background-image":"url("+$(this).attr("data-2x")+")"});
	        }
	    });
	}

	Number.prototype.formatMoney = function(c, d, t){
		var n = this,
		    c = isNaN(c = Math.abs(c)) ? 2 : c,
		    d = d == undefined ? "." : d,
		    t = t == undefined ? "," : t,
		    s = n < 0 ? "-" : "",
		    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
		    j = (j = i.length) > 3 ? j % 3 : 0;
		   return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
	};
};

$(document).on("ready page:load", ready);

$(document).on("page:change", function () {
	window.prevPageYOffset = window.pageYOffset;
    window.prevPageXOffset = window.pageXOffset;
});

$(document).on("page:load", function () {
	if ($(".fix-scroll").length > 0) {
		$('.fix-scroll').hide().show() // force re-render -- having an issue with that on Chrome/OSX
      	//window.scrollTo(window.prevPageXOffset, window.prevPageYOffset);
	}
});


var UI = {
	smart_selects: function () {
		var $selects = $("[data-smart-select]");
		$.each($selects, function (index, el) {
			var $select = $(el);

			// It has been already initialized
			if ($select.parent().hasClass("fake-select-wrap")) {
				$select.siblings(".fake-select").html($select.find("option:selected").text());
				return;
			}

			var $wrapper = $("<div class='fake-select-wrap' />");
			var $fake_select = $("<div class='fake-select'></div>");
			$select.wrap($wrapper);
			$select.after($fake_select);

			// set selected value as default
			$fake_select.html($select.find("option:selected").text());

			// change handler
			$select.change(function () {
				$fake_select.html($(this).find("option:selected").text());
			});

			$select.focus(function () {
				$fake_select.addClass("focus");
			}).focusout(function () {
				$fake_select.removeClass("focus");
			});
		});
	}
}

var Sidebar = {
	initialize: function () {
		var $sidebar_menu = $(".main-sidebar");

		// my account dropdown menu
		var $account_menu = $sidebar_menu.find(".current-user .menu");
		$(".current-user .name").click(function (e) {
			e.preventDefault();
			e.stopPropagation();
			$account_menu.toggleClass("active");
		});

		$("body").click(function () { $account_menu.removeClass("active") });

		// sidebar menu dropdown levels
		var $dropdown_triggers = $sidebar_menu.find("[data-toggle~='sidebar']");

		$dropdown_triggers.click(function (e) {
			e.preventDefault();

			if (!utils.isTablet()) {
				// reset other dropdown menus
				if (!$(this).closest(".submenu").length) {
					$dropdown_triggers.not(this).removeClass("toggled").siblings(".submenu").slideUp(300, check_height);
				}

				var $trigger = $(this);
				var $dropdown = $(this).siblings(".submenu");

				$trigger.toggleClass("toggled");

				if ($trigger.hasClass("toggled")) {
					$dropdown.slideDown(300, check_height);
				} else {
					$dropdown.slideUp(300, check_height);
				}
			}
		});



		// fix sidebar height depending on browser dimensions
		var check_height = function () {
			var height = $("body").height();
			$(".main-sidebar").css("bottom", "auto");
			var sidebar_height = $(".main-sidebar").height();

			if (height > sidebar_height) {
				$(".main-sidebar").css("bottom", 0);
			} else {
				$(".main-sidebar").css("bottom", "auto");
			}
		};


		// mobile sidebar toggler
		var $mobile_toggler = $("#content .sidebar-toggler");
		$mobile_toggler.click(function (e) {
			e.stopPropagation();
			$("body").toggleClass("open-sidebar");
		});

		$("#content").click(function () {
			$("body").removeClass("open-sidebar");
		})
	}
};

window.utils = {
	isFirefox: function () {
		return navigator.userAgent.toLowerCase().indexOf('firefox') > -1;
	},
	animation_ends: function () {
		return "animationend webkitAnimationEnd oAnimationEnd";
	},
	isTablet: function () {
		return ($(".main-sidebar").width() < 100);
	},
	get_timestamp: function (less_days) {
    	return moment().subtract('days', less_days).toDate().getTime();
    }
};
