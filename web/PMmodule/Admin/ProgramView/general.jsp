<!-- 
/*
* 
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
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
* This software was written for 
* Centre for Research on Inner City Health, St. Michael's Hospital, 
* Toronto, Ontario, Canada 
*/
 -->
<%@ include file="/taglibs.jsp"%>
<div class="tabs" id="tabs">
<table cellpadding="3" cellspacing="0" border="0">
	<tr>
		<th title="Programs">General Information</th>
	</tr>
</table>
</div>
<table width="100%" border="1" cellspacing="2" cellpadding="3">
	<tr class="b">
		<td width="20%">Name:</td>
		<td><c:out value="${program.name}" /></td>
	</tr>
	<tr class="b">
		<td width="20%">Description:</td>
		<td><c:out value="${program.descr}" /></td>
	</tr>
	<tr class="b">
		<td width="20%">HIC:</td>
		<td><c:out value="${program.hic}" /></td>
	</tr>
	<tr class="b">
		<td width="20%">Type:</td>
		<td><c:out value="${program.type}" /></td>
	</tr>
	<tr class="b">
		<td width="20%">Agency:</td>
		<td><c:out value="${agency.name}" /></td>
	</tr>
	<tr class="b">
		<td width="20%">Location:</td>
		<td><c:out value="${program.location}" /></td>
	</tr>
	<tr class="b">
		<td width="20%">Client Participation:</td>
		<td><c:out value="${program.numOfMembers}" />/<c:out value="${program.maxAllowed}" />&nbsp;(<c:out value="${program.queueSize}" /> waiting)</td>
	</tr>
	<tr class="b">
		<td width="20%">Holding Tank:</td>
		<td><c:out value="${program.holdingTank}" /></td>
	</tr>
	<tr class="b">
		<td width="20%">Allow Batch Admissions:</td>
		<td><c:out value="${program.allowBatchAdmission}" /></td>
	</tr>
	<tr class="b">
		<td width="20%">Allow Batch Discharges:</td>
		<td><c:out value="${program.allowBatchDischarge}" /></td>
	</tr>
</table>
