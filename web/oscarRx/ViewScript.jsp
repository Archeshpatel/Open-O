<%@ page language="java" %>
<%@ page import="oscar.oscarProvider.data.*, oscar.OscarProperties, oscar.oscarClinic.ClinicData, java.util.*" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<% response.setHeader("Cache-Control","no-cache");%>

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
<title><bean:message key="ViewScript.title"/></title>

<html:base/>
<logic:notPresent name="RxSessionBean" scope="session">
    <logic:redirect href="error.html" />
</logic:notPresent>
<logic:present name="RxSessionBean" scope="session">
    <bean:define id="bean" type="oscar.oscarRx.pageUtil.RxSessionBean" name="RxSessionBean" scope="session" />
    <logic:equal name="bean" property="valid" value="false">
        <logic:redirect href="error.html" />
    </logic:equal>
</logic:present>
<%
oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean)pageContext.findAttribute("bean");

// for satellite clinics
Vector vecAddressName = null;
Vector vecAddress = null;
Vector vecAddressPhone = null;
Vector vecAddressFax = null;
OscarProperties props = OscarProperties.getInstance();
if(props.getProperty("clinicSatelliteName") != null) {
    oscar.oscarRx.data.RxProviderData.Provider provider = new oscar.oscarRx.data.RxProviderData().getProvider(bean.getProviderNo());
    ProSignatureData sig = new ProSignatureData();
    boolean hasSig = sig.hasSignature(bean.getProviderNo());
    String doctorName = "";
    if (hasSig){
       doctorName = sig.getSignature(bean.getProviderNo());
    }else{
       doctorName = (provider.getFirstName() + ' ' + provider.getSurname());
    }
    doctorName = doctorName.replaceAll("\\d{6}","");
    doctorName = doctorName.replaceAll("\\-","");
    ClinicData clinic = new ClinicData();
    vecAddressName = new Vector();
    vecAddress = new Vector();
    vecAddressPhone = new Vector();
    vecAddressFax = new Vector();
    String[] temp0 = props.getProperty("clinicSatelliteName", "").split("\\|");
    String[] temp1 = props.getProperty("clinicSatelliteAddress", "").split("\\|");
    String[] temp2 = props.getProperty("clinicSatelliteCity", "").split("\\|");
    String[] temp3 = props.getProperty("clinicSatelliteProvince", "").split("\\|");
    String[] temp4 = props.getProperty("clinicSatellitePostal", "").split("\\|");
    String[] temp5 = props.getProperty("clinicSatellitePhone", "").split("\\|");
    String[] temp6 = props.getProperty("clinicSatelliteFax", "").split("\\|");
    for(int i=0; i<temp0.length; i++) {
        vecAddressName.add(temp0[i]);
        vecAddress.add("<b>"+doctorName+"</b><br>"+provider.getClinicName().replaceAll("\\(\\d{6}\\)","")+"<br>"+temp1[i] + "<br>" + temp2[i] + ", " + temp3[i] + " " + temp4[i] + "<br>Tel: " + temp5[i] + "<br>Fax: " + temp6[i]);
    }
}
%>
<link rel="stylesheet" type="text/css" href="styles.css" />
<style type="text/css">
@media print{
span { display:none; }
td.leftGreyLine { border-left: 0px; }    
td.leftBottomGreyLine { border-bottom:0px solid #ffffff; border-top:0px solid #ffffff; }
}
@media screen{
td.leftGreyLine { border-left: 2px solid #A9A9A9; padding-left: 5; }
td.leftBottomGreyLine { border-bottom:2px solid #A9A9A9; border-top:2px solid #A9A9A9; }
}
</style>

<script type="text/javascript">

function printIframe(){
   preview.focus();
   preview.print();
}

function printPaste2Parent(){
	confirm("\"Paste\" function is only enable if EMR is opened.");
	text = "**<%=oscar.oscarProvider.data.ProviderData.getProviderName(bean.getProviderNo())%>********************************************************************************";
	text = text.substring(0, 82) + "\n";
	if (document.all){
		text += preview.document.forms[0].rx.value.substring(0, (preview.document.forms[0].rx.value.length-2));
	} else {
		text += preview.document.forms[0].rx.value + "\n";;
	}
	text += "**********************************************************************************\n";
    opener.document.encForm.enTextarea.value = opener.document.encForm.enTextarea.value + text;
    printIframe();
}

function addressSelect() {
	<% if(vecAddressName != null) {
	    for(int i=0; i<vecAddressName.size(); i++) {%>
	if(document.getElementById("addressSel").value=="<%=i%>") {
    	frames['preview'].document.getElementById("clinicAddress").innerHTML="<%=vecAddress.get(i)%>";
    } 
<% } }%>
}

</script>
</head>

<body topmargin="0" leftmargin="0" vlink="#0000FF">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1" height="100%">
    <tr>
      <td width="100%" style="padding-left: 3; padding-right: 3; padding-top: 2; padding-bottom: 2" height="0%" colspan="2">
        <p class="HelpAboutLogout"><span class="FakeLink"><a href="Help.htm">Help</a></span> <span> | </span>
        <span class="FakeLink"><a href="About.htm">About</a></span><span> | </span><span class="FakeLink">
        <a href="Disclaimer.htm">Disclaimer</a></span></p>
      </td>
    </tr>

    <tr>
      <td width="10%" height="37" bgcolor="#000000">&nbsp;</td>
      <td width="100%" bgcolor="#000000" class="leftGreyLine" height="0%">
        <table>
        <tr>
        <td>
            <span class="ScreenTitle">
                oscarRx
            </span>
        </td>
        <td width=10px>
        </td>
        <td>
            <span style="color:#FFFFFF">
                <b>
                To print, right click on prescription<br>
                and select "print" from the menu.
                </b>
            </span>
        </td>
        </tr>
        </table>
      </td>
    </tr>
    <tr>
    <td></td>

    <td width="100%" class="leftGreyLine" height="100%" valign="top">
      <table style="border-collapse: collapse" bordercolor="#111111" width="100%" height="100%">

            <!----Start new rows here-->
                    <tr>
                      <td colspan=2><div class="DivContentPadding">
                        <span class="DivContentTitle" valign="middle">
                            <bean:message key="ViewScript.title"/>
                        </span>
                      </div></td>
                    </tr>

                     <tr>
                        <td width=440px><div class="DivContentPadding">
                        <iframe name=preview width=440px height=580px src="Preview.jsp"
                            align=center border=0 frameborder=0></iframe></div>
                        </td>

                        <td valign=top>
                            <html:form action="/oscarRx/clearPending">
                            <html:hidden property="action" value="" />
                            </html:form>
                            <script language=javascript>
                                function clearPending(action){
                                    document.forms.RxClearPendingForm.action.value = action;
                                    document.forms.RxClearPendingForm.submit();
                                }
                            </script>
                            <script language=javascript>
                                function ShowDrugInfo(drug){
                                    window.open("drugInfo.do?GN=" + escape(drug), "_blank",
                                        "location=no, menubar=no, toolbar=no, scrollbars=yes, status=yes, resizable=yes");
                                }
                            </script>

                            <table cellpadding=10 cellspacing=0>
							<% if(vecAddress != null) { %>            
                                <tr>
					            <td align="center" colspan=2 >
					                Address
					                <select name="addressSel" id="addressSel" onChange="addressSelect()">
					            <%  for (int i =0; i < vecAddressName.size();i++){
					                 String te = (String) vecAddressName.get(i);
					            %>
					                    <option value="<%=i%>"><%=te%></option>
					            <%  }%>
					                </select>
					            </td>
                                </tr>
							<% } %>
                                <tr>
                                    <td colspan=2 style="font-weight:bold; ">
                                         <span>Actions</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=10px></td>
                                    <td>
                                        <span><input type=button value="Create a New Prescription" class="ControlPushButton" style="width:200px" onClick="javascript:clearPending('');" /></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=10px></td>
                                    <td>
                                        <span><input type=button value="Back to Oscar" class="ControlPushButton" style="width:200px" onClick="javascript:clearPending('close');" /></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=10px></td>
                                    <td>
                                        <span><input type=button value="Print" class="ControlPushButton" style="width:200px" onClick="javascript:printIframe();" /></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=10px></td>
                                    <td>
                                        <span><input type=button value="Print & Paste into EMR" class="ControlPushButton" style="width:200px" onClick="javascript:printPaste2Parent();" /></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan=2 style="font-weight: bold">
                                        <span>Drug Information</span>
                                    </td>
                                </tr>
                        <%
                        for(int i=0; i<bean.getStashSize(); i++){
                            oscar.oscarRx.data.RxPrescriptionData.Prescription rx
                                = bean.getStashItem(i);

                            if (! rx.isCustom()){
                            %>
                                <tr>
                                    <td width=10px></td>
                                    <td>
                                        <span><a href="javascript:ShowDrugInfo('<%= rx.getGenericName() %>');">
                                            <%= rx.getGenericName() %> (<%= rx.getBrandName() %>)
                                        </a></span>
                                    </td>
                                </tr>
                            <%
                            }
                        }
                        %>
                            </table>
                        </td>
                    </tr>



            <!----End new rows here-->

 	<tr height="100%"><td></td></tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="0%" class="leftBottomGreyLine"></td>
    <td height="0%" class="leftBottomGreyLine"></td>
  </tr>
  <tr>
    <td width="100%" height="0%" colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td width="100%" height="0%" style="padding: 5" bgcolor="#DCDCDC" colspan="2">
    </td>
  </tr>
</table>
</body>
</html:html>