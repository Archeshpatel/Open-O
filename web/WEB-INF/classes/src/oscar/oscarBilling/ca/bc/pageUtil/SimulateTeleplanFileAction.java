/*
 *  Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 *  This software is published under the GPL GNU General Public License.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 *  Jason Gallagher
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada
 *
 * GenerateTeleplanFileAction.java
 *
 * Created on January 21, 2007, 6:05 PM
 *
 */

package oscar.oscarBilling.ca.bc.pageUtil;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import oscar.Misc;
import oscar.OscarProperties;
import oscar.oscarBilling.ca.bc.MSP.TeleplanFileWriter;
import oscar.oscarBilling.ca.bc.MSP.TeleplanSubmission;
import oscar.oscarBilling.ca.bc.data.BillActivityDAO;
import oscar.oscarProvider.data.ProviderData;
import oscar.util.UtilDateUtilities;


/**
 * Action Simulates a MSP teleplan file but doesn't commit any of the data. 
 * 
 * @author jay
 */
public class SimulateTeleplanFileAction extends Action{
    
    /**
     * Creates a new instance of GenerateTeleplanFileAction
     */
    public SimulateTeleplanFileAction() {
    }
    
    public ActionForward execute(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response) throws Exception{
        String dataCenterId = OscarProperties.getInstance().getProperty("dataCenterId");
        
        String providerNo = request.getParameter("user");
        String provider = request.getParameter("provider");
        String providerBillingNo = request.getParameter("provider");
        if(provider != null && provider.equals("all")){
          providerBillingNo = "%";    
        }
        ProviderData pd = new ProviderData();
        List list = pd.getProviderListWithInsuranceNo(providerBillingNo);
        
        ProviderData[] pdArr = new ProviderData[list.size()];
        
        for (int i=0;i < list.size(); i++){
            String provNo = (String) list.get(i);
            pdArr[i] = new ProviderData(provNo);
        }
        //This needs to be replaced for sim
        boolean testRun = true;
        //To prevent multiple submissions being generated at the same time
        synchronized (this)  { 
            try{
               TeleplanFileWriter teleplanWr = new TeleplanFileWriter();  
               TeleplanSubmission submission = teleplanWr.getSubmission(testRun,pdArr,dataCenterId);
               response.getWriter().print(submission.getHtmlFile());
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return null;
    }
}