/*	Javascript Ground Zero 2 Mapplet,v.2.2.0
	Carlos Labs Pty, 2007-2013
	PID: 200712B, http://www.carloslabs.com
	
	This code is released under a Creative Commons license. 
	http://creativecommons.org/licenses/by/3.0/legalcode

	You may use this code in any software project, provided you
	do not remove or modify this header and you credit us as the
	original authors of the code.
	
	Thanks and credits on www.carloslabs.com
	
	November 2013: This version uses Google's Maps API v.3 - JS code is based on the revised Ground Zero, released in April 2013,
	but with additional code for handling Google's custom controls, and extra code for calculating overpressure and radiation.
	
*/

	// Ground Zero namespace
	var grz = {};
	grz.map;
	grz.geocoder;
	grz.marker;
	grz.overlays = [];	
	grz.gZ = null;
	grz.location = null;
	grz.tg = new Array();
	grz.w = new Array();
	grz.c = new Array();	
	grz.c1 = "";grz.c2 = "";grz.c3 = "";grz.c4 = "";
	grz.mapzoom = 12;
	grz.default_zoom = grz.mapzoom;
	grz.idx = 0;
	grz.y = 0;
	grz.drop = 0;
	grz.cities = 16;
	grz.MapLoaded = false;
	grz.mode = 0;	//default to Thermal
	grz.wind = 90;
	grz.options = 0;

	var f = loadData();
	
	// Load static data
	function loadData()	{
	// List of weapons: yield in kilotons, year, country, narrative, map zoom
		grz.w[0] = "0,0,0,0";
		grz.w[1] = "7.5,2013,N Korea,The latest brinkmanship device from Kim Jong Un himself.,13";		
		grz.w[2] = "15,1945,US,The uranium Hiroshima bomb was the 1st device used in war.,13";
		grz.w[3] = "21,1945,US,The plutonium Nagasaki bomb was the 2nd device used in war.,13";
		grz.w[4] = "400,1953,USSR,Named after Joseph Stalin; this was the 1st soviet H-bomb.,11";
		grz.w[5] = "1400,1958,US,A cowboy was seen riding this bomb in the Dr Strangelove movie.,11";
		grz.w[6] = "50000,1961,USSR,This was the largest manmade explosion ever recorded in history.,9";
		grz.w[7] = "340,1991,US,A modern nuclear bomb that can be carried by a fighter jet.,11";
		grz.w[8] = "12000,1952,US,The first H-bomb was a massive cryogenic nightmare in a coral atoll.,9"; 
		grz.w[9] = "140,2001,China,A modern nuclear bomb carried by an intercontinental missile.,12";
		grz.w[10] = "8500000000,Prehistory,Cosmic Event,The Chicxulub impact caused the end of the dinosaurs.,2";	
	
	// List of targets: latitude, longitude, narrative
		grz.c[0] = "39.768403,-86.158068,Indianapolis";
		return 1;
	}

	function ButtonControl(controlDiv, targetMap) {
      var widthPercent = '25%';
      var heightPercent = '100%';

	  controlDiv.style.padding = '1px';
	  controlDiv.style.paddingTop = '5px';
      controlDiv.style.width = '100%';
      controlDiv.style.height = '20%';
      controlDiv.style.minHeight = '25px';

	  // Set CSS for the control border.
	  var controlUI = document.createElement('div');
      controlUI.style.width = '100%';
      controlUI.style.height = '20%';
      controlUI.style.minHeight = '25px';
	  controlUI.style.borderStyle = 'none';
	  controlUI.style.borderWidth = '1px';
	  controlUI.style.cursor = 'pointer';
	  controlUI.style.textAlign = 'center';
	  controlUI.style.backgroundColor = "#666666";	  
	  controlDiv.appendChild(controlUI);
	
	  // Set CSS for the control interior.
	  var btn1 = document.createElement('button');
      btn1.style.width = widthPercent;
      btn1.style.height = heightPercent;
      btn1.style.minHeight = '25px';
	  btn1.title = "Radius of damage caused by fireball";
	  btn1.style.fontFamily = 'Arial,sans-serif';
	  btn1.style.fontSize = '2vw';
	  btn1.style.backgroundColor = "#ff7373";
	  btn1.style.color = "#ffefef";
	  btn1.style.borderStyle = 'solid';
	  btn1.style.borderWidth = '1px';  
	  btn1.style.paddingLeft = '3px';
	  btn1.style.paddingRight = '3px';
	  btn1.style.paddingTop = '2px';
	  btn1.style.paddingBottom = '2px';
	  btn1.innerHTML = '<strong>Thermal Map</strong>';
	  controlUI.appendChild(btn1);
  	
	  var btn2 = document.createElement('button');
      btn2.style.width = widthPercent;
      btn2.style.height = heightPercent;
      btn2.style.minHeight = '25px';
	  btn2.title = "Shows radius of overpressure";
	  btn2.style.fontFamily = 'Arial,sans-serif';
	  btn2.style.fontSize = '2vw';
	  btn2.style.backgroundColor = "#7872d8";
	  btn2.style.color = "#ffefef";  
	  btn2.style.borderStyle = 'solid';
	  btn2.style.borderWidth = '1px';    
	  btn2.style.paddingLeft = '2px';
	  btn2.style.paddingRight = '2px';
	  btn2.style.paddingTop = '2px';
	  btn2.style.paddingBottom = '2px';  
	  btn2.innerHTML = '<strong>Pressure Map</strong>';
	  controlUI.appendChild(btn2);
	  
	  var btn3 = document.createElement('button');
      btn3.style.width = widthPercent;
      btn3.style.height = heightPercent;
      btn3.style.minHeight = '25px';
	  btn3.title = "Display of fallout patterns. Click to change wind direction";  
	  btn3.style.fontFamily = 'Arial,sans-serif';
	  btn3.style.fontSize = '2vw';
	  btn3.style.backgroundColor = "#8fbc8f";
	  btn3.style.color = "#ffefef";  
	  btn3.style.borderStyle = 'solid';
	  btn3.style.borderWidth = '1px';    
	  btn3.style.paddingLeft = '2px';
	  btn3.style.paddingRight = '2px';
	  btn3.style.paddingTop = '2px';
	  btn3.style.paddingBottom = '2px';    
	  btn3.innerHTML = '<strong>Fallout Map</strong>';
	  controlUI.appendChild(btn3);	

	  var btn4 = document.createElement('button');
      btn4.style.width = widthPercent;
      btn4.style.height = heightPercent;
      btn4.style.minHeight = '25px';
	  btn4.title = "Clear Map";  
	  btn4.style.fontFamily = 'Arial,sans-serif';
	  btn4.style.fontSize = '2vw';
	  btn4.style.backgroundColor = "#dddddd";
	  btn4.style.color = "#373333";  
	  btn4.style.borderStyle = 'solid';
	  btn4.style.borderWidth = '1px';    
	  btn4.style.paddingLeft = '2px';
	  btn4.style.paddingRight = '2px';
	  btn4.style.paddingTop = '2px';
	  btn4.style.paddingBottom = '2px';    
	  btn4.innerHTML = '<strong>Reset All</strong>';
	  controlUI.appendChild(btn4);	
	
	
	  // Event listeners
	  google.maps.event.addDomListener(btn1, 'click', function() {
	    	grz.mode = 0;
	    	closeInfoWindow();
	    	dropBomb(grz.options);
	  }); 
	     google.maps.event.addDomListener(btn2, 'click', function() {
			grz.mode = 1;
			closeInfoWindow();
			dropBomb(grz.options);
	  });
	     google.maps.event.addDomListener(btn3, 'click', function() {
			grz.mode = 2;
			grz.wind += 45;
			closeInfoWindow();
			dropBomb(grz.options);
	  });
	    google.maps.event.addDomListener(btn4, 'click', function() {
			clearAll();
	  }); 
  
	}
        
	function initialize() {
		var rd = Math.floor(0 * grz.cities);
		var cd = grz.c[rd].split(",");
		grz.tg[0] = parseFloat(cd[0]);
		grz.tg[1] = parseFloat(cd[1]);
		var search_caption = ""+ cd[2];
		document.forms.yields.selector.value = 0;
		var mapOptions = {
		    zoom: grz.default_zoom,
		    center: new google.maps.LatLng(grz.tg[0], grz.tg[1]),
		    panControl: false,
            scrollwheel: false,
            disableDoubleClickZoom: true,
            draggable: false,
            mapTypeControl: false,
		    streetViewControl: false,
		    zoomControl: true,
		    zoomControlOptions: {
				style: google.maps.ZoomControlStyle.LARGE,
				position: google.maps.ControlPosition.LEFT_CENTER		      
		    },
		    scaleControl: true,
		    scaleControlOptions: {		    	
				position: google.maps.ControlPosition.BOTTOM_CENTER
		    },		    
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		}
				  			  
		grz.map = new google.maps.Map(document.getElementById("map"), mapOptions);
		grz.geocoder = new google.maps.Geocoder();
		
		var btnDiv = document.createElement("div");
		var btnDivC = new ButtonControl(btnDiv, grz.map);			
		btnDiv.index = 1;
		grz.map.controls[google.maps.ControlPosition.LEFT_TOP].push(btnDiv);		
		
		var search_caption =  '' + cd[2];
		document.getElementById("address").value = search_caption;
		
		grz.location = new google.maps.LatLng(grz.tg[0], grz.tg[1]);
		grz.map.setCenter(grz.location);
		
		grz.marker = new google.maps.Marker({
		    position: grz.location, 
		    draggable: true,
		    map: grz.map,
		    title: 'Click for details: ' + grz.tg[0].toString() + ', ' + grz.tg[1].toString()
		});
		grz.MapLoaded = true;

	}
	
	function codeAddress() {
	    var address = document.getElementById("address").value;
	    
	    grz.geocoder.geocode( { 'address': address}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			
			if (grz.marker)
				grz.marker.setMap(null);  			
				
		  	grz.tg[0] = results[0].geometry.location.lat();
			grz.tg[1] = results[0].geometry.location.lng();
			grz.location = new google.maps.LatLng(grz.tg[0], grz.tg[1]);
			
		    grz.map.setCenter(results[0].geometry.location);
		    
			grz.marker = new google.maps.Marker({
			    position: grz.location, 
			    draggable: true,
			    map: grz.map,
			    title: grz.tg[0].toString() + ', ' + grz.tg[1].toString()
			});  	     

		  } else {
		    alert("Geocode error: " + status);	        
		  }
	    });	
	    
	}
	function closeInfoWindow()	{
		if (grz.infowindow)
			grz.infowindow.close();	
	}	
	function deleteOverlays()	{
		if (grz.overlays) {
		    for (var i in grz.overlays) {
		      grz.overlays[i].setMap(null);
		    }
		}
	}
		
	function clearAll(){	
		closeInfoWindow();		
		deleteOverlays();
		document.forms.yields.selector.value = 0;
		document.getElementById('t_1').innerHTML = " ";		
	
		grz.idx=0;
		grz.mapzoom=13;
		grz.map.setCenter(grz.location, grz.mapzoom);
		grz.tg[0] = parseFloat(grz.location.lat());
		grz.tg[1] = parseFloat(grz.location.lng());	
		grz.drop=0;
		return 1;
	}

	function buildInfo(mode){
		var n;
		if (mode==0)	{
			n = "<table width=\"375px\" cellspacing=\"1\" cellpadding=\"0\" border=\"0\">";
			n+="<tr align=\"center\" class=\"gz_c_t\"><th width=\"35%\">Zone</th><th width=\"65%\">Physical Effects</th></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_c_1\">1st Degree Burns</td><td width=\"65%\" class=\"gz_c_p\">Sunburn-like discomfort, skin redness</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_c_2\">2nd Degree Burns</td><td width=\"65%\" class=\"gz_c_p\">Blisters and pain, like burns by boiling water</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_c_3\">3rd Degree Burns</td><td width=\"65%\" class=\"gz_c_p\">Skin charring and necrosis, requiring medical care</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_c_4\">Conflagration</td><td width=\"65%\" class=\"gz_c_p\">Most people will die within 24 hours</td></tr></table>";
		}
		if (mode==1)	{
			n = "<table width=\"375px\" cellspacing=\"1\" cellpadding=\"0\" border=\"0\">";
			n+="<tr align=\"center\" class=\"gz_c_t\"><th width=\"35%\">Zone</th><th width=\"65%\">Physical Effects</th></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_p_1\">1 psi (6.9 kPa)</td><td width=\"65%\" class=\"gz_c_p\">Windows shatter, injuries by shards and debris</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_p_2\">5 psi (34.5 kPa)</td><td width=\"65%\" class=\"gz_c_p\">Non-reinforced structures fail and collapse</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_p_3\">10 psi (69 kPa)</td><td width=\"65%\" class=\"gz_c_p\">Quake-proof buildings are totally destroyed</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_p_4\">20 psi (138 kPa)</td><td width=\"65%\" class=\"gz_c_p\">Fortifications and bunkers are demolished</td></tr></table>";
		}
		if (mode==2)	{
			n = "<table width=\"375px\" cellspacing=\"1\" cellpadding=\"0\" border=\"0\">";
			n+="<tr align=\"center\" class=\"gz_c_t\"><th width=\"35%\">Zone</th><th width=\"65%\">Physical Effects</th></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_f_1\">&gt; 200 REM</td><td width=\"65%\" class=\"gz_c_p\">Vomits, nausea. Long term risk of cancer</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_f_2\">200 - 500 REM</td><td width=\"65%\" class=\"gz_c_p\">Bleeding, vomiting, hair loss, 10-30% fatalities</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_f_3\">500 - 800 REM</td><td width=\"65%\" class=\"gz_c_p\">Bone marrow destruction, coma, 50-70% fatalities</td></tr>";
			n+="<tr align=\"center\"><td width=\"35%\" class=\"gz_f_4\">&lt; 800 REM</td><td width=\"65%\" class=\"gz_c_p\">Fatalities approach 100% within 24 hours</td></tr></table>";
			}					
		return n;
	}	
	
	// sourced and inspired by www.fas.org and wikipedia.org
	function kmToDegX(kms, lat) {
		return (kms / (Math.abs(lat) * 180/112.12 + 112.12));}
	function kmToDegY(kms) {
		return (kms / 112); }					
	function cX(x, radius, angle) {
		return x + radius * Math.cos(radians(angle));	}
	function cY(y, radius, angle) {
		return y + radius * Math.sin(radians(angle));	}
	function radians(degrees) {
		return degrees*Math.PI/180;		}
	
	function pa(kt, f)	{
		var A = 1, B = 1;
		if (grz.mode == 0)	{
			if (f==1) {A=0.38;B=1.2;grz.c1="#ff9933";};
			if (f==2) {A=0.4;B=0.88;grz.c2="#cc6666"};
			if (f==3) {A=0.34;B=0.67;grz.c3="#660066"};
			if (f==4) {A=0.3;B=0.55;grz.c4="#333333"};
		}
		if (grz.mode == 1)	{
			if (f==1) {A=0.33;B=1.8;grz.c1="#9370DB";};
			if (f==2) {A=0.33;B=0.71;grz.c2="#007BA7"};
			if (f==3) {A=0.33;B=0.45;grz.c3="#5218FA"};
			if (f==4) {A=0.3;B=0.28;grz.c4="#333333"};
		}
		if (grz.mode == 2)	{	
			if (f==1) {A=0.33;B=0.8;grz.c1="#44944A"};
			if (f==2) {A=0.32;B=0.55;grz.c2="#D1E231"};
			if (f==3) {A=0.31;B=0.42;grz.c3="#3FFF00"};
			if (f==4) {A=0.3;B=0.3;grz.c4="#333333";};
		}	
		return Math.pow(kt,A) * B;
	}			

	function eX(x, radiusA, radiusB, sinalpha, cosalpha, sinbeta, cosbeta) {
		return x + (radiusA * cosalpha * cosbeta - radiusB * sinalpha * sinbeta);}
	function eY(y, radiusA, radiusB, sinalpha, cosalpha, sinbeta, cosbeta) {
		return y + (radiusA * cosalpha * sinbeta + radiusB * sinalpha * cosbeta);}
		
	function dropBomb(options) {
		var vX = 0, vY = 0;
		var opt = {geodesic:true};
		var zX = new Array(), zY = new Array();
		var circles = new Array();
		var polys = new Array();
		var aE1 = new google.maps.MVCArray();
		var aE2 = new google.maps.MVCArray();
		var aE3 = new google.maps.MVCArray();
		var aE4 = new google.maps.MVCArray();
		
		if (!grz.MapLoaded)
			return 0;
	
		if (grz.idx == 0) {
			alert("Select a Weapon from the list");
			return 0;
		}
				
		deleteOverlays();
			
		grz.map.setZoom(grz.mapzoom);
		grz.map.setCenter(grz.location);
		
		grz.infowindow = new google.maps.InfoWindow({
		    content: buildInfo(grz.mode)
		});
			
		google.maps.event.addListener(grz.marker, 'click', function() {
			if (grz.drop==1)		  		
				grz.infowindow.open(grz.map, grz.marker);
		});				
		if (grz.mode!=2)	{
			for (var i = 1; i < 5; i ++) {
				circles[i] = new google.maps.Circle({
					center: grz.location,
					clickable: false,
					map: grz.map,
					radius: pa((grz.y),i) * 700, //corrects the projection of GZ-II
					strokeColor: eval("grz.c" + i),
					strokeOpacity: 0.2,
					strokeWeight: 1,
					fillColor: eval("grz.c" + i),
					fillOpacity: 0.4		
				});
				grz.overlays.push(circles[i]);
			}	
		}
		else	{
			zX[0] = kmToDegX(pa((grz.y),1), grz.tg[0]);
			zX[1] = kmToDegX(pa((grz.y),2), grz.tg[0]);
			zX[2] = kmToDegX(pa((grz.y),3), grz.tg[0]);
			zX[3] = kmToDegX(pa((grz.y),4), grz.tg[0]);	
			
			zY[0] = kmToDegY(pa((grz.y),1));
			zY[1] = kmToDegY(pa((grz.y),2));
			zY[2] = kmToDegY(pa((grz.y),3));
			zY[3] = kmToDegY(pa((grz.y),4));	
			var sinbeta = Math.sin(radians(grz.wind));
			var cosbeta = Math.cos(radians(grz.wind));
			var a = 0, b=0;
			var item;
			
			for (var i = 0; i < 360; i += (360 / 24)) {	
				var sinalpha = Math.sin(radians(i));
			    var cosalpha = Math.cos(radians(i));
			    
				a=zX[0];b=zY[0];
	
			    if ((i >= 180)) {b=(zY[0] * 3.5);} else {b=(zY[0] * 0.65);}
			    	
			    vX = eX(grz.tg[0],a,b,sinalpha,cosalpha,sinbeta,cosbeta);
			    vY = eY(grz.tg[1],a,b,sinalpha,cosalpha,sinbeta,cosbeta);
				item = aE1.push(new google.maps.LatLng(vX, vY));	
				a=zX[1];b=zY[1];
	
		    	if ((i >= 180)) {b=(zY[1] * 3.5);} else {b=(zY[1] * 0.85);}
	
			    vX = eX(grz.tg[0],a,b,sinalpha,cosalpha,sinbeta,cosbeta);
			    vY = eY(grz.tg[1],a,b,sinalpha,cosalpha,sinbeta,cosbeta);
				item = aE2.push(new google.maps.LatLng(vX, vY));
				a=zX[2];b=zY[2];
	
		    	if ((i >= 180)) {b=(zY[2] * 3.5);} else {b=(zY[2] * 0.90);}
	
			    vX = eX(grz.tg[0],a,b,sinalpha,cosalpha,sinbeta,cosbeta);
			    vY = eY(grz.tg[1],a,b,sinalpha,cosalpha,sinbeta,cosbeta);
				item = aE3.push(new google.maps.LatLng(vX, vY));		
				a=zX[3];b=zY[3];
				
		    	if ((i >= 180)) {b=(zY[3] * 3.5);} else {b=(zY[3] * 0.95);}
	
			    vX = eX(grz.tg[0],a,b,sinalpha,cosalpha,sinbeta,cosbeta);
			    vY = eY(grz.tg[1],a,b,sinalpha,cosalpha,sinbeta,cosbeta);
				item = aE4.push(new google.maps.LatLng(vX, vY));
				
			};
			
			for (var i = 1; i < 5; i ++) {
				polys[i] = new google.maps.Polygon({
					clickable:false,
					strokeColor: eval("grz.c" + i),
					strokeOpacity: 0.22,
					strokeWeight: 1,
					fillColor: eval("grz.c" + i),
					fillOpacity: 0.44				
				});
				polys[i].setPath(eval("aE"+ i));
				polys[i].setMap(grz.map);
				grz.overlays.push(polys[i]);
			}
		}		
		grz.drop=1;	
		return 1;
	}
	
	// Load the combo for weapons
	function loadWeapon(form) {
		grz.idx = form.selector.value;
		var wd = grz.w[grz.idx].split(",");
		grz.y = parseInt(wd[0]);
		grz.mapzoom = parseInt(wd[4]);
		if (grz.idx > 0)	{
			document.getElementById('t_1').innerHTML = wd[1] + ", " + wd[2] + ", " + wd[3];
		}
		else	{
			document.getElementById('t_1').innerHTML = "&nbsp;";
		}
		return 1;
	}	
	
	//CM, call the Google Maps libraries and attach into the DOM
	function loadScript() {
	  var script = document.createElement("script");
	  script.type = "text/javascript";
	  script.src = "http://maps.googleapis.com/maps/api/js?key=AIzaSyB-b40bbE9V3mYMEg2wuW1FJA-jgCsqQ2g&sensor=false&callback=initialize";
	  document.body.appendChild(script);
	}
	
	window.onload = loadScript;
