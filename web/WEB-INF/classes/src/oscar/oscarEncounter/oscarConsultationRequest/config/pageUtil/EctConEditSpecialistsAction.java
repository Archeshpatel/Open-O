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
package oscar.oscarEncounter.oscarConsultationRequest.config.pageUtil;

import java.io.IOException;
import java.io.PrintStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.*;
import oscar.oscarDB.DBHandler;

public class EctConEditSpecialistsAction extends Action
{

    public ActionForward perform(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException
    {
        System.out.println("Entering EditSpecialistsAction Jackson");
        EctConEditSpecialistsForm editSpecialistsForm = (EctConEditSpecialistsForm)form;
        String specId = editSpecialistsForm.getSpecId();
        String delete = editSpecialistsForm.getDelete();
        String specialists[] = editSpecialistsForm.getSpecialists();
        System.out.println(String.valueOf(String.valueOf((new StringBuffer("===>")).append(delete).append("<==="))));
        if(delete.equals("Delete Specialist"))
        {
            if(specialists.length > 0)
            {
                StringBuffer stringBuffer = new StringBuffer();
                for(int i = 0; i < specialists.length; i++)
                    if(i == specialists.length - 1)
                        stringBuffer.append(String.valueOf(String.valueOf((new StringBuffer(" specId = '")).append(specialists[i]).append("' "))));
                    else
                        stringBuffer.append(String.valueOf(String.valueOf((new StringBuffer(" specId = '")).append(specialists[i]).append("' or "))));

                try
                {
                    DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
                    String sql = "delete from professionalSpecialists where ".concat(String.valueOf(String.valueOf(stringBuffer.toString())));
                    ResultSet rs = db.GetSQL(sql);
                    rs.close();
                    db.CloseConn();
                }
                catch(SQLException e)
                {
                    System.out.println(e.getMessage());
                }
            }
            EctConConstructSpecialistsScriptsFile constructSpecialistsScriptsFile = new EctConConstructSpecialistsScriptsFile();
            constructSpecialistsScriptsFile.makeString();
            return mapping.findForward("delete");
        }
        String fName = new String();
        String lName = new String();
        String proLetters = new String();
        String address = new String();
        String phone = new String();
        String fax = new String();
        String website = new String();
        String email = new String();
        String specType = new String();
        int updater = 0;
        try
        {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = String.valueOf(String.valueOf((new StringBuffer("select * from professionalSpecialists where specId = '")).append(specId).append("'")));
            ResultSet rs;
            for(rs = db.GetSQL(sql); rs.next();)
            {
                fName = rs.getString("fName");
                lName = rs.getString("lName");
                proLetters = rs.getString("proLetters");
                address = rs.getString("address");
                phone = rs.getString("phone");
                fax = rs.getString("fax");
                website = rs.getString("website");
                email = rs.getString("email");
                specType = rs.getString("specType");
                updater = 1;
            }

            rs.close();
            db.CloseConn();
        }
        catch(SQLException e)
        {
            System.out.println(e.getMessage());
        }
        request.setAttribute("fName", fName);
        request.setAttribute("lName", lName);
        request.setAttribute("proLetters", proLetters);
        request.setAttribute("address", address);
        request.setAttribute("phone", phone);
        request.setAttribute("fax", fax);
        request.setAttribute("website", website);
        request.setAttribute("email", email);
        request.setAttribute("specType", specType);
        request.setAttribute("specId", specId);
        request.setAttribute("upd", new Integer(updater));
        EctConConstructSpecialistsScriptsFile constructSpecialistsScriptsFile = new EctConConstructSpecialistsScriptsFile();
        request.setAttribute("verd", constructSpecialistsScriptsFile.makeFile());
        constructSpecialistsScriptsFile.makeString();
        return mapping.findForward("success");
    }
}
