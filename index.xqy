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

	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Semansys Upload service</title>
<link href="css/semansys.css" rel="stylesheet" type="text/css" />
</head>

<body>
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
	<form name="test" action="upload.xqy" method="post" enctype="multipart/form-data">
    <p><label>File to upload:
    <input type="file" class="name" name="upload" size="50" multiple="true" /></label></p>
    <p><input type="submit" value="Upload and Get Results"/></p>
    </form>
  </div>
  <div id="graybar">
  </div>  
</div>
</body>
</html>
