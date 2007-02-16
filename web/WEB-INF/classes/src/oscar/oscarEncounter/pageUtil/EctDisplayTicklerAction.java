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

 
import oscar.oscarTickler.TicklerData;
import oscar.util.DateUtils;
import oscar.util.StringUtils;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.util.MessageResources;
import org.apache.commons.lang.StringEscapeUtils;

//import oscar.oscarSecurity.CookieSecurity;

public class EctDisplayTicklerAction extends EctDisplayAction {
    private static final String cmd = "tickler";
    
 public boolean getInfo(EctSessionBean bean, HttpServletRequest request, NavBarDisplayDAO Dao, MessageResources messages) {
                      
 try {         

    //Set lefthand module heading and link
    String winName = "ViewTickler" + bean.demographicNo;
    String url = "popupPage(500,900,'" + winName + "','" + request.getContextPath() + "/tickler/ticklerDemoMain.jsp?demoview=" + bean.demographicNo + "&parentAjaxId=" + cmd + "')";
    Dao.setLeftHeading(messages.getMessage("global.viewTickler"));
    Dao.setLeftURL(url);        
    
    //set right hand heading link
    winName = "AddTickler" + bean.demographicNo;
    url = "popupPage(500,600,'" + winName + "','" + request.getContextPath() + "/appointment/appointmentcontrol.jsp?keyword=" + URLEncoder.encode(bean.patientLastName + "," + bean.patientFirstName,"UTF-8") + "&displaymode=" + URLEncoder.encode("Search ", "UTF-8") + "&search_mode=search_name&originalpage=" + URLEncoder.encode(request.getContextPath() + "/tickler/ticklerAdd.jsp", "UTF-8") + "&orderby=last_name&appointment_date=2000-01-01&limit1=0&limit2=5&status=t&start_time=10:45&end_time=10:59&duration=15&dboperation=add_apptrecord&type=&demographic_no=" + bean.demographicNo + "&parentAjaxId=" + cmd + "&updateParent=false'); return false;";
    Dao.setRightURL(url);
    Dao.setRightHeadingID(cmd); //no menu so set div id to unique id for this action
        
    String dateBegin = "0001-01-01";
    String dateEnd = "9999-12-31";        
     
    TicklerData tickler = new TicklerData();
    ResultSet rs = tickler.listTickler(bean.demographicNo, TicklerData.ACTIVE, dateBegin, dateEnd);
    
    Date serviceDate;
    Date today = new Date(System.currentTimeMillis());
    String itemHeader;    
    int hash;
    long days;
    while(rs.next()) {
        NavBarDisplayDAO.Item item = Dao.Item();                        
        serviceDate = rs.getDate("service_date");
        item.setDate(serviceDate);
        days = (today.getTime() - serviceDate.getTime())/(1000*60*60*24);
        if( days > 0 )
            item.setColour("FF0000");
            
        itemHeader = StringUtils.maxLenString(rs.getString("message"), MAX_LEN_TITLE, CROP_LEN_TITLE, ELLIPSES) + " " + DateUtils.getDate(serviceDate,dateFormat);                      
        item.setLinkTitle(itemHeader);        
        item.setTitle(itemHeader);
        winName = StringUtils.maxLenString(rs.getString("message"), MAX_LEN_TITLE, MAX_LEN_TITLE, "");                
        hash = Math.abs(winName.hashCode());        
        url = "popupPage(500,900,'" + hash + "','" + request.getContextPath() + "/tickler/ticklerDemoMain.jsp?demoview=" + bean.demographicNo + "&parentAjaxId=" + cmd + "'); return false;";        
        item.setURL(url);        
        Dao.addItem(item);

    }
    
     Dao.sortItems(NavBarDisplayDAO.DATESORT);
 }catch( Exception e ) {
     System.out.println("Error retrieving " + cmd + " : " + e.getMessage());
     e.printStackTrace();
     return false;
 }
    return true;
        
  }
 
 public String getCmd() {
     return cmd;
 }
}
