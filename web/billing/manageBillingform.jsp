<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
 <%      
  if(session.getValue("user") == null)
      response.sendRedirect("../logout.jsp");
  String user_no; 
  user_no = (String) session.getAttribute("user");
  String asstProvider_no = "";
   String color ="";
  String premiumFlag="";
String service_form="", service_name="";
%>       
<%@ page import="java.util.*, java.sql.*, oscar.*, java.net.*" errorPage="errorpage.jsp" %>
<%@ include file="../admin/dbconnection.jsp" %>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean" scope="session" />
<%@ include file="dbBilling.jsp" %>            
<%
  String clinicview = request.getParameter("billingform")==null?oscarVariables.getProperty("default_view"):request.getParameter("billingform");
   String reportAction=request.getParameter("reportAction")==null?"":request.getParameter("reportAction");
 
%> 
<html>
<head>
<title>oscarBilling :: manage billing form  ::</title>
<link rel="stylesheet" href="billing.css" >
 
<style type="text/css">
	<!--
	A, INPUT, OPTION ,SELECT , TABLE, TEXTAREA, TD, TR {font-family:tahoma,sans-serif; font-size:10px;}
	
	BODY                  {                     font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TR.list                    {                     font-size: 8pt ; font-family: tahoma,verdana,arial,helvetica; color: #CDCFFF;}                                                    }
	TR.swap                    {                     font-size: 8pt ; font-family: tahoma,verdana,arial,helvetica; color: #000000;								 background-color: #CDCFFF;}
	 
	TD                    {                     font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000                                                    }
	TD.black              {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FFFFFF; background-color: #666699   ;}
	TD.lilac              {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #EEEEFF  ;}
	TD.boldlilac          {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #EEEEFF  ;}
	TD.lilac A:link       {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #EEEEFF  ;}
	TD.lilac A:visited    {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #EEEEFF  ;}
	TD.lilac A:hover      {font-weight: normal;                                                                            color: #000000; background-color: #CDCFFF  ;}
	TD.white              {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.heading            {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FDCB03; background-color: #666699   ;}
	
	td.bottomBorder A:link       { font-size: 8pt ; font-family: verdana,arial,helvetica; color: #AAAAAA;}
	td.bottomBorder A:visited    { font-size: 8pt ; font-family: verdana,arial,helvetica; color: #AAAAAA;}
	td.bottomBorder A:hover      {                                                        color: #616130;}
	      
	td.allBorder{border-style: dotted;border-color: #aaaaaa;border-width: 1px 1px 1px 1px;}
	td.topBorder{	border-top: 1pt solid #aaaaaa;}
	td.topBottomBorder{		border-top: 1pt solid #aaaaaa;	    border-bottom: 1pt solid #aaaaaa;}
	td.topRightBottomBorder{	border-right: 1pt solid #aaaaaa;	border-top: 1pt solid #aaaaaa;  border-bottom: 1pt solid #aaaaaa;}
	td.topRightBorder{	border-right: 1pt solid #aaaaaa;	border-top: 1pt solid #aaaaaa;}
	td.bottomRightBorder{	border-right: 1pt solid #aaaaaa;	border-bottom: 1pt solid #aaaaaa;}
	td.bottomBorder{	border-bottom: 1pt solid #aaaaaa;	padding: 0px 0px 0px 4px;}
	td.rightBorder{	border-right: 1pt solid #aaaaaa;}
	td.sideTite{	color: #003377;	font-family: tahoma,Arial, Helvetica, Sans Serif;	font-size: 10pt;	border-bottom: 1pt solid #dddddd;}
	td.sideMenuItem{	/*background-color: #fafafa;*/	border-bottom: 1pt solid #fafafa;}
	td.mainTableTite{	font-family: tahoma,Arial, Helvetica, Sans Serif;	font-size: 14pt;}
  
	H2                    {font-weight: bold  ; font-size: 12pt; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	H3                    {font-weight: bold  ; font-size: 10pt; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	H4                    {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	H6                    {font-weight: bold  ; font-size: 7pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	A:link                {                     font-size: 8pt ; font-family: verdana,arial,helvetica; color: #336666; background-color: #FFFFFF;}
	A:visited             {                     font-size: 8pt ; font-family: verdana,arial,helvetica; color: #336666; background-color: #FFFFFF;}
	A:hover               {                                                                            color: red; background-color: #CDCFFF  ;}
	TD.cost               {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #FFFFFF;}
	TD.black A:link       {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FFFFFF; background-color: #666699;}
	TD.black A:visited    {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FFFFFF; background-color: #666699;}
	TD.black A:hover      {                                                                            color: #FDCB03; background-color: #666699;}
	TD.title              {font-weight: bold  ; font-size: 10pt; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.white 	      {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.white A:link       {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.white A:visited    {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.white A:hover      {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #CDCFFF  ;}
	#navbar               {                     font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FDCB03; background-color: #666699   ;}
	SPAN.navbar A:link    {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FFFFFF; background-color: #666699   ;}
	SPAN.navbar A:visited {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #EFEFEF; background-color: #666699   ;}
	SPAN.navbar A:hover   {                                                                            color: #FDCB03; background-color: #666699   ;}
	SPAN.bold             {font-weight: bold  ;                                                                                            background-color: #666699   ;}
	-->
</style>  
<script language="JavaScript">
<!--
function popupPage(vheight,vwidth,varpage) { //open a new popup window
  var page = "" + varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes";
  var popup=window.open(page, "attachment", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self; 
    }
  }
}
function selectprovider(s) {
  if(self.location.href.lastIndexOf("&providerview=") > 0 ) a = self.location.href.substring(0,self.location.href.lastIndexOf("&providerview="));
  else a = self.location.href;
	self.location.href = a + "&providerview=" +s.options[s.selectedIndex].value ;
}
function openBrWindow(theURL,winName,features) { 
  window.open(theURL,winName,features);
} 
function setfocus() {
  this.focus();
  document.ADDAPPT.keyword.focus();
  document.ADDAPPT.keyword.select();
}
   
function valid(form){
if (validateServiceType(form)){
form.action = "dbManageBillingform_add.jsp"
form.submit()}

else{}
}
function validateServiceType() {
  if (document.servicetypeform.typeid.value == "MFP") {
alert("Service Type ID exists, please verify!");
	return false;
 }
 else{
 return true;
} 
    
}
function refresh() {
  var u = self.location.href;
  if(u.lastIndexOf("view=1") > 0) {
    self.location.href = u.substring(0,u.lastIndexOf("view=1")) + "view=0" + u.substring(eval(u.lastIndexOf("view=1")+6));
  } else {
    history.go(0);
  }
}

function onUnbilled(url) {
  if(confirm("You are about to delete the billing form, are you sure?")) {
    popupPage(700,720, url);
  }
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2">
</head>

<body leftmargin="0" topmargin="5" rightmargin="0">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#000000"> 
    <td height="40" width="10%"> </td>
    <td width="90%" align="left"> 
      <p><font face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"><b><font face="Arial, Helvetica, sans-serif" size="4">oscar<font size="3">Billing</font></font></b></font> 
      </p>
    </td>
  </tr>
</table> 
<table width="100%" border="0" bgcolor="#EEEEFF">
  <form name="serviceform" method="get" action="">
    <tr> 
      <td width="30%" align="right"> <font size="2" color="#333333" face="Verdana, Arial, Helvetica, sans-serif"> 
        <input type="radio" name="reportAction" value="servicecode" <%=reportAction.equals("servicecode")?"checked":""%>>
        service code 
        <input type="radio" name="reportAction" value="dxcode"  <%=reportAction.equals("dxcode")?"checked":""%>>
        Dx Code</font> </td>
      <td width="50%"> <div align="right"></div>
         <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b>Select 
           form</b></font> 
          
 	   	  <select name="billingform">
           <option value="000" <%=clinicview.equals("000")?"selected":""%>>Add/Delete Form </option>
            <option value="***" <%=clinicview.equals("***")?"selected":""%>>Manage Premium Form </option>
  		    <% String formDesc="";
            String formID="";
            int Count = 0;  
        ResultSet rslocal;
        rslocal = null;
 rslocal = apptMainBean.queryResults("%", "search_billingform");
 while(rslocal.next()){
 formDesc = rslocal.getString("servicetype_name");
 formID = rslocal.getString("servicetype"); 
  
%>  
               <option value="<%=formID%>" <%=clinicview.equals(formID)?"selected":""%>><%=formDesc%></option>
            <%
      }      
   
  %>
          </select>
        </div></td>
      <td width="40%"> <font color="#333333" size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
        
        <input type="submit" name="Submit" value="Manage">
        </font></td>
    </tr>
  </form>
</table>
<% if (clinicview.compareTo("000") == 0) { %>
<%@ include file="manageBillingform_add.jsp" %> 

<%} else{ %>
<% if (clinicview.compareTo("***") == 0) { %>
<%@ include file="manageBillingform_premium.jsp" %> 

<%} else{ %>


<% if (reportAction.compareTo("") == 0 || reportAction == null){%>

  <p>&nbsp; </p>
<% } else {  
if (reportAction.compareTo("servicecode") == 0) {
%> 
<%@ include file="manageBillingform_service.jsp" %> 
<%
} else {
%>

<%
if (reportAction.compareTo("dxcode") == 0) {
%> 
<%@ include file="manageBillingform_dx.jsp" %> 
<%
}}}}}
%>

  
    <%
 apptMainBean.closePstmtConn();
  %>

<%@ include file="../demographic/zfooterbackclose.htm" %> 

</body>
</html>
