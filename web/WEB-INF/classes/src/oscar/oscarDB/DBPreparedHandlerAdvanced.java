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
package oscar.oscarDB;

import java.sql.*;


public class DBPreparedHandlerAdvanced extends DBPreparedHandler {
    public DBPreparedHandlerAdvanced(String dbDriver, String dbName,
        String dbUser, String dbPwd) throws SQLException {
        super(dbDriver, dbName, dbUser, dbPwd);
    }

	synchronized public void setAutoCommit(boolean flag)
		throws SQLException {
		this.conn.setAutoCommit(flag);
	}

	synchronized public void rollback()
		throws SQLException {
		this.conn.rollback();
	}

	synchronized public void commit()
		throws SQLException {
		this.conn.commit();
	}

    synchronized public PreparedStatement getPrepareStatement(
        String preparedSQL) throws SQLException {
        return conn.prepareStatement(preparedSQL);
    }

    synchronized public int execute(PreparedStatement preparedSQL)
        throws SQLException {
        return preparedSQL.executeUpdate();
    }
}
