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
 * Jason Gallagher
 * 
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */ 

/*
 * SurveillanceAnswerAction.java
 *
 * Created on September 10, 2004, 8:07 PM
 */

package oscar.oscarSurveillance;

import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.struts.action.*;

/**
 *
 * @author  Jay Gallagher
 */
public class SurveillanceAnswerAction extends Action {
   
   /** Creates a new instance of SurveillanceAnswerAction */
   public SurveillanceAnswerAction() {
   }
   
   public ActionForward execute(ActionMapping mapping,
				ActionForm form,
				HttpServletRequest request,
				HttpServletResponse response) throws IOException, ServletException {
                                   
      SurveillanceAnswerForm frm = (SurveillanceAnswerForm) form;                                   
                                 
      String answer      = frm.getAnswer();
      String surveyId    = frm.getSurveyId();
      String demographic = frm.getDemographicNo();
      String provider    = (String) request.getSession().getAttribute("user");
      String currentSurveyNum = frm.getCurrentSurveyNum();
      
      SurveillanceMaster sir = SurveillanceMaster.getInstance();
      
      Survey survey = sir.getSurveyById(surveyId);
        
      
      survey.processAnswer(provider, demographic,answer);
      
      System.out.println("Survey: "+surveyId+" answer "+answer);
      
      String proceed = frm.getProceed();
      String proceedURL = URLDecoder.decode(proceed);      
      
      ActionForward forward = new ActionForward();
                    forward.setPath(proceedURL);
                    forward.setRedirect(true);
      
      if (currentSurveyNum != null){
         try{
            int num = Integer.parseInt(currentSurveyNum);            
            if (num < sir.numSurveys() ){
               request.setAttribute("currentSurveyNum",  currentSurveyNum);
               forward = mapping.findForward("survey");
               String newURL = forward.getPath()+"?demographicNo="+demographic+"&proceed="+URLEncoder.encode(proceed);  
               System.out.println("sending to: "+newURL);
               forward.setPath(newURL);                                 
               forward.setRedirect(true);
            }
         }catch (Exception e){ }
      }
      
      
                    
      return forward;
   }
   
   
   
}
