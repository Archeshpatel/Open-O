<!--  
/*
 * 
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
 * This software is published under the GPL GNU General Public License. 
 * This program is free software; you can redistribute it and/or 
 * modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation; either version 2 
 * of the License, or (at your option) any later version. * 
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
 * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
 * 
 * <OSCAR TEAM>
 * 
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster Unviersity 
 * Hamilton 
 * Ontario, Canada 
 */
-->

<%      
if(session.getValue("user") == null) response.sendRedirect("../logout.jsp");
String user_no = (String) session.getAttribute("user");
String asstProvider_no = "";
String color ="";
String premiumFlag="";
String service_form="", service_name="";
%>


<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="java.util.*, java.sql.*, oscar.*, java.net.*" errorPage="errorpage.jsp" %>
<%@ include file="../admin/dbconnection.jsp" %>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean" scope="session" />
<%@ include file="dbBilling.jsp" %>            

<%
String clinicview = request.getParameter("billingform")==null?oscarVariables.getProperty("default_view"):request.getParameter("billingform");
String reportAction=request.getParameter("reportAction")==null?"":request.getParameter("reportAction");
%>

<html:html locale="true">
<head>
<title><bean:message key="billing.manageBillingLocation.title"/></title>
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
alert("<bean:message key="billing.manageBillingLocation.msgServiceTypeExists"/>");
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
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2">
</head>

<body leftmargin="0" topmargin="5" rightmargin="0">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr bgcolor="#000000"> 
	<td height="40" width="10%"> </td>
	<td width="90%" align="left"> 
	<p><font face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"><b><font face="Arial, Helvetica, sans-serif" size="4">oscar<font size="3"><bean:message key="billing.manageBillingLocation.msgBilling"/></font></font></b></font> 
	</p>
	</td>
</tr>
</table> 

<table width="100%" border="0" bgcolor="#EEEEFF">
<tr>
	<td width="27%" align="left">
	<form name="serviceform" method="post" action="dbManageBillingLocation.jsp">
	<p><bean:message key="billing.manageBillingLocation.msgCodeDescription"/></p>
	<input type="text" name="location1" size="10">
	<input type="text" name="location1desc" size="30">
	<br>
	<input type="text" name="location2" size="10">
	<input type="text" name="location2desc" size="30">
	<br>
	<input type="text" name="location3" size="10">
	<input type="text" name="location3desc" size="30">
	<br>
	<input type="text" name="location4" size="10">
	<input type="text" name="location4desc" size="30">
	<br>
	<input type="text" name="location5" size="10">
	<input type="text" name="location5desc" size="30">
	<br><br>
	<input type="submit" name="action" value="<bean:message key="billing.manageBillingLocation.btnAdd"/>">
	<br>
	</p>
	</form>
	</td>
      
    <td width="39%" valign="top">

	<table width="90%" border="0" cellspacing="2" cellpadding="2">
	<tr>
		<td><bean:message key="billing.manageBillingLocation.msgClinicLocation"/></td>
		<td><bean:message key="billing.manageBillingLocation.msgDescription"/></td>
	</tr>
        
<% 
ResultSet rs=null ;
ResultSet rs2=null ;
String[] param =new String[1];
String[] param2 =new String[10];
String[] service_code = new String[45];

param[0] = "1";
rs = apptMainBean.queryResults(param, "search_clinic_location");
int rCount = 0;
boolean bodd=false;
String servicetype_name="";

if(rs==null) {
	out.println("failed!!!"); 
} else {
%>
<% 
	while (rs.next()) {
		bodd=bodd?false:true; //for the color of rows
%>

	<tr>
		<td><%=rs.getString("clinic_location_no")%></td>
		<td><%=rs.getString("clinic_location_name")%></td>
	</tr>
<%
	}
}     

apptMainBean.closePstmtConn();
%> 

	</table>

	</td>
	<td width="34%">&nbsp;</td>
	</tr>  

</table>
</body>
</html:html>
