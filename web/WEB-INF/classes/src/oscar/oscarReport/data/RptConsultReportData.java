package oscar.oscarReport.data;

import oscar.oscarDB.*;
import java.sql.*;
import java.util.*;
/**
*This classes main function ConsultReportGenerate collects a group of patients with consults in the last specified date
*/
public class RptConsultReportData {

    public ArrayList demoList = null;
    public String days = null;


    public RptConsultReportData() {
    }

    public ArrayList providerList(){
        ArrayList arrayList = new ArrayList();
        try{

              DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
              ResultSet rs;
              String sql = "select provider_no, last_name, first_name from provider where provider_type = 'doctor' order by last_name";
              rs = db.GetSQL(sql);
              while (rs.next()) {
                 ArrayList a = new ArrayList (); 
                 a.add( rs.getString("provider_no") );
                 a.add( rs.getString("last_name") +", "+ rs.getString("first_name") );
                 arrayList.add(a);
              }
              rs.close();
              db.CloseConn();
        }catch (java.sql.SQLException e){ System.out.println("Problems");   System.out.println(e.getMessage());  }
    return arrayList;
    }

    public void consultReportGenerate( String providerNo, String days ){
       this.days = days;
       try{
              
              DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
              ResultSet rs;
              // mysql function for dates = select date_sub(now(),interval 1 month); 
              String sql = "select distinct c.demographicNo from consultationRequests c , demographic d where "
                          +" referalDate >= (CURRENT_DATE - interval " + days + " month)"
                          +" and c.demographicNo = d.demographic_no ";
              if (!providerNo.equals("-1")){
                 sql = sql +" and d.provider_no = '"+providerNo+"' "; 
              }
              sql = sql + "  order by d.last_name ";



              //String sql = " Select distinct demographicNo from consultationRequests where to_days(now()) - to_days(referalDate) <= 30 ";
              rs = db.GetSQL(sql);
              demoList = new ArrayList();
              DemoConsultDataStruct d;
              while (rs.next()) {
                d = new DemoConsultDataStruct();
                d.demoNo = rs.getString("demographicNo");
                demoList.add(d);
              }

              rs.close();
              db.CloseConn();
        }catch (java.sql.SQLException e){ System.out.println("Problems");   System.out.println(e.getMessage());  }


    }

/**
*This is a inner class that stores info on demographics.  It will get Consult letters that have been scanned and consults for the patient
*/
public class DemoConsultDataStruct{
   public String demoNo;
    ArrayList consultList;
    ArrayList conReplyList;

    public ArrayList getConsults(){
       try{
          DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
          java.sql.ResultSet rs;
          String sql = " select * from consultationRequests where demographicNo = '"+demoNo+"' "
                      +" and to_days(now()) - to_days(referalDate) <=  "
                      +" (to_days( now() ) - to_days( date_sub( now(), interval "+days+" month ) ) )";
          rs = db.GetSQL(sql);
          Consult con; 
          consultList = new ArrayList();
          while (rs.next()){
             con = new Consult(); 
             con.requestId   = rs.getString("requestId");
             con.referalDate = rs.getString("referalDate");
             con.serviceId   = rs.getString("serviceId");
             con.specialist  = rs.getString("specId");
             con.appDate     = rs.getString("appointmentDate");
             consultList.add(con);
          }
          rs.close();
          db.CloseConn();
       }catch (java.sql.SQLException e2) { System.out.println(e2.getMessage()); }
      return consultList;
    }
    public ArrayList getConReplys(){

       try{
          DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
          ResultSet rs;
          String sql = "select d.document_no, d.docdesc,d.docfilename, d.updatedatetime, d.status  from ctl_document c, document d where c.module = 'demographic' and c.document_no = d.document_no and d.doctype = 'consult' and module_id = '"+demoNo+"' ";
          rs = db.GetSQL(sql);
          ConLetter conLetter;
          conReplyList = new ArrayList();
          while( rs.next()){
             conLetter = new ConLetter();
             conLetter.document_no = rs.getString("document_no"); 
             conLetter.docdesc     = rs.getString("docdesc");
             conLetter.docfileName = rs.getString("docfilename");
             conLetter.docDate     = rs.getDate("updatedatetime");     
             conLetter.docStatus   = rs.getString("status");
             conReplyList.add(conLetter);
          }         
          rs.close();
          db.CloseConn(); 
       }catch (java.sql.SQLException e3) { System.out.println(e3.getMessage()); }
    return conReplyList;
    }

    public String getDemographicName(){
       String retval = "&nbsp;";
       try{
           DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
           ResultSet rs;
           String sql = "Select last_name, first_name from demographic where demographic_no = '"+demoNo+"' ";
           rs = db.GetSQL(sql);
           if (rs.next()){
              retval = rs.getString("last_name")+", "+rs.getString("first_name");
           }
           rs.close();
           db.CloseConn();
       }catch ( java.sql.SQLException e4) { System.out.println(e4.getMessage()); }
       return retval;
    }

    public String getService(String serId){
       String retval = "";
       try{
           DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
           ResultSet rs;
           String sql = "Select serviceDesc from consultationServices where serviceId = '"+serId+"' ";
           rs = db.GetSQL(sql);
           if (rs.next()){
              retval = rs.getString("last_name")+", "+rs.getString("first_name");
           }
           rs.close();
           db.CloseConn();
       }catch ( java.sql.SQLException e4) { System.out.println(e4.getMessage()); }
       return retval;
    }

    public String getSpecialist(String specId){
        String retval = "";
       try{
           DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
           ResultSet rs;
           String sql = "Select lname, fname from professionalSpecialists where specId = '"+specId+"' ";
           rs = db.GetSQL(sql);
           if (rs.next()){
              retval = rs.getString("lname")+", "+rs.getString("fname");
           }
           rs.close();
           db.CloseConn();
       }catch ( java.sql.SQLException e4) { System.out.println(e4.getMessage()); }
       return retval;
    }

    
  public final class Consult{
     public  String requestId;
     public  String referalDate;
     public  String serviceId;
     public  String specialist;
     public  String appDate;

      public String getService(String serId){
       String retval = "&nbsp;";
       try{
           DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
           ResultSet rs;
           String sql = "Select serviceDesc from consultationServices where serviceId = '"+serId+"' ";
           rs = db.GetSQL(sql);
           if (rs.next()){
              retval = rs.getString("serviceDesc");
           }
           rs.close();
           db.CloseConn();
       }catch ( java.sql.SQLException e4) { System.out.println(e4.getMessage()); }
       return retval;
    }

    public String getSpecialist(String specId){
        String retval = "&nbsp;";
       try{
           DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
           ResultSet rs;
           String sql = "Select lname, fname from professionalSpecialists where specId = '"+specId+"' ";
           rs = db.GetSQL(sql);
           if (rs.next()){
              retval = rs.getString("lname")+", "+rs.getString("fname");
           }
           rs.close();
           db.CloseConn();
       }catch ( java.sql.SQLException e4) { System.out.println(e4.getMessage()); }
       return retval;
    }

  };
  public final class ConLetter{
     public String document_no;
     public String docdesc;
     public String docfileName;
     public String docStatus;
     public java.sql.Date   docDate;
  };


};
}
