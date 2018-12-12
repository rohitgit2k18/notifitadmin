$(document).ready(function () {
    

    //alert("calenderData");
    $.ajax({
        type: "GET",
        url: "/MySchedule/ShowShiftTimings?DoctorId?ScheduleMonth=",
        dataType: "json",
        success: function (calenderData) {
            console.log(calenderData);
            var caldata = [];
            $.each(calenderData, function (index, value) {               
                    caldata.push({
                        "Id": value.Id,
                        "DoctorId": value.DoctorId,
                        "Title": value.Title,
                        "IsWorking": value.IsWorking,
                        "start": value.start,
                        "end": value.end,
                        "value": value.value,
                        "ScheduleMonth": value.ScheduleMonth
                    });                
            });

            console.log('tarran')
            console.log(caldata);
       
            $('#calendar').fullCalendar({
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                },
                navLinks: true, // can click day/week names to navigate views
                selectable: true,
                selectHelper: true,
                select: function (start, end) {    
                    $('.modal').modal('show');
                },
                events: caldata,
                dayClick: function (date, jsEvent, view) {

                    alert('Clicked on: ' + date.format());
                    presentDate = formatDate(date.format());
                    $('.modal').find('#pDate').val(presentDate);
                    // change the day's background color just for fun
                    $(this).css('background-color', 'white');

                },

                eventClick: function (event, element) {
                    // Display the modal and set the values to the event values.
                    $('.modal').modal('show');
                    console.log(event);
                    $('.modal').find('#title').val(event.title);
                    $('.modal').find('#starts-at').val(event.start);
                    $('.modal').find('#ends-at').val(event.time);

                },
                editable: true,
                eventLimit: true // allow "more" link when too many events

            });
        },
        error: function () {
            alert("Error occured!!")
        }
    });
  
    //end


    var presentDate;
	
	function gettime(time){	
		return time.substr(time.indexOf(' '),time.length);
	}
	
	// Bind the dates to datetimepicker.
	// You should pass the options you need
	
	$("#starts-at, #ends-at").datetimepicker();
	// Whenever the user clicks on the "save" button om the dialog
	$('#save-event').on('click', function() {
		
		var title = $('#title').val();
	    //var time = gettime($('#starts-at').val()) +'-'+gettime($('#ends-at').val());
		console.log(presentDate);
		if (title) {
			var eventData = {
			    title: title,               
			    start: presentDate + ' ' + $('#timepicker1').val(),
			    end: presentDate + ' ' + $('#timepicker2').val(),
			    startTime:$('#timepicker1').val(),
			    endTime: $('#timepicker2').val(), 
			    value: $('#timepicker1').val() +'-'+ $('#timepicker2').val()
			};		
		
			$('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
		}
		$('#calendar').fullCalendar('unselect');

		alert("submit");
		$('form').submit();
	    // Clear modal inputs
		$('.modal').find('input[type="text"]').val('');

	    // hide modal
		$('.modal').modal('hide');
       
	});
	 
});

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [month, day, year].join('/');
}

	










