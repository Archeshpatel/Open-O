/**
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
 * Ontario, Canada   Creates a new instance of CMLLabTest
 *   
 *
 * CMLLabTest.java
 *
 * Created on April 22, 2005, 10:52 AM
 */

package oscar.oscarLab.ca.on.CML;

import java.sql.*;
import java.text.*;
import java.util.*;
import oscar.oscarDB.*;
import oscar.oscarLab.ca.on.*;
import oscar.util.*;

/**
 *
 * @author Jay Gallagher
 */
public class CMLLabTest {
   
      public String locationId = null; //  2. (e.g. 70 = CML Mississauga)
      public String printDate  = null; //  3. YYYYMMDD
      public String printTime  = null; //  4. HH:MM
      public String totalBType = null; //  5. number of ‘B-type’ lines (= # of reports)
      public String totalCType = null; //  6. number of ‘C-type’ lines
      public String totalDType = null; //  7. number of ‘D-type’ lines
   
      
      public String accessionNum = null;        //  2. CML Accession number (minus first char)
      public String physicianAccountNum = null; //  3. Physician Account number
      public String serviceDate = null;         //  4. YYYYMMDD
      public String pFirstName = null;          //  5. Patient: First name
      public String pLastName = null;           //  6. Patient: Last name
      public String pSex = null;                //  7. Sex ‘F’ or ‘M’
      public String pHealthNum = null;          //  8. Patient: Health number
      public String pDOB = null;                //  9. Patient: Birth date
      public String status = null;              // 10. Final or Partial ‘F’ or ‘P’
      public String docNum = null;              // 11. Physician: Number
      public String docName = null;             // 12. Physician: Name
      public String docAddr1 = null;            // 13. Physician: Address line 1
      public String docAddr2 = null;            // 14. Physician: Address line 2
      public String docAddr3 = null;            // 15. Physician: Address line 3
      public String docPostal = null;           // 16. Physician: Postal code
      public String docRoute = null;            // 17. Physician: Route number
      public String comment1 = null;            // 18. Comment 1
      public String comment2 = null;            // 19. Comment 2
      public String pPhone = null;              // 20. Patient: Phone number
      public String docPhone = null;            // 21. Physician: Phone number
      public String collectionDate = null;      // 22. Collection date "DD MMM YY"
      
      public String labReportInfoId = null;
      
      public String labID= null;
      
      public ArrayList labResults = null;
      
      public String demographicNo = null;
   
   public CMLLabTest() {
   }
   
   public String getAge(){       
      return getAge(this.pDOB);
   }
   
   public String getAge(String s){       
       String age = "N/A";
       try {
          // Some examples
          DateFormat formatter = new SimpleDateFormat("yyyyMMdd");
          java.util.Date date = (java.util.Date)formatter.parse(s);
          age = UtilDateUtilities.calcAge(date);
       } catch (ParseException e) {
       }
      return age;      
   }
   
   public String getDemographicNo(){
      return demographicNo;
   }
   
   private void populateDemoNo(String labId){
      try{
         DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
         ResultSet rs = db.GetSQL("select demographic_no from patientLabRouting where lab_no = '"+labId+"' and lab_type = 'CML'");                   
         System.out.println("select demographic_no from patientLabRouting where lab_no = '"+labId+"' and lab_type = 'CML'");                   
         if (rs.next()){                                    
            String d = rs.getString("demographic_no");
            System.out.println("dd "+d);
            if ( !"0".equals(d)){
               this.demographicNo = d;
            }                        
         }         
         rs.close();
         db.CloseConn();
         
      }catch(Exception e){
         e.printStackTrace();
      }
      System.out.println("going out "+this.demographicNo);
   }
   
   public void populateLab(String labid){
      labID = labid;
      
      System.out.println("lab id "+labid);
      try{
         DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
         ResultSet rs = db.GetSQL("select * from labPatientPhysicianInfo where id = '"+labid+"'"); 
         
         
         if (rs.next()){                        
            this.labReportInfoId = rs.getString("labReportInfo_id");
            this.accessionNum = rs.getString("accession_num");
            this.physicianAccountNum = rs.getString("physician_account_num");
            this.serviceDate = rs.getString("service_date");
            this.pFirstName = rs.getString("patient_first_name");
            this.pLastName = rs.getString("patient_last_name");
            this.pSex = rs.getString("patient_sex");
            this.pHealthNum = rs.getString("patient_health_num");
            this.pDOB = rs.getString("patient_dob");
            this.status = rs.getString("lab_status");
            this.docNum = rs.getString("doc_num");
            this.docName = rs.getString("doc_name");
            this.docAddr1 = rs.getString("doc_addr1");
            this.docAddr2 = rs.getString("doc_addr2");
            this.docAddr3 = rs.getString("doc_addr3");
            this.docPostal = rs.getString("doc_postal");
            this.docRoute = rs.getString("doc_route");
            this.comment1 = rs.getString("comment1");
            this.comment2 = rs.getString("comment2");
            this.pPhone = rs.getString("patient_phone");
            this.docPhone = rs.getString("doc_phone");
            this.collectionDate = rs.getString("collection_date");                                                                                                
            System.out.println(" lab id "+labReportInfoId);
         }
         
         rs.close();
         db.CloseConn();
         
      }catch(Exception e){
         e.printStackTrace();
      }
      
      if (labReportInfoId != null){
         System.out.println(" filling labReport Info");
         populateLabReportInfo(labReportInfoId);
      }
      
      if (labid != null){         
         System.out.println("Filling lab Result DAta");
         this.labResults =  populateLabResultData(labid);
      }
      
      if (labid != null ){
         populateDemoNo(labid);         
      }
         
   }
   
   public ArrayList getStatusArray(){
      CommonLabResultData comLab = new CommonLabResultData();
      return comLab.getStatusArray(labID,"CML");
   }
   
   public ArrayList getStatusArray(String labid){
      return new ArrayList();
   }
      
   private void populateLabReportInfo(String labid){
      //labID = labid;
      try{
         DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
         ResultSet rs = db.GetSQL("select * from labReportInformation where id = '"+labid+"'");          
         if (rs.next()){                        
            this.locationId = rs.getString("location_id");
            this.printDate = rs.getString("print_date");
            this.printTime = rs.getString("print_time");
            this.totalBType = rs.getString("total_BType");
            this.totalCType = rs.getString("total_CType");
            this.totalDType = rs.getString("total_DType");
         }         
         rs.close();
         db.CloseConn();         
      }catch(Exception e){
         e.printStackTrace();
      }         
   }
   
   
   private ArrayList populateLabResultData(String labid){
      ArrayList alist = new ArrayList();
      try{
         DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
         ResultSet rs = db.GetSQL("select * from labTestResults where labPatientPhysicianInfo_id = '"+labid+"'");          
         System.out.println("select * from labTestResults where labPatientPhysicianInfo_id = '"+labid+"'");
         while (rs.next()){             
            String lineType = rs.getString("line_type");
            System.out.println("line "+lineType);
            if (lineType != null){
               LabResult labRes = new LabResult();
                                             
               labRes.title = rs.getString("title");
               labRes.notUsed1 = rs.getString("notUsed1");            
               labRes.locationId = rs.getString("location_id");
               labRes.last = rs.getString("last");
               
               if(lineType.equals("C")){
                  labRes.notUsed2 = rs.getString("notUsed2");
                  labRes.testName = rs.getString("test_name");
                  labRes.abn = rs.getString("abn");
                  if(labRes.abn != null && labRes.abn.equals("N")){
                      labRes.abn = "";
                  }
                  labRes.minimum = rs.getString("minimum");
                  labRes.maximum = rs.getString("maximum");
                  labRes.units = rs.getString("units");
                  labRes.result = rs.getString("result");
               }else if (lineType.equals("D")){
                  labRes.description = rs.getString("description");
                  labRes.labResult = false;
               }
               alist.add(labRes);
            }                        
         }         
         rs.close();
         db.CloseConn();         
      }catch(Exception e){
         e.printStackTrace();
      }     
      return alist;
   }
   
   public class LabResult{
      
      boolean labResult = true;
      
      public boolean isLabResult(){ return labResult ;}
      public boolean isLabResultComment(){ return labResult ;}
     
      
      ///      
      public String title = null;       //  2. Title
      public String notUsed1 = null;    //  3. Not used ?
      public String notUsed2 = null;    //  4. Not used ?
      public String testName = null;    //  5. Test name
      public String abn  = null;     //  6. Normal/Abnormal ‘N’ or ‘A’
      public String minimum = null;     //  7. Minimum
      public String maximum = null;     //  8. Maximum
      public String units = null;       //  9. Units
      public String result = null;      // 10. Result
      public String locationId = null;  // 11. Location Id (Test performed at …)
      public String last = null;        // 12. Last ‘Y’ or ‘N’

      
      //String title = null;       // 2. Title
      //String notUsed1 = null;    // 3. not used ?
      public String description = null; // 4. Description/Comment
      //String locationId = null;  // 5. Location Id
      //String last = null;        // 6. Last ‘Y’ or ‘N’
      
      ///
      public String getReferenceRange(){
         String retval ="";
         if (minimum != null && maximum != null){
            if (!minimum.equals("") && !maximum.equals("")){
               if (minimum.equals(maximum)){
                 retval = minimum;
               }else{
                  retval = minimum + " - " + maximum;
               }
            }
         }
         return retval;
      }
      
   }
   
   public class GroupResults{
      public String groupName = null;
      private ArrayList labResults = null;
      
      public void addLabResult(LabResult l){
         if (labResults == null){ labResults = new ArrayList(); }
         labResults.add(l);
      }
      
      public ArrayList getLabResults(){
         return labResults;
      }
   }
   
   public ArrayList getGroupResults(ArrayList list){
      ArrayList groups = new ArrayList();
      String currentGroup = "";
      GroupResults gResults = null;
      System.out.println("start getGroupResults ... list size: "+list.size());
      for ( int i = 0; i < list.size(); i++){
         LabResult lab = (LabResult) list.get(i);
            System.out.println(" lab title "+lab.title+ " currentGroup "+currentGroup);
         if ( currentGroup.equals(lab.title) && gResults != null){              
            System.out.println("old");
            gResults.addLabResult(lab);
            gResults.groupName =  lab.title;
         }else{
            System.out.println("new");
            gResults = new GroupResults();            
            gResults.groupName = currentGroup = lab.title;
            groups.add(gResults);
            gResults.addLabResult(lab);   
            currentGroup = lab.title;
         }
      }
      return groups;
   }
}//end

   
   
   