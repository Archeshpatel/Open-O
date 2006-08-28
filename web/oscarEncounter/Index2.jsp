
<%--
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
--%>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security" %>
<%
    if(session.getAttribute("userrole") == null )  response.sendRedirect("../logout.jsp");
    String roleName$ = (String)session.getAttribute("userrole") + "," + (String) session.getAttribute("user");
    String demographic$ = request.getParameter("demographicNo") ;
    boolean bPrincipalControl = false;
    boolean bPrincipalDisplay = false;
%>
<security:oscarSec roleName="<%=roleName$%>" objectName="_eChart" rights="r" reverse="<%=true%>" >
"You have no right to access this page!"
<% response.sendRedirect("../noRights.html"); %>
</security:oscarSec>

<security:oscarSec roleName="<%=roleName$%>" objectName="<%="_eChart$"+demographic$%>" rights="o" reverse="<%=false%>" >
You have no rights to access the data!
<% response.sendRedirect("../noRights.html"); %>
</security:oscarSec>

<%-- only principal has the save rights --%>
<security:oscarSec roleName="<%="_principal"%>" objectName="<%="_eChart"%>" rights="ow" reverse="<%=false%>" >
<% 	bPrincipalControl = true;
	if(EctPatientData.getProviderNo(demographic$).equals((String) session.getAttribute("user")) ) {
		bPrincipalDisplay = true;
	}
%>
</security:oscarSec>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/rewrite-tag.tld" prefix="rewrite" %>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security" %>
<%@ taglib uri="/WEB-INF/oscar-tag.tld" prefix="oscar" %>

<%@page import="oscar.log.*,oscar.util.UtilMisc,oscar.oscarEncounter.data.*, java.net.*,java.util.*,oscar.util.UtilDateUtilities"%>
<%@page import="oscar.oscarMDS.data.MDSResultsData,oscar.oscarLab.ca.on.*, oscar.oscarMessenger.util.MsgDemoMap, oscar.oscarMessenger.data.MsgMessageData"%>
<%@page import="oscar.oscarEncounter.oscarMeasurements.*,oscar.oscarResearch.oscarDxResearch.bean.*,oscar.util.*"%>
<%@page import="oscar.eform.*, oscar.dms.*, org.apache.commons.lang.StringEscapeUtils" %> 

<jsp:useBean id="oscarVariables" class="java.util.Properties" scope="session" />

<%
	String ip = request.getRemoteAddr();
//	LogAction.addLog((String) session.getAttribute("user"), LogConst.READ, LogConst.CON_ECHART, demographic$, ip);
%>
<%

  response.setHeader("Cache-Control","no-cache");
  //The oscarEncounter session manager, if the session bean is not in the context it looks for a session cookie with the appropriate name and value, if the required cookie is not available
  //it dumps you out to an erros page.

  oscar.oscarEncounter.pageUtil.EctSessionBean bean = null;
  if((bean=(oscar.oscarEncounter.pageUtil.EctSessionBean)request.getSession().getAttribute("EctSessionBean"))==null) {
    response.sendRedirect("error.jsp");
    return;
  }
%>

<%
  //need these variables for the forms
  oscar.util.UtilDateUtilities dateConvert = new oscar.util.UtilDateUtilities();
  String demoNo = bean.demographicNo;
  String provNo = bean.providerNo;
  EctFormData.Form[] forms = new EctFormData().getForms();
  EctPatientData.Patient pd = new EctPatientData().getPatient(demoNo);
  EctProviderData.Provider prov = new EctProviderData().getProvider(provNo);
  String patientName = pd.getFirstName()+" "+pd.getSurname();
  String patientAge = pd.getAge();
  String patientSex = pd.getSex();
  String providerName = bean.userName;
  String pAge = Integer.toString(dateConvert.calcAge(bean.yearOfBirth,bean.monthOfBirth,bean.dateOfBirth));
  java.util.Locale vLocale =(java.util.Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);

  CommonLabResultData comLab = new CommonLabResultData();
  ArrayList labs = comLab.populateLabResultsData("",demoNo, "", "","","U");
  Collections.sort(labs);

  //MDSResultsData labResults =  new MDSResultsData();
  //labResults.populateMDSResultsData("", demoNo, "", "", "", "U");

  String province = ((String ) oscarVariables.getProperty("billregion","")).trim().toUpperCase();
  Properties windowSizes = oscar.oscarEncounter.pageUtil.EctWindowSizes.getWindowSizes(provNo);

  MsgDemoMap msgDemoMap = new MsgDemoMap();
  Vector msgVector = msgDemoMap.getMsgVector(demoNo);
  MsgMessageData msgData;

  EctSplitChart ectSplitChart = new EctSplitChart();
  Vector splitChart = ectSplitChart.getSplitCharts(demoNo);

  boolean sChart = true;
  if (splitChart == null || splitChart.size() == 0){
     sChart = false;
  }
  
  String enTemplates = "";
  boolean first = true;
  for(int j=0; j<bean.templateNames.size(); j++) {
     String encounterTmp = (String)bean.templateNames.get(j);
        if (first){
           enTemplates += "'"+encounterTmp+"'";
           first = false;
        }else{
           enTemplates += ",'"+encounterTmp+"'";        
        }
  }

  
%>



<html:html locale="true">
<head>
<title><bean:message key="oscarEncounter.Index.title"/> - <oscar:nameage demographicNo="<%=demoNo%>"/></title>
<html:base/>
<script language="javascript" type="text/javascript" src="../share/javascript/Oscar.js" ></script>
<style type="text/css">
	div.presBox {
		height: <%=windowSizes.getProperty("presBoxSize")%>;
		overflow: auto;
	}

	div.presBox ul{
       width:8em;
       list-style:none;
       list-style-type:none;
       list-style-position:outside;
       padding-left:1px;
       margin-left:1px;
       margin-top:1px;
       padding-top:1px;
	}

	div.presBox li{
	    border-bottom: 1pt solid #888888;
	}

	div.presBox li a{
	   font-size:10px;
	}
</style>
<!-- This is from OscarMessenger to get the top and left borders on -->
<link rel="stylesheet" type="text/css" href="encounterStyles.css">
<link rel="stylesheet" type="text/css" href="../share/css/dhtmlXMenu_xp.css">

<!-- link href="../share/css/script.aculo.us.css" media="screen" rel="Stylesheet" type="text/css" / -->
  <script src="../share/javascript/prototype.js" type="text/javascript"></script>
  <script src="../share/javascript/effects.js" type="text/javascript"></script>
  <script src="../share/javascript/dragdrop.js" type="text/javascript"></script>
  <script src="../share/javascript/controls.js" type="text/javascript"></script>

<!--<script type="application/x-javascript" language="javascript" src="/javascript/sizing.js"></script>-->
<script type="text/javascript" language=javascript>
    var X       = 10;
    var pBSmall = 30;
    var small   = 60;
    var normal  = 166;
    var medium  = 272;
    var large   = 378;
    var full    = 649;
//tilde operator function variables
    var handlePressState = 0;
    var handlePressFocus;
    var handlePressFocus2 = "none";
    var keyPressed;
    var textValue1;
    var textValue2;
    var textValue3;

    function closeEncounterWindow() {
        return window.confirm("<bean:message key="oscarEncounter.Index.closeEncounterWindowConfirm"/>");
    }
    //function saveAndCloseEncounterWindow() {
    //    var x = window.confirm("<bean:message key="oscarEncounter.Index.confirmExit"/>");
    //    if(x) {window.close();}
    //}
    //get another encounter from the select list
    function onSplit() {
        document.forms['encForm'].btnPressed.value = 'Split Chart';
        var ret = confirm("<bean:message key="oscarEncounter.Index.confirmSplit"/>");
        return ret;
    }
    function popUpImmunizations(vheight,vwidth,varpage) {
        var page = varpage;
        windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
        var popup=window.open(varpage, "<bean:message key="global.immunizations"/>", windowprops);
    }

    function popUpMeasurements(vheight,vwidth,varpage) { //open a new popup window
      if(varpage!= 'null'){
          //document.measurementGroupForm.measurementGroupSelect.options[0].selected = true;
          var page = "<rewrite:reWrite jspPage="oscarMeasurements/SetupMeasurements.do"/>?groupName=" + varpage;
          windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=600,screenY=200,top=0,left=0";
          var popup=window.open(page, "<bean:message key="oscarEncounter.Index.popupPageWindow"/>", windowprops);
          if (popup != null) {
            if (popup.opener == null) {
              popup.opener = self;
              alert("<bean:message key="oscarEncounter.Index.popupPageAlert"/>");
            }
          }
      }
    }
    function popUpInsertTemplate(vheight,vwidth,varpage) { //open a new popup window
        //var x = window.confirm("<bean:message key="oscarEncounter.Index.insertTemplateConfirm"/>");
        //if(x) {
              if(varpage!= 'null'){
                  //document.insertTemplateForm.templateSelect.options[0].selected=true;
                  var page = "<rewrite:reWrite jspPage="InsertTemplate.do"/>?templateName=" + varpage;
                  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=600,screenY=200,top=0,left=0";
                  var popup=window.open(page, "<bean:message key="oscarEncounter.Index.popupPageWindow"/>", windowprops);
                  if (popup != null) {
                    if (popup.opener == null) {
                      popup.opener = self;
                      alert("<bean:message key="oscarEncounter.Index.popupPageAlert"/>");
                    }
                  }
              }
          //}
    }
    
    function setCaretPosition(inpu, pos){
	if(inpu.setSelectionRange){
		inpu.focus();
		inpu.setSelectionRange(pos,pos);
	}else if (inpu.createTextRange) {
		var range = inpu.createTextRange();
		range.collapse(true);
		range.moveEnd('character', pos);
		range.moveStart('character', pos);
		range.select();
	}
    }
    
    function writeToEncounterNote(res){
       //paste to encounter window
       //alert("in writeToEncouterNote"+res);
       var curPos = document.encForm.enTextarea.value.length + res.responseText.indexOf('\n') +1;
       //alert(curPos);
       //alert("len :"+document.encForm.enTextarea.value.length+" first newline "+res.responseText.indexOf('\n'));
       document.encForm.enTextarea.value = document.encForm.enTextarea.value + "\n\n" + res.responseText;
       setTimeout("document.encForm.enTextarea.scrollTop=2147483647", 0);  // setTimeout is needed to allow browser to realize that text field has been updated 
       document.encForm.enTextarea.focus();
       setCaretPosition(document.encForm.enTextarea,curPos);
       
    }
    function ajaxInsertTemplate(varpage) { //open a new popup window
        if(varpage!= 'null'){
        
          var page = "<rewrite:reWrite jspPage="InsertTemplate.do"/>?templateName=" + varpage;
          new Ajax.Request(page, {onSuccess:writeToEncounterNote});
          
          
        }
          
    }
    

    function popupStart1(vheight,vwidth,varpage) {
        var page = varpage;
        windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
        var popup=window.open(varpage, "<bean:message key="oscarEncounter.Index.title"/>", windowprops);
    }
    function getAnotherEncounter(newAppointmentNo){
            varpage = "./IncomingEncounter.do?appointmentList=true&appointmentNo="+newAppointmentNo;
            location = varpage;
    }
    function insertTemplate(text){
        // var x = window.confirm("<bean:message key="oscarEncounter.Index.insertTemplateConfirm"/>");
        // if(x) {
            document.encForm.enTextarea.value = document.encForm.enTextarea.value + "\n\n" + text;
            document.encForm.enTextarea.value = document.encForm.enTextarea.value.replace(/\\u003E/g, "\u003E");
            document.encForm.enTextarea.value = document.encForm.enTextarea.value.replace(/\\u003C/g, "\u003C");
            document.encForm.enTextarea.value = document.encForm.enTextarea.value.replace(/\\u005C/g, "\u005C");
            document.encForm.enTextarea.value = document.encForm.enTextarea.value.replace(/\\u0022/g, "\u0022");
            document.encForm.enTextarea.value = document.encForm.enTextarea.value.replace(/\\u0027/g, "\u0027");
            window.setTimeout("document.encForm.enTextarea.scrollTop=2147483647", 0);  // setTimeout is needed to allow browser to realize that text field has been updated
            document.encForm.enTextarea.focus();
        // }
    }

    function refresh() {
        var u = self.location.href;
        if(u.lastIndexOf("&status=B") > 0) {
            self.location.href = u.substring(0,u.lastIndexOf("&status=B")) + "&status=P"  ;
        } else if (u.lastIndexOf("&status=") > 0) {
            self.location.href = u.substring(0,u.lastIndexOf("&status=")) + "&status=B"  ;
        } else {
            history.go(0);
        }
     	  self.opener.refresh();
    }
    function onUnbilled(url) {
        if(confirm("<bean:message key="oscarEncounter.Index.onUnbilledConfirm"/>")) {
            popupPage(700,720, url);
        }
    }
    function popupPage2(varpage) {
        var page = "" + varpage;
        windowprops = "height=600,width=700,location=no,"
          + "scrollbars=yes,menubars=no,toolbars=no,resizable=yes,top=0,left=0";
        window.open(page, "<bean:message key="oscarEncounter.Index.popupPage2Window"/>", windowprops);
    }
    function popupPage(vheight,vwidth,varpage) { //open a new popup window
      var page = "" + varpage;
      windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=600,screenY=200,top=0,left=0";
      var popup=window.open(page, "<bean:message key="oscarEncounter.Index.popupPageWindow"/>", windowprops);
      if (popup != null) {
        if (popup.opener == null) {
          popup.opener = self;
          alert("<bean:message key="oscarEncounter.Index.popupPageAlert"/>");
        }
      }
    }
    function urlencode(str) {
        var ns = (navigator.appName=="Netscape") ? 1 : 0;
        if (ns) { return escape(str); }
        var ms = "%25#23 20+2B?3F<3C>3E{7B}7D[5B]5D|7C^5E~7E`60";
        var msi = 0;
        var i,c,rs,ts ;
        while (msi < ms.length) {
            c = ms.charAt(msi);
            rs = ms.substring(++msi, msi +2);
            msi += 2;
            i = 0;
            while (true)	{
                i = str.indexOf(c, i);
                if (i == -1) break;
                ts = str.substring(0, i);
                str = ts + "%" + rs + str.substring(++i, str.length);
            }
        }
        return str;
    }
    function popupStart(vheight,vwidth,varpage) {
      var page = varpage;
      windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
      var popup=window.open(varpage, "", windowprops);
      if (popup != null) {
        if (popup.opener == null) {
          popup.opener = self;
        }
      }
    }

function reset() {
    document.encForm.shTextarea.style.overflow="auto";
    document.encForm.fhTextarea.style.overflow="auto";
    document.encForm.mhTextarea.style.overflow="auto";
    document.encForm.shTextarea.style.height=small;
    document.encForm.fhTextarea.style.height=small;
    document.encForm.mhTextarea.style.height=small;
    document.encForm.rowOneSize.value=small;
    document.encForm.ocTextarea.style.overflow="auto";
    document.encForm.reTextarea.style.overflow="auto";
    document.encForm.ocTextarea.style.height=small;
    document.encForm.reTextarea.style.height=small;
    document.encForm.rowTwoSize.value=small;
    document.encForm.enTextarea.style.overflow="auto";
    document.encForm.enTextarea.style.height=large;
    document.encForm.rowThreeSize.value=large;
    document.getElementById("presBox").style.height=pBSmall;
    document.getElementById("allergyBox").style.height=pBSmall;
    document.encForm.presBoxSize.value=pBSmall;
}
function rowOneX(){
    document.encForm.shTextarea.style.overflow="auto";
    document.encForm.fhTextarea.style.overflow="auto";
    document.encForm.mhTextarea.style.overflow="auto";
    document.encForm.shTextarea.style.height=X;
    document.encForm.fhTextarea.style.height=X;
    document.encForm.mhTextarea.style.height=X;
    document.encForm.rowOneSize.value=X;
}
function rowOneSmall(){
    document.encForm.shTextarea.style.overflow="auto";
    document.encForm.fhTextarea.style.overflow="auto";
    document.encForm.mhTextarea.style.overflow="auto";
    document.encForm.shTextarea.style.height=small;
    document.encForm.fhTextarea.style.height=small;
    document.encForm.mhTextarea.style.height=small;
    document.encForm.rowOneSize.value=small;
}
function rowOneNormal(){
    document.encForm.shTextarea.style.overflow="auto";
    document.encForm.fhTextarea.style.overflow="auto";
    document.encForm.mhTextarea.style.overflow="auto";
    document.encForm.shTextarea.style.height=normal;
    document.encForm.fhTextarea.style.height=normal;
    document.encForm.mhTextarea.style.height=normal;
    document.encForm.rowOneSize.value=normal;
}
function rowOneLarge(){
    document.encForm.shTextarea.style.overflow="auto";
    document.encForm.fhTextarea.style.overflow="auto";
    document.encForm.mhTextarea.style.overflow="auto";
    document.encForm.shTextarea.style.height=large;
    document.encForm.fhTextarea.style.height=large;
    document.encForm.mhTextarea.style.height=large;
    document.encForm.rowOneSize.value=large;
}
function rowOneFull(){
    document.encForm.shTextarea.style.overflow="auto";
    document.encForm.fhTextarea.style.overflow="auto";
    document.encForm.mhTextarea.style.overflow="auto";
    document.encForm.shTextarea.style.height=full;
    document.encForm.fhTextarea.style.height=full;
    document.encForm.mhTextarea.style.height=full;
    document.encForm.shInput.scrollIntoView(top);
    document.encForm.rowOneSize.value=full;
}
function rowTwoX(){
    document.encForm.ocTextarea.style.overflow="auto";
    document.encForm.reTextarea.style.overflow="auto";
    document.encForm.ocTextarea.style.height=X;
    document.encForm.reTextarea.style.height=X;
    document.encForm.rowTwoSize.value=X;
}
function rowTwoSmall(){
    document.encForm.ocTextarea.style.overflow="auto";
    document.encForm.reTextarea.style.overflow="auto";
    document.encForm.ocTextarea.style.height=small;
    document.encForm.reTextarea.style.height=small;
    document.encForm.rowTwoSize.value=small;
}
function rowTwoNormal(){
    document.encForm.ocTextarea.style.overflow="auto";
    document.encForm.reTextarea.style.overflow="auto";
    document.encForm.ocTextarea.style.height=normal;
    document.encForm.reTextarea.style.height=normal;
    document.encForm.rowTwoSize.value=normal;
}
function rowTwoLarge(){
        document.encForm.ocTextarea.style.overflow="auto";
    document.encForm.reTextarea.style.overflow="auto";
    document.encForm.ocTextarea.style.height=large;
    document.encForm.reTextarea.style.height=large;
    document.encForm.rowTwoSize.value=large;
}
function rowTwoFull(){
    document.encForm.ocTextarea.style.overflow="auto";
    document.encForm.reTextarea.style.overflow="auto";
    document.encForm.ocTextarea.style.height=full;
    document.encForm.reTextarea.style.height=full;
    document.encForm.ocInput.scrollIntoView(top);
    document.encForm.rowTwoSize.value=full;
}

function rowThreeX(){
    document.encForm.enTextarea.style.overflow="auto";
    document.encForm.enTextarea.style.height=X;
    document.encForm.rowThreeSize.value=X;
}
function rowThreeSmall(){
    document.encForm.enTextarea.style.overflow="auto";
    document.encForm.enTextarea.style.height=small;
    document.encForm.rowThreeSize.value=small;
}
function rowThreeNormal(){
    document.encForm.enTextarea.style.overflow="auto";
    document.encForm.enTextarea.style.height=normal;
    document.encForm.rowThreeSize.value=normal;
}
function rowThreeMedium(){
    document.encForm.enTextarea.style.overflow="auto";
    document.encForm.enTextarea.style.height=medium;
    document.encForm.rowThreeSize.value=medium;
}
function rowThreeLarge(){
    document.encForm.enTextarea.style.overflow="auto";
    document.encForm.enTextarea.style.height=large;
    document.encForm.rowThreeSize.value=large;
}
function rowThreeFull(){
    document.encForm.enTextarea.style.overflow="auto";
    document.encForm.enTextarea.style.height=full;
    document.encForm.enInput.scrollIntoView(top);
    document.encForm.rowThreeSize.value=full;
}

function presBoxX(){
    document.getElementById("presBox").style.height=X;
    document.getElementById("allergyBox").style.height=X;
    document.encForm.presBoxSize.value=X;
}
function presBoxSmall(){
    document.getElementById("presBox").style.height=pBSmall;
    document.getElementById("allergyBox").style.height=pBSmall;
    document.encForm.presBoxSize.value=pBSmall;
}
function presBoxNormal(){
    document.getElementById("presBox").style.height=normal;
    document.getElementById("allergyBox").style.height=normal;
    document.encForm.presBoxSize.value=normal;
}
function presBoxLarge(){
    document.getElementById("presBox").style.height=large;
    document.getElementById("allergyBox").style.height=large;
    document.encForm.presBoxSize.value=large;
}
function presBoxFull(){
    document.getElementById("presBox").style.height=full;
    document.getElementById("allergyBox").style.height=full;
    document.getElementById("presTopTable").scrollIntoView(top);
    document.encForm.presBoxSize.value=full;
}
<!--new functions end from jay-->

function popupSearchPage(vheight,vwidth,varpage) { //open a new popup window
  var page = "" + varpage;
  windowprop = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=50,screenY=50,top=0,left=0";
  var popup=window.open(page, "<bean:message key="oscarEncounter.Index.popupSearchPageWindow"/>", windowprop);
}


if (!document.all) document.captureEvents(Event.MOUSEUP);
document.onmouseup = getActiveText;

function getActiveText(e) {

  //text = (document.all) ? document.selection.createRange().text : document.getSelection();
  //document.ksearch.keyword.value = text;
 if(document.all) {
    //alert("one");
    text = document.selection.createRange().text;
    if(text != "" && document.ksearch.keyword.value=="") {
      document.ksearch.keyword.value += text;
    }
    if(text != "" && document.ksearch.keyword.value!="") {
      document.ksearch.keyword.value = text;
    }
  } else {
    text = window.getSelection();

    if (text.toString().length == 0){  //for firefox
       var txtarea = document.encForm.enTextarea;
       var selLength = txtarea.textLength;
       var selStart = txtarea.selectionStart;
       var selEnd = txtarea.selectionEnd;
       if (selEnd==1 || selEnd==2) selEnd=selLength;
       text = (txtarea.value).substring(selStart, selEnd);
    }
    //
    document.ksearch.keyword.value = text;
  }
  return true;
}

function tryAnother(){
////
    var txt = "null";
    var foundIn = "null";
    if (window.getSelection){
		txt = window.getSelection();
		foundIn = 'window.getSelection()';
	 }else if (document.getSelection){
		txt = document.getSelection();
		foundIn = 'document.getSelection()';
	 }else if (document.selection){
		txt = document.selection.createRange().text;
		foundIn = 'document.selection.createRange()';
	 }
	 alert (txt+"\n"+foundIn);
    ////
}
function popupPageK(page) {
    windowprops = "height=700,width=960,location=no,"
    + "scrollbars=yes,menubars=no,toolbars=no,resizable=yes,top=0,left=0";
    var popup = window.open(page, "<bean:message key="oscarEncounter.Index.popupPageKWindow"/>", windowprops);
    popup.focus();
}
function selectBox(name) {
    to = name.options[name.selectedIndex].value;
    name.selectedIndex =0;
    if(to!="null")
      popupPageK(to);
}
function popupOscarRx(vheight,vwidth,varpage) {
  var page = varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
  var popup=window.open(varpage, "<bean:message key="global.oscarRx"/>", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self;
    }
  }
  popup.focus();
}
function popupOscarCon(vheight,vwidth,varpage) {
  var page = varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=no,menubars=no,toolbars=no,resizable=no,screenX=0,screenY=0,top=0,left=0";
  var popup=window.open(varpage, "<bean:message key="oscarEncounter.Index.msgOscarConsultation"/>", windowprops);
  popup.focus();
}


function popupOscarComm(vheight,vwidth,varpage) {
  var page = varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
  var popup=window.open(varpage, "<bean:message key="global.oscarComm"/>", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self;
    }
  }
  popup.focus();
}

function popUpMsg(vheight,vwidth,msgPosition) {


  var page = "<rewrite:reWrite jspPage="../oscarMessenger/ViewMessageByPosition.do"/>?from=encounter&orderBy=!date&demographic_no=<%=demoNo%>&messagePosition="+msgPosition;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
  var popup=window.open(page, "<bean:message key="global.oscarRx"/>", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self;
    }
  }
  popup.focus();
}

function goToSearch() {
        var x = window.confirm("<bean:message key="oscarEncounter.Index.goToSearchConfirm"/>");
        if(x)
        {  location = "./search/DemographicSearch.jsp";}
}
//function sign(){
//        document.encForm.enTextarea.value =document.encForm.enTextarea.value +"\n[<bean:message key="oscarEncounter.Index.signed"/> <%=dateConvert.DateToString(bean.currentDate)%> <bean:message key="oscarEncounter.Index.by"/> <%=bean.userName%>]";
//}

//function saveEncounter(){
//        location="SaveEncounter.do";
//}

//function saveSignEncounter(){
//        location="SaveEncounter.do";
//}

function loader(){
    window.focus();
    var tmp;

    document.encForm.enTextarea.focus();
    document.encForm.enTextarea.value = document.encForm.enTextarea.value + "";
    document.encForm.enTextarea.scrollTop = document.encForm.enTextarea.scrollHeight;

    <%String popUrl = request.getParameter("popupUrl");
      if (popUrl != null){           %>
      window.setTimeout("popupPageK('<%=popUrl%>')", 2);
    <%}%>

    //tmp = document.encForm.enTextarea.value; // these two lines cause the enTextarea to scroll to the bottom (only works in IE)
    //document.encForm.enTextarea.value = tmp; // another option is to use window.setTimeout("document.encForm.enTextarea.scrollTop=2147483647", 0);  (also only works in IE)
}
</script>
<script language="javascript">


/////
function showpic(picture,id){
     if (document.getElementById){ // Netscape 6 and IE 5+
        var targetElement = document.getElementById(picture);
        var bal = document.getElementById(id);

        var offsetTrail = document.getElementById(id);
        var offsetLeft = 0;
        var offsetTop = 0;
        while (offsetTrail) {
           offsetLeft += offsetTrail.offsetLeft;
           offsetTop += offsetTrail.offsetTop;
           offsetTrail = offsetTrail.offsetParent;
        }
        if (navigator.userAgent.indexOf("Mac") != -1 &&
           typeof document.body.leftMargin != "undefined") {
           offsetLeft += document.body.leftMargin;
           offsetTop += document.body.topMargin;
        }

        targetElement.style.left = offsetLeft +bal.offsetWidth;
        targetElement.style.top = offsetTop;
        targetElement.style.visibility = 'visible';
     }
  }

  function hidepic(picture){
     if (document.getElementById){ // Netscape 6 and IE 5+
        var targetElement = document.getElementById(picture);
        targetElement.style.visibility = 'hidden';
     }
  }


/////





function popperup(vheight,vwidth,varpage,pageName) { //open a new popup window
  hidepic('Layer1');
  var page = varpage;
  windowprops = "height="+vheight+",width="+vwidth+",status=yes,location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=100,left=100";
  var popup=window.open(varpage, pageName, windowprops);
      popup.opener = self;
  popup.focus();
}


function grabEnter(event){
  if(window.event && window.event.keyCode == 13){
      popupSearchPage(600,800,document.forms['ksearch'].channel.options[document.forms['ksearch'].channel.selectedIndex].value+urlencode(document.forms['ksearch'].keyword.value));
      return false;
  }else if (event && event.which == 13){
      popupSearchPage(600,800,document.forms['ksearch'].channel.options[document.forms['ksearch'].channel.selectedIndex].value+urlencode(document.forms['ksearch'].keyword.value));
      return false;
  }
}

function grabEnterGetTemplate(event){

  
  if(window.event && window.event.keyCode == 13){
      //alert (document.getElementById('enTemplate').value + " | " +$('enTemplate_list').getStyle('display'));
      if ( $('enTemplate_list').getStyle('display') == 'none'){     
         popUpInsertTemplate(40,50,document.getElementById('enTemplate').value);   
      }     
      return false;
  }else if (event && event.which == 13){
      if ( $('enTemplate_list').getStyle('display') == 'none'){
      //alert (document.getElementById('enTemplate').value + " | " +$('enTemplate_list').getStyle('display'));
         popUpInsertTemplate(40,50,document.getElementById('enTemplate').value);
      }
      return false;
  }
}


</script>

<style type="text/css">
td.menuLayer{
        background-color: #ccccff;
        font-size: 14px;
}
table.layerTable{
        border-top: 2px solid #cfcfcf;
        border-left: 2px solid #cfcfcf;
        border-bottom: 2px solid #333333;
        border-right: 2px solid #333333;
}

table.messButtonsA{
border-top: 2px solid #cfcfcf;
border-left: 2px solid #cfcfcf;
border-bottom: 2px solid #333333;
border-right: 2px solid #333333;
}

table.messButtonsD{
border-top: 2px solid #333333;
border-left: 2px solid #333333;
border-bottom: 2px solid #cfcfcf;
border-right: 2px solid #cfcfcf;
}

</style>

<style type="text/css">


div.leftBox{
   width:95%;
   margin-top: 2px;
   margin-left:3px;
   margin-right:1px;   
   /*float: left;*/
   border-left: 1px solid #6699cc;   
   border-right: 1px solid #6699cc;
   border-bottom: 1px solid #6699cc;
}

span.footnote {
    background-color: #ccccee;
    border: 1px solid #000;
    width: 4px;
}

div.leftBox h3 a {
    color: white;
    text-decoration: none;
}

div.leftBox h3 {  
   background-color: #6699cc; 
   /*font-size: 1.25em;*/
   font-size: 9px;
   /*font-variant:small-caps;*/
   color: white;
   font-weight:bold;
   margin-top:0px;
   padding-top:0px;
   margin-bottom:0px;
   padding-bottom:0px;
}

div.leftBox ul{ 
       /*border-top: 1px solid #F11;*/
       /*border-bottom: 1px solid #F11;*/
       /*font-size: 1.0em;*/
       font-size: 9px;
       list-style:none;
       list-style-type:none; 
       list-style-position:outside;       
       padding-left:1px;
       margin-left:1px;    
       margin-top:0px;
       padding-top:1px;
       margin-bottom:0px;
       padding-bottom:0px;	
}

div.leftBox li {
padding-right: 15px;
white-space: nowrap;
}


/* template styles*/
          
          div.enTemplate_name_auto_complete {
            width: 350px;
            background: #fff;
            font-size: 9px;
          }
          div.enTemplate_name_auto_complete ul {
            border:1px solid #888;
            margin:0;
            padding:0;
            width:100%;
            list-style-type:none;
          }
          div.enTemplate_name_auto_complete ul li {
            margin:0;
            padding:3px;
          }
          div.enTemplate_name_auto_complete ul li.selected { 
            background-color: #ffb; 
          }
          div.enTemplate_name_auto_complete ul strong.highlight { 
            color: #800; 
            margin:0;
            padding:0;
          }


</style>


<script type="text/javascript">
        //['icon', 'title', 'url', 'target', 'description'],
  var myMenu =   [
                    
                    [null,'Add',null,null,null,
                         <%//EctFormData.Form[] forms = new EctFormData().getForms();
                           for(int j=0; j<forms.length; j++) {
                              EctFormData.Form frm = forms[j];
                              if (!frm.isHidden()) {
                         %>
                              ['&nbsp;','<%=frm.getFormName()%>','javascript: popupPageK("<%=frm.getFormPage()+demoNo+"&formId=0&provNo="+provNo%>")',null,'<%=frm.getFormName()%>'],
                                                      
                         <%   } 
                           }
                         %>                         
                            ['&nbsp;','<bean:message key="oscarEncounter.Index.msgOldForms"/>','javascript:popupPage2("<rewrite:reWrite jspPage="formlist.jsp"/>?demographic_no=<%=demoNo%>")',null,null]			
                    ]
                 ];

	
</script>


<SCRIPT LANGUAGE="JavaScript" SRC="../share/javascript/JSCookMenu.js"></SCRIPT>



<LINK REL="stylesheet" HREF="../share/css/ThemeOffice/theme.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="../share/css/ThemeOffice/theme.js"></SCRIPT>





</head>

<body  onload="javascript:loader();"  topmargin="0" leftmargin="0" bottommargin="0" rightmargin="0" vlink="#0000FF">
<script type="text/javascript" src="../share/javascript/dhtmlXProtobar.js"></script>
<script type="text/javascript" src="../share/javascript/dhtmlXMenuBar.js"></script>
<script type="text/javascript" src="../share/javascript/dhtmlXCommon.js"></script>

<html:errors/>

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse;width:100%;height:680;" bordercolor="#111111" id="scrollNumber1" name="<bean:message key="oscarEncounter.Index.encounterTable"/>">
    <tr>
        <td class="hidePrint" bgcolor="#003399" style="border-right: 2px solid #A9A9A9;height:34px;" >
            <div class="Title">
			&nbsp;<bean:message key="oscarEncounter.Index.msgEncounter"/>
            </div>
        </td>

        <td  bgcolor="#003399" style="text-align:right;height:34px;padding-left:3px;" >
                <table name="tileTable" style="vertical-align:middle;border-collapse:collapse;" >
                    <tr>
                        <td width=70% class="Header" style="padding-left:2px;padding-right:2px;border-right:2px solid #003399;text-align:left;font-weight:bold;width:100%;" NOWRAP >
                            <%=bean.patientLastName %>, <%=bean.patientFirstName%> <%=bean.patientSex%> <%=bean.patientAge%>
                            <span style="margin-left:20px;"><i>Next Appointment: <oscar:nextAppt demographicNo="<%=bean.demographicNo%>"/></i></span>
                    
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            
                            <form style="display:inline;" name="ksearch" >
                              <select  name="channel" >
                                 <option value="http://resource.oscarmcmaster.org/oscarResource/OSCAR_search/OSCAR_search_results?title="><bean:message key="oscarEncounter.Index.oscarSearch"/></option>
                                 <option value="http://www.google.com/search?q="><bean:message key="global.google"/></option>
                                 <option value="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?SUBMIT=y&CDM=Search&DB=PubMed&term="><bean:message key="global.pubmed"/></option>
                                 <option value="http://search.nlm.nih.gov/medlineplus/query?DISAMBIGUATION=true&FUNCTION=search&SERVER2=server2&SERVER1=server1&PARAMETER="><bean:message key="global.medlineplus"/></option>
                                 <option value="http://www.bnf.org/bnf/bnf/current/noframes/search.htm?n=50&searchButton=Search&q="><bean:message key="global.BNF"/></option>
                              </select>
                               <input type="text" name="keyword"  value=""  onkeypress="return grabEnter(event)"/>
                              <input type="button" name="button"  value="Search" onClick="popupSearchPage(600,800,forms['ksearch'].channel.options[forms['ksearch'].channel.selectedIndex].value+urlencode(forms['ksearch'].keyword.value) ); return false;">
                            
                              </form>
                             
                        </td>
                        <td class="Header" style="text-align:center;border-right: 3px solid #003399" NOWRAP>
                                <a href="javascript:popupStart(300,400,'Help.jsp')"><bean:message key="global.help"/></a> | <a href="javascript:popupStart(300,400,'About.jsp')"><bean:message key="global.about"/></a>
                        </td>
                    </tr>
                    
                </table>

            </td>
    </tr>
    <tr style="height:100%">
        <td style="border-top:2px solid #A9A9A9;border-right:2px solid #A9A9A9;vertical-align:top">
   
         
        
           <div class="leftbox">
                <h3>&nbsp;<bean:message key="oscarEncounter.Index.clinicalModules"/></h3>
                <ul>
                    <li>               
                        <%if (vLocale.getCountry().equals("BR")) {%>
                            <a href="javascript: function myFunction() {return false; }" onClick="popup(700,1000,'../demographic/demographiccontrol.jsp?demographic_no=<%=bean.demographicNo%>&displaymode=edit&dboperation=search_detail_ptbr','master')"
                            title="<bean:message key="provider.appointmentProviderAdminDay.msgMasterFile"/>"><bean:message key="global.master"/></a>
                        <%}else{%>
                            <a href="javascript: function myFunction() {return false; }" onClick="popup(700,1000,'../demographic/demographiccontrol.jsp?demographic_no=<%=bean.demographicNo%>&displaymode=edit&dboperation=search_detail','master')"
                            title="<bean:message key="provider.appointmentProviderAdminDay.msgMasterFile"/>"><bean:message key="global.master"/></a>
                        <%}%>
                    </li>
                    <li>
                        <a href=# onClick="popupOscarCon(700,960,'<rewrite:reWrite jspPage="oscarConsultationRequest/DisplayDemographicConsultationRequests.jsp"/>?de=<%=bean.demographicNo%>');return false;"><bean:message key="global.consultations"/></a>
                    </li>
                    <li>
                        <oscar:oscarPropertiesCheck property="PREVENTION" value="yes">
                            <a href="javascript:popUpImmunizations(700,960,'../oscarPrevention/index.jsp?demographic_no=<%=bean.demographicNo%>')">
                            <oscar:preventionWarnings demographicNo="<%=bean.demographicNo%>">prevention</oscar:preventionWarnings></a>
                        </oscar:oscarPropertiesCheck>
                    </li>
                    <li>
                        <a href=# onClick="popupOscarComm(580,900,'../oscarResearch/oscarDxResearch/setupDxResearch.do?demographicNo=<%=bean.demographicNo%>&providerNo=<%=provNo%>&quickList=');return false;"><bean:message key="global.disease"/></a>
                    </li>
                    <li>
                        <a href=# onClick="popupOscarCon(580,800,'../appointment/appointmentcontrol.jsp?keyword=<%=URLEncoder.encode(bean.patientLastName+","+bean.patientFirstName)%>&displaymode=<%=URLEncoder.encode("Search ")%>&search_mode=search_name&originalpage=<%=URLEncoder.encode("../tickler/ticklerAdd.jsp")%>&orderby=last_name&appointment_date=2000-01-01&limit1=0&limit2=5&status=t&start_time=10:45&end_time=10:59&duration=15&dboperation=add_apptrecord&type=&demographic_no=<%=bean.demographicNo%>');return false;"><bean:message key="oscarEncounter.Index.addTickler"/></a>
                        <a href="#" onClick="popupPage(700,1000, '../tickler/ticklerDemoMain.jsp?demoview=<%=bean.demographicNo%>');return false;"><bean:message key="global.viewTickler"/></a><br>
                        
                    </li>
                    <li>
                       <a href="javascript: function myFunction() {return false; }"  onClick="popupPage(150,200,'calculators.jsp?sex=<%=bean.patientSex%>&age=<%=pAge%>'); return false;" ><bean:message key="oscarEncounter.Index.calculators"/></a>
                    </li>
                    
                </ul>
            </div>
            
            <div class="leftbox">
                <span id="newMen" style="display: inline; float: right;">&nbsp;</span>
                <h3 onMouseOver="javascript:window.status='View any of <%=patientName%>\'s current forms.';">
                    &nbsp;<a href=# onClick='popupPage2("<rewrite:reWrite jspPage="formlist.jsp"/>?demographic_no=<%=demoNo%>"); return false;' ><bean:message key="oscarEncounter.Index.msgForms"/></a>  
                </h3>
                
                <ul>                   
                    <%for(int j=0; j<forms.length; j++) {
                         EctFormData.Form frm = forms[j];
                         String table = frm.getFormTable();
                         if(!table.equalsIgnoreCase("")){
                            EctFormData.PatientForm[] pforms = new EctFormData().getPatientForms(demoNo, table);
                            if(pforms.length>0) {
                               EctFormData.PatientForm pfrm = pforms[0];
                     %>
                           <li><a href="javascript: function myFunction() {return false; }" onclick="javascript: popupPageK('<%="../form/forwardshortcutname.jsp?formname="+frm.getFormName()+"&demographic_no="+demoNo%>')" title="Cr:<%=pfrm.getCreated()%> Ed:<%=pfrm.getEdited()%>">
                               <%=frm.getFormName()%>
                           </a></li>
                     <%     }
                         }
                      }     %>
                          
                </ul>
            </div>
         
            
            <div class="leftbox">
                <h3 >
                    &nbsp;<a href=# onClick='popupOscarRx(600,900,"<rewrite:reWrite jspPage="../oscarMessenger/DisplayDemographicMessages.do"/>?orderby=date&boxType=3&demographic_no=<%=demoNo%>&providerNo=<%=provNo%>&userName=<%=providerName%>"); return false;' >oscarMessenger</a>                 
                   <a href="javascript: function myFunction() {return false; }" onClick="popup(700,960,'../oscarMessenger/SendDemoMessage.do?demographic_no=<%=demoNo%>','msg')">Msg</a>                   
                </h3>
                
                <ul>                   
                   <%
                    String msgId;
                    String msgSubject;
                    String msgDate;
                    for(int j=0; j<10 && j<msgVector.size(); j++) {
                        msgId = (String) msgVector.elementAt(j);
                        msgData = new MsgMessageData(msgId);
                        msgSubject = msgData.getSubject();
                        msgDate = msgData.getDate();

                        String stripe = "style=\"background-color: #f0f5fe; \" ";
                        if ( (j % 2) == 0){
                           stripe = "";
                        }
                   %>
                     <li <%=stripe%>>
                        <a onclick="javascript:popUpMsg(600,900,<%=j%>);" href=# title="<%=msgSubject +" - "+msgDate%>">
                        <%=StringUtils.maxLenString(msgSubject, 25, 21, "...")%>
                        </a>
                     </li>
                 <% }%>
                </ul>
            </div>
            
            <div class="leftbox">
                <h3 >
                   &nbsp;<a href=# onClick="popupPage(600,1000,'<rewrite:reWrite jspPage="oscarMeasurements/SetupHistoryIndex.do"/>'); return false;" ><bean:message key="oscarEncounter.Index.measurements"/></a>
                </h3>
                
                <ul>                   
                   <oscar:oscarPropertiesCheck property="TESTING" value="yes">
                        <%
                        dxResearchBeanHandler dxRes = new dxResearchBeanHandler(bean.demographicNo);
                        Vector dxCodes = dxRes.getActiveCodeListWithCodingSystem();
                        ArrayList flowsheets = MeasurementTemplateFlowSheetConfig.getInstance().getFlowsheetsFromDxCodes(dxCodes);
                        for (int f = 0; f < flowsheets.size();f++){
                            String flowsheetName = (String) flowsheets.get(f);
                        %>
                        <li>
                            <a href="javascript: function myFunction() {return false; }" onClick="popup(700,1000,'oscarMeasurements/TemplateFlowSheet.jsp?demographic_no=<%=bean.demographicNo%>&template=<%=flowsheetName%>','flowsheet')">
                               <%=MeasurementTemplateFlowSheetConfig.getInstance().getDisplayName(flowsheetName)%>
                            </a>
                        </li>
                        <%}%>
                   </oscar:oscarPropertiesCheck>
                   <%
                   for(int j=0; j<bean.measurementGroupNames.size(); j++) {
                      String tmp = (String)bean.measurementGroupNames.get(j);
                   %>
                      <li>
                            <a onclick="popUpMeasurements(500,1000,'<%=tmp%>');" href=# title="<%=tmp%>">
                            <%=StringUtils.maxLenString(tmp, 25, 21, "...")%>
                            </a>
                      </li>
                 <%}%>
                           
                </ul>
            </div>
            <script type="text/javascript">
                function whereisit(t){
                   alert(t.getHeight());
                   g = $('baaa');
                   alert(" position "+Position.positionedOffset(g)+ " cumulative " + Position.cumulativeOffset(g)+" real "+Position.realOffset(g)+" ");
                   alert(window.screen.availTop);
                   alert(window.screen);
                   alert("window.screenTop " +window.screenTop);
                   alert("document.layers" +document.layers);
                   
                   var x = 0, y = 0; // default values

                    if (document.all) {
                      alert("Document.all");
                      x = window.screenTop + 100;
                      y = window.screenLeft + 100;
                    }
                    else if (document.layers) {
                      alert("document.layers");
                      x = window.screenX + 100;
                      y = window.screenY + 100;
                    }
                    alert (" X "+ x + " Y " + y);
                }
            </script>
            <div class="leftbox">
                <h3><!--a id="baaa" onclick="whereisit(this);">sfsdfsdf</a-->
&nbsp;<a href="javascript: function myFunction() {return false; }" onClick="popupxy(700,599,'../lab/DemographicLab.jsp?demographicNo=<%=bean.demographicNo%>','DemoLabSheet',5,305)">Lab Result</a>   
                   <a href="#" onClick="popupPage(700,1000, '../lab/CumulativeLabValues.jsp?demographic_no=<%=bean.demographicNo%>');return false;">Labs</a>
                   <a href="#" onClick="popupPage(700,1000, '../lab/CumulativeLabValues2.jsp?demographic_no=<%=bean.demographicNo%>');return false;">La</a>
                </h3>
                
                <ul>
                   <%
                    for(int j=0; j<labs.size(); j++) {
                       LabResultData result =  (LabResultData) labs.get(j);
                       String labURL = "";
                       String labDisplayName = "";
                       
                        if ( result.isMDS() ){ 
                            labURL ="../oscarMDS/SegmentDisplay.jsp?providerNo="+provNo+"&segmentID="+result.segmentID+"&status="+result.getReportStatus();
                            labDisplayName = result.getDiscipline()+" "+result.getDateTime();
                        }else if (result.isCML()){ 
                            labURL ="../lab/CA/ON/CMLDisplay.jsp?providerNo="+provNo+"&segmentID="+result.segmentID; 
                            labDisplayName = result.getDiscipline()+" "+result.getDateTime();
                        }else {
                            labURL ="../lab/CA/BC/labDisplay.jsp?segmentID="+result.segmentID+"&providerNo="+provNo;
                            labDisplayName = result.getDiscipline()+" "+result.getDateTime();
                        }
                       String stripe = "style=\"background-color: #f3f3f3; \" ";
                       if ( (j % 2) == 0){
                           stripe = "";
                       }
                       
                   %>
                        <li <%=stripe%>>
                           <a href=# onclick="javascript: popupPageK('<%=labURL%>');" title="<%=labDisplayName%>">
                               <%=StringUtils.maxLenString(labDisplayName, 18, 15, "...")%>
                           </a>
                        </li>
                 <% } %>
                        
                </ul>
            </div>
           

            <div class="leftbox">
                <h3>
                   &nbsp;<a href="#" onClick="popupPage(500,600,'../dms/documentReport.jsp?function=demographic&doctype=lab&functionid=<%=bean.demographicNo%>&curUser=<%=bean.curProviderNo%>');return false;"><bean:message key="oscarEncounter.Index.msgDocuments"/></a>
                </h3>
                <ul>
                <% 
                
                ArrayList docList = EDocUtil.listDocs("demographic", bean.demographicNo, null, EDocUtil.PRIVATE, EDocUtil.SORT_OBSERVATIONDATE);
                for (int i=0; i< docList.size(); i++) {
                    EDoc curDoc = (EDoc) docList.get(i);
                    String dispFilename = curDoc.getFileName();
                    String dispStatus   = curDoc.getStatus() + "";
                    String dispDocNo    = curDoc.getDocId();
                    String dispDesc     = curDoc.getDescription();
                   
                %>
                   <li >
                      <a href=# onclick="popup(700,800,'../dms/documentGetFile.jsp?document=<%=StringEscapeUtils.escapeJavaScript(dispFilename)%>&type=<%=dispStatus%>&doc_no=<%=dispDocNo%>', 480,480,1)"><%=dispDesc%></a>
                   </li>
                <%}%>          
                </ul>
            </div>

            <div class="leftbox">
                <h3>
                   &nbsp;<a href="#" style="color:white;" onClick="popupPage(500,950, '../eform/efmpatientformlist.jsp?demographic_no=<%=bean.demographicNo%>');return false;"><bean:message key="global.eForms"/></a> 
                </h3>   
                <ul>
                <%
                ArrayList eForms = EFormUtil.listPatientEForms(EFormUtil.DATE, EFormUtil.CURRENT, bean.demographicNo);
  
                for (int i=0; i< eForms.size(); i++) {
                    Hashtable curform = (Hashtable) eForms.get(i);
                     String stripe = "style=\"background-color: #f0fff0;";
                    
                    if ( (i % 2) == 0){
                           stripe = "";
                       }
                %>
                <li <%=stripe%> title="<%=curform.get("formSubject")%> - <%=curform.get("formDate")%>" >
                    <a  href=# onclick="popup( 700, 800, '../eform/efmshowform_data.jsp?fdid=<%= curform.get("fdid")%>', '<%="FormP" + i%>');">t</a>
                    <a  href="#" ONCLICK="popupPage(700,800,'../eform/efmshowform_data.jsp?fdid=<%= curform.get("fdid")%>','<%="FormP" + i%>' ); return false;" >
                       <%=curform.get("formName")%>
                    </a>
                </li>
              <%}%>                         
                </ul>
            </div>
           
            
           
           
           
            
        </td>
        <td valign="top">
        <form name="encForm" action="SaveEncounter2.do" method="POST">
            <table  name="encounterTableRightCol" >
    <!-- social history row --><!-- start new rows here -->
                <tr>
                    <td>
                        <table bgcolor="#CCCCFF" id="rowOne" width="100%">
                            <tr>
                               <td>
                                    <div class="RowTop" ><bean:message key="oscarEncounter.Index.socialFamHist"/>:</div><input type="hidden" name="shInput"/>
                                </td>
                                <td>
                                    <div class="RowTop" >
                                    <% if(oscarVariables.getProperty("otherMedications", "").length() > 1) {
                                        out.print(oscarVariables.getProperty("otherMedications", ""));
                                    %>
                                    <% } else { %>
                                    <bean:message key="oscarEncounter.Index.otherMed"/>:
                                    <% } %>
                                    </div>
                                </td>
                                <td><div class="RowTop" >
                                    <% if(oscarVariables.getProperty("medicalHistory", "").length() > 1) {
                                        out.print(oscarVariables.getProperty("medicalHistory", ""));
                                    %>
                                    <% } else { %>
                                    <bean:message key="oscarEncounter.Index.medHist"/>:
                                    <% } %>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size:8pt;text-align:right;vertical-align:bottom">
                                    <a onMouseOver="javascript:window.status='Minimize'; return true;" href="javascript:rowOneX();" title="<bean:message key="oscarEncounter.Index.tooltipClose"/>">
                                        <bean:message key="oscarEncounter.Index.x"/></a> |
                                    <a onMouseOver="javascript:window.status='Small Size'; return true;" href="javascript:rowOneSmall();" title="<bean:message key="oscarEncounter.Index.tooltipSmall"/>">
                                        <bean:message key="oscarEncounter.Index.s"/></a> |
                                    <a onMouseOver="javascript:window.status='Medium Size'; return true;" href="javascript:rowOneNormal();" title="<bean:message key="oscarEncounter.Index.tooltipNormal"/>">
                                        <bean:message key="oscarEncounter.Index.n"/></a> |
                                    <a onMouseOver="javascript:window.status='Large Size'; return true;" href="javascript:rowOneLarge();" title="<bean:message key="oscarEncounter.Index.tooltipLarge"/>">
                                        <bean:message key="oscarEncounter.Index.l"/></a> |
                                    <a onMouseOver="javascript:window.status='Full Size'; return true;" href="javascript:rowOneFull();" title="<bean:message key="oscarEncounter.Index.tooltipFull"/>">
                                        <bean:message key="oscarEncounter.Index.f"/></a> |
                                    <a onMouseOver="javascript:window.status='Full Size'; return true;" href="javascript:reset();" title="<bean:message key="oscarEncounter.Index.tooltipReset"/>">
                                        <bean:message key="oscarEncounter.Index.r"/></a>
                                    </div>
                                </td>
                            </tr>
                            <tr width="100%">
                                <!-- This is the Social History cell ...sh...-->
                                <td  valign="top">
                                    <!-- Creating the table tag within the script allows you to adjust all table sizes at once, by changing the value of leftCol -->
                                       <textarea name="shTextarea" wrap="hard"  cols= "31" style="height:<%=windowSizes.getProperty("rowOneSize")%>;overflow:auto"><%=bean.socialHistory%></textarea>
                                </td>
                                <!-- This is the Family History cell ...fh...-->
                                <td  valign="top">
                                       <textarea name="fhTextarea" wrap="hard"  cols= "31" style="height:<%=windowSizes.getProperty("rowOneSize")%>;overflow:auto"><%=bean.familyHistory%></textarea>
                                </td>
                                <!-- This is the Medical History cell ...mh...-->
                                <td  valign="top" colspan="2">
                                       <textarea name="mhTextarea" wrap="hard"  cols= "31" style="height:<%=windowSizes.getProperty("rowOneSize")%>;overflow:auto"><%=bean.medicalHistory%></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
    <!-- ongoing concerns row -->
                <tr>
                    <td>
                        <table bgcolor="#CCCCFF" id="rowTwo" width="100%">
                            <tr>
                                <td><div class="RowTop" >
                                    <% if(oscarVariables.getProperty("ongoingConcerns", "").length() > 1) {
                                        out.print(oscarVariables.getProperty("ongoingConcerns", ""));
                                    %>
                                    <% } else { %>
                                    <bean:message key="oscarEncounter.Index.msgConcerns"/>:
                                    <% } %>
                                    </div><input type="hidden" name="ocInput"/>
                                </td>

                                <td>
                                    <div class="RowTop" ><bean:message key="oscarEncounter.Index.msgReminders"/>:</div>
                                </td>
                                <td>
                                    <div style="font-size:8pt;text-align:right;vertical-align:bottom">
                                    <a onMouseOver="javascript:window.status='Minimize'; return true;" href="javascript:rowTwoX();" title="<bean:message key="oscarEncounter.Index.tooltipClose"/>">
                                        <bean:message key="oscarEncounter.Index.x"/></a> |
                                    <a onMouseOver="javascript:window.status='Small Size'; return true;" href="javascript:rowTwoSmall();" title="<bean:message key="oscarEncounter.Index.tooltipSmall"/>">
                                        <bean:message key="oscarEncounter.Index.s"/></a> |
                                    <a onMouseOver="javascript:window.status='Medium Size'; return true;" href="javascript:rowTwoNormal();" title="<bean:message key="oscarEncounter.Index.tooltipNormal"/>">
                                        <bean:message key="oscarEncounter.Index.n"/></a> |
                                    <a onMouseOver="javascript:window.status='Large Size'; return true;" href="javascript:rowTwoLarge();" title="<bean:message key="oscarEncounter.Index.tooltipLarge"/>">
                                        <bean:message key="oscarEncounter.Index.l"/></a> |
                                    <a onMouseOver="javascript:window.status='Full Size'; return true;" href="javascript:rowTwoFull();" title="<bean:message key="oscarEncounter.Index.tooltipFull"/>">
                                        <bean:message key="oscarEncounter.Index.f"/></a> |
                                    <a onMouseOver="javascript:window.status='Full Size'; return true;" href="javascript:reset();" title="<bean:message key="oscarEncounter.Index.tooltipReset"/>">
                                        <bean:message key="oscarEncounter.Index.r"/></a>
                                    </div>
                               </td>
                            </tr>
                            <tr width="100%">
                                <td valign="top" style="border-right:2px solid #ccccff">
                                       <textarea name='ocTextarea' wrap="hard" cols="48" style="height:<%=windowSizes.getProperty("rowTwoSize")%>;overflow:auto"><%=bean.ongoingConcerns%></textarea>
                                </td>
                                <td colspan= "2" valign="top">
                                       <textarea name='reTextarea' wrap="hard" cols="48" style="height:<%=windowSizes.getProperty("rowTwoSize")%>;overflow:auto"><%=bean.reminders%></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
    <!-- prescription row -->
		<tr>
		   <td >
		      <table bgcolor="#ccccff" id="presTopTable" border="0" width="100%">
                        <tr>  <!--hr style="border-bottom: 0pt solid #888888; background-color: #888888;"-->
                            <td valign="top">
                                    <div class="RowTop" ><a href=# onClick="popupOscarRx(700,960,'../oscarRx/showAllergy.do?demographicNo=<%=bean.demographicNo%>');return false;"><bean:message key="global.allergies"/></a>:&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;</div>
                                    <div class="presBox" id="allergyBox">
                                    <ul >
                                    <%      oscar.oscarRx.data.RxPatientData.Patient.Allergy[] allergies
                                            = new oscar.oscarRx.data.RxPatientData().getPatient(Integer.parseInt(demoNo)).getAllergies();

                                            for (int j=0; j<allergies.length; j++){%>
                                        <li>
                                           <a title="<%= allergies[j].getAllergy().getDESCRIPTION() %>" >
                                              <%=allergies[j].getAllergy().getShortDesc(13,8,"...")%>
                                           </a>
                                        </li>
                                    <%}%>
                                    </ul>
                                    </div>

                            </td>
                            <td width="85%" style="font-size: 10px;">
                                    <table width="100%" cellpadding=0 cellspacing=0 border="0">
                                        <tr>
                                            <td width=60><div class="RowTop" >Rx Date</td>
                                            <td>
                                                 <div class="RowTop" ><div class="RowTop" ><a href=# onClick="popupOscarRx(700,960,'../oscarRx/choosePatient.do?providerNo=<%=bean.providerNo%>&demographicNo=<%=bean.demographicNo%>');return false;"><bean:message key="global.prescriptions"/></a></div></div>
                                            </td>
                                            <td align=right>
                                                <div style="font-size:8pt;text-align:right;vertical-align:bottom">
                                                    <a onMouseOver="javascript:window.status='Minimize'; return true;" href="javascript:presBoxX();" title="<bean:message key="oscarEncounter.Index.tooltipClose"/>">
                                                        <bean:message key="oscarEncounter.Index.x"/></a> |
                                                    <a onMouseOver="javascript:window.status='Small Size'; return true;" href="javascript:presBoxSmall();" title="<bean:message key="oscarEncounter.Index.tooltipSmall"/>">
                                                        <bean:message key="oscarEncounter.Index.s"/></a> |
                                                    <a onMouseOver="javascript:window.status='Medium Size'; return true;" href="javascript:presBoxNormal();" title="<bean:message key="oscarEncounter.Index.tooltipNormal"/>">
                                                        <bean:message key="oscarEncounter.Index.n"/></a> |
                                                    <a onMouseOver="javascript:window.status='Large Size'; return true;" href="javascript:presBoxLarge();" title="<bean:message key="oscarEncounter.Index.tooltipLarge"/>">
                                                        <bean:message key="oscarEncounter.Index.l"/></a> |
                                                    <a onMouseOver="javascript:window.status='Full Size'; return true;" href="javascript:presBoxFull();" title="<bean:message key="oscarEncounter.Index.tooltipFull"/>">
                                                        <bean:message key="oscarEncounter.Index.f"/></a> |
                                                    <a onMouseOver="javascript:window.status='Full Size'; return true;" href="javascript:reset();" title="<bean:message key="oscarEncounter.Index.tooltipReset"/>">
                                                        <bean:message key="oscarEncounter.Index.r"/></a>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    <div class="presBox" id="presBox">

                                    <%
                                    oscar.oscarRx.data.RxPrescriptionData prescriptData = new oscar.oscarRx.data.RxPrescriptionData();
                                    oscar.oscarRx.data.RxPrescriptionData.Prescription [] arr = {};
                                    arr = prescriptData.getUniquePrescriptionsByPatient(Integer.parseInt(bean.demographicNo));
                                    if (arr.length > 0){%>
                                        <table>
                                            <%for (int i = 0; i < arr.length; i++){
                                                String rxD = arr[i].getRxDate().toString();
                                                //String rxP = arr[i].getRxDisplay();
                                                String rxP = arr[i].getFullOutLine().replaceAll(";"," ");
                                                rxP = rxP + "   " + arr[i].getEndDate();
                                                String styleColor = "";
                                                if(arr[i].isCurrent() == true){  styleColor="style='color:red;'";  }
                                            %>
                                                <tr>
                                                    <td <%=styleColor%> valign=top style="border-bottom: 1pt solid #888888; font-size:10px;"><%=rxD%></td>
                                                    <td width=600 <%=styleColor%> style="border-bottom: 1pt solid #888888; font-size:10px;"><%=rxP%></td>
                                                </tr>
                                            <%}%>
                                        </table>
                                    <%}else{out.write("&nbsp;");}%>
                                    </div>
                            </td>
			</tr>
                      </table>
		   </td>
		</tr>
    <!-- encounter row -->
                <tr>
                    <td>
                        <table bgcolor="#CCCCFF" width="100%" id="rowThree">
                           <tr>
                                <td nowrap>
                                    <table  border="0" cellpadding="0" cellspacing="0" width='100%' >
									  <tr><td width='75%' >
                                					         <div class="RowTop" >
                                    <a href=# onClick="popupPage2('../report/reportecharthistory.jsp?demographic_no=<%=bean.demographicNo%>');return false;">
                                       <bean:message key="global.encounter"/>: <%=bean.patientLastName %>, <%=bean.patientFirstName%>
                                    </a>
                                
                                    
                                    <%if (sChart) {%>
                                    &nbsp; &nbsp; &nbsp;<!--http://localhost:8084/oscar/oscarEncounter/echarthistoryprint.jsp?echartid=7491&demographic_no=10090-->
                                    <a href="javascript: function myFunction() {return false; }"  onClick="showpic('splitChartLayer','splitChartId');"  id="splitChartId" >
                                       Split Chart
                                    </a>
                                    <%}%>
                                    
                                                                                  <!-- encounter template -->
                                eTemplate
                                <input id="enTemplate" autocomplete="off" size="18" type="text" value=""  onkeypress="return grabEnterGetTemplate(event)"/>
                                <div class="enTemplate_name_auto_complete" id="enTemplate_list" style="display:none"></div>
           
                                <script type="text/javascript">
                                    function dd(){
                                       
                                       ajaxInsertTemplate(document.getElementById('enTemplate').value);   
                                    }    
                                new Autocompleter.Local('enTemplate', 'enTemplate_list', [<%=enTemplates%>], {afterUpdateElement: dd});
                                </script>
                                <!-- end template -->
				
                                    </div>
                                
                                
                                
                                    <input type="hidden" name="enInput"/>
									  </td><td width='5%' >
								<%
										boolean bSplit = request.getParameter("splitchart")!=null?true:false;
										int nEctLen = bean.encounter.length();
									    boolean bTruncate = bSplit &&  nEctLen > 5120?true:false;
										int consumption = (int) ((bTruncate?5120:nEctLen) / (10.24*32));
                    consumption = consumption == 0 ? 1 : consumption;
									    String ccolor = consumption>=70? "red":(consumption>=50?"orange":"green");
								%>
									  <div class="RowTop"><%=consumption+"%"%></div>
									  </td><td align='right'>
                                     <table  border="0" cellpadding="0" cellspacing="0" bgcolor="white" width="100%" %>
									  <tr><td width='<%=consumption+"%"%>' bgcolor='<%=ccolor%>'><div class="RowTop">&nbsp;</div></td>
									  <td><% if (consumption<100) { %><div class="RowTop">&nbsp;</div><% } %></td>
									  </tr>
									 </table>
									</td></tr></table>
                                </td>
                                <td nowrap>
                                    <div style="font-size:8pt;text-align:right;vertical-align:bottom">
                                    <a onMouseOver="javascript:window.status='Minimize'; return true;" href="javascript:rowThreeX();" title="<bean:message key="oscarEncounter.Index.tooltipClose"/>">
                                        <bean:message key="oscarEncounter.Index.x"/></a> |
                                    <a onMouseOver="javascript:window.status='Small Size'; return true;" href="javascript:rowThreeSmall();" title="<bean:message key="oscarEncounter.Index.tooltipSmall"/>">
                                        <bean:message key="oscarEncounter.Index.s"/></a> |
                                    <a onMouseOver="javascript:window.status='Normal Size'; return true;" href="javascript:rowThreeNormal();" title="<bean:message key="oscarEncounter.Index.tooltipNormal"/>">
                                        <bean:message key="oscarEncounter.Index.n"/></a> |
                                    <a onMouseOver="javascript:window.status='Medium Size'; return true;" href="javascript:rowThreeMedium();" title="<bean:message key="oscarEncounter.Index.tooltipMedium"/>">
                                        <bean:message key="oscarEncounter.Index.m"/></a> |
                                    <a onMouseOver="javascript:window.status='Large Size'; return true;" href="javascript:rowThreeLarge();" title="<bean:message key="oscarEncounter.Index.tooltipLarge"/>">
                                        <bean:message key="oscarEncounter.Index.l"/></a> |
                                    <a onMouseOver="javascript:window.status='Full Size'; return true;" href="javascript:rowThreeFull();" title="<bean:message key="oscarEncounter.Index.tooltipFull"/>">
                                        <bean:message key="oscarEncounter.Index.f"/></a> |
                                    <a onMouseOver="javascript:window.status='Full Size'; return true;" href="javascript:reset();" title="<bean:message key="oscarEncounter.Index.tooltipReset"/>">
                                        <bean:message key="oscarEncounter.Index.r"/></a>
                                   </div>
                                </td>
                            </tr>
                            <%
                            //System.out.println("reason "+bean.reason+" subject "+bean.subject);
                            String encounterText = "";
                            try{
                               if(!bSplit){
                                  encounterText = bean.encounter;
                               }else if(bTruncate){
                                  encounterText = bean.encounter.substring(nEctLen-5120)+"\n--------------------------------------------------\n$$SPLIT CHART$$\n";
                               }else{
                                  encounterText = bean.encounter+"\n--------------------------------------------------\n$$SPLIT CHART$$\n";
                               }
                               System.out.println("currDate "+bean.appointmentDate+ " currdate "+bean.currentDate);
                               if(bean.eChartTimeStamp==null){
                                  encounterText +="\n["+dateConvert.DateToString(bean.currentDate)+" .: "+bean.reason+"] \n";
                                  //encounterText +="\n["+bean.appointmentDate+" .: "+bean.reason+"] \n";
                               }else if(bean.currentDate.compareTo(bean.eChartTimeStamp)>0){
                                   //System.out.println("2curr Date "+ oscar.util.UtilDateUtilities.DateToString(oscar.util.UtilDateUtilities.now(),"yyyy",java.util.Locale.CANADA) );
                                  //encounterText +="\n__________________________________________________\n["+dateConvert.DateToString(bean.currentDate)+" .: "+bean.reason+"]\n";
                                   encounterText +="\n__________________________________________________\n["+("".equals(bean.appointmentDate)?UtilDateUtilities.getToday("yyyy-MM-dd"):bean.appointmentDate)+" .: "+bean.reason+"]\n";
                               }else if((bean.currentDate.compareTo(bean.eChartTimeStamp) == 0) && (bean.reason != null || bean.subject != null ) && !bean.reason.equals(bean.subject) ){
                                   //encounterText +="\n__________________________________________________\n["+dateConvert.DateToString(bean.currentDate)+" .: "+bean.reason+"]\n";
                                   encounterText +="\n__________________________________________________\n["+bean.appointmentDate+" .: "+bean.reason+"]\n";
                               }
                               //System.out.println("eChartTimeStamp" + bean.eChartTimeStamp+"  bean.currentDate " + dateConvert.DateToString(bean.currentDate));//" diff "+bean.currentDate.compareTo(bean.eChartTimeStamp));
                               if(!bean.oscarMsg.equals("")){
                                  encounterText +="\n\n"+bean.oscarMsg;
                               }

                            }catch(Exception eee){eee.printStackTrace();}
                            %>
                            <tr>
                                <td colspan="2" valign="top" style="text-align:left">
                                    <textarea name='enTextarea' wrap="hard" cols="99" style="height:<%=windowSizes.getProperty("rowThreeSize")%>;overflow:auto"><%=encounterText%></textarea>
                                </td>
                            </tr>
                        </table>
						<table border=0  bgcolor="#CCCCFF" width=100% >
                            <tr nowrap>
							    <td>
                                    <input type="hidden" name="subject" value="<%=UtilMisc.htmlEscape(bean.reason)%>">
									<% if (consumption>=50) {%>
                                    <input type="submit" style="height:20px"  name="buttonPressed" value="Split Chart" class="ControlPushButton2"  onClick="return (onSplit());">
									<% } %>
								</td>
                                <td style="text-align:right" nowrap>
                                
                               
                                
                                
                                
                                <oscar:oscarPropertiesCheck property="CPP" value="yes">
                                <input type="button" style="height:20px;" class="ControlPushButton2" value="CPP" onClick="document.forms['encForm'].btnPressed.value='Save'; document.forms['encForm'].submit();javascript:popupPageK('encounterCPP.jsp');"/>
                                </oscar:oscarPropertiesCheck>
				    <input type="button" style="height:20px;" class="ControlPushButton2" value="<bean:message key="global.btnPrint"/>" onClick="document.forms['encForm'].btnPressed.value='Save'; document.forms['encForm'].submit();javascript:popupPageK('encounterPrint.jsp');"/>
				    <input type="hidden"  name="btnPressed" value="">

<!-- security code block -->
	<security:oscarSec roleName="<%=roleName$%>" objectName="_eChart" rights="w">
					<% if(!bPrincipalControl || (bPrincipalControl && bPrincipalDisplay) ) { %>
				    <input type="button" style="height:20px" value="<bean:message key="oscarEncounter.Index.btnSave"/>" class="ControlPushButton2" onclick="document.forms['encForm'].btnPressed.value='Save'; document.forms['encForm'].submit();">
                                    <input type="button" style="height:20px" value="<bean:message key="oscarEncounter.Index.btnSignSave"/>" class="ControlPushButton2" onclick="document.forms['encForm'].btnPressed.value='Sign,Save and Exit'; document.forms['encForm'].submit();">
                                    <oscar:oscarPropertiesCheck property="billregion" value="yes">
                                    <input type="button" style="height:20px" value="<bean:message key="oscarEncounter.Index.btnSignSaveBill"/>" class="ControlPushButton2" onclick="document.forms['encForm'].btnPressed.value='Sign,Save and Bill'; document.forms['encForm'].submit();">
                                    </oscar:oscarPropertiesCheck>					
	<security:oscarSec roleName="<%=roleName$%>" objectName="_eChart.verifyButton" rights="w">
                                    <input type="button" style="height:20px" value="<bean:message key="oscarEncounter.Index.btnSign"/>" class="ControlPushButton2" onclick="document.forms['encForm'].btnPressed.value='Verify and Sign'; document.forms['encForm'].submit();">
	</security:oscarSec>
					<% } %>
	</security:oscarSec>
<!-- security code block -->
                                    <input type="button" style="height:20px" name="buttonPressed" value="<bean:message key="global.btnExit"/>" class="ControlPushButton2" onclick="document.forms['encForm'].btnPressed.value='Exit'; if (closeEncounterWindow()) {document.forms['encForm'].submit();}">
                                    <!--input type="button" style="height:20px" onclick="javascript:goToSearch()" name="btnPressed" value="Search New Patient" class="ControlPushButton"-->
                                    <input type="hidden" name="rowOneSize" value="<%=windowSizes.getProperty("rowOneSize")%>">
                                    <input type="hidden" name="rowTwoSize" value="<%=windowSizes.getProperty("rowTwoSize")%>">
                                    <input type="hidden" name="presBoxSize" value="<%=windowSizes.getProperty("presBoxSize")%>">
                                    <input type="hidden" name="rowThreeSize" value="<%=windowSizes.getProperty("rowThreeSize")%>">
                                </td>
                            </tr>
                        </table>
                        <%
                            if(bSplit){%>
                            <script>
                                document.forms['encForm'].btnPressed.value='Save';
                                document.forms['encForm'].submit();
                            </script>
                            <%}
                        %>
                    </td>
                </tr>
<!-- end new rows here -->
            </table>
        </td>
    </tr>
    <tr>
        <td class="MainTableBottomRowLeftColumn">
        &nbsp;
        </td>
        <td class="MainTableBottomRowRightColumn" valign="top">
        &nbsp;
        </td>
    </tr>
</table>
</form>

<%if (sChart){ %>
<div id="splitChartLayer" style="position:absolute; left:1px; top:1px; width:150px; height:311px; visibility: hidden; z-index:1"   >

   <table width="98%" border="1" cellspacing="1" cellpadding="1" align=center bgcolor="#CCCCFF">
      <tr class="LightBG">
         <td class="wcblayerTitle">Date</td>
         <td class="wcblayerTitle" align="right">
            <a href="javascript: function myFunction() {return false; }" onClick="hidepic('splitChartLayer');" style="text-decoration: none;">X</a>
         </td>
      </tr>
      <% for (int i = 0 ; i < splitChart.size(); i++){
            String[] s = (String[]) splitChart.get(i);%>
      <tr class="background-color : #ccccff;">
         <td class="wcblayerTitle">
            <a href=# onClick="hidepic('splitChartLayer');popupPage2('echarthistoryprint.jsp?echartid=<%=s[0]%>&demographic_no=<%=bean.demographicNo%>');return false;">
               <%=s[1]%>
            </a>
         </td>
	      <td class="wcblayerItem" >&nbsp;
            
	      </td>
      </tr>
      <%}%>
   </table>
</div>
<%}System.out.println("Session:" + session.getAttribute("user"));%>

<SCRIPT LANGUAGE="JavaScript">
	cmDraw ('newMen', myMenu, 'vbr', cmThemeOffice, 'ThemeOffice');
</SCRIPT>

</body>
</html:html>

