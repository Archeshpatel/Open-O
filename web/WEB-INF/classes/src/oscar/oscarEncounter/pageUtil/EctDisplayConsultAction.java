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

package oscar.oscarEncounter.pageUtil;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import org.apache.struts.util.MessageResources;
import oscar.util.DateUtils;
import oscar.util.StringUtils;

/**
 *
 * Retrieves consultation requests for demographic
 */
public class EctDisplayConsultAction extends EctDisplayAction {
         private String cmd = "consultation";
 
         public boolean getInfo(EctSessionBean bean, HttpServletRequest request, NavBarDisplayDAO Dao, MessageResources messages) {
            String winName = "Consultation" + bean.demographicNo;
            String url = "popupPage(700,960,'" + winName + "','" + request.getContextPath() + "/oscarEncounter/oscarConsultationRequest/DisplayDemographicConsultationRequests.jsp?de=" + bean.demographicNo + "');return false;";
            String header = "<h3><a href=\"#\" onclick=\"" + url + "\">" + messages.getMessage("global.consultations") + "</a></h3>";
            Dao.setLeftHeading(header);
            
            oscar.oscarEncounter.oscarConsultationRequest.pageUtil.EctViewConsultationRequestsUtil theRequests;
            theRequests = new  oscar.oscarEncounter.oscarConsultationRequest.pageUtil.EctViewConsultationRequestsUtil();
            theRequests.estConsultationVecByDemographic(bean.demographicNo);
                    
            String dbFormat = "yyyy-MM-dd";
            String serviceDateStr;
            for (int idx = theRequests.ids.size() - 1; idx >= 0; --idx ){
                NavBarDisplayDAO.Item item = Dao.Item();
                String service = (String) theRequests.service.get(idx);
                String dateStr    = (String) theRequests.date.get(idx);
                DateFormat formatter = new SimpleDateFormat(dbFormat);
                try {
                    Date date = (Date)formatter.parse(dateStr);
                    serviceDateStr = DateUtils.getDate(date, dateFormat);
                }
                catch(ParseException ex ) {
                    System.out.println("EctDisplayConsultationAction: Error creating date " + ex.getMessage());
                    serviceDateStr = "Error";
                }
                url = "popupPage(700,960,'" + winName + "','" + request.getContextPath() + "/oscarEncounter/ViewRequest.do?de=" + bean.demographicNo + "&requestId=" + (String)theRequests.ids.get(idx) + "'); return false;";
                service = StringUtils.maxLenString(service, MAX_LEN_TITLE, CROP_LEN_TITLE, ELLIPSES);
                item.setTitle(service + " " + serviceDateStr);
                item.setURL(url);
                Dao.addItem(item);
            } 
            
            return true;
         }
         
        public String getCmd() {
            return cmd;
        }
}
