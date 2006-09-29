/*
 *  Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
 *  This software is published under the GPL GNU General Public License.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version. *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
 *
 *  Jason Gallagher
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada   
 *
 * ScratchData.java
 *
 * Created on September 2, 2006, 7:30 PM
 *
 */

package oscar.scratch;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import oscar.oscarDB.DBHandler;

/**
 create table scratch_pad (
           id int(10) not null auto_increment primary key,
           provider_no varchar(6),
           date_time datetime,
           scratch_text text
       );
 * @author jay
 */
public class ScratchData {
    
    /** Creates a new instance of ScratchData */
    public ScratchData() {
    }
    
    public Hashtable getLatest(String providerNo){
        Hashtable retval = null;
        try {
            //Get Provider from database
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT * FROM scratch_pad WHERE provider_no = '" + providerNo + "' order by id  desc limit 1";
            rs = db.GetSQL(sql);
   
            if (rs.next()){
                retval = new Hashtable();
                retval.put("id",rs.getString("id"));
                retval.put("text",rs.getString("scratch_text"));
                retval.put("date",rs.getString("date_time"));
            }
            rs.close();
            db.CloseConn();
        } catch (SQLException e) {
           e.printStackTrace();
        }
        return retval;
    }
    
    public String insert(String providerNo,String text){
        String scratch_id = null;
        try {
            //Get Provider from database
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "INSERT into scratch_pad (provider_no, scratch_text,date_time ) values ('" + providerNo + "','"+text+"',now())";
            db.RunSQL(sql);
            rs = db.GetSQL("SELECT LAST_INSERT_ID() ");
   
            if(rs.next()){
               scratch_id = Integer.toString( rs.getInt(1) );
            }
            rs.close();
            db.CloseConn();
        } catch (SQLException e) {
           e.printStackTrace();
        }
        return scratch_id;
    }
    
}
