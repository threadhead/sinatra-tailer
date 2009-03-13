$(document).ready(function(){
	var selectedLog;
	var logLines;
	function setSelectedLog() {
		selectedLog = $("#select_log option:selected").val();
		logLines = $("#log_lines option:selected").val();
	}
	
	$("#select_log").change(function(e){
		setSelectedLog();
		window.parent.location = "/log/" + selectedLog;
	});
	
	
	function updateLog() {
		setSelectedLog();
		$("#log_text").load("/log_text", {lines: logLines} );
		$("#info-bar").load("/info_bar", {lines: logLines} );
	}
	
	
	$("#refresh_seconds").change( function(){
		stopUpdate();
		startUpdate();
	});
	
	
	var intervalID;
	function startUpdate() {
		var updateInterval = $("#refresh_seconds option:selected").val() * 1000;
		intervalID = setInterval( function(){updateLog();}, updateInterval);
	}
	
	function stopUpdate() {
		clearInterval(intervalID);
	}
	
	
	$("button[id='start-stop']").click(function(){
		if ($(this).html() == "start") {
			$("#refresh_seconds").removeAttr("disabled");
			$("#spinner").show();
			$(this).html("stop");
			startUpdate();
			
		} else {
			$("#refresh_seconds").attr("disabled","disabled");
			$("#spinner").hide();
			$(this).html("start");
			stopUpdate();
			
		};
	});
	
	updateLog();
	startUpdate();
});