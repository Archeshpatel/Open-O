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

<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page import="oscar.oscarEncounter.data.EctType2DiabetesRecord" %>
<html:html locale="true">
<% response.setHeader("Cache-Control","no-cache");%>
<head>
<title>Type 2 Diabetes Record</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<html:base/>
<style media="print">
.hidePrint
{
    display: none;
}
</style>
</head>

<%
    int demoNo = Integer.parseInt(request.getParameter("demographic_no"));
    int formId = Integer.parseInt(request.getParameter("formId"));
    EctType2DiabetesRecord rec = new EctType2DiabetesRecord();
    java.util.Properties props = rec.getType2DiabetesRecord(demoNo, formId);
    String color="#FFFFFF";
%>

<body bgproperties="fixed" class="Type2DiabetesForm" bgcolor="<%=color%>" onLoad="javascript:window.focus()" topmargin="0" leftmargin="0" rightmargin="0">
<html:form action="/oscarEncounter/Type2Diabetes">


<input type="hidden" name="demographic_no" value="<%= props.getProperty("demographic_no", "0") %>" />
<input type="hidden" name="ID" value="<%= props.getProperty("ID", "0") %>"/>
<input type="hidden" name="provider_no" value=<%=request.getParameter("provNo")%> />
<input type="hidden" name="formCreated" value="<%= props.getProperty("formCreated", "") %>" />
<input type="hidden" name="formEdited" value="<%= props.getProperty("formEdited", "") %>" />


<table border="0" cellspacing="3" cellpadding="0" width="100%" bordercolor="#000000">
    <tr>
        <th align=CENTER colspan="4" class="titleweb">TYPE 2 DIABETES RECORD</th>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>
            Name: <input type="text" class="Type2DiabetesInput" name="pName" readonly="true" size="30" value="<%= props.getProperty("pName", "") %>" />
        </td>
        <td>
            DOB<small>(yyyy/mm/dd)</small>: <input type="text" class="Type2DiabetesInput" readonly="true" name="birthDate" size="11" value="<%= props.getProperty("birthDate", "") %>" readonly="true" />
        </td>
        <td>
            Date of Dx<small>(yyyy/mm/dd)</small>: <input type="text" readonly="true" class="Type2DiabetesInput" name="dateDX" size="11" value="<%=props.getProperty("dateDX", "") %>" />
        </td>
        <td>
            Height: <input type="text" readonly="true" class="Type2DiabetesInput" name="height" size="5" value="<%= props.getProperty("height", "") %>" />
        </td>
    </tr>
</table>
<table border="1" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="100%">
                <tr>
                    <td>Date <small>(complete q3-6 months)</small></td>
                    <td align="right"><small>(yyyy/mm/dd)</small></td>
                </tr>
            </table>
        </td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="date1" value="<%= props.getProperty("date1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="date2" value="<%= props.getProperty("date2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="date3" value="<%= props.getProperty("date3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="date4" value="<%= props.getProperty("date4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="date5" value="<%= props.getProperty("date5", "") %>" /></td>
    </tr>
    <tr>
        <td align="left">Weight (BMI ideally &lt;27)</td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="weight1" value="<%= props.getProperty("weight1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="weight2" value="<%= props.getProperty("weight2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="weight3" value="<%= props.getProperty("weight3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="weight4" value="<%= props.getProperty("weight4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="weight5" value="<%= props.getProperty("weight5", "") %>" /></td>
    </tr>
    <tr>
        <td align="left">*BP (ideally &lt;130/85)</td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="bp1" value="<%= props.getProperty("bp1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="bp2" value="<%= props.getProperty("bp2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="bp3" value="<%= props.getProperty("bp3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="bp4" value="<%= props.getProperty("bp4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="bp5" value="<%= props.getProperty("bp5", "") %>" /></td>
    </tr>
    <tr>
        <td align="left" rowspan="3">
            <table border="0" nowrap="true">
                <tr>
                    <td colspan="4" align="left" nowrap="true">GLUCOSE <small>(insulin q3mo, OHA q6mo)</small></td>
                    <td align="right"><u>HbAic</u></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td nowrap="true" align="center"><small>Optimal</small></td>
                    <td nowrap="true" align="center"><small>Suboptimal</small></td>
                    <td nowrap="true" align="center"><small>Inadequate</small></td>
                </tr>
                <tr>
                    <td align="left"><small>&nbsp;<br>HbAic<br>FBS</small></td>
                    <td nowrap="true" align="center"><small>(target goal)<br>&lt;,0.07<br>4-7</small></td>
                    <td nowrap="true" align="center"><small>(action may be required)<br>0.07-0.084<br>7.1-10</small></td>
                    <td nowrap="true" align="center"><small>(action required)<br>&gt;0.084<br>&gt;10</small></td>
                    <td align="right" valign="top"><u>FBS</u></td>
                </tr>
                <tr>
                    <td colspan="5" align="left">
                        <u>HOME</u><br>
                        (check glucometer q yearly)<br>
                        RANGE
                    </td>
                </tr>
            </table>
        </td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseA1"><%= props.getProperty("glucoseA1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseA2"><%= props.getProperty("glucoseA2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseA3"><%= props.getProperty("glucoseA3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseA4"><%= props.getProperty("glucoseA4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseA5"><%= props.getProperty("glucoseA5", "") %></textarea></td>
    </tr>
    <tr>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseB1"><%= props.getProperty("glucoseB1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseB2"><%= props.getProperty("glucoseB2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseB3"><%= props.getProperty("glucoseB3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseB4"><%= props.getProperty("glucoseB4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseB5"><%= props.getProperty("glucoseB5", "") %></textarea></td>
    </tr>
    <tr>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseC1"><%= props.getProperty("glucoseC1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseC2"><%= props.getProperty("glucoseC2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseC3"><%= props.getProperty("glucoseC3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseC4"><%= props.getProperty("glucoseC4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="glucoseC5"><%= props.getProperty("glucoseC5", "") %></textarea></td>
    </tr>
    <tr>
        <td align="left">
            RENAL<br>
            1. Dip for macroalbuminuria (q 3-6 months)<br>
            <font color="<%=color%>">tab</font>
            <small>*if -ve see step 2, if +ve see step 3</small>
        </td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="renal1"><%= props.getProperty("renal1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="renal2"><%= props.getProperty("renal2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="renal3"><%= props.getProperty("renal3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="renal4"><%= props.getProperty("renal4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="renal5"><%= props.getProperty("renal5", "") %></textarea></td>
    </tr>
    <tr>
        <td align="left">
            2. <b>*Urine alb:creat ratio yearly</b><br>
            <font color="<%=color%>">tab</font>
            <small>*if +ve (female &gt;=2.8 or male &gt;=2.0) see step 3</small>
        </td>
        <td><textarea readonly="true" style="height:37px;" class="Type2DiabetesTextarea" name="urineRatio1"><%= props.getProperty("urineRatio1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:37px;" class="Type2DiabetesTextarea" name="urineRatio2"><%= props.getProperty("urineRatio2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:37px;" class="Type2DiabetesTextarea" name="urineRatio3"><%= props.getProperty("urineRatio3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:37px;" class="Type2DiabetesTextarea" name="urineRatio4"><%= props.getProperty("urineRatio4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:37px;" class="Type2DiabetesTextarea" name="urineRatio5"><%= props.getProperty("urineRatio5", "") %></textarea></td>
    </tr>
    <tr>
        <td align="left">
            3. <b>*24-hr urine cr clearance & albuminuria</b><br>
            <font color="<%=color%>">tab</font>
            q 6-12 mos<br>
            <font color="<%=color%>">tab</font>
            <small>*if &gt; 30mg albumin ?ACE<br></small>
            <font color="<%=color%>">tab</font>
            Nephrologist (if cr. clear <font face="Symbols">&#223</font> by 50%)
        </td>
        <td><textarea readonly="true" style="height:67px;" class="Type2DiabetesTextarea" name="urineClearance1"><%= props.getProperty("urineClearance1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:67px;" class="Type2DiabetesTextarea" name="urineClearance2"><%= props.getProperty("urineClearance2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:67px;" class="Type2DiabetesTextarea" name="urineClearance3"><%= props.getProperty("urineClearance3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:67px;" class="Type2DiabetesTextarea" name="urineClearance4"><%= props.getProperty("urineClearance4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:67px;" class="Type2DiabetesTextarea" name="urineClearance5"><%= props.getProperty("urineClearance5", "") %></textarea></td>
    </tr>
    <tr>
        <td rowspan="3">
            <table nowrap="true" width="100%">
                <tr>
                    <td align="left" colspan="5">*LIPIDS (monitor every 1-3y)</td>
                    <td align="right">TG</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td align="center"><small>TG</small></td>
                    <td align="center"><small>LDL</small></td>
                    <td align="center"><small>TC/HDL</small></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td align="center"><small>&lt;2.0</small></td>
                    <td align="center"><small>&lt;2.5</small></td>
                    <td align="center"><small>&lt;4.0</small></td>
                    <td><font color="<%=color%>">some space</font></td>
                    <td align="right">LDL</td>
                </tr>
                <tr>
                    <td align="left">&nbsp;<br>TC/HDL</td>
                </tr>
            </table>
        </td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsA1"><%= props.getProperty("lipidsA1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsA2"><%= props.getProperty("lipidsA2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsA3"><%= props.getProperty("lipidsA3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsA4"><%= props.getProperty("lipidsA4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsA5"><%= props.getProperty("lipidsA5", "") %></textarea></td>
    </tr>
    <tr>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsB1"><%= props.getProperty("lipidsB1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsB2"><%= props.getProperty("lipidsB2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsB3"><%= props.getProperty("lipidsB3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsB4"><%= props.getProperty("lipidsB4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsB5"><%= props.getProperty("lipidsB5", "") %></textarea></td>
    </tr>
    <tr>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsC1"><%= props.getProperty("lipidsC1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsC2"><%= props.getProperty("lipidsC2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsC3"><%= props.getProperty("lipidsC3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsC4"><%= props.getProperty("lipidsC4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:30px;" class="Type2DiabetesTextarea" name="lipidsC5"><%= props.getProperty("lipidsC5", "") %></textarea></td>
    </tr>
    <tr>
        <td align="left">
            <b>EYES (@dx then q2-4yrs)</b><br>
            Ophthalmologist: <input type="text" readonly="true" class="Type2DiabetesInput" name="ophthalmologist" value="<%= props.getProperty("ophthalmologist", "") %>" />
        </td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="eyes1"><%= props.getProperty("eyes1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="eyes2"><%= props.getProperty("eyes2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="eyes3"><%= props.getProperty("eyes3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="eyes4"><%= props.getProperty("eyes4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:42px;" class="Type2DiabetesTextarea" name="eyes5"><%= props.getProperty("eyes5", "") %></textarea></td>
    </tr>
    <tr>
        <td align="left">
            <b>FEET</b> check skin (q visit)<br>
            <font color="<%=color%>">tab</font>
            annually (sensation, vibration, reflexes, pulses,<br> infection)
        </td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="feet1"><%= props.getProperty("feet1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="feet2"><%= props.getProperty("feet2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="feet3"><%= props.getProperty("feet3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="feet4"><%= props.getProperty("feet4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:50px;" class="Type2DiabetesTextarea" name="feet5"><%= props.getProperty("feet5", "") %></textarea></td>
    </tr>
    <tr>
        <td>
            <table width="100%">
                <tr>
                    <td colspan="4" align="left">MEDICATIONS</td>
                </tr>
                <tr>
                    <td>1. METFORMIN</td>
                    <td><%= checkMarks(props.getProperty("metformin", "")) %></td>
                    <td>5. ACE INHIBITOR</td>
                    <td nowrap="true"><%= checkMarks(props.getProperty("aceInhibitor", "")) %>*</td>
                </tr>
                <tr>
                    <td>2. GLYBURIDE</td>
                    <td><%= checkMarks(props.getProperty("glyburide", "")) %></td>
                    <td>6. ASA &gt;30 YR</td>
                    <td align="left"><%= checkMarks(props.getProperty("asa", "")) %></td>
                </tr>
                <tr>
                    <td>3. OTHER OHA</td>
                    <td><%= checkMarks(props.getProperty("otherOha", "")) %></td>
                    <td colspan="2">7. <input type="text" readonly="true" class="Type2DiabetesInput" name="otherBox7" value="<%= props.getProperty("otherBox7", "") %>" /></td>
                </tr>
                <tr>
                    <td>4. INSULIN</td>
                    <td><%= checkMarks(props.getProperty("insulin", "")) %></td>
                    <td colspan="2">8. <input type="text" readonly="true" class="Type2DiabetesInput" name="otherBox8" value="<%= props.getProperty("otherBox8", "") %>" /></td>
                </tr>
            </table>
        </td>
        <td><textarea readonly="true" style="height:120px;" class="Type2DiabetesTextarea" name="meds1"><%= props.getProperty("meds1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:120px;" class="Type2DiabetesTextarea" name="meds2"><%= props.getProperty("meds2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:120px;" class="Type2DiabetesTextarea" name="meds3"><%= props.getProperty("meds3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:120px;" class="Type2DiabetesTextarea" name="meds4"><%= props.getProperty("meds4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:120px;" class="Type2DiabetesTextarea" name="meds5"><%= props.getProperty("meds5", "") %></textarea></td>
    </tr>
    <tr>
        <td align="left">*LIFESTYLE <b>Smoking</b></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="lifestyle1" value="<%= props.getProperty("lifestyle1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="lifestyle2" value="<%= props.getProperty("lifestyle2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="lifestyle3" value="<%= props.getProperty("lifestyle3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="lifestyle4" value="<%= props.getProperty("lifestyle4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="lifestyle5" value="<%= props.getProperty("lifestyle5", "") %>" /></td>
    </tr>
    <tr>
        <td align="left">
            <font color="<%=color%>">*LIFESTYLE </font>
            <i>Exercise</i>
        </td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="exercise1" value="<%= props.getProperty("exercise1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="exercise2" value="<%= props.getProperty("exercise2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="exercise3" value="<%= props.getProperty("exercise3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="exercise4" value="<%= props.getProperty("exercise4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="exercise5" value="<%= props.getProperty("exercise5", "") %>" /></td>
    </tr>
    <tr>
        <td align="left">
            <font color="<%=color%>">*LIFESTYLE </font>
            Alcohol
        </td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="alcohol1" value="<%= props.getProperty("alcohol1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="alcohol2" value="<%= props.getProperty("alcohol2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="alcohol3" value="<%= props.getProperty("alcohol3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="alcohol4" value="<%= props.getProperty("alcohol4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="alcohol5" value="<%= props.getProperty("alcohol5", "") %>" /></td>
    </tr>
    <tr>
        <td align="left">
            <font color="<%=color%>">*LIFESTYLE </font>
            Sexual Function
        </td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="sexualFunction1" value="<%= props.getProperty("sexualFunction1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="sexualFunction2" value="<%= props.getProperty("sexualFunction2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="sexualFunction3" value="<%= props.getProperty("sexualFunction3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="sexualFunction4" value="<%= props.getProperty("sexualFunction4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="sexualFunction5" value="<%= props.getProperty("sexualFunction5", "") %>" /></td>
    </tr>
    <tr>
        <td align="left">
            <font color="<%=color%>">*LIFESTYLE </font>
            <i>Diet</i>
        </td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="diet1" value="<%= props.getProperty("diet1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="diet2" value="<%= props.getProperty("diet2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="diet3" value="<%= props.getProperty("diet3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="diet4" value="<%= props.getProperty("diet4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="diet5" value="<%= props.getProperty("diet5", "") %>" /></td>
    </tr>
    <tr>
        <td align="left">OTHER/PLAN</td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="otherPlan1" value="<%= props.getProperty("otherPlan1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="otherPlan2" value="<%= props.getProperty("otherPlan2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="otherPlan3" value="<%= props.getProperty("otherPlan3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="otherPlan4" value="<%= props.getProperty("otherPlan4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="otherPlan5" value="<%= props.getProperty("otherPlan5", "") %>" /></td>
    </tr>
    <tr>
        <td rowspan="1">
            <table>
                <tr>
                    <td>Consultant:</td>
                    <td><input type="text" readonly="true" class="Type2DiabetesInput" name="consultant" value="<%= props.getProperty("consultant", "") %>" /></td>
                </tr>
                <tr>
                    <td>Diabetic Educator:</td>
                    <td><input type="text" readonly="true" class="Type2DiabetesInput" name="educator" value="<%= props.getProperty("educator", "") %>" /></td>
                </tr>
                <tr>
                    <td>Nutritionist:</td>
                    <td><input type="text" readonly="true" class="Type2DiabetesInput" name="nutritionist" value="<%= props.getProperty("nutritionist", "") %>" /></td>
                </tr>
            </table>
        </td>
        <td><textarea readonly="true" style="height:75px;" class="Type2DiabetesTextarea" name="cdn1"><%= props.getProperty("cdn1", "") %></textarea></td>
        <td><textarea readonly="true" style="height:75px;" class="Type2DiabetesTextarea" name="cdn2"><%= props.getProperty("cdn2", "") %></textarea></td>
        <td><textarea readonly="true" style="height:75px;" class="Type2DiabetesTextarea" name="cdn3"><%= props.getProperty("cdn3", "") %></textarea></td>
        <td><textarea readonly="true" style="height:75px;" class="Type2DiabetesTextarea" name="cdn4"><%= props.getProperty("cdn4", "") %></textarea></td>
        <td><textarea readonly="true" style="height:75px;" class="Type2DiabetesTextarea" name="cdn5"><%= props.getProperty("cdn5", "") %></textarea></td>
    </tr>
    <tr>
        <td>Initials</td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="initials1" value="<%= props.getProperty("initials1", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="initials2" value="<%= props.getProperty("initials2", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="initials3" value="<%= props.getProperty("initials3", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="initials4" value="<%= props.getProperty("initials4", "") %>" /></td>
        <td><input type="text" readonly="true" class="Type2DiabetesTextarea" name="initials5" value="<%= props.getProperty("initials5", "") %>" /></td>
    </tr>
    <tr class="Type2DiabetesFooter">
        <td colspan="3">
            *This form is based on (April 2000) Diabetes Guidelines, CMAJ 1999<br>
            DISCLAIMER: This is a guidline only and should be modified according to current evidence and guidelines<br>
            <br>
            <b>GRADE A</b>: good evidence <font color="<%=color%>">tab</font><i>GRADE B</i>: fair evidence<br>
            <br>
            OHA = ORAL HYPOGLYCEMIC AGENT
            *HOPE TRIAL: Ramipril for diabetics with other risk factor: HTN, smoking, increased TC, decreased LDL, MA
        </td>
        <td colspan="3" align="right">
            <table class="TableWithBorder" bordercolor="#000000" width="100%">
                <tr>
                    <td>RESOURCE MATERIAL</td>
                </tr>
                <tr>
                    <td>
                        <%= checkMarks(props.getProperty("resource1", "")) %>
                        Things You Should Know About Diabetes-Type2
                    </td>
                </tr>
                <tr>
                    <td>
                        <%= checkMarks(props.getProperty("resource2", "")) %>
                        Services Available for People with Diabetes in Hamilton
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table>
    <tr>
        <td class="hidePrint">
            <a href="formType2Diabetes.jsp?demographic_no=<%=demoNo%>&formId=<%=formId%>">Cancel</a>&nbsp;<a href=# onClick="window.print()">Print</a>
        </td>
    </tr>
</table>

</html:form>
</body>
</html:html>

<%! String checkMarks(String val)
    {
        String ret="<img src='graphics/notChecked.gif'>";
        if(val.equalsIgnoreCase("checked='checked'"))
        {
            ret="<img src='graphics/checkmark.gif'>";
        }
        return ret;
    }
%>