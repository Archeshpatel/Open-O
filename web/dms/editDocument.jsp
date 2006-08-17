<%
if(session.getValue("user") == null) response.sendRedirect("../logout.htm");
String user_no = (String) session.getAttribute("user");
String userfirstname = (String) session.getAttribute("userfirstname");
String userlastname = (String) session.getAttribute("userlastname");
%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<jsp:useBean id="oscarVariables" class="java.util.Properties" scope="page" />
<%@ page import="java.util.*, java.io.*, java.sql.*, oscar.*, oscar.util.*, java.net.*,oscar.MyDateFormat, oscar.dms.*, oscar.dms.data.*" %>


<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%
String editDocumentNo = "";
if (request.getAttribute("editDocumentNo") != null) {
    editDocumentNo = (String) request.getAttribute("editDocumentNo");
} else {
    editDocumentNo = (String) request.getParameter("editDocumentNo");
}

String module = "";
String moduleid = "";
if (request.getParameter("function") != null) {
    module = request.getParameter("function");
    moduleid = request.getParameter("functionid");
} else if (request.getAttribute("function") != null) {
    module = (String) request.getAttribute("function");
    moduleid = (String) request.getAttribute("functionid");
}

Hashtable docerrors = new Hashtable();
if (request.getAttribute("docerrors") != null) {
    docerrors = (Hashtable) request.getAttribute("docerrors");
}

   String lastUpdate = "";
   String fileName = "";
   AddEditDocumentForm formdata = new AddEditDocumentForm();
if (request.getAttribute("completedForm") != null) {
    formdata = (AddEditDocumentForm) request.getAttribute("completedForm");
    lastUpdate = EDocUtil.getDmsDateTime();
} else if (editDocumentNo != null) {
    EDoc currentDoc = EDocUtil.getDoc(editDocumentNo);
    formdata.setFunction(currentDoc.getModule());
    formdata.setFunctionId(currentDoc.getModuleId());
    formdata.setDocType(currentDoc.getType());
    formdata.setDocDesc(currentDoc.getDescription());
    formdata.setDocPublic((currentDoc.getDocPublic().equals("1"))?"checked":"");
    formdata.setDocCreator(currentDoc.getCreatorId());
    formdata.setObservationDate(currentDoc.getObservationDate());
    lastUpdate = currentDoc.getDateTimeStamp();
    fileName = currentDoc.getFileName();
}
ArrayList doctypes = EDocUtil.getDoctypes(formdata.getFunction());
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="Cache-Control" content="no-cache">
        <title>Edit Document</title>
        <script type="text/javascript" src="../share/javascript/Oscar.js"></script>
        <script type="text/javascript" src="../share/javascript/prototype.js"></script>

        <link rel="stylesheet" type="text/css" href="../share/css/niftyCorners.css" />
        <link rel="stylesheet" type="text/css" href="../share/css/OscarStandardLayout.css"/>
        <link rel="stylesheet" type="text/css" href="dms.css"/>
        <link rel="stylesheet" type="text/css" href="../share/css/niftyPrint.css" media="print" />
        <script type="text/javascript" src="../share/javascript/nifty.js"></script>
        <link rel="stylesheet" type="text/css" media="all" href="../share/calendar/calendar.css" title="win2k-cold-1" /> 
        <script type="text/javascript" src="../share/calendar/calendar.js" ></script>      
        <script type="text/javascript" src="../share/calendar/lang/<bean:message key="global.javascript.calendar"/>" ></script>      
        <script type="text/javascript" src="../share/calendar/calendar-setup.js" ></script>
        <script type="text/javascript">
            window.onload=function(){
                if(!NiftyCheck())
                    return;
                    //Rounded("div.leftplane","top", "transparent", "#CCCCFF","small border #ccccff");
                    //Rounded("div.leftplane","bottom","transparent","#EEEEFF","small border #ccccff");
            }
            function submitUpload(object) {
                object.Submit.disabled = true;
                if (!validDate("observationDate")) {
                    alert("Invalid Date: must be in format yyyy/mm/dd");
                    object.Submit.disabled = false;
                    return false;
                }
                return true;
            }
        </script>
        <style type="text/css">
            body.mainbody {
                padding: 0px;
                margin: 3px;
                font-size: 13px;
            }
            div.maindiv {
                background-color: #f2f7ff;
                border: 1px solid #acb3f5;
                height: 390px;
            }
            div.maindivheading {
                background-color: #acb3f5;
                font-size: 14px;
            }
            label.labels {
                float: left;
                clear: left;
                width: 160px;
            }
            .field {
                float: left;
            }
            table.layouttable {
                font-family: Verdana, Tahoma, Arial, sans-serif;
                font-size: 12px;
            }
        </style>
    </head>
    <body class="mainbody">
       <div class="maindiv">
           <div class="maindivheading">
              &nbsp;&nbsp;&nbsp; Edit Document
           </div>
               <%-- Lists docerrors --%>
               <% for (Enumeration errorkeys = docerrors.keys(); errorkeys.hasMoreElements();) {%>
                  <font class="warning">Error: <bean:message key="<%=(String) docerrors.get(errorkeys.nextElement())%>"/></font><br/>
               <% } %>
           <html:form action="/dms/addEditDocument" method="POST" enctype="multipart/form-data" onsubmit="return submitUpload(this);">
               <input type="hidden" name="function" value="<%=formdata.getFunction()%>" size="20">
               <input type="hidden" name="functionId" value="<%=formdata.getFunctionId()%>" size="20">
               <input type="hidden" name="functionid" value="<%=moduleid%>" size="20">
               <input type="hidden" name="mode" value="<%=editDocumentNo%>">
               <table class="layouttable">
                   <tr>
                     <td>Type:</td>
                     <td>
                       <select name="docType" id="docType" <% if (docerrors.containsKey("typemissing")) {%> class="warning"<%}%>>
                            <option value=""><bean:message key="dms.addDocument.formSelect"/></option>
                        <%for (int i=0; i<doctypes.size(); i++) {
                             String doctype = (String) doctypes.get(i); %>
                                  <option value="<%= doctype%>"<%=(formdata.getDocType().equals(doctype))?" selected":""%>><%= doctype%></option>
                        <%}%>
                       </select>
                     </td>
                   </tr>
                   <tr>
                        <td>Description: </td>
                        <td><input<% if (docerrors.containsKey("descmissing")) {%> class="warning"<%}%> type="text" name="docDesc" size="30" value="<%=formdata.getDocDesc()%>"><td>
                   </tr>
                   <tr>
                        <td>Observation Date: </td>
                        <td><input id="observationDate" name="observationDate" type="text" value="<%=formdata.getObservationDate()%>"><a id="obsdate"><img title="Calendar" src="../images/cal.gif" alt="Calendar" border="0" /></a></td>
                   </tr>
                   <tr>
                        <td>Added By: </td>
                        <td><%=EDocUtil.getModuleName("provider", formdata.getDocCreator())%></td
                   </tr>
                   <tr>
                        <td>Date Added/Updated: </td>
                        <td><%=lastUpdate%></td>
                   </tr>
                  <% if (module.equals("provider")) {%>
                      <tr>
                         <td>Public? </td>
                         <td><input type="checkbox" name="docPublic" <%=formdata.getDocPublic() + " "%>value="checked"></td>
                      </tr>
                  <%}%>
                  <tr>
                       <td>File Name: </td>
                       <td><div style="width: 300px; overflow: hidden; text-overflow: ellipsis;"><%=fileName%></div>
                  </tr>
                  <tr>
                       <td>File: <font class="comment">blank to keep file</font></td>
                       <td><input type="file" name="docFile" size="20"<% if (docerrors.containsKey("uploaderror")) {%> class="warning"<%}%>></td>
                  </tr>
               </table>
                  <center><input type="submit" name="Submit" value="Update"><input type="button" value="Cancel" onclick="window.close();"></center>
           </html:form>
           <script type="text/javascript">
               Calendar.setup( { inputField : "observationDate", ifFormat : "%Y/%m/%d", showsTime :false, button : "obsdate", singleClick : true, step : 1 } );
           </script>  
       </div>
    </body>
</html>
