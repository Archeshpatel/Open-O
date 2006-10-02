<%@ page language="java" errorPage="../provider/errorpage.jsp" %>
<%@ page import="java.util.*, oscar.oscarMDS.data.*,oscar.oscarLab.ca.on.CML.*" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/oscar-tag.tld" prefix="oscar" %>
<%
if(session.getValue("user") == null) response.sendRedirect("../logout.jsp");

MDSSegmentData mDSSegmentData = new MDSSegmentData();

CMLLabTest lab = new CMLLabTest();
lab.populateLab(request.getParameter("segmentID"));
System.out.println("num labs "+lab.labResults.size());
for (int i = 0 ; i < lab.labResults.size(); i++){
    System.out.println(i);
}

/*
String ackStatus = request.getParameter("status");
if ( request.getParameter("searchProviderNo") == null || request.getParameter("searchProviderNo").equals("") ) {
    ackStatus = "U";
} */
//mDSSegmentData.populateMDSSegmentData(request.getParameter("segmentID"));

//PatientData.Patient pd = new PatientData().getPatient(request.getParameter("segmentID"));
String AbnFlag = "";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
<html>
<head>
<html:base/>
<title><%=lab.pLastName%>, <%=lab.pFirstName%> <bean:message key="oscarMDS.segmentDisplay.title"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="javascript" type="text/javascript" src="../../../share/javascript/Oscar.js" ></script>
<link rel="stylesheet" type="text/css" href="../../../share/css/OscarStandardLayout.css">
<style type="text/css">
<!--
.RollRes     { font-weight: 700; font-size: 8pt; color: white; font-family: 
               Verdana, Arial, Helvetica }
.RollRes a:link { color: white }
.RollRes a:hover { color: white }
.RollRes a:visited { color: white }
.RollRes a:active { color: white }
.AbnormalRollRes { font-weight: 700; font-size: 8pt; color: red; font-family: 
               Verdana, Arial, Helvetica }
.AbnormalRollRes a:link { color: red }
.AbnormalRollRes a:hover { color: red }
.AbnormalRollRes a:visited { color: red }
.AbnormalRollRes a:active { color: red }
.CorrectedRollRes { font-weight: 700; font-size: 8pt; color: yellow; font-family: 
               Verdana, Arial, Helvetica }
.CorrectedRollRes a:link { color: yellow }
.CorrectedRollRes a:hover { color: yellow }
.CorrectedRollRes a:visited { color: yellow }
.CorrectedRollRes a:active { color: yellow }
.AbnormalRes { font-weight: bold; font-size: 8pt; color: red; font-family: 
               Verdana, Arial, Helvetica }
.AbnormalRes a:link { color: red }
.AbnormalRes a:hover { color: red }
.AbnormalRes a:visited { color: red }
.AbnormalRes a:active { color: red }
.NormalRes   { font-weight: bold; font-size: 8pt; color: black; font-family: 
               Verdana, Arial, Helvetica }
.NormalRes a:link { color: black }
.NormalRes a:hover { color: black }
.NormalRes a:visited { color: black }
.NormalRes a:active { color: black }
.HiLoRes     { font-weight: bold; font-size: 8pt; color: blue; font-family: 
               Verdana, Arial, Helvetica }
.HiLoRes a:link { color: blue }
.HiLoRes a:hover { color: blue }
.HiLoRes a:visited { color: blue }
.HiLoRes a:active { color: blue }
.CorrectedRes { font-weight: bold; font-size: 8pt; color: #E000D0; font-family: 
               Verdana, Arial, Helvetica }
.CorrectedRes a:link { color: #6da997 }
.CorrectedRes a:hover { color: #6da997 }
.CorrectedRes a:visited { color: #6da997 }
.CorrectedRes a:active { color: #6da997 }
.Field       { font-weight: bold; font-size: 8.5pt; color: black; font-family: 
               Verdana, Arial, Helvetica }
div.Field a:link { color: black }
div.Field a:hover { color: black }
div.Field a:visited { color: black }
div.Field a:active { color: black }
.Field2      { font-weight: bold; font-size: 8pt; color: #ffffff; font-family: 
               Verdana, Arial, Helvetica }
div.Field2   { font-weight: bold; font-size: 8pt; color: #ffffff; font-family: 
               Verdana, Arial, Helvetica }
div.FieldData { font-weight: normal; font-size: 8pt; color: black; font-family: 
               Verdana, Arial, Helvetica }
div.Field3   { font-weight: normal; font-size: 8pt; color: black; font-style: italic; 
               font-family: Verdana, Arial, Helvetica }
div.Title    { font-weight: 800; font-size: 10pt; color: white; font-family: 
               Verdana, Arial, Helvetica; padding-top: 4pt; padding-bottom: 
               2pt }
div.Title a:link { color: white }
div.Title a:hover { color: white }
div.Title a:visited { color: white }
div.Title a:active { color: white }
div.Title2   { font-weight: bolder; font-size: 9pt; color: black; text-indent: 5pt; 
               font-family: Verdana, Arial, Helvetica; padding-bottom: 2pt }
div.Title2 a:link { color: black }
div.Title2 a:hover { color: black }
div.Title2 a:visited { color: black }
div.Title2 a:active { color: black }
.Cell        { background-color: #9999CC; border-left: thin solid #CCCCFF; 
               border-right: thin solid #6666CC; 
               border-top: thin solid #CCCCFF; 
               border-bottom: thin solid #6666CC }
.Cell2       { background-color: #376c95; border-left-style: none; border-left-width: medium; 
               border-right-style: none; border-right-width: medium; 
               border-top: thin none #bfcbe3; border-bottom-style: none; 
               border-bottom-width: medium }
.Cell3       { background-color: #add9c7; border-left: thin solid #dbfdeb; 
               border-right: thin solid #5d9987; 
               border-top: thin solid #dbfdeb; 
               border-bottom: thin solid #5d9987 }
.CellHdr     { background-color: #cbe5d7; border-right-style: none; border-right-width: 
               medium; border-bottom-style: none; border-bottom-width: medium }
.Nav         { font-weight: bold; font-size: 8pt; color: black; font-family: 
               Verdana, Arial, Helvetica }
.PageLink a:link { font-size: 8pt; color: white }
.PageLink a:hover { color: red }
.PageLink a:visited { font-size: 9pt; color: yellow }
.PageLink a:active { font-size: 12pt; color: yellow }
.PageLink    { font-family: Verdana }
.text1       { font-size: 8pt; color: black; font-family: Verdana, Arial, Helvetica }
div.txt1     { font-size: 8pt; color: black; font-family: Verdana, Arial }
div.txt2     { font-weight: bolder; font-size: 6pt; color: black; font-family: Verdana, Arial }
div.Title3   { font-weight: bolder; font-size: 12pt; color: black; font-family: 
               Verdana, Arial }
.red         { color: red }
.text2       { font-size: 7pt; color: black; font-family: Verdana, Arial }
.white       { color: white }
.title1      { font-size: 9pt; color: black; font-family: Verdana, Arial }
div.Title4   { font-weight: 600; font-size: 8pt; color: white; font-family: 
               Verdana, Arial, Helvetica }
-->
</style>
</head>

<script language="JavaScript">
function getComment() {    
    var ret = true;
    var commentVal = prompt('<bean:message key="oscarMDS.segmentDisplay.msgComment"/>', '');
    
    if( commentVal == null )
        ret = false;
    else
        document.acknowledgeForm.comment.value = commentVal;
    
    return ret;
}

function popupStart(vheight,vwidth,varpage,windowname) {
    var page = varpage;
    windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes";
    var popup=window.open(varpage, windowname, windowprops);
}
</script>

<body>
<form name="acknowledgeForm" method="post" action="../../../oscarMDS/UpdateStatus.do">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr>
                    <td align="left" class="MainTableTopRowRightColumn" width="100%">                        
                        <input type="hidden" name="segmentID" value="<%= request.getParameter("segmentID") %>"/>
                        <input type="hidden" name="providerNo" value="<%= request.getParameter("providerNo") %>"/>
                        <input type="hidden" name="status" value="A"/>
                        <input type="hidden" name="comment" value=""/>
                        <input type="hidden" name="labType" value="CML"/>
                        <% if ( request.getParameter("providerNo") != null /*&& ! mDSSegmentData.getAcknowledgedStatus(request.getParameter("providerNo")) */) { %>
                        <input type="submit" value="<bean:message key="oscarMDS.segmentDisplay.btnAcknowledge"/>" onclick="return getComment();">
                        <% } %>
                        <input type="button" value=" <bean:message key="global.btnClose"/> " onClick="window.close()">
                        <input type="button" value=" <bean:message key="global.btnPrint"/> " onClick="window.print()">
                        <% if ( lab.getDemographicNo() != null && !lab.getDemographicNo().equals("") && !lab.getDemographicNo().equalsIgnoreCase("null")){ %>
                        <input type="button" value="Msg" onclick="popup(700,960,'../../../oscarMessenger/SendDemoMessage.do?demographic_no=<%=lab.getDemographicNo()%>','msg')"/>
                        <input type="button" value="Tickler" onclick="popup(450,600,'../../../tickler/ForwardDemographicTickler.do?demographic_no=<%=lab.getDemographicNo()%>','tickler')"/>
                        <% } %>
                        <% if ( request.getParameter("searchProviderNo") != null ) { // we were called from e-chart %>                            
                            <input type="button" value=" <bean:message key="oscarMDS.segmentDisplay.btnEChart"/> " onClick="popupStart(360, 680, '../../../oscarMDS/SearchPatient.do?labType=CML&segmentID=<%= request.getParameter("segmentID")%>&name=<%=java.net.URLEncoder.encode(lab.pLastName+", "+lab.pFirstName )%>', 'searchPatientWindow')">
                        <% } %>
                        
                        <span class="Field2"><i>Next Appointment: <oscar:nextAppt demographicNo="<%=lab.getDemographicNo()%>"/></i></span>
                    </td>
                </tr>
            </table>


            <table width="100%" border="1" cellspacing="0" cellpadding="3" bgcolor="#9999CC" bordercolordark="#bfcbe3">
                <tr>
                    <td width="66%" align="middle" class="Cell">
                        <div class="Field2">
                             <bean:message key="oscarMDS.segmentDisplay.formDetailResults"/> 
                        </div>
                    </td>
                    <td width="33%" align="middle" class="Cell">
                        <div class="Field2">
                            <bean:message key="oscarMDS.segmentDisplay.formResultsInfo"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td bgcolor="white" valign="top">
                        <table valign="top" border="0" cellpadding="2" cellspacing="0" width="100%">
                            <tr valign="top">
                                <td valign="top" width="33%" align="left">
                                    <table width="100%" border="0" cellpadding="2" cellspacing="0" valign="top">
                                        <tr>
                                            <td valign="top" align="left">
                                                <table valign="top" border="0" cellpadding="3" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td colspan="2" nowrap>
                                                            <div class="FieldData">
                                                                <strong><bean:message key="oscarMDS.segmentDisplay.formPatientName"/>: </strong>
                                                            </div>
                                                        </td>
                                                        <td colspan="2" nowrap>
                                                            <div class="FieldData" nowrap="nowrap">
                                                                <% if ( request.getParameter("searchProviderNo") == null ) { // we were called from e-chart %>
                                                                    <a href="javascript:window.close()">
                                                                <% } else { // we were called from lab module %>
                                                                    <a href="javascript:popupStart(360, 680, '../../../oscarMDS/SearchPatient.do?labType=CML&segmentID=<%= request.getParameter("segmentID")%>&name=<%=java.net.URLEncoder.encode(lab.pLastName+", "+lab.pFirstName )%>', 'searchPatientWindow')">
                                                                <% } %>
                                                                    <%=lab.pLastName%>, <%=lab.pFirstName%> 
                                                                    </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" nowrap>
                                                            <div class="FieldData">
                                                                <strong><bean:message key="oscarMDS.segmentDisplay.formDateBirth"/>: </strong>
                                                            </div>
                                                        </td>
                                                        <td colspan="2" nowrap>
                                                            <div class="FieldData" nowrap="nowrap">
                                                                <%=lab.pDOB%>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" nowrap>
                                                            <div class="FieldData">
                                                                <strong><bean:message key="oscarMDS.segmentDisplay.formAge"/>: </strong><%=lab.getAge()%>
                                                                <%
                                                                try{
                                                                    lab.getAge();
                                                                    }catch(Exception e){ e.printStackTrace(); }
                                                                
                                                                %>
                                                            </div>
                                                        </td>
                                                        <td colspan="2" nowrap>
                                                            <div class="FieldData">
                                                                <strong><bean:message key="oscarMDS.segmentDisplay.formSex"/>: </strong><%=lab.pSex%>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" nowrap>
                                                            <div class="FieldData">
                                                                <strong><% if (!lab.pHealthNum.startsWith("X")) {%>
                                                                               <bean:message key="oscarMDS.segmentDisplay.formHealthNumber"/>
                                                                           <%} else {%>
                                                                               <bean:message key="oscarMDS.segmentDisplay.formMDSIDNumber"/>
                                                                           <%}%>
                                                                </strong>
                                                            </div>
                                                        </td>
                                                        <td colspan="2" nowrap>
                                                            <div class="FieldData" nowrap="nowrap">
                                                                <%=lab.pHealthNum%>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="33%" valign="top">
                                                <table valign="top" border="0" cellpadding="3" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td nowrap>
                                                            <div align="left" class="FieldData">
                                                                <strong><bean:message key="oscarMDS.segmentDisplay.formHomePhone"/>: </strong>
                                                            </div>
                                                        </td>
                                                        <td nowrap>
                                                            <div align="left" class="FieldData" nowrap="nowrap">
                                                                <%=lab.pPhone%>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td nowrap>
                                                            <div align="left" class="FieldData">
                                                                <strong><bean:message key="oscarMDS.segmentDisplay.formWorkPhone"/>: </strong>
                                                            </div>
                                                        </td>
                                                        <td nowrap>
                                                            <div align="left" class="FieldData" nowrap="nowrap">
                                                                &nbsp;
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td nowrap>
                                                            <div align="left" class="FieldData" nowrap="nowrap">
                                                            </div>
                                                        </td>
                                                        <td nowrap>
                                                            <div align="left" class="FieldData" nowrap="nowrap">
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td nowrap>
                                                            <div align="left" class="FieldData">
                                                                <strong><bean:message key="oscarMDS.segmentDisplay.formPatientLocation"/>: </strong>
                                                            </div>
                                                        </td>
                                                        <td nowrap>
                                                            <div align="left" class="FieldData" nowrap="nowrap">
                                                                <%=""/*not sure on what goes here*/%>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td bgcolor="white" valign="top">
                        <table width="100%" border="0" cellspacing="0" cellpadding="1">
                            <tr>
                                <td>
                                    <div class="FieldData">
                                        <strong><bean:message key="oscarMDS.segmentDisplay.formDateService"/>:</strong>
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldData" nowrap="nowrap">
                                        <%= lab.serviceDate %>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldData">
                                        <strong><bean:message key="oscarMDS.segmentDisplay.formReportStatus"/>:</strong>
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldData" nowrap="nowrap">
                                        <%= ( (String) ( lab.status.equals("F") ? "Final" : "Partial") )%>                                        
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td nowrap>
                                    <div class="FieldData">
                                        <strong><bean:message key="oscarMDS.segmentDisplay.formClientRefer"/>:</strong>
                                    </div>
                                </td>
                                <td nowrap>
                                    <div class="FieldData" nowrap="nowrap">
                                        <%= lab.docNum%>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldData">
                                        <strong><bean:message key="oscarMDS.segmentDisplay.formAccession"/>:</strong>
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldData" nowrap="nowrap">
                                        <%= lab.accessionNum%>                                        
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldData">
                                        <strong>Lab Vendor:</strong>
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldData" nowrap="nowrap">
                                        CML                                        
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td bgcolor="white" colspan="2">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
                            <tr>
                                <td bgcolor="white">
                                    <div class="FieldData">
                                        <strong><bean:message key="oscarMDS.segmentDisplay.formRequestingClient"/>: </strong>
                                            <%= lab.docName%>
                                    </div>
                                </td>
                                <td bgcolor="white">
                                    <div class="FieldData">
                                        <strong><bean:message key="oscarMDS.segmentDisplay.formReportToClient"/>: </strong>
                                            <%= ""/*mDSSegmentData.providers.admittingDoctor not sure*/%>
                                    </div>
                                </td>
                                <td bgcolor="white" align="right">
                                    <div class="FieldData">
                                        <strong><bean:message key="oscarMDS.segmentDisplay.formCCClient"/>: </strong>
                                            <%="" /* mDSSegmentData.providers.consultingDoctor*/ %>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center" bgcolor="white" colspan="2">
                        <table width="100%" height="20" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center" bgcolor="white">
                                    <div class="FieldData">
                                        <center>
                                            <!-- <table width="90%" border="0" cellpadding="0" cellspacing="0"> -->
                                                <% ArrayList statusArray = lab.getStatusArray(); 
                                                                System.out.println("size of status array "+statusArray.size());
                                                   for (int i=0; i < statusArray.size(); i++) { 
                                                    ReportStatus rs = (ReportStatus) statusArray.get(i); %>
                                                    <%= rs.getProviderName() %> :
                                                    <font color="red"><%= rs.getStatus() %></font>
                                                        <% if ( rs.getStatus().equals("Acknowledged") ) { %>
                                                           <%= rs.getTimestamp() %>, 
                                                           <%= ( rs.getComment().equals("") ? "no comment" : "comment : "+rs.getComment() ) %>
                                                        <%} %>                                                
                                                    <br>                                                                                                                                                     
                                                <% } %>
                                                   
                                            <!-- </table> -->                                   
                                        </center>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
      
        
        
        
        
            <% int i=0;
	       int j=0;
	       int k=0;
               int linenum=0;
               String highlight = "#E0E0FF";
               
               ArrayList groupLabs = lab.getGroupResults(lab.labResults);
               
     	       for(i=0;i<groupLabs.size();i++){
                   linenum=0;
                   CMLLabTest.GroupResults gResults = (CMLLabTest.GroupResults) groupLabs.get(i);
                   %>
                        <table style="page-break-inside:avoid;" bgcolor="#003399" border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td colspan="4" height="7">&nbsp;</td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFCC00" width="200" height="22" valign="bottom">
                                    <div class="Title2">
                                        <%=gResults.groupName%>
                                    </div>
                                </td>
                                <td align="right" bgcolor="#FFCC00" width="100">&nbsp;</td>
                                <td width="9">&nbsp;</td>
                                <td width="*">&nbsp;</td>
                            </tr>
                        </table>
                        
                        <table width="100%" border="0" cellspacing="0" cellpadding="2" bgcolor="#CCCCFF" bordercolor="#9966FF" bordercolordark="#bfcbe3" name="tblDiscs" id="tblDiscs">
                            <tr class="Field2">
                                <td width="25%" align="middle" valign="bottom" class="Cell"><bean:message key="oscarMDS.segmentDisplay.formTestName"/></td>
                                <td width="15%" align="middle" valign="bottom" class="Cell"><bean:message key="oscarMDS.segmentDisplay.formResult"/></td>
                                <td width="5%" align="middle" valign="bottom" class="Cell"><bean:message key="oscarMDS.segmentDisplay.formAbn"/></td>
                                <td width="15%" align="middle" valign="bottom" class="Cell"><bean:message key="oscarMDS.segmentDisplay.formReferenceRange"/></td>
                                <td width="10%" align="middle" valign="bottom" class="Cell"><bean:message key="oscarMDS.segmentDisplay.formUnits"/></td>
                                <td width="15%" align="middle" valign="bottom" class="Cell"><bean:message key="oscarMDS.segmentDisplay.formDateTimeCompleted"/></td>
                                <td width="6%" align="middle" valign="bottom" class="Cell"><bean:message key="oscarMDS.segmentDisplay.formTestLocation"/></td>
                                <td width="6%" align="middle" valign="bottom" class="Cell"><bean:message key="oscarMDS.segmentDisplay.formNew"/></td>
                            </tr>
                        
                        <%
                        //int linenum = 1;
                        ArrayList labs = gResults.getLabResults();
                        for ( int l =0 ; l < labs.size() ; l++){
                            CMLLabTest.LabResult thisResult = (CMLLabTest.LabResult) labs.get(l);
                            String lineClass = "NormalRes";
                            if ( thisResult.abn != null && thisResult.abn.equals("A")){
                                lineClass = "AbnormalRes";
                            }
                            if (thisResult.isLabResult()){
                        %>
                        
                            <tr bgcolor="<%=(linenum % 2 == 1 ? highlight : "")%>" class="<%=lineClass%>">
                                <td valign="top" align="left"><a href="labValues.jsp?testName=<%=thisResult.testName%>&demo=<%=lab.getDemographicNo()%>&labType=CML"><%=thisResult.testName %></a></td>                                         
                                <td align="right"><%=thisResult.result %></td>
                                <td align="center"><%=thisResult.abn %></td>
                                <td align="left"><%=thisResult.getReferenceRange()%></td>
                                <td align="left"><%=thisResult.units %></td>
                                <td align="center"><%=""/*thisGroup.timeStamp */%></td>
                                <td align="center"><%=thisResult.locationId %></td>
                                <td align="center"><%=""/*thisResult.resultStatus*/ %></td>
                            </tr>
                        <% }else{%>
                            <tr bgcolor="<%=(linenum % 2 == 1 ? highlight : "")%>" class="<%=lineClass%>">
                                <td valign="top" align="left" colspan="8"><pre  style="margin-left:100px;"><%=thisResult.description %></pre></td>                                         
                                
                            </tr>
                        
                        <% }%>
                        
                        <%}/*for lab.size*/%>
                        </table>
                 <% //} // end if microbiology or not microbiology
              }  // for i=0... (headers) %>
        
        
        
    
            <!-- <table border="0" width="100%" cellpadding="5" cellspacing="0" bgcolor="white">
                <tr class="Field2">
                    <td width="20%" class="Cell2">
                        <div class="Field2" align="left">
                            <font color="white"></font>
                        </div>
                    </td>
                    <td width="60%" class="Cell2" valign="center" align="middle"><font color="white"><i>END
                        OF REPORT</i></font></td>
                    <td width="20%" class="Cell2" valign="center" align="right">&nbsp;</td>
                </tr>
            </table> -->
            <table width="100%" border="0" cellspacing="0" cellpadding="3" class="MainTableBottomRowRightColumn" bgcolor="#003399">
                <tr>
                    <td align="left" width="50%">
                        <% if ( request.getParameter("providerNo") != null /*&& ! mDSSegmentData.getAcknowledgedStatus(request.getParameter("providerNo")) */) { %>
                        <input type="submit" value="<bean:message key="oscarMDS.segmentDisplay.btnAcknowledge"/>" onclick="getComment()">
                        <% } %>
                        <input type="button" value=" <bean:message key="global.btnClose"/> " onClick="window.close()">
                        <input type="button" value=" <bean:message key="global.btnPrint"/> " onClick="window.print()">
                        <% if ( lab.getDemographicNo() != null && !lab.getDemographicNo().equals("") && !lab.getDemographicNo().equalsIgnoreCase("null")){ %>
                        <input type="button" value="Msg" onclick="popup(700,960,'../../../oscarMessenger/SendDemoMessage.do?demographic_no=<%=lab.getDemographicNo()%>','msg')"/>
                        <input type="button" value="Tickler" onclick="popup(450,600,'../../../tickler/ForwardDemographicTickler.do?demographic_no=<%=lab.getDemographicNo()%>','tickler')"/>
                        <% } %>
                        <% if ( request.getParameter("searchProviderNo") != null ) { // we were called from e-chart %>                            
                            <input type="button" value=" <bean:message key="oscarMDS.segmentDisplay.btnEChart"/> " onClick="popupStart(360, 680, '../../../oscarMDS/SearchPatient.do?labType=CML&segmentID=<%= request.getParameter("segmentID")%>&name=<%=java.net.URLEncoder.encode(lab.pLastName+", "+lab.pFirstName )%>', 'searchPatientWindow')">
                        <% } %>
                    </td>
                    <td width="50%" valign="center" align="left">
                        <span class="Field2"><i><bean:message key="oscarMDS.segmentDisplay.msgReportEnd"/></i></span>
                    </td>
                    
                </tr>
            </table>
        </td>
    </tr>
</table>

</form>

</body>
</html>
