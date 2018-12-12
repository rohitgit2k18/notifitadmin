(function () {
    $(document).ready(function () {

        $('.product-anchor').mouseover(function () {
            var id = $(this).parent().parent().attr("id");
            $("#" + id + ' .detailsArea').css({ 'visibility': 'hidden' });
        }).mouseleave(function () {
            var id = $(this).parent().parent().attr("id");
            $("#" + id + ' .detailsArea').css({ 'visibility': 'visible' });
        });
    });
})(jQuery);