// -----------------------------------------------------------------------------------------------------------------------
// *
// *
// * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
// * This software is published under the GPL GNU General Public License. 
// * This program is free software; you can redistribute it and/or 
// * modify it under the terms of the GNU General Public License 
// * as published by the Free Software Foundation; either version 2 
// * of the License, or (at your option) any later version. * 
// * This program is distributed in the hope that it will be useful, 
// * but WITHOUT ANY WARRANTY; without even the implied warranty of 
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
// * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
// * along with this program; if not, write to the Free Software 
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
// * 
// * <OSCAR TEAM>
// * This software was written for the 
// * Department of Family Medicine 
// * McMaster Unviersity 
// * Hamilton 
// * Ontario, Canada 
// *
// -----------------------------------------------------------------------------------------------------------------------
package oscar.oscarMessenger.config.pageUtil;


import oscar.oscarDB.DBHandler;
import oscar.oscarMessenger.data.*;

import java.io.IOException;
import java.util.Hashtable;
import java.util.Locale;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.util.MessageResources;

public class MsgMessengerCreateGroupAction extends Action {

    public ActionForward perform(ActionMapping mapping,
				 ActionForm form,
				 HttpServletRequest request,
				 HttpServletResponse response)
	throws IOException, ServletException {


       String grpName = ((MsgMessengerCreateGroupForm)form).getGroupName();
       String parentID = ((MsgMessengerCreateGroupForm)form).getParentID();
       String type = ((MsgMessengerCreateGroupForm)form).getType2();

       System.out.println("type = "+type);
       grpName = grpName.trim();

       if (!grpName.equals("")){
           if (type.equals("1")){
              try{
                 DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
                 java.sql.ResultSet rs;
                 String sql = "insert into groups_tbl (parentID,groupDesc) values ('"+parentID+"','"+grpName+"')";
                 rs = db.GetSQL(sql);

                 rs.close();
                 MsgAddressBookMaker addMake = new MsgAddressBookMaker(db);
                 addMake.updateAddressBook();
                 db.CloseConn();

               }catch (java.sql.SQLException e){ System.out.println(e.getMessage()); System.out.println("Update of address book didn't happen when updating groups");}
           }else if (type.equals("2")){
                try{
                 DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
                 java.sql.ResultSet rs;
                 String sql = "update groups_tbl set groupDesc = '"+grpName+"' where groupID = '"+parentID+"'";
                 rs = db.GetSQL(sql);

                 rs.close();
                 MsgAddressBookMaker addMake = new MsgAddressBookMaker(db);
                 addMake.updateAddressBook();
                 db.CloseConn();

               }catch (java.sql.SQLException e){ System.out.println(e.getMessage()); System.out.println("Update of address book didn't happen when deleting group"); }
           }
        }
      request.setAttribute("groupNo",parentID);
      return (mapping.findForward("success"));
    }
}
