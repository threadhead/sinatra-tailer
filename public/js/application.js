$(document).ready(function(){
	var selectedLog;
	var logLines;
	var updateSeconds;
	function setSelectedLog() {
		selectedLog = $("#select_log option:selected").val();
		logLines = $("#log_lines option:selected").val();
		updateSeconds = $("#refresh_seconds option:selected").val();
	}
	
	$("#select_log").change(function(e){
			setSelectedLog();
			window.parent.location = "/log/" + selectedLog;
	});
	
	$("#log_lines").change(function(e){
			updateLog();
	});
	
	
	function updateLog() {
		setSelectedLog();
		$("#log_text").load("/log_text", {lines: logLines, id: selectedLog, refresh: updateSeconds} );
		$("#path-info").load("/info_bar", {lines: logLines, id: selectedLog, refresh: updateSeconds} );
	}
	
	
	$("#refresh_seconds").change( function(){
		stopUpdate();
		startUpdate();
	});
	
	
	var intervalID;
	function startUpdate() {
		setSelectedLog();
		updateInterval = updateSeconds * 1000;
		intervalID = setInterval( function(){updateLog();}, updateInterval);
	}
	
	function stopUpdate() {
		clearInterval(intervalID);
	}
	
	
	$("button[id='start-stop']").click(function(){
		if ($(this).html() == "start") {
			$("#refresh_seconds").removeAttr("disabled");
			$("img#spinner").show();
			$(this).html("stop");
			startUpdate();
			
		} else {
			$("#refresh_seconds").attr("disabled","disabled");
			$("img#spinner").hide();
			$(this).html("start");
			stopUpdate();
			
		};
	});
	
	updateLog();
	startUpdate();
});