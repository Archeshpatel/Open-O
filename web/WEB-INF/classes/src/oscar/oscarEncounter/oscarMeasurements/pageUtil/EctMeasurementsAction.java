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
package oscar.oscarEncounter.oscarMeasurements.pageUtil;

import java.io.*;
import java.util.*;
import java.lang.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.validator.*;
import org.apache.commons.validator.*;
import org.apache.struts.util.MessageResources;
import oscar.oscarDB.DBHandler;
import oscar.oscarMessenger.util.MsgStringQuote;
import oscar.oscarEncounter.pageUtil.EctSessionBean;
import oscar.OscarProperties;


public class EctMeasurementsAction extends Action {

    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException
    {
        EctMeasurementsForm frm = (EctMeasurementsForm) form;
        
        HttpSession session = request.getSession();
        request.getSession().setAttribute("EctMeasurementsForm", frm);
        
        EctSessionBean bean = (EctSessionBean)request.getSession().getAttribute("EctSessionBean");
        request.getSession().setAttribute("EctSessionBean", bean);
        
        java.util.Calendar calender = java.util.Calendar.getInstance();
        String day =  Integer.toString(calender.get(java.util.Calendar.DAY_OF_MONTH));
        String month =  Integer.toString(calender.get(java.util.Calendar.MONTH)+1);
        String year = Integer.toString(calender.get(java.util.Calendar.YEAR));
        String hour = Integer.toString(calender.get(java.util.Calendar.HOUR));
        String min = Integer.toString(calender.get(java.util.Calendar.MINUTE));
        String second = Integer.toString(calender.get(java.util.Calendar.SECOND));
        String dateEntered = year+"-"+month+"-"+day+" " + hour + ":" + min + ":" + second + ":";
        
        String numType = (String) frm.getValue("numType");        
        int iType = Integer.parseInt(numType);
         
        String demographicNo = null;
        String providerNo = (String) session.getValue("user");
        if ( bean != null)
            demographicNo = bean.getDemographicNo();        
        
        MsgStringQuote str = new MsgStringQuote();       
        
        List messages = new LinkedList();
        String textOnEncounter = "**********************************************************************************\\n";        
        boolean valid = true;
        try
            {
                DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
                EctValidation ectValidation = new EctValidation();                    
                ActionErrors errors = new ActionErrors();   
                
                String inputValueName;
                String inputTypeName;
                String inputTypeDisplayName;
                String mInstrcName;
                String commentsName;
                String dateName;
                String validationName;
                String inputValue;
                String inputType;
                String inputTypeDisplay;
                String mInstrc;
                String comments;
                String dateObserved; 
                String validation;
                String msg = null;
                String regExp = null;
                double dMax = 0;
                double dMin = 0;
                int iMax = 0;
                int iMin = 0;
                
                ResultSet rs;
                String regCharExp;
                //goes through each type to check if the input value is valid
                for(int i=0; i<iType; i++){
                    inputValueName = "inputValue-" + i;
                    inputTypeName = "inputType-" + i;
                    inputTypeDisplayName = "inputTypeDisplayName-" + i;
                    mInstrcName = "inputMInstrc-" + i;
                    commentsName = "comments-" + i;
                    dateName = "date-" + i;
                    inputValue = (String) frm.getValue(inputValueName);
                    inputType = (String) frm.getValue(inputTypeName);
                    inputTypeDisplay = (String) frm.getValue(inputTypeDisplayName);
                    mInstrc = (String) frm.getValue(mInstrcName);
                    comments = (String) frm.getValue(commentsName);
                    dateObserved = (String) frm.getValue(dateName);
                    
                    msg = null;
                    regExp = null;
                    dMax = 0;
                    dMin = 0;
                    iMax = 0;
                    iMin = 0;
                                                       
                    rs = ectValidation.getValidationType(inputType, mInstrc);
                    regCharExp = ectValidation.getRegCharacterExp();
                    
                    if (rs.next()){
                        dMax = rs.getDouble("maxValue");
                        dMin = rs.getDouble("minValue");
                        iMax = rs.getInt("maxLength");
                        iMin = rs.getInt("minLength");
                        regExp = rs.getString("regularExp");
                    }                                                                                                                        
	
                    if(!ectValidation.isInRange(dMax, dMin, inputValue)){                       
                        errors.add(inputValueName, new ActionError("errors.range", inputTypeDisplay, Double.toString(dMin), Double.toString(dMax)));
                        saveErrors(request, errors);
                        valid = false;
                    }
                    if(!ectValidation.maxLength(iMax, inputValue)){                       
                        errors.add(inputValueName, new ActionError("errors.maxlength", inputTypeDisplay, Integer.toString(iMax)));
                        saveErrors(request, errors);
                        valid = false;
                    }
                    if(!ectValidation.minLength(iMin, inputValue)){                       
                        errors.add(inputValueName, new ActionError("errors.minlength", inputTypeDisplay, Integer.toString(iMin)));
                        saveErrors(request, errors);
                        valid = false;
                    }
                    if(!ectValidation.matchRegExp(regExp, inputValue)){                        
                        errors.add(inputValueName,
                        new ActionError("errors.invalid", inputTypeDisplay));
                        saveErrors(request, errors);
                        valid = false;
                    }
                    if(!ectValidation.isValidBloodPressure(regExp, inputValue)){                        
                        errors.add(inputValueName,
                        new ActionError("error.bloodPressure"));
                        saveErrors(request, errors);
                        valid = false;
                    }
                    if(!ectValidation.matchRegExp(regCharExp, comments)){                        
                        errors.add(commentsName,
                        new ActionError("errors.invalidComments", inputTypeDisplay));
                        saveErrors(request, errors);
                        valid = false;
                    }
                    if(!ectValidation.isDate(dateObserved)&&inputValue.compareTo("")!=0){                        
                        errors.add(dateName,
                        new ActionError("errors.invalidDate", inputTypeDisplay));
                        saveErrors(request, errors);
                        valid = false;
                    }
                }

                //Write to database and to encounter form if all the input values are valid
                if(valid){
                    for(int i=0; i<iType; i++){

                        inputValueName = "inputValue-" + i;
                        inputTypeName = "inputType-" + i;
                        mInstrcName = "inputMInstrc-" + i;
                        commentsName = "comments-" + i;
                        validationName = "validation-" + i;
                        dateName = "date-" + i;                       

                        inputValue = (String) frm.getValue(inputValueName);
                        inputType = (String) frm.getValue(inputTypeName);
                        mInstrc = (String) frm.getValue(mInstrcName);
                        comments = (String) frm.getValue(commentsName);
                        validation = (String) frm.getValue(validationName);
                        dateObserved = (String) frm.getValue(dateName);                        
                        
                        org.apache.commons.validator.GenericValidator gValidator = new org.apache.commons.validator.GenericValidator();
                        if(!gValidator.isBlankOrNull(inputValue)){
                            //Write to the Dababase if all input values are valid                        
                            String sql = "INSERT INTO measurements"
                                    +"(type, demographicNo, providerNo, dataField, measuringInstruction, comments, dateObserved, dateEntered)"
                                    +" VALUES ('"+str.q(inputType)+"','"+str.q(demographicNo)+"','"+str.q(providerNo)+"','"+str.q(inputValue)+"','"
                                    + str.q(mInstrc)+"','"+str.q(comments)+"','"+str.q(dateObserved)+"','"+str.q(dateEntered)+"')";                           
                            db.RunSQL(sql);
                            //prepare input values for writing to the encounter form
                            textOnEncounter =  textOnEncounter + inputType + "    " + inputValue + " " + mInstrc + " " + comments + "\\n";                             
                            
                        }
                                            
                    }
                    textOnEncounter = textOnEncounter + "**********************************************************************************\\n";
                    System.out.println(textOnEncounter);
                }
                else{                                        
                    String groupName = (String) frm.getValue("groupName");
                    String css = (String) frm.getValue("css");
                    request.setAttribute("groupName", groupName);
                    request.setAttribute("css", css);
                    return (new ActionForward(mapping.getInput()));
                }
                /* select the correct db specific command */
                String db_type = OscarProperties.getInstance().getProperty("db_type").trim();
                String dbSpecificCommand;
                if (db_type.equalsIgnoreCase("mysql")) {
                    dbSpecificCommand = "SELECT LAST_INSERT_ID()";
                } 
                else if (db_type.equalsIgnoreCase("postgresql")){
                    dbSpecificCommand = "SELECT CURRVAL('consultationrequests_numeric')";
                }
                else
                    throw new SQLException("ERROR: Database " + db_type + " unrecognized.");
                                    
                db.CloseConn();
                
            }
            catch(SQLException e)
            {
                System.out.println(e.getMessage());
            }
            
        
        //put the inputvalue to the encounter form
        session.setAttribute( "textOnEncounter", textOnEncounter );    
        return mapping.findForward("success");
    }

     
}
