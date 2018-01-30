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
declare namespace venj-bw2-i="http://www.nltaxonomie.nl/nt11/venj/20161214/dictionary/venj-bw2-data";

declare function local:getNumberOfCompanies()
{
	let $numberOfIDS := for $id in cts:element-values(xs:QName("xbrli:identifier"))
		return $id
	return fn:count($numberOfIDS)
};

declare function local:getCompanyNumbers($companyID, $startDateFunc, $endDateFunc, $factFunc)
{
	if($startDateFunc castable as xs:date)		
		then 	if($endDateFunc castable as xs:date)
				then	if(xs:date($startDateFunc) <= xs:date($endDateFunc))
						then							 
							let $fact := cts:element-values(xs:QName($factFunc), 0, (), 
											cts:and-query((
												cts:and-query((
													 cts:range-query(cts:element-reference(xs:QName("xbrli:startDate")), ">=",
														xs:date($startDateFunc)),
													cts:range-query(cts:element-reference(xs:QName("xbrli:endDate")), "<=",
														xs:date($endDateFunc)))),
											cts:element-query(xs:QName("xbrli:identifier"), $companyID))))
							return fn:sum($fact)
						else <div>Start date must be earlier then End date</div>			
				else	if($endDateFunc)
						then <div>Your input is invalid: {$endDateFunc}</div>						
						else						 
							let $fact :=  cts:element-values(xs:QName($factFunc), 0, (), 
												cts:and-query((							
													cts:range-query(cts:element-reference(xs:QName("xbrli:startDate")), ">=",
														xs:date($startDateFunc)),
													cts:element-query(xs:QName("xbrli:identifier"), $companyID))))
						return fn:sum($fact)
		else 	if($endDateFunc castable as xs:date)
				then 	if($startDateFunc)
						then <div>Your input is invalid: {$startDateFunc}</div>						
						else						
							let $fact :=  cts:element-values(xs:QName($factFunc), 0, (), 
												cts:and-query((							
													cts:range-query(cts:element-reference(xs:QName("xbrli:endDate")), "<=",
														xs:date($endDateFunc)),
													cts:element-query(xs:QName("xbrli:identifier"), $companyID))))
						return fn:sum($fact)
				else <div>Your input is invalid: {$startDateFunc, $endDateFunc}</div>
};

declare function local:getRestNumbers($startDateFunc, $endDateFunc, $factFunc)
{
	if($startDateFunc castable as xs:date)		
		then 	if($endDateFunc castable as xs:date)
				then	if(xs:date($startDateFunc) <= xs:date($endDateFunc))
						then							 
							let $fact := cts:element-values(xs:QName($factFunc), 0, (),
												cts:and-query((
													 cts:range-query(cts:element-reference(xs:QName("xbrli:startDate")), ">=",
														xs:date($startDateFunc)),
													cts:range-query(cts:element-reference(xs:QName("xbrli:endDate")), "<=",
														xs:date($endDateFunc)))))
							return fn:sum($fact) div local:getNumberOfCompanies()
						else <div>Start date must be earlier then End date</div>			
				else	if($endDateFunc)
						then <div>Your input is invalid: {$endDateFunc}</div>						
						else						 
							let $fact :=  cts:element-values(xs:QName($factFunc), 0, (), 					
													cts:range-query(cts:element-reference(xs:QName("xbrli:startDate")), ">=",
														xs:date($startDateFunc)))
						return fn:sum($fact) div local:getNumberOfCompanies()
		else 	if($endDateFunc castable as xs:date)
				then 	if($startDateFunc)
						then <div>Your input is invalid: {$startDateFunc}</div>						
						else						
							let $fact :=  cts:element-values(xs:QName($factFunc), 0, (), 
													cts:range-query(cts:element-reference(xs:QName("xbrli:endDate")), "<=",
													xs:date($endDateFunc)))
						return fn:sum($fact) div local:getNumberOfCompanies()
				else <div>Your input is invalid: {$startDateFunc, $endDateFunc}</div>
};

declare function local:checkDatesGetNumbers()
{
	if(xdmp:get-request-field("startDateInput") or xdmp:get-request-field("endDateInput"))
		then 			 
			(
				<tr>
					<td>
						Cijfers bedrijf {xdmp:get-request-field("idInput")}
					</td>
					<td>
						Gemiddeld cijfer alle bedrijven({local:getNumberOfCompanies()})
					</td>
				</tr>,
				<tr>
				<td>{local:getCompanyNumbers(xdmp:get-request-field("idInput"),xdmp:get-request-field("startDateInput"),
											 xdmp:get-request-field("endDateInput"),xdmp:get-request-field("factSelect"))}
				</td>,
				<td>{local:getRestNumbers(xdmp:get-request-field("startDateInput"), xdmp:get-request-field("endDateInput"),
										  xdmp:get-request-field("factSelect"))} 
				</td>
				</tr>
			)
		else			 
			(
				<tr>
					<td>Vul data in om te beginnen</td>,
					<td></td>				   
				</tr>
			)
};
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Semansys Benchmark service</title>
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
	<form name="inputForm" method="get" action="benchmark.xqy" id="inputForm">
		<div id="graybar">
		</div>
		<div id="content">
			Identifier: <br />
			<input type="text" name="idInput" id="idInput" size="15" value="{xdmp:get-request-field("idInput")}"/>
			Select searchable Fact:
			<select name="factSelect" selected="selected" value="{xdmp:get-request-field("factSelect")}">
				<option value="venj-bw2-i:Income">Income</option>
				<option value="venj-bw2-i:Assets">Assets</option>
				<option value="venj-bw2-i:Equity">Equity</option>
				<option value="venj-bw2-i:WagesSalaries">Salaries Wages</option>
				<option value="venj-bw2-i:Expenses">Expenses</option>
				<option value="venj-bw2-i:NetRevenue">Net Revenue</option>				
			</select>
		</div>
		<div id="graybar">
		</div>
		<div id="content">
			Start date: <br />
			<input type="text" name="startDateInput" id="startDateInput" size="15" value="{xdmp:get-request-field("startDateInput")}"/> 
		</div>
		<div id="graybar">
		</div>
		<div id="content">
			End date: <br />
			<input type="text" name="endDateInput" id="endDateInput" size="15" value="{xdmp:get-request-field("endDateInput")}"/> 
		</div>
		<div id="graybar">
		</div>
		<div id="content">
			Submit input: <br></br>
			<input type="submit" id="submit" value="go"/>			
		</div>
		<div id="graybar">
		</div>
	</form>
</div>  
<div id="wrapper">
  <div id="graybar">
  </div>
  <div id="content"> 
  <table>
		{local:checkDatesGetNumbers()}
	<tr>		
	</tr>	
  </table>
  </div>
  <div id="graybar">
  </div>
</div> 
</body>
</html>
