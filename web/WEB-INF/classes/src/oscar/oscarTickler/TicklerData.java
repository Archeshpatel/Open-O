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
 * Ontario, Canada   Creates a new instance of TicklerData
 * 
 *
 * TicklerData.java
 *
 * Created on July 20, 2005, 1:45 PM
 */

package oscar.oscarTickler;

import java.sql.*;
import org.apache.commons.lang.*;
import oscar.oscarDB.*;

/**
 *
 * @author Jay Gallagher
 */
public class TicklerData {
   
   public static String ACTIVE  = "A";
   public static String COMPLETED = "C";
   public static String DELETED = "D";
      
   public static String HIGH = "High";
   public static String NORMAL = "Normal";
   public static String LOW = "Low";
   
   public TicklerData() {
   }
   
   public void addTickler(String demographic_no,String message,String status,String service_date,String creator,String priority,String task_assigned_to){
            
      String date = service_date;
      if ( date != null && !date.equals("now()")){          //Just a hack for now.
         date = "'"+StringEscapeUtils.escapeSql(service_date)+"'";
      }
      
      String sql = "insert into tickler (demographic_no, message, status, update_date, service_date, creator, priority, task_assigned_to) "
                  +" values "
                  +"('"+StringEscapeUtils.escapeSql(demographic_no)+"', "
                  +" '"+StringEscapeUtils.escapeSql(message)+"', "
                  +" '"+StringEscapeUtils.escapeSql(status)+"', "
                  //+" '"+StringEscapeUtils.escapeSql(demographic_no)+"', "
                  +" now(), "                    
                  +" "+date+", "
                  +" '"+StringEscapeUtils.escapeSql(creator)+"', "
                  +" '"+StringEscapeUtils.escapeSql(priority)+"', "
                  +" '"+StringEscapeUtils.escapeSql(task_assigned_to)+"')";  
      //System.out.println(sql);
      try {         
         DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            db.RunSQL(sql);            
            db.CloseConn();         
      } catch (SQLException e) {         
         System.out.println(e.getMessage());
         e.printStackTrace();
      }      
   }
   
   public boolean hasTickler(String demographic,String task_assigned_to,String message){
      boolean hastickler = false;
      try {         
         DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
         String sql = "select * from tickler  where demographic_no = '"+StringEscapeUtils.escapeSql(demographic)+"' "
                     +" and task_assigned_to = '"+StringEscapeUtils.escapeSql(task_assigned_to)+"' "
                     +" and message = '"+StringEscapeUtils.escapeSql(message)+"'";
         //System.out.println(sql);
         ResultSet rs = db.GetSQL(sql);
         if (rs.next()){
            hastickler = true;
         }
         rs.close();
         db.CloseConn();         
      } catch (SQLException e) {
         System.out.println(e.getMessage());
         e.printStackTrace();
      }      
      return hastickler;
   }
   
}
