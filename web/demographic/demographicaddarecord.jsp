<%@ page  import="java.sql.*, java.util.*, oscar.MyDateFormat" errorPage="errorpage.jsp" %>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean" scope="session" />

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
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
<html:html locale="true">
<head>
<link rel="stylesheet" href="../web.css" />
<script LANGUAGE="JavaScript">
    <!--
    function start(){
      this.focus();
    }
    function closeit() {
      //parent.refresh();
      close();
    }   
    //-->
</script>
</head>
<body  onload="start()"  background="../images/gray_bg.jpg" bgproperties="fixed" topmargin="0" leftmargin="0" rightmargin="0">
<center>
    <table border="0" cellspacing="0" cellpadding="0" width="100%" >
      <tr bgcolor="#486ebd"> 
            <th align="CENTER"><font face="Helvetica" color="#FFFFFF">
            <bean:message key="demographic.demographicaddarecord.title"/></font></th>
      </tr>
    </table>
 
<%
  //if action is good, then give me the result
	  //param[0]=Integer.parseInt((new GregorianCalendar()).get(Calendar.MILLISECOND) ); //int
	  //temp variables for test/set null dates
	  String year, month, day;
    String[] param =new String[27];
	  param[0]=request.getParameter("last_name");
	  param[1]=request.getParameter("first_name");
	  param[2]=request.getParameter("address");
	  param[3]=request.getParameter("city");
	  param[4]=request.getParameter("province");
	  param[5]=request.getParameter("postal");
	  param[6]=request.getParameter("phone");
	  param[7]=request.getParameter("phone2");
	  param[8]=request.getParameter("email");
	  param[9]=request.getParameter("pin");
	  param[10]=request.getParameter("year_of_birth");
	  param[11]=request.getParameter("month_of_birth")!=null && request.getParameter("month_of_birth").length()==1 ? "0"+request.getParameter("month_of_birth") : request.getParameter("month_of_birth");
	  param[12]=request.getParameter("date_of_birth")!=null && request.getParameter("date_of_birth").length()==1 ? "0"+request.getParameter("date_of_birth") : request.getParameter("date_of_birth");
	  param[13]=request.getParameter("hin");
	  param[14]=request.getParameter("ver");
	  param[15]=request.getParameter("roster_status");
	  param[16]=request.getParameter("patient_status");
	  // Databases have an alias for today. It is not necessary give the current date.          
          // ** Overridden - we want to give users option to change if needed
          // ** Now defaults to current date on the add demographic screen
	  param[17]=request.getParameter("date_joined_year")+"-"+request.getParameter("date_joined_month")+"-"+request.getParameter("date_joined_date");
	  param[18]=request.getParameter("chart_no");
	  param[19]=request.getParameter("staff");
	  param[20]=request.getParameter("sex");

	  // If null, set year, month and date
	  if (request.getParameter("end_date_year").equals("")) {
	    year = "0001";
	  } else {
	    year = request.getParameter("end_date_year");
	  }

	  if (request.getParameter("end_date_month").equals("")) {
	    month = "01";
	  } else {
	    month = request.getParameter("end_date_month");
	  }

	  if (request.getParameter("end_date_date").equals("")) {
	    day = "01";
	  } else {
	    day = request.getParameter("end_date_date");
	  }

	  param[21] = year + "-" + month + "-" + day;

	  // If null, set year, month and date
	  if (request.getParameter("eff_date_year").equals("")) {
	    year = "0001";
	  } else {
	    year = request.getParameter("eff_date_year");
	  }

	  if (request.getParameter("eff_date_month").equals("")) {
	    month = "01";
	  } else {
	    month = request.getParameter("eff_date_month");
	  }

	  if (request.getParameter("eff_date_date").equals("")) {
	    day = "01";
	  } else {
	    day = request.getParameter("eff_date_date");
	  }

	  param[22] =  year + "-" + month + "-" + day;

	  param[23]=request.getParameter("pcn_indicator");
	  param[24]=request.getParameter("hc_type");

	  // If null, set year, month and date
	  if (request.getParameter("hc_renew_date_year").equals("")) {
	    year = "0001";
	  } else {
	    year = request.getParameter("hc_renew_date_year");
	  }

	  if (request.getParameter("hc_renew_date_month").equals("")) {
	    month = "01";
	  } else {
	    month = request.getParameter("hc_renew_date_month");
	  }

	  if (request.getParameter("hc_renew_date_date").equals("")) {
	    day = "01";
	  } else {
	    day = request.getParameter("hc_renew_date_date");
	  }

	  param[25] =  year + "-" + month + "-" + day;
	  param[26]="<rdohip>" + request.getParameter("r_doctor_ohip") + "</rdohip>" + "<rd>" + request.getParameter("r_doctor") + "</rd>"+ (request.getParameter("family_doc")!=null? ("<family_doc>" + request.getParameter("family_doc") + "</family_doc>") : "");    

	String[] paramName =new String[5];
	  paramName[0]=param[0].trim();
	  paramName[1]=param[1].trim();
	  paramName[2]=param[10].trim();
	  paramName[3]=param[11].trim();
	  paramName[4]=param[12].trim();
	  //System.out.println("from -------- :"+ param[0]+ ": next :"+param[1]);
    ResultSet rs = apptMainBean.queryResults(paramName, "search_lastfirstnamedob");
    
    if(rs.next()) {  %>
      ***<font color='red'><bean:message key="demographic.demographicaddarecord.msgDuplicatedRecord"/></font>***<br>
      <br><a href=# onClick="history.go(-1);"><b>&lt;-<bean:message key="global.btnBack"/></b></a>
      <% return;
    }

    // int rowsAffected = apptMainBean.queryExecuteUpdate(intparam, param, request.getParameter("dboperation"));
    
  int rowsAffected = apptMainBean.queryExecuteUpdate(param, request.getParameter("dboperation")); //add_record
  if (rowsAffected ==1) {
    //find the demo_no and add democust record for alert
    String[] param1 =new String[7];
	  param1[0]=request.getParameter("last_name");
	  param1[1]=request.getParameter("first_name");
	  param1[2]=request.getParameter("year_of_birth");
	  param1[3]=request.getParameter("month_of_birth");
	  param1[4]=request.getParameter("date_of_birth");
	  param1[5]=request.getParameter("hin");
	  param1[6]=request.getParameter("ver");
    
    rs = apptMainBean.queryResults(param1, "search_demoaddno");
    if(rs.next()) { //
        //add democust record for alert
        String[] param2 =new String[6];
	    param2[0]=rs.getString("demographic_no");
	    param2[1]=request.getParameter("cust1");
	    param2[2]=request.getParameter("cust2");
	    param2[3]=request.getParameter("cust3");
	    param2[4]=request.getParameter("cust4");
	    param2[5]=request.getParameter("content");
	    System.out.println("demographic_no" + param2[0] +param2[1]+param2[2]+param2[3]+param2[4]+param2[5] );
        rowsAffected = apptMainBean.queryExecuteUpdate(param2, "add_custrecord" ); //add_record
      
      
	  	if (request.getParameter("dboperation2") != null) {
	  	  	String[] parametros = new String[13];
  	  	
	  	  	parametros[0]=rs.getString("demographic_no");
	  	  	parametros[1]=request.getParameter("cpf");
	  	  	parametros[2]=request.getParameter("rg");
	  	  	parametros[3]=request.getParameter("chart_address");
	  	  	parametros[4]=request.getParameter("marriage_certificate");
	  	  	parametros[5]=request.getParameter("birth_certificate");
	  	  	parametros[6]=request.getParameter("marital_state");
	  	  	parametros[7]=request.getParameter("partner_name");
	  	  	parametros[8]=request.getParameter("father_name");
	  	  	parametros[9]=request.getParameter("mother_name");
	  	  	parametros[10]=request.getParameter("district");
	  	  	parametros[11]=request.getParameter("address_no")==null || request.getParameter("address_no").trim().equals("")?"0":request.getParameter("address_no");
	  	  	parametros[12]=request.getParameter("complementary_address");
  	
  	
	  		rowsAffected = apptMainBean.queryExecuteUpdate(parametros, request.getParameter("dboperation2")); //add_record
	  	}
      
    }
    
%>
  <p><h2><bean:message key="demographic.demographicaddarecord.msgSuccessful"/>
  </h2></p>
<%  
  } else {
%>
  <p><h1><bean:message key="demographic.demographicaddarecord.msgFailed"/></h1></p>
<%  
  }
  apptMainBean.closePstmtConn();
%>
  <p> </p>
<%@ include file="footer.jsp" %>
</center>
</body>
</html:html>