/*
 * MspErrorCodes.java
 *
 * Created on June 20, 2004, 6:41 PM
 */


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
 * <OSCAR TEAM> 
 * 
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */ 


package oscar.oscarBilling.ca.bc.MSP;

import java.io.*;
import java.util.*;

public class MspErrorCodes extends Properties{
   
   /** Creates a new instance of MspErrorCodes */
   public MspErrorCodes() {         
      try {
            load(new FileInputStream(oscar.OscarProperties.getInstance().getProperty("MSP_EDIT_CODES"))); 
      } catch (IOException e) {
		e.printStackTrace();
                System.out.println("Error loading MSP Error codes file");
      }      
   }
   
}
