<?php

$ip = $_SERVER['REMOTE_ADDR'];
$usage = <<<EOD
<html>
<head>
<title>SimpleStorage</title>
</head>

<body>
	<h1>SimpleStorage</h1>
	Gets and sets game data by id<br />

	<p>current ip: <b>$ip</b></p>
	<br />

	<h3>Params</h3>
	<table cellpadding="4">
	<tr><td><code><b>game</b></code></td><td><i>String</i></td><td>unique game id</td></tr>
	<tr><td><code><b>format</b></code></td><td>["json", "vrml"]</td><td>data format</td></tr>
	<tr><td><code><b>data</b></code></td><td><i>String</i></td><td>game data and access mode. for a non-empty string the value is stored; an empty string triggers data retrieval</td></tr>
	</table>
	<br />
 
	<a name="usage"><h2>Usage Examples</h2></a>
	<h3>JSON</h3>
	<ul>
	<li><a href='?game=test1&format=json&data={%22initials%22:[%22he%22,%22she%22,%22me%22,%22we%22,%22they%22],%22scores%22:[61,50,34,25,24]}'>set</a></li>
	<li><a href='?game=test1&format=json'>get</a></li>
	</ul>

	<h3>VRML</h3>
	<ul>
	<li><a href='?game=test2&format=vrml&data=GameData{scores[1010,123,400]initials[%22pbg%22,%22abc%22,%22ace%22]data[%22foo%22%20%221%22,%20%22bar%22%20%222%22,%20%22bat%22%20%223%22]}'>set</a></li>
	<li><a href='?game=test2&format=vrml'>get</a></li>
	</ul>
	<br />
	
	<h2>Data Structure Requirements and Server Response Formats</h2>
	<p>This implementation receives data sent via HTTP GET, limiting data submissions to <a href="http://support.microsoft.com/kb/208427">2048 characters in IE</a>.</p>

	<h3>Error Codes</h3>
	The server provides an integer error code value in all responses:
	<ul>
	<li>&emsp;&ensp;0 &ensp;<i>no error</i></li>
	<li>-999 &ensp;<i>access denied</i></li>
	<li>-100 &ensp;<i>illegal game id</i> - must be 32 characters or less, using only letters A-Z,a-z and numbers 0-9</li>
	<li>-200 &ensp;<i>file unable to be read</i> - the file may not exist yet</li>
	<li>-300 &ensp;<i>file unable to be written</i> - you may not have write permissions for the file</li>
	</ul>
	<br />

	<h3>JSON</h3>
	<table cellpadding="8">
	<tr>
	<td valign="top" bgcolor="dfdfdf">
	Any valid JSON object can be submitted.<br />
	The example <a href="#usage">above</a> submits:
	<pre>{
	"initials": [
		"he",
		"she",
		"me",
		"we",
		"they"
	],
	"scores": [
		61,
		50,
		34,
		25,
		24
	]
}</pre>
	</td>
	<td valign="top" bgcolor="eaeaea">
	<br />
	...and server response objects have the following structure:
	<pre>{
	"type" : <i>String</i>, 
	"success" : <i>Boolean</i>, 
	"message" : <i>String</i>, 
	"code" : <i>Number</i>, 
	"data" : <i>Object</i>
}</pre>
	</td>
	</tr>
	</table>
	<br />
	
	<h3>VRML</h3>
	<table cellpadding="4">
	<tr>
	<td valign="top" bgcolor="dfdfdf">
	The following GameData node prototype is supported for data submission:
	<pre>PROTO GameData [
   field MFInt32 scores [] 
   field MFString initials []
   field MFString data []
] {}</pre>

	<br />
	The example <a href="#usage">above</a> submits:
	<pre>GameData{
   scores[
      1010,
      123,
      400
   ]
   initials[
      "abc",
      "pbg",
      "ace"
   ]
   data[
      "foo" "1", 
      "bar" "2", 
      "bat" "3"
   ]
}</pre>
	</td>
	<td valign="top" bgcolor="eaeaea">
	...and server responses are instances of the following ServerRequest node prototype:
	<pre>PROTO ServerRequest [ 
   field SFString type "" 
   field SFBool success FALSE 
   field SFString message "" 
   field SFInt32 code 0
   field SFNode data NULL # GameData instance
] {}</pre>
	</td>
	</tr>
	</table>
	<br />

	<br />

</body>
</html>
EOD;

// read parameters from the query string
$game = $_GET["game"];
$format = $_GET["format"];
$data = stripcslashes($_GET["data"]); // undo url encoding

// set global vars
$mode = (($data == "") ? "get" : "set");
$dataFileDirectory = "/somewhere/not/webreadable/";
$dataFileExtension = ".data";
$thelist = $dataFileDirectory. "whitelist.php";
$defaultFormat = "json";
$formatHeaders = array(
	"json" => "",
	"vrml" => "#VRML V2.0 utf8\nPROTO GameData[field MFInt32 scores[] field MFString initials[] field MFString data[]]{}\nPROTO ServerRequest[field SFString type\"\" field SFBool success FALSE field SFString message\"\" field SFInt32 code 0 field SFNode data NULL]{}\n"
);

$NONE = 0;
$LOAD = 1;
$ALL  = 2;

$NO_ERR = 0;
$ACCESS_DENIED = -999;
$ILLEGAL_ID = -100;
$NO_READ = -200;
$NO_WRITE = -300;

// early bail: show usage when operation is impossible
if ( $game == "" ) {
  print($usage);
  return;
}


// use default format if none or invalid provided
if (!isset($formatHeaders[$format])) { $format = $defaultFormat; }

// print header for selected format
print($formatHeaders[$format]);


// check the whitelist
include $thelist;

$permission = $NONE;
if (array_key_exists($game, $whitelist)) {
	$permission = $LOAD;
	if (in_array("*", $whitelist[$game]) || in_array($ip, $whitelist[$game])) {
		$permission = $ALL;
	}
}


// bail on lack or permissions
if ( $permission == $NONE ) { 
	print( new_result($format, $mode, FALSE, "access denied", $ACCESS_DENIED, "") );
	return;
}

// bail on invalid file name
if ( !preg_match("/^[A-Za-z0-9]{1,32}$/", $game) ) { 
	print( new_result($format, $mode, FALSE, "invalid game id '$game'", $ILLEGAL_ID, "") );
	return;
}

// construct path for valid file name
$dataFileName = md5($game); // hash to avoid allowing using user to specify filename on disk
$dataFilePath = $dataFileDirectory. $dataFileName. $dataFileExtension;

// access data according to mode and print result
switch ($mode) {
	case "get":
		$fileData = @file_get_contents($dataFilePath);
		if ($fileData) {
			print( new_result($format, $mode, TRUE, "data retrieved for '$game'", $NO_ERR, $fileData) );
		}
		else {
			print( new_result($format, $mode, FALSE, "error retrieving data for '$game'", $NO_READ, "") );
		}
	break;
	
	case "set":
		if ( ($permission == $ALL) && (file_put_contents($dataFilePath, $data)) ) {
			print( new_result($format, $mode, TRUE, "data stored for '$game'", $NO_ERR, $data) );
		}
		else {
			print( new_result($format, $mode, FALSE, "error storing data for '$game'", $NO_WRITE, $data) );
		}
	break;
}

// done!
return;



// / / / / / utility functions / / / / / / / / / / / / / / / / /

/* simple file I/O not defined in php4, but is in php5
function file_put_contents($file, $string) {
	// chmod 701 <thisFile>.php
	// chmod 707 <the target directory>
	$f=@fopen($file, 'a+');
	if ( !$f ) {
		return 0;
	}
	ftruncate($f, 0);
	fwrite($f, $string);
	fclose($f);
	return 1;
}*/


// formatted result objects
function new_result($format, $type, $success, $message, $code, $data) {
	$r = " ";
	
	switch ($format) {
		case "json":
			if ($data == "") { $data = "null"; }
			$bool = (($success) ? "true" : "false");
			$r = "{\"type\" : \"{$type}\",\"success\" : {$bool},\"message\" : \"{$message}\",\"code\" : {$code},\"data\" : {$data}}";
			break;
			
		case "vrml":
			if ($data == "") { $data = "NULL"; }
			$bool = (($success) ? "TRUE" : "FALSE");
			$r = "ServerRequest {type \"{$type}\" success {$bool} message \"{$message}\" code {$code} data {$data}}";
			break;
	}
	
	return $r;
}

?>