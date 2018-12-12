$(document).ready(function(){

$("body").on("click", "#view_report", function (e) {
e.preventDefault();
$("body").addClass("pop-overlay-body");
$(".view_report_popup").show();
$(".view-reports").show();
});

$("body").on("click", "#view_priscip", function (e) {
    e.preventDefault();
$("body").addClass("pop-overlay-body");
$(".view_report_popup").show();
$(".view-priscriptions").show();
});

$("body").off().on("click", ".refer-patient-link", function (e) {
    e.preventDefault();
$("body").addClass("pop-overlay-body");
$(".refer_patient_popup").show();
});

$("body").on("click", ".close_popup", function (e) {
    e.preventDefault();
$('body').removeClass("pop-overlay-body");
$(".view_report_popup").hide();
$(".view-reports").hide();
$(".view-priscriptions").hide();
$(".refer_patient_popup").hide();

});


$("body").on("click", "#notifi-bell", function (e) {
        $(".notification-popup").slideToggle();
});




var pathname = window.location.pathname; // Returns path only
var url = window.location.href;     // Returns full URL
console.log("pathname", pathname);
console.log("url", url);
$('.dashboard-menu-list li').removeClass('active');
$('.dashboard-menu-list li').each(function () {
    var href = $(this).find('a').attr('href');   
    if (href === pathname) {
        $(this).addClass('active');
    }

});
// The latitude and longitude of your business / place
var position = [28.681477, 77.08604600000001];

function showGoogleMaps() {

    var latLng = new google.maps.LatLng(position[0], position[1]);

    var mapOptions = {
        zoom:16, // initialize zoom level - the max value is 21
        streetViewControl: false, // hide the yellow Street View pegman
        scaleControl: true, // allow users to zoom the Google Map
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        center: latLng
    };

    map = new google.maps.Map(document.getElementById('googlemaps'),
        mapOptions);

    // Show the default red marker at the location
    marker = new google.maps.Marker({
        position: latLng,
        map: map,
        draggable: false,
        animation: google.maps.Animation.DROP
    });
}

google.maps.event.addDomListener(window, 'load', showGoogleMaps);


/*Login Form popup*/

$("body").on("click",".login_link", function(){
$('body').addClass("pop-overlay-body");
$(".login_popup").show();
$(".login_popup_form").show();
});

/*Forgot pwd Form popup*/
$("body").on("click",".forgot_link", function(){
$(".forgot_popup_form").show();
$(".login_popup_form").hide();
});


//$("body").on("click",".close_popup", function(){
//$('body').removeClass("pop-overlay-body");
//$(".login_popup").hide();
//$(".forgot_popup_form").hide();

//});

//$('#calendar').fullCalendar({
//            header: {
//                left: 'prev,next today',
//                center: 'title',
//                right: 'month,basicWeek,basicDay'
//            },
//            defaultDate: '2017-09-12',
//            navLinks: true, // can click day/week names to navigate views
//            editable: true,
//            eventLimit: true, // allow "more" link when too many events
//            events: [
//                {
//                    title: 'Mr. Tejwani 8:00am',
//                    start: '2017-09-01',
//                },
//                {
//                    title: 'Mr. Tejawani 8:00am',
//                    start: '2017-09-02',
//                },
//                 {
//                    title: 'Mr. Tejawani 8:00am',
//                    start: '2017-09-12',
//                },
//                 {
//                    title: 'Mr. Tejawani 8:00am',
//                    start: '2017-09-14',
//                }
    
//            ]
//        });



/*Reset pswd popup*/

});


