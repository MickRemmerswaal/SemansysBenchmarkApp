xquery version "1.0-ml";
xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">';

declare namespace link="http://www.xbrl.org/2003/linkbase";
declare namespace bd-alg="http://www.nltaxonomie.nl/nt11/bd/20161207/dictionary/bd-algemeen";
declare namespace bd-bedr="http://www.nltaxonomie.nl/nt11/bd/20161207/dictionary/bd-bedrijven";
declare namespace bd-bedr-tuple="http://www.nltaxonomie.nl/nt11/bd/20161207/dictionary/bd-bedr-tuples";
declare namespace bd-dim-mem="http://www.nltaxonomie.nl/nt11/bd/20161207/dictionary/bd-domain-members";
declare namespace bd-dim-dim="http://www.nltaxonomie.nl/nt11/bd/20161207/validation/bd-axes";
declare namespace xbrldi="http://xbrl.org/2006/xbrldi";
declare namespace xbrli="http://www.xbrl.org/2003/instance";
declare namespace iso4217="http://www.xbrl.org/2003/iso4217";
declare namespace xlink="http://www.w3.org/1999/xlink";

declare function local:uploadFile()
{
for $file at $pos in xdmp:get-request-field("upload")
	let $filename := xdmp:get-request-field-filename("upload")[$pos]
	let $contenttype := xdmp:get-request-field-content-type("upload")[$pos]
	let $extension := fn:replace($filename, '.*\.', '')[$pos]
	let $insert := switch ($contenttype)
		case "text/xml"
		case "text/xhtml"
		case "text/csv"
		case "text/plain"
		case "application/json"
			return xdmp:document-insert($filename,xdmp:unquote($file))
		case "application/octet-stream"
			return switch ($extension)
			case "gpx"
			case "xbrl"
				return xdmp:document-insert($filename,xdmp:unquote(xdmp:quote(binary{xs:hexBinary($file)})))
			default
				return xdmp:document-insert($filename,$file)
		default
			return xdmp:document-insert($filename,$file)
	return fn:concat("file '",$filename,"' uploaded, contenttype: ",$contenttype," extension: ",$extension)
};
	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/xml; charset=utf-8" />
<title>Semansys Upload service</title>
<link href="css/semansys.css" rel="stylesheet" type="text/css" />
</head>
<body>
{local:uploadFile()}
<div id="wrapper">
   <span class="currently">Start <a href="benchmark.xqy">Benchmarking</a></span><br />
</div>
<div id="wrapper">
  <span class="currently">Go to <a href="index.xqy">Uploader</a></span><br />  
  <span class="currently">Currently in database: {fn:count(fn:doc())}</span><br />
</div> 
<div id="wrapper">
  <br />
  <br />
  <br />
  <div id="graybar">
  </div>
  <div id="content">
	<p>Dank voor het uploaden</p>
  </div>
  <div id="graybar">
  </div>  
</div>
</body>
</html>
