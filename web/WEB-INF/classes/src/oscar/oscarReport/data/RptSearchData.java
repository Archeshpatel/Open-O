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
 * Ontario, Canada   Creates a new instance of DemographicSets
 *
 *
 */

package oscar.oscarReport.data;


import oscar.oscarDB.*;
/**
 *
 * @author  McMaster
 */
public class RptSearchData {

    java.util.ArrayList rosterTypes;
    java.util.ArrayList patientTypes;
    java.util.ArrayList savedQueries;

    /**
     *This function runs through the demographic table and retrieves all the roster types currently being used
     * @return  ArrayList  of roster status types in the demographic table*/
    public java.util.ArrayList getRosterTypes(){
            java.util.ArrayList retval = new java.util.ArrayList();
         try{
              DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
              java.sql.ResultSet rs;
              rs = db.GetSQL("select distinct roster_status from demographic order by roster_status");

              while (rs.next()) {
                retval.add( rs.getString("roster_status") );
                //System.out.println("roster "+rs.getString("roster_status"));
              }
              rs.close();
              db.CloseConn();
            }catch (java.sql.SQLException e){ System.out.println(e.getMessage()); }
            return retval;
    }

    /**
     * @return  */
    public java.util.ArrayList getPatientTypes(){
            java.util.ArrayList retval = new java.util.ArrayList();
         try{
              DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
              java.sql.ResultSet rs;
              rs = db.GetSQL("select distinct patient_status from demographic order by patient_status");

              while (rs.next()) {
                retval.add( rs.getString("patient_status") );
                //System.out.println("patient "+rs.getString("patient_status"));
              }
              rs.close();
              db.CloseConn();
            }catch (java.sql.SQLException e){ System.out.println(e.getMessage()); }
            return retval;
    }

    public java.util.ArrayList getProvidersWithDemographics(){
            java.util.ArrayList retval = new java.util.ArrayList();
         try{
              DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
              java.sql.ResultSet rs;
              rs = db.GetSQL("select distinct provider_no from demographic order by provider_no");

              while (rs.next()) {
                retval.add( rs.getString("provider_no") );
                //System.out.println("patient "+rs.getString("patient_status"));
              }
              rs.close();
              db.CloseConn();
            }catch (java.sql.SQLException e){ System.out.println(e.getMessage()); }
            return retval;
    }

    public java.util.ArrayList getQueryTypes(){
            java.util.ArrayList retval = new java.util.ArrayList();
         try{
              DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
              java.sql.ResultSet rs;
              rs = db.GetSQL("select favId, queryName from demographicQueryFavourites where archived = '1' order by queryName");

              while (rs.next()) {
                SearchCriteria sc = new SearchCriteria();
                sc.id = rs.getString("favId");
                sc.queryName = rs.getString("queryName");

                retval.add( sc );
                //System.out.println("patient "+rs.getString("patient_status"));
              }
              rs.close();
              db.CloseConn();
            }catch (java.sql.SQLException e){ System.out.println(e.getMessage()); }
            return retval;
    }


////////////////////////////////////////////////////////////////////////////////
public class Demographic {

    public String demographic_no;

    public String last_name;

    public String first_name;

    public String address;

    public String city;

    public String province;

    public String postal;

    public String phone;

    public String phone2;

    public String year_of_birth;

    public String month_of_birth;

    public String date_of_birth;

    public String hin;

    public String ver;

    public String roster_status;

    public String patient_status;

    public String date_joined;

    public String chart_no;

    public String provider_no;

    public String sex;

    public String end_date;

    public String eff_date;

    public String pcn_indicator;

    public String hc_type;

    public String hc_renew_date;

    public String family_doctor;
};

public class SearchCriteria {
    public String id;
    public String queryName;
};
}