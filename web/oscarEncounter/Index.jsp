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
<!-- Mar 8, 2003,-->
<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/rewrite-tag.tld" prefix="rewrite" %>

<%@page import="oscar.util.UtilMisc,oscar.oscarEncounter.data.*,java.net.*,java.util.Properties"%>
<%@page import="oscar.oscarMDS.data.MDSResultsData"%>
<jsp:useBean id="oscarVariables" class="java.util.Properties" scope="session" />
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
  java.util.Locale vLocale =(java.util.Locale)session.getAttribute(org.apache.struts.action.Action.LOCALE_KEY);
  MDSResultsData labResults =  new MDSResultsData();    
  labResults.populateMDSResultsData("", demoNo, "", "", "", "U");
  String province = ((String ) oscarVariables.getProperty("billregion","")).trim().toUpperCase();
  Properties windowSizes = oscar.oscarEncounter.pageUtil.EctWindowSizes.getWindowSizes(provNo);
%>

<html:html locale="true">
<head>
<title><bean:message key="oscarEncounter.Index.title"/></title>
<html:base/>

<style type="text/css">
	div.presBox {
		height: <%=windowSizes.getProperty("presBoxSize")%>;
		overflow: auto;
	}
</style>
<!-- This is from OscarMessenger to get the top and left borders on -->
<link rel="stylesheet" type="text/css" href="encounterStyles.css">
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
          document.measurementGroupForm.measurementGroupSelect.options[0].selected = true;
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
                  document.insertTemplateForm.templateSelect.options[0].selected=true;
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
    document.encForm.presBoxSize.value=X; 
}
function presBoxSmall(){   
    document.getElementById("presBox").style.height=pBSmall;
    document.encForm.presBoxSize.value=pBSmall;
}
function presBoxNormal(){
    document.getElementById("presBox").style.height=normal;
    document.encForm.presBoxSize.value=normal;
}
function presBoxLarge(){
    document.getElementById("presBox").style.height=large;
    document.encForm.presBoxSize.value=large;
}
function presBoxFull(){
    document.getElementById("presBox").style.height=full;
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
  //document.ksearch.term.value = text;
 if(document.all) {
    text = document.selection.createRange().text;
    if(text != "" && document.ksearch.term.value=="") {
      document.ksearch.term.value += text;
    }
    if(text != "" && document.ksearch.term.value!="") {
      document.ksearch.term.value = text;
    }
  } else {
    text = window.getSelection();
    document.ksearch.term.value = text;
  }
  return true;
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
    tmp = document.encForm.enTextarea.value; // these two lines cause the enTextarea to scroll to the bottom (only works in IE)
    document.encForm.enTextarea.value = tmp; // another option is to use window.setTimeout("document.encForm.enTextarea.scrollTop=2147483647", 0);  (also only works in IE)
}
</script>
<script language="javascript">

function showpic(picture){
        //if (document.getElementById){ // Netscape 6 and IE 5+
        //        var targetElement = document.getElementById(picture);
        //targetElement.style.visibility = 'visible';
    //}
var aew = document.ids.Layer1.visibility;
}

function hidepic(picture){
        if (document.getElementById){ // Netscape 6 and IE 5+
                var targetElement = document.getElementById(picture);
        targetElement.style.visibility = 'hidden';
        }
}
function popperup(vheight,vwidth,varpage,pageName) { //open a new popup window
  hidepic('Layer1');
  var page = varpage;
  windowprops = "height="+vheight+",width="+vwidth+",status=yes,location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=100,left=100";
  var popup=window.open(varpage, pageName, windowprops);
      popup.opener = self;
  popup.focus();
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

</head>

<body  onload="javascript:loader();"  topmargin="0" leftmargin="0" bottommargin="0" rightmargin="0" vlink="#0000FF">
<html:errors/>

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse;width:100%;height:680" bordercolor="#111111" id="scrollNumber1" name="<bean:message key="oscarEncounter.Index.encounterTable"/>">
    <tr>
        <td class="hidePrint" bgcolor="#003399" style="border-right: 2px solid #A9A9A9;height:34px;" >
            <div class="Title">
			&nbsp;<bean:message key="oscarEncounter.Index.msgEncounter"/>
            </div>
        </td>

        <td  bgcolor="#003399" style="text-align:right;height:34px;padding-left:3px;" >
                <table name="tileTable" style="veritcal-align:middle;border-collapse:collapse;" >
                    <form name="appointmentListForm" action="./oscarEncounter.Index/IncomingEncounter.do">
                    <tr>
                        <td width=70% class="Header" style="padding-left:2px;padding-right:2px;border-right:2px solid #003399;text-align:left;font-size:80%;font-weight:bold;width:100%;" NOWRAP >
                            <%=bean.patientLastName %>, <%=bean.patientFirstName%> <%=bean.patientSex%> <%=bean.patientAge%>
                        </td>                        
                        <td class="Header" style="text-align:center;border-right: 3px solid #003399" NOWRAP>
                        <!--div class="FakeLink">
                        </div-->
                                <a href="javascript:popupStart(300,400,'Help.jsp')"><bean:message key="global.help"/></a> | <a href="javascript:popupStart(300,400,'About.jsp')"><bean:message key="global.about"/></a> 
                        </td>
                    </tr>
                    </form>
                </table>

            </td>
    </tr>
    <tr style="height:100%">
        <td style="font-size:80%;border-top:2px solid #A9A9A9;border-right:2px solid #A9A9A9;vertical-align:top">
            <table class="LeftTable">
                <tr class="Header">
                    <td style="font-weight:bold">
                        <bean:message key="oscarEncounter.Index.clinicalModules"/>
                    </td>
                </tr>
                <tr>
                    <td>
 	            <%if (vLocale.getCountry().equals("BR")) {%>
                        <a href=# onClick="popupPage2('../demographic/demographiccontrol.jsp?demographic_no=<%=bean.demographicNo%>&displaymode=edit&dboperation=search_detail_ptbr');return false;" 
                        title="<bean:message key="provider.appointmentProviderAdminDay.msgMasterFile"/>"><bean:message key="global.master"/></a>
		    <%}else{%>
	                <a href=# onClick="popupPage2('../demographic/demographiccontrol.jsp?demographic_no=<%=bean.demographicNo%>&displaymode=edit&dboperation=search_detail');return false;" 
                        title="<bean:message key="provider.appointmentProviderAdminDay.msgMasterFile"/>"><bean:message key="global.master"/></a>
    		    <%}%><br>
             <% 
                if (vLocale.getCountry().equals("BR")) { %>  
               <a href=# onClick='popupPage(700,1000, "../oscar/billing/procedimentoRealizado/init.do?appId=<%=bean.appointmentNo%>");return false;' title="<bean:message key="global.billing"/>"><bean:message key="global.billing"/></a>
             <% } else {%>  
                   <% if(bean.status.indexOf('B')==-1) { %>
                        <!--a href=# onClick='popupPage(700,1000, "../billing/billingOB.jsp?billForm=<%=URLEncoder.encode("MFP")%>&hotclick=<%=URLEncoder.encode("")%>&appointment_no=<%=bean.appointmentNo%>&demographic_name=<%=URLEncoder.encode(bean.patientLastName+","+bean.patientFirstName)%>&demographic_no=<%=bean.demographicNo%>&providerview=<%=bean.curProviderNo%>&user_no=<%=bean.providerNo%>&apptProvider_no=<%=bean.curProviderNo%>&appointment_date=<%=bean.appointmentDate%>&start_time=<%=bean.startTime%>&bNewForm=1");return false;' title="<bean:message key="global.billing"/>"><bean:message key="global.billing"/></a-->
						<a href=# onClick='popupPage(700,1000, "../billing.do?billRegion=<%=URLEncoder.encode(province)%>&billForm=<%=URLEncoder.encode(oscarVariables.getProperty("default_view"))%>&hotclick=<%=URLEncoder.encode("")%>&appointment_no=<%=bean.appointmentNo%>&demographic_name=<%=URLEncoder.encode(bean.patientLastName+","+bean.patientFirstName)%>&demographic_no=<%=bean.demographicNo%>&providerview=<%=bean.curProviderNo%>&user_no=<%=bean.providerNo%>&apptProvider_no=<%=bean.curProviderNo%>&appointment_date=<%=bean.appointmentDate%>&start_time=<%=bean.startTime%>&bNewForm=1&status=t");return false;' title="<bean:message key="global.billing"/>"><bean:message key="global.billing"/></a>
                   <% } else {%>
                        <!--a href=# onClick='onUnbilled("../billing/billingDeleteWithoutNo.jsp?appointment_no=<%=bean.appointmentNo%>");return false;' title="<bean:message key="global.unbil"/>">-<bean:message key="global.billing"/></a-->
						<a href=# onClick='onUnbilled("../billing/CA/<%=province%>/billingDeleteWithoutNo.jsp?appointment_no=<%=bean.appointmentNo%>");return false;' title="<bean:message key="global.unbil"/>">-<bean:message key="global.billing"/></a>
                   <% } %>				
             <% } %>  
                <br>
                        <%  if (!vLocale.getCountry().equals("BR")) { %>
                            <a href=# onClick="popupOscarRx(700,960,'../oscarRx/choosePatient.do?providerNo=<%=bean.providerNo%>&demographicNo=<%=bean.demographicNo%>');return false;"><bean:message key="global.prescriptions"/></a><br>                        
                        <% } %>
                        <a href=# onClick="popupOscarCon(700,960,'<rewrite:reWrite jspPage="oscarConsultationRequest/DisplayDemographicConsultationRequests.jsp"/>?de=<%=bean.demographicNo%>');return false;"><bean:message key="global.consultations"/></a><br>
                        <% if (oscar.oscarEncounter.immunization.data.EctImmImmunizationData.hasImmunizations(demoNo)) { %>
                            <a style="color:red" href="javascript:popUpImmunizations(700,960,'<rewrite:reWrite jspPage="immunization/initSchedule.do"/>')"><bean:message key="global.immunizations"/></a><br>
                        <% } else {%>
                            <a href="javascript:popUpImmunizations(700,960,'<rewrite:reWrite jspPage="immunization/initSchedule.do"/>')"><bean:message key="global.immunizations"/></a><br>
                        <% } %>
                        <%  if (oscar.OscarProperties.getInstance().getProperty("oscarcomm","").equals("on")) { %>
                        	<a href="javascript:popupOscarComm(700,960,'RemoteAttachments.jsp')"><bean:message key="global.oscarComm"/></a><br> 
                        <% } else {%>
                        	<a href="javascript:popupOscarComm(700,960,'../packageNA.jsp?pkg=oscarComm')"><bean:message key="global.oscarComm"/></a><br>
                        <% } %>
                        <a href=# onClick="popupOscarComm(580,900,'../oscarResearch/oscarDxResearch/setupDxResearch.do?demographicNo=<%=bean.demographicNo%>&providerNo=<%=provNo%>&quickList=');return false;"><bean:message key="global.disease"/></a><br>
                  <a href=# onClick="popupOscarCon(580,800,'../appointment/appointmentcontrol.jsp?keyword=<%=URLEncoder.encode(bean.patientLastName+","+bean.patientFirstName)%>&displaymode=<%=URLEncoder.encode("Search ")%>&search_mode=search_name&originalpage=<%=URLEncoder.encode("../tickler/ticklerAdd.jsp")%>&orderby=last_name&appointment_date=2000-01-01&limit1=0&limit2=5&status=t&start_time=10:45&end_time=10:59&duration=15&dboperation=add_apptrecord&type=&demographic_no=<%=bean.demographicNo%>');return false;"><bean:message key="oscarEncounter.Index.addTickler"/></a><br>                
                 </td>
                </tr>
                <!-- <tr><td>&nbsp;</td></tr> -->
            </table>

            <table class="LeftTable">
            <form name="leftColumnForm">
                <tr class="Header">
                    <td style="font-weight:bold">
                        <bean:message key="oscarEncounter.Index.msgForms"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <select name="selectCurrentForms" onChange="javascript:selectBox(this)" class="ControlSelect" onMouseOver="javascript:window.status='View any of <%=patientName%>\'s current forms.'; return true;">
                            <option value="null" selected>-<bean:message key="oscarEncounter.Index.currentForms"/>-
                            <%
                            for(int j=0; j<forms.length; j++) {
                                EctFormData.Form frm = forms[j];
                                String table = frm.getFormTable();
                                EctFormData.PatientForm[] pforms = new EctFormData().getPatientForms(demoNo, table);
                                if(pforms.length>0) {
                                    EctFormData.PatientForm pfrm = pforms[0];
                            %>
                            <option value="<%="../form/forwardshortcutname.jsp?formname="+frm.getFormName()+"&demographic_no="+demoNo%>"><%=frm.getFormName()%>&nbsp;Cr:<%=pfrm.getCreated()%>&nbsp;Ed:<%=pfrm.getEdited()%>
                            <%}}

                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <select name="selectForm" onChange="javascript:selectBox(this)" class="ControlSelect" onMouseOver="javascript:window.status='<bean:message key="oscarEncounter.Index.createForm"/> <%=patientName%>.'; return true;">
                        <option value="null" selected>-<bean:message key="oscarEncounter.Index.addForm"/>-
                        <%
                        //EctFormData.Form[] forms = new EctFormData().getForms();
                        for(int j=0; j<forms.length; j++) {
                            EctFormData.Form frm = forms[j];
                            if (!frm.isHidden()) {
                        %>
                        <option value="<%=frm.getFormPage()+demoNo+"&formId=0&provNo="+provNo%>"><%=frm.getFormName()%>
                        <%

                            }
                        }

                        %>
                        
                        </select>

                    </td>
                </tr>
                <tr>
                    <td><a href=# onClick='popupPage2("<rewrite:reWrite jspPage="formlist.jsp"/>?demographic_no=<%=demoNo%>"); return false;' >
					-<bean:message key="oscarEncounter.Index.msgOldForms"/>-</a>
                    </td>
                </tr>

                <!-- <tr><td>&nbsp;</td></tr> -->
            </form>
            </table>


            <table class="LeftTable">
            <form name="insertTemplateForm">
                <tr class="Header">
                    <td style="font-weight:bold">
                        <bean:message key="oscarEncounter.Index.encounterTemplate"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <select name="templateSelect" class="ControlSelect" onchange="javascript:popUpInsertTemplate(40,50,document.insertTemplateForm.templateSelect.options[document.insertTemplateForm.templateSelect.selectedIndex].value)">
                        <option value="null" selected>-<bean:message key="oscarEncounter.Index.insertTemplate"/>-
                         <%
                            String encounterTmp ="NONE";
                            String encounterTmpValue="NONE";
                            for(int j=0; j<bean.templateNames.size(); j++) {
                                encounterTmp = (String)bean.templateNames.get(j);                                
                         %>
                                <option value="<%=encounterTmp%>"><%=encounterTmp %></option>
                         <% }%>
                        </select>
                    </td>
                </tr>
                <!-- <tr><td>&nbsp;</td></tr> -->
            </form>
            </table>
            <table class="LeftTable">           
                <tr class="Header">
                    <td style="font-weight:bold" colspan="2"><bean:message key="oscarEncounter.Index.measurements"/></td>
                </tr>
                <tr>
                    <td>
                        <form name="measurementGroupForm">
                        <select name="measurementGroupSelect" class="ControlSelect" onchange="popUpMeasurements(500,1000,document.measurementGroupForm.measurementGroupSelect.options[document.measurementGroupForm.measurementGroupSelect.selectedIndex].value);return false;">
                        <option value="null" selected>-<bean:message key="oscarEncounter.Index.SelectGroup"/>-
                         <%                            
                            for(int j=0; j<bean.measurementGroupNames.size(); j++) {
                            String tmp = (String)bean.measurementGroupNames.get(j);
                         %>
                         <option value="<%=tmp%>"><%=tmp %>
                         <%}%>
                        </select>
                        
                    </td>
                </tr>                
                <tr>                    
                    <td><a href=# onClick="popupPage(600,1000,'<rewrite:reWrite jspPage="oscarMeasurements/SetupDisplayHistory.do"/>'); return false;" ><bean:message key="oscarEncounter.Index.oldMeasurements"/></a>
                    </td>                                    
                </tr> 
                </form>
            </table>
            <table class="LeftTable">
                <tr class="Header">
                    <td style="font-weight:bold">
                            <bean:message key="oscarEncounter.Index.clinicalResources"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="#" ONCLICK ="popupPage2('http://67.69.12.117:8080/oscarResource/');return false;" title="<bean:message key="oscarEncounter.Index.resource"/>" onmouseover="window.status='<bean:message key="oscarEncounter.Index.viewResource"/>';return true"><bean:message key="oscarEncounter.Index.resource"/></a><br>
                        <a href="#" onClick="popupPage(500,600,'../dms/documentReport.jsp?function=demographic&doctype=lab&functionid=<%=bean.demographicNo%>&curUser=<%=bean.curProviderNo%>');return false;"><bean:message key="oscarEncounter.Index.msgDocuments"/></a><br>
                        <a href="#" onClick="popupPage(500,950, '../eform/showmyform.jsp?demographic_no=<%=bean.demographicNo%>');return false;"><bean:message key="global.eForms"/></a><br>
                 	<a href="#" onClick="popupPage(700,1000, '../tickler/ticklerDemoMain.jsp?demoview=<%=bean.demographicNo%>');return false;"><bean:message key="global.viewTickler"/></a><br>
                        <a href="javascript: function myFunction() {return false; }"  onClick="popupPage(150,200,'calculators.jsp?sex=<%=bean.patientSex%>&age=<%=pAge%>'); return false;" ><bean:message key="oscarEncounter.Index.calculators"/></a><br>
                        <select name="selectCurrentForms" onChange="javascript:selectBox(this)" class="ControlSelect" onMouseOver="javascript:window.status='View <%=patientName%>\'s lab results'; return true;">
                            <option value="null" selected>-lab results-</option>
                            <% for(int j=0; j<labResults.segmentID.size(); j++) { %>                                
                                <option value="../oscarMDS/SegmentDisplay.jsp?providerNo=<%=bean.curProviderNo%>&segmentID=<%=(String)labResults.segmentID.get(j)%>&status=<%=(String)labResults.reportStatus.get(j)%>"><%=((String)labResults.dateTime.get(j)).substring(0,10)%> <%=(String)labResults.discipline.get(j)%></option>
                            <% } %>
                        </select>
                 </td>
                </tr>
                <!-- <tr><td>&nbsp;</td></tr> -->
            </table>
            <table class="LeftTable">
                <form name="ksearch" >
                    <tr class="Header">
                        <td style="font-weight:bold">
                            <bean:message key="oscarEncounter.Index.internetResources"/>
                        </td>
                    </tr>                                                       
                    <tr>
                        <td><bean:message key="oscarEncounter.Index.searchFor"/></td>
                    </tr>
                    <tr>
                        <td><input type="text" name="keyword" class="ControlSelect" value=""/></td>                        
                    </tr>
                    <tr>
                        <td><bean:message key="oscarEncounter.Index.using"/></td>
                    </tr>
                    <tr>
                        <td>
                                <select class="ControlSelect" name="channel" >
                                    <option value="http://67.69.12.117:8080/oscarResource/OSCAR_search/OSCAR_search_results?title="><bean:message key="oscarEncounter.Index.oscarSearch"/></option>                                                                                
                                    <option value="http://www.google.com/search?q="><bean:message key="global.google"/></option>
                                    <option value="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?SUBMIT=y&CDM=Search&DB=PubMed&term="><bean:message key="global.pubmed"/></option>
                                    <option value="http://search.nlm.nih.gov/medlineplus/query?DISAMBIGUATION=true&FUNCTION=search&SERVER2=server2&SERVER1=server1&PARAMETER="><bean:message key="global.medlineplus"/></option>
                                    <option value="http://www.bnf.org/bnf/bnf/current/noframes/search.htm?n=50&searchButton=Search&q="><bean:message key="global.BNF"/></option>
                                </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" name="button" class="ControlPushButton" value="<bean:message key="oscarEncounter.Index.btnGo"/>" onClick="popupSearchPage(600,800,forms['ksearch'].channel.options[forms['ksearch'].channel.selectedIndex].value+urlencode(forms['ksearch'].keyword.value) ); return false;">                        
                        </td>
                    </tr>                   
                </form>                               
            </table>
        </td>        
        <td valign="top">        
        <form name="encForm" action="SaveEncounter.do" method="POST">             
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
                                    <div class="RowTop" ><bean:message key="oscarEncounter.Index.otherMed"/>:</div>
                                </td>
                                <td>
                                    <div class="RowTop" ><bean:message key="oscarEncounter.Index.medHist"/>:</div>
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
                                <!----This is the Social History cell ...sh...-->
                                <td  valign="top">
                                    <!-- Creating the table tag within the script allows you to adjust all table sizes at once, by changing the value of leftCol -->
                                       <textarea name='shTextarea' wrap="hard"  cols= "31" style="height:<%=windowSizes.getProperty("rowOneSize")%>;overflow:auto"><%=bean.socialHistory%></textarea>
                                </td>
                                <!----This is the Family History cell ...fh...-->
                                <td  valign="top">
                                       <textarea name='fhTextarea' wrap="hard"  cols= "31" style="height:<%=windowSizes.getProperty("rowOneSize")%>;overflow:auto"><%=bean.familyHistory%></textarea>
                                </td>
                                <!----This is the Medical History cell ...mh...-->
                                <td  valign="top" colspan="2">
                                       <textarea name='mhTextarea' wrap="hard"  cols= "31" style="height:<%=windowSizes.getProperty("rowOneSize")%>;overflow:auto"><%=bean.medicalHistory%></textarea>
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
                                <td>
                                    <div class="RowTop" ><bean:message key="oscarEncounter.Index.msgConcerns"/>:</div><input type="hidden" name="ocInput"/>
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
		      <table bgcolor="#ccccff" id="presTopTable">
                        <tr>
                            <td valign="top">
                                    <div class="RowTop" >Drug Info:</div>
                            </td>
                            <td width="100%" style="font-size: 10px;">
                                    <table width="100%" cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td width=75><div class="RowTop" >Rx Date</td>
                                            <td>
                                                 <div class="RowTop" >Prescription</div>
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
                                                String rxP = arr[i].getRxDisplay();
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
                                    <a href=# onClick="popupPage2('../report/reportecharthistory.jsp?demographic_no=<%=bean.demographicNo%>');return false;"><div class="RowTop" ><bean:message key="global.encounter"/>: <%=bean.reason%></div></a><input type="hidden" name="enInput"/>
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
                            <tr>
                                <td colspan="2" valign="top" style="text-align:left">
                                    <textarea name='enTextarea' wrap="hard" cols="99" style="height:<%=windowSizes.getProperty("rowThreeSize")%>;overflow:auto"><% if(!bSplit) out.print(bean.encounter); else if(bTruncate) out.print(bean.encounter.substring(nEctLen-5120)+"\n--------------------------------------------------\n$$SPLIT CHART$$\n"); else out.print(bean.encounter+"\n--------------------------------------------------\n$$SPLIT CHART$$\n");%><%if(bean.eChartTimeStamp==null){%><%="\n["+dateConvert.DateToString(bean.currentDate)+" .: "+bean.reason+"]\n"%><%}
                                    // border-right:6px solid #ccccff;border-right:6px solid #ccccff;
                                        else if(bean.currentDate.compareTo(bean.eChartTimeStamp)>0)
                                        {%><%="\n__________________________________________________\n["+dateConvert.DateToString(bean.currentDate)+" .: "+bean.reason+"]\n"%><%}
                                        if(!bean.oscarMsg.equals("")){%><%="\n\n"+bean.oscarMsg%><%}%></textarea>
                                </td>
                            </tr>
                        </table>
						<table border=0  bgcolor="#CCCCFF" width=100% >
                            <tr nowrap>
							    <td>
                                    <input type="hidden" name="subject" value="<%=UtilMisc.htmlEscape(bean.reason)%>">
									<% if (consumption>=50) {%>
                                    <input type="submit" style="height:20px"  name="buttonPressed" value="Split Chart" class="ControlPushButton"  onClick="return (onSplit());">
									<% } %>
								</td>
                                <td style="text-align:right" nowrap>
				    <input type="button" style="height:20px;" class="ControlPushButton" value="<bean:message key="global.btnPrint"/>" onClick="document.forms['encForm'].btnPressed.value='Save'; document.forms['encForm'].submit();javascript:popupPageK('encounterPrint.jsp');"/>
				    <input type="hidden"  name="btnPressed" value="">

				    <input type="button" style="height:20px" value="<bean:message key="oscarEncounter.Index.btnSave"/>" class="ControlPushButton" onclick="document.forms['encForm'].btnPressed.value='Save'; document.forms['encForm'].submit();">
                                    <input type="button" style="height:20px" value="<bean:message key="oscarEncounter.Index.btnSignSave"/>" class="ControlPushButton" onclick="document.forms['encForm'].btnPressed.value='Sign,Save and Exit'; document.forms['encForm'].submit();">
                                    <input type="button" style="height:20px" value="<bean:message key="oscarEncounter.Index.btnSign"/>" class="ControlPushButton" onclick="document.forms['encForm'].btnPressed.value='Verify and Sign'; document.forms['encForm'].submit();">
                                    <input type="button" style="height:20px" name="buttonPressed" value="<bean:message key="global.btnExit"/>" class="ControlPushButton" onclick="document.forms['encForm'].btnPressed.value='Exit'; if (closeEncounterWindow()) {document.forms['encForm'].submit();}">
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
</table>
</form>

</body>
</html:html>

