// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var logged_in_user=null;

function logged_in_setup()
{
	if (s=readCookie("account"))
	{
		nick=unescape(s).split(":")[0];
		logged_in_user=nick;
	//	alert(nick);
		$('login_nick').innerHTML=nick;
		$('mine_nav_link').href="/author/" + nick;
		document.getElementsByClassName("loggedinonly").each(function(e) {
			e.show(); });
	}
//	alert(readCookie("pasties"));
}

	function register_onload(func) {
	  Event.observe(window, 'load', func, false);
	}
	
	function show_dates_as_local_time() {
	  var spans = document.getElementsByTagName('span');
	  for (var i=0; i<spans.length; i++) {
	    if (spans[i].className.match(/\btypo_date\b/i)) {
	      spans[i].innerHTML = get_local_time_for_date(spans[i].title);
	    }
	  }
	}
	
	function get_local_time_for_date(time) {
	  system_date = new Date(time);
	  user_date = new Date();
	  delta_minutes = Math.floor((user_date - system_date) / (60 * 1000));
	  if (Math.abs(delta_minutes) <= (8*7*24*60)) { // eight weeks... I'm lazy to count days for longer than that
	    distance = distance_of_time_in_words(delta_minutes);
	    if (delta_minutes < 0) {
	      return distance + ' from now';
	    } else {
	      return distance + ' ago';
	    }
	  } else {
	    return system_date.toLocaleDateString();
	  }
	}
	
	// a vague copy of rails' inbuilt function,
	// but a bit more friendly with the hours.
	function distance_of_time_in_words(minutes) {
	  if (minutes.isNaN) return "";
	  minutes = Math.abs(minutes);
	  if (minutes < 1) return ('less than a minute');
	  if (minutes < 50) return (minutes + ' minute' + (minutes == 1 ? '' : 's'));
	  if (minutes < 90) return ('about one hour');
	  if (minutes < 1080) return (Math.round(minutes / 60) + ' hours');
	  if (minutes < 1440) return ('one day');
	  if (minutes < 2880) return ('about one day');
	  else return (Math.round(minutes / 1440) + ' days')
	}

/* tm themes */

function setActiveStyleSheet(title) {
  var i, a, main;
//  for(i=0; (a = document.getElementsByTagName("link")[i]); i++) 
	var links=$$('#head link');
//	var start=new Date();
	links.each (function (a) 
	{
    if(a.getAttribute("rel").indexOf("style") != -1 && a.getAttribute("title")) {
      a.disabled = true;
      if(a.getAttribute("title") == title) a.disabled = false;
    }
  });
	// var end=new Date();
	// alert (end-start);
	createCookie("tm_theme", title, 365);
}

window.onload = function(e) {
  var cookie = readCookie("tm_theme");
  var theme = cookie ? cookie : "twilight";
	if ($('tm_theme_picker')) {
		$('tm_theme_picker').value=theme;
	  setActiveStyleSheet(theme);
	}
  }

/* cookies */

function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)
	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function createCookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
  }
  else expires = "";
  document.cookie = name+"="+value+expires+"; path=/";
}

/* private */

function toggle_private()
{
  o=$('paste_restricted');
  if (o.checked)
  {
    $('private').show();
    $('legend').hide();
  }
  else
  {
    $('private').hide();
    $('legend').show();
  }

}

function bounty(o)
{
  if (o.value=="bounty")
    $('bounty_div').show();
  else
    $('bounty_div').hide();  
}