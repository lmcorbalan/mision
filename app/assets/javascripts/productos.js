/**
 * Created by niquito on 22/02/16.
 */

(function ($) {
	$.fn.uniformHeight = function () {
		var maxHeight = 0,
				wrapper,
				wrapperHeight;

		return this.each(function () {
			wrapper = $(this).wrapInner('<div class="wrapper" />').children('.wrapper');
			wrapperHeight = wrapper.outerHeight();

			maxHeight = Math.max(maxHeight, wrapperHeight);

			wrapper.children().unwrap();

		}).height(maxHeight);
	}
})(jQuery);

$(document).ready(function() {
    $('.fila').editable();

    $(function(){
        $('.status').editable({
            value: 2,
            source: [
                {value: 1, text: 'Active'},
                {value: 2, text: 'Blocked'},
                {value: 3, text: 'Deleted'}
            ]
        });
    });

    $(function(){
        $('.estado').editable({
            value: [false, true],
            source: [
                {value: false, text: 'Activo'},
                {value: true, text: 'Oculto'}
            ]
        });
    });

});




