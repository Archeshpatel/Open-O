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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<html:html locale="true">
    <head>
        <title> <bean:message key="demographic.search.title"/> </title>
        <meta http-equiv="Expires" content="Monday, 8 Aug 88 18:18:18 GMT">
        <meta http-equiv="Cache-Control" content="no-cache">
        <script language="JavaScript">

        function setfocus() {
            document.titlesearch.keyword.focus();
            document.titlesearch.keyword.select();
        }
        
        function checkTypeIn() {
          var dob = document.titlesearch.keyword; typeInOK = true;

          if(document.titlesearch.search_mode[2].checked) {
            if(dob.value.length==8) {
              dob.value = dob.value.substring(0, 4)+"-"+dob.value.substring(4, 6)+"-"+dob.value.substring(6, 8);
            }
            if(dob.value.length != 10) {
              alert("<bean:message key="demographic.search.msgWrongDOB"/>");
              typeInOK = false;
            }
            return typeInOK ;
          } else {
            return true;
          }
        }        
        
        function searchInactive() {
            document.titlesearch.ptstatus.value="inactive";
            if (checkTypeIn()) document.titlesearch.submit();
        }
            
        function searchAll() {
            document.titlesearch.ptstatus.value="";
            if (checkTypeIn()) document.titlesearch.submit();
        }
         
        </SCRIPT>
        <link rel="stylesheet" href="../web.css">
    </head>
    <body  background="../images/gray_bg.jpg" bgproperties="fixed" onLoad="setfocus()" topmargin="0" leftmargin="0" rightmargin="0">
        <table border="0" cellspacing="0" cellpadding="0" width="100%" >
            <tr bgcolor="#CCCCFF"><th NOWRAP><font face="Helvetica"><bean:message key="demographic.search.msgSearchPatient"/></font></th></tr>
        </table>

        <table BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%" BGCOLOR="#EEEEFF">
            <form method="post" name="titlesearch" action="demographiccontrol.jsp" onSubmit="return checkTypeIn()">
            <tr valign="top">
                <td rowspan="2" ALIGN="right" valign="middle">
                    <font face="Verdana" color="#0000FF"><b><i><bean:message key="demographic.search.msgSearch"/></i></b></font>
                </td>
			
                <td width="10%" nowrap>
                    <font size="1" face="Verdana" color="#0000FF"> 
                    <input type="radio"  checked name="search_mode" value="search_name">
                    <bean:message key="demographic.search.formName"/> </font>
                </td>
                <td nowrap>
                    <font size="1" face="Verdana" color="#0000FF"> 
                    <input type="radio"  name="search_mode" value="search_phone">
                    <bean:message key="demographic.search.formPhone"/></font>
                </td> 
                <td nowrap>
                    <font size="1" face="Verdana" color="#0000FF">
                    <input type="radio"  name="search_mode" value="search_dob">
                    <bean:message key="demographic.search.formDOB"/></font>
                </td> 
                <td valign="middle" rowspan="2" ALIGN="left"><input type="text" NAME="keyword" SIZE="17"  MAXLENGTH="100">
                    <INPUT TYPE="hidden" NAME="orderby" VALUE="last_name, first_name" >
                    <INPUT TYPE="hidden" NAME="dboperation" VALUE="search_titlename" >
                    <INPUT TYPE="hidden" NAME="limit1" VALUE="0" >
                    <INPUT TYPE="hidden" NAME="limit2" VALUE="10" >
                    <INPUT TYPE="hidden" NAME="displaymode" VALUE="Search" >
                    <INPUT TYPE="hidden" NAME="ptstatus" VALUE="active">
                    <INPUT TYPE="SUBMIT" NAME="displaymode" VALUE="<bean:message key="demographic.search.btnSearch"/>" SIZE="17" TITLE="<bean:message key="demographic.zdemographicfulltitlesearch.tooltips.searchActive"/>">
                    &nbsp;&nbsp;&nbsp;
                    <INPUT TYPE="button" onclick="searchInactive();" TITLE="<bean:message key="demographic.zdemographicfulltitlesearch.tooltips.searchInactive"/>" VALUE="<bean:message key="demographic.search.Inactive"/>">
                    <INPUT TYPE="button" onclick="searchAll();" TITLE="<bean:message key="demographic.zdemographicfulltitlesearch.tooltips.searchAll"/>" VALUE="<bean:message key="demographic.search.All"/>">                    
                </td>
            </tr>
            <tr>			
                <td nowrap>
                    <font size="1" face="Verdana" color="#0000FF"> 
                    <input type="radio" name="search_mode" value="search_address">
                    <bean:message key="demographic.search.formAddr"/> </font>
                </td>
                <td nowrap>
                    <font size="1" face="Verdana" color="#0000FF"> 
                    <input type="radio" name="search_mode" value="search_hin">
                    <bean:message key="demographic.search.formHIN"/></font>
                </td>
                <td nowrap>
                    <font size="1" face="Verdana" color="#0000FF"> 
                    <input type="radio" name="search_mode" value="search_chart_no">
                    <bean:message key="demographic.search.formChart"/></font>
                </td>
            </tr>
            </form>
        </table>
			
        <CENTER>
        <p> <br>
        </p>
 
        <p><a href="demographicaddarecordhtm.jsp"><b><font size="+1"><bean:message key="demographic.search.btnCreateNew"/></font></b></a></p>
        <p><!--a href="http://204.92.240.253:8080/test/slt/Search.jsp"><font size="+1"><bean:message key="demographic.search.btnELearning"/></font></a--></p>
        </center>
    </body>
</html:html>