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
  if (session.getAttribute("user") == null) {
    response.sendRedirect("../logout.jsp");
  }

  String   curUser_no = (String)session.getAttribute("user");
  String[] ROLE       = new String[]{"doctor", "resident", "nurse", "social worker", "other"};
%>
  <%@ page errorPage="../errorpage.jsp" %>
  <%@ page import="java.util.*" %>
  <%@ page import="java.sql.*" %>
  <%@ page import="oscar.oscarBilling.data.BillingONDataHelp" %>
<%
  BillingONDataHelp dbObj = new BillingONDataHelp();

  // update the role list
  if (request.getParameter("buttonUpdate") != null && request.getParameter("buttonUpdate").length() > 0) {
    String number = request.getParameter("providerId");
    String name   = request.getParameter("name" + number);

    System.out.println(number + "  " + name);

    String sql = "update userRole set role_name='" + name + "' where provider_no='" + number + "'";

    dbObj.updateDBRecord(sql);
  }

  // save the role list
  if (request.getParameter("submit") != null && request.getParameter("submit").equals("Add Role(s)")) {
    Properties prop  = new Properties();
    String     query = "select u.provider_no from userRole u ";
    ResultSet  rs    = dbObj.searchDBRecord(query);

    while (rs.next()) {
      prop.setProperty(rs.getString("provider_no"), "");
    }

    for (Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
      String temp = e.nextElement().toString();

      if (!temp.startsWith("type") || prop.containsKey(temp.substring(4, temp.length()))) {
        continue;
      }

      String value = request.getParameter(temp);
      String sql   = "insert into userRole(provider_no, role_name) values('" + temp.substring(4, temp.length()) + "', '" + 
              value + "')";

      dbObj.updateDBRecord(sql);
    }
  }
%>
  <html>
    <head>
      <title>
        PROVIDER
      </title>
      <link rel="stylesheet" href="../receptionist/receptionistapptstyle.css">
      <script language="JavaScript">
        
                <!--
function setfocus() {
	this.focus();
	//  document.titlesearch.keyword.select();
}
function submit(form) {
	form.submit();
}

//-->
        
      </script>
    </head>
    <body bgproperties="fixed" onLoad="setfocus()" topmargin="0" leftmargin="0" rightmargin="0">
      <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <tr bgcolor="#486ebd">
          <th align="CENTER" width="90%">
            <font face="Helvetica" color="#FFFFFF">
              PROVIDER LIST
            </font>
          </th>
          <td nowrap>
            <font size="-1" color="#FFFFFF">
              FP-doctor; MFP-resident; NP-nurse; SW-social worker; OT-other
            </font>
          </td>
        </tr>
      </table>
<%
      String     color       = "#ccCCFF";
      Properties prop        = new Properties();
      Properties oldRoleProp = new Properties();
      Vector     vec         = new Vector();
      Vector     oldRoleList = new Vector();
      String     query       = "select u.*, p.first_name, p.last_name from userRole u, provider p ";

      query += "where u.provider_no=p.provider_no  order by p.first_name, p.last_name";

      ResultSet rs = dbObj.searchDBRecord(query);

      while (rs.next()) {
        oldRoleProp.setProperty(rs.getString("provider_no"), rs.getString("role_name"));
        oldRoleList.add(rs.getString("first_name"));
        oldRoleList.add(rs.getString("last_name"));
        oldRoleList.add(rs.getString("role_name"));
        oldRoleList.add(rs.getString("provider_no"));
      }

      query = "select * from provider order by first_name, last_name";
      rs = dbObj.searchDBRecord(query);

      while (rs.next()) {
        if (rs.getString("last_name").length() < 1 || oldRoleProp.containsKey((rs.getString("provider_no")))) {
          continue;
        }

        prop = new Properties();

        prop.setProperty("provider_no", rs.getString("provider_no"));
        prop.setProperty("first_name", rs.getString("first_name"));
        prop.setProperty("last_name", rs.getString("last_name"));
        prop.setProperty("provider_type", rs.getString("provider_type"));
        prop.setProperty("specialty", rs.getString("specialty"));
        prop.setProperty("ohip_no", rs.getString("ohip_no"));
        vec.add(prop);
      }
%>
      <form name="myform" action="reportonbilledvisitprovider.jsp" method="POST">
        <table width="100%" border="0" bgcolor="ivory" cellspacing="1" cellpadding="1">
          <tr bgcolor="mediumaquamarine">
            <th colspan="6" align="left">
              New Provider-Role List
            </th>
            <td align="right">
              <input type="submit" name="submit" value="Add Role(s)">
            </td>
          </tr>
          <tr bgcolor="silver">
            <th width="30%" nowrap>
              <b>First Name</b>
            </th>
            <th width="30%" nowrap>
              <b>Last Name</b>
            </th>
            <!--th width="10%" nowrap>
            <b>provider type</b>
          </th>
          <th width="10%" nowrap>
            <b>specialty</b>
          </th>
          <th width="10%" nowrap>
            <b>ohip_no</b>
          </th-->
            <th width="5%" nowrap>
              FP
              <br>
              doctor
            </th>
            <th width="5%" nowrap>
              RFP
              <br>
              resident
            </th>
            <th width="5%" nowrap>
              NP
              <br>
              nurse
            </th>
            <th width="5%" nowrap>
              SW
              <br>
              social worker
            </th>
            <th width="5%" nowrap>
              OT
            </th>
          </tr>
<%
          for (int i = 0; i < vec.size(); i++) {
            boolean bDoc         = false;
            boolean bRes         = false;
            boolean bNp          = false;
            boolean bSw          = false;
            boolean bOt          = false;
            String  providerType = ((Properties)vec.get(i)).getProperty("provider_type", "");

            if (((Properties)vec.get(i)).getProperty("ohip_no", "").length() > 3) {
              bDoc = true;
            } else if (providerType.matches(".*[rR][eE][sS][iI][dD][eE][nN][tT].*")) {
              bRes = true;
            } else if (providerType.matches(".*[nN][pP].*|.*[nN][uU][rR][sS][eE].*")) {
              bNp = true;
            } else {
              bOt = true;
            }
%>
            <tr bgcolor="<%=i%2==0?"white":color%>">
              <td>
                <%= ((Properties)vec.get(i)).getProperty("first_name", "") %>
              </td>
              <td>
                <%= ((Properties)vec.get(i)).getProperty("last_name", "") %>
              </td>
              <!--td>
              <%= ((Properties)vec.get(i)).getProperty("provider_type", "") %>
            </td>
            <td>
              <%= ((Properties)vec.get(i)).getProperty("specialty", "") %>
            </td>
            <td>
              <%= ((Properties)vec.get(i)).getProperty("ohip_no", "") %>
            </td-->
              <td align="center" <%=bDoc?"bgcolor=\"silver\"":""%> title="Doctor">
                <input type="radio" name="type<%=((Properties)vec.get(i)).getProperty("provider_no", "")%>" value="<%=ROLE[0]%>" <%=bDoc?"checked":""%>>
              </td>
              <td align="center" <%=bRes?"bgcolor=\"silver\"":""%> title="Resident">
                <input type="radio" name="type<%=((Properties)vec.get(i)).getProperty("provider_no", "")%>" value="<%=ROLE[1]%>" <%=bRes?"checked":""%>>
              </td>
              <td align="center" <%=bNp?"bgcolor=\"silver\"":""%> title="Nurse">
                <input type="radio" name="type<%=((Properties)vec.get(i)).getProperty("provider_no", "")%>" value="<%=ROLE[2]%>" <%=bNp?"checked":""%>>
              </td>
              <td align="center" <%=bSw?"bgcolor=\"silver\"":""%> title="Social Worker">
                <input type="radio" name="type<%=((Properties)vec.get(i)).getProperty("provider_no", "")%>" value="<%=ROLE[3]%>" <%=bSw?"checked":""%>>
              </td>
              <td align="center" <%=bOt?"bgcolor=\"silver\"":""%> title="Other">
                <input type="radio" name="type<%=((Properties)vec.get(i)).getProperty("provider_no", "")%>" value="<%=ROLE[4]%>" <%=bOt?"checked":""%>>
              </td>
            </tr>
<%
          }
          if (vec.size() > 0) {
%>
            <tr bgcolor="A9A9A9">
              <td colspan="7" align="right">
                <input type="submit" name="submit" value="Add Role(s)">
              </td>
            </tr>
<%
          }
%>
        </table>
      </form>
      <hr>
      <table width="100%" border="0" bgcolor="ivory" cellspacing="1" cellpadding="1">
        <tr bgcolor="mediumaquamarine">
          <th colspan="4" align="left">
            Confirmed Provider-Role List
          </th>
        </tr>
        <tr bgcolor="silver">
          <th width="30%" nowrap>
            <b>Fisst Name</b>
          </th>
          <th width="30%" nowrap>
            <b>Last Name</b>
          </th>
          <th nowrap>
            Role
          </th>
          <th nowrap>
            Action
          </th>
<%
          int k = 0;

          for (int i = 0; i < oldRoleList.size(); i += 4) {
            k++;
%>
            <tr bgcolor="<%=k%2==0?"white":color%>">
              <form name="mySecform<%=i%>" action="reportonbilledvisitprovider.jsp" method="POST">
                <td>
                  <%= oldRoleList.get(i) %>
                </td>
                <td>
                  <%= oldRoleList.get(i + 1) %>
                </td>
                <td align="center">
                  <select name="<%="name" + oldRoleList.get(i + 3)%>">
<%
                    for (int j = 0; j < ROLE.length; j++) {
%>
                      <option value="<%=ROLE[j]%>" <%= ROLE[j].equals(oldRoleList.get(i + 2))?"selected":"" %>>
                      <%= ROLE[j] %>
                      </option>
<%
                    }
%>
                  </select>
                </td>
                <td align="center">
                  <input type="hidden" name="providerId" value="<%= oldRoleList.get(i + 3) %>">
                  <input type="submit" name="buttonUpdate" value="Update">
                </td>
              </form>
            </tr>
<%
          }
%>
        </table>
      </body>
    </html>
