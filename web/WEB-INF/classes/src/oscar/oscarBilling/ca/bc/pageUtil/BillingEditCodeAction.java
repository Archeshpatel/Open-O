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
package oscar.oscarBilling.ca.bc.pageUtil;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import oscar.*;
import oscar.oscarBilling.ca.bc.data.*;
import oscar.oscarDB.*;

public final class BillingEditCodeAction extends Action {

    public ActionForward execute(ActionMapping mapping,
    ActionForm form,
    HttpServletRequest request,
    HttpServletResponse response)
    throws IOException, ServletException {

        Locale locale = getLocale(request);

        if(request.getSession().getAttribute("user") == null  ){
            return (mapping.findForward("Logout"));
        }

        BillingEditCodeForm frm = (BillingEditCodeForm) form;

        String codeId  =frm.getCodeId();
        String code    =frm.getCode();
        String desc    =frm.getDesc();
        String value   =frm.getValue();
        String whereTo =frm.getWhereTo();
        String submitButton = frm.getSubmitButton();

        System.out.println(submitButton);
        if (submitButton.equals("Edit")){
           System.out.println("here with codeid "+codeId);
          BillingCodeData bcd = new BillingCodeData();
          bcd.editBillingCode(code,desc, value,codeId);
        }

        ActionForward retval;
        if(whereTo == null || whereTo.equals("")){
           retval = mapping.findForward("success");
        }else{
           retval = mapping.findForward("private");
        }

        return retval;
    }

}
