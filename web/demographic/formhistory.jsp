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
  if(session.getAttribute("user") == null) response.sendRedirect("../logout.jsp");
  String user_no = (String) session.getAttribute("user");
%>
<%@ page import="java.util.*, java.sql.*" errorPage="errorpage.jsp" %>
<jsp:useBean id="formHistBean" class="oscar.AppointmentMainBean" scope="page" />
<%@ include file="../admin/dbconnection.jsp" %>  
<%
  String [][] dbQueries=new String[][] {
    {"search_form", "select * from form where demographic_no = ? order by form_date desc, form_time desc, form_no desc"},
    {"search_formdetail", "select * from form where form_no=?"},
    {"delete_form1", "insert into recyclebin (provider_no,updatedatetime,table_name,keyword,table_content) values(?,?,'form',?,?)"},
    {"delete_form2", "delete from form where form_no = ?"},
   };
   formHistBean.doConfigure(dbParams,dbQueries);
%>

<% //delete the selected records
  if(request.getParameter("submit")!=null && request.getParameter("submit").equals("Delete") ) {
    ResultSet rs = null;
    int ii = Integer.parseInt(request.getParameter("formnum"));  
    String[] param =new String[4];
    String content=null, keyword=null, datetime=null;
    GregorianCalendar now=new GregorianCalendar();
    datetime  =now.get(Calendar.YEAR)+"-"+(now.get(Calendar.MONTH)+1)+"-"+now.get(Calendar.DAY_OF_MONTH) +" "+now.get(Calendar.HOUR_OF_DAY)+":"+now.get(Calendar.MINUTE)+":"+now.get(Calendar.SECOND);
    
    for(int i=0;i<=ii;i++) {
      if(request.getParameter("form_no"+i)==null) {
// System.out.println("      1     ");
        continue;
      }
      
      rs = formHistBean.queryResults(request.getParameter("form_no"+i), "search_formdetail");
      while (rs.next()) { 
        keyword = rs.getString("form_name")+rs.getString("form_date");
        content = "<form_no>"+rs.getString("form_no")+"</form_no>"+ "<demographic_no>"+rs.getString("demographic_no")+"</demographic_no>"+ "<provider_no>"+rs.getString("provider_no")+"</provider_no>";
        content += "<form_date>"+rs.getString("form_date")+"</form_date>"+ "<form_time>"+rs.getString("form_time")+"</form_time>"+ "<form_name>"+rs.getString("form_name")+"</form_name>";
        content += "<content>"+rs.getString("content")+"</content>" ;
      }
      
	    param[0]=user_no;
	    param[1]=datetime;
	    param[2]=keyword;
	    param[3]=content;
      
      int rowsAffected = formHistBean.queryExecuteUpdate(param, "delete_form1");
      if(rowsAffected ==1) {
        rowsAffected = formHistBean.queryExecuteUpdate(request.getParameter("form_no"+i), "delete_form2");
      } else {
        response.sendRedirect("index.htm");
      }
    } //end for loop
  }
%>

<html>
<head>
<title>PATIENT'S FORM</title>
<link rel="stylesheet" href="../web.css" >
      <meta http-equiv="expires" content="Mon,12 May 1998 00:36:05 GMT">
      <meta http-equiv="Pragma" content="no-cache">
<script language="JavaScript">
<!--
function setfocus() {
  this.focus();
}
function popupPage(vheight,vwidth,varpage) { //open a new popup window
  var page = "" + varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=600,screenY=200,top=0,left=0";
  var popup=window.open(page, "formhist", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self; 
      alert("hi this is a null for self!");
    }
  }
}
//-->
</script>
</head>
<body onLoad="setfocus()" topmargin="0" leftmargin="0" rightmargin="0">

<table border="0" cellspacing="0" cellpadding="0" width="100%" >
  <tr bgcolor="silver"><th align=CENTER NOWRAP><font face="Helvetica" color="navy">FORM HISTORY</font></th></tr>
</table>

<table width="100%" border="0" bgcolor="ivory">
  <form name="encounterrep" method="post" action="formhistory.jsp">
  <tr > 
    <td ><font size="-1"> </font></td>
  </tr><tr>  
    <td bgcolor="#FFFFFF" align="center"> 
<%
   ResultSet rsdemo = null;
   rsdemo = formHistBean.queryResults(request.getParameter("demographic_no"), "search_form");
   int i=0;
   while (rsdemo.next()) { 
     i++;
%>
      &nbsp;<%=rsdemo.getString("form_date")%> <%=rsdemo.getString("form_time")%>

        <input type="checkbox" name="<%="form_no"+i%>" value="<%=rsdemo.getString("form_no")%>" >
      
      <font color="blue"> 
      <a href=# onClick ="popupPage(600,800,'../provider/providercontrol.jsp?form_no=<%=rsdemo.getString("form_no")%>&dboperation=search_form&displaymodevariable=form<%=rsdemo.getString("form_name")%>.jsp&displaymode=vary&bNewForm=0')"> 
      <%=rsdemo.getString("form_name")%></a></font> by <%=rsdemo.getString("provider_no")%><br>
<%
   }     
   formHistBean.closePstmtConn();
%>      
    </td>
  </tr>
  <tr bgcolor="#eeeeee"><td align="center">
    <input type="hidden" name="formnum" value="<%=i%>">
    <input type="hidden" name="demographic_no" value="<%=request.getParameter("demographic_no")%>">
    <input type="submit" name="submit" value="Delete"><input type="button" name="button" value="Cancel" onClick="window.close()">
  </td></tr></form>
</table>
<center></center>
</body>
</html>