/*
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
package oscar.dms;

import oscar.oscarTags.*;
import oscar.util.*;
import java.util.Date;

public class EDoc extends TagObject {
    private String docId;
    private String description = "";
    private String dateTimeStamp = "";
    private String type = "";
    private String fileName = "";
    private String html = "";
    private String creatorId = "";
    private char status;
    private String module = "";
    private String moduleId = "";
    private String docPublic = "0";
    private String contentType = "";
    private String observationDate = "";
    
    /** Creates a new instance of EDoc */
    public EDoc() {
    }
    
    public EDoc(String description, String type, String fileName, String html, String creatorId, char status, String observationDate, String module, String moduleId) {
        this.setDescription(description.trim());
        this.setType(type.trim());
        this.setFileName(fileName.trim());
        this.setHtml(html);
        this.setCreatorId(creatorId.trim());
        this.setStatus(status);
        this.setModule(module.trim());
        this.setModuleId(moduleId.trim());
        this.setObservationDate(observationDate);
        preliminaryProcessing();
    }
    
    
    private void preliminaryProcessing() {
        this.dateTimeStamp = EDocUtil.getDmsDateTime();
        if (fileName.length() != 0) {
            String filenamePrefix = UtilDateUtilities.DateToString(UtilDateUtilities.now(), "yyyyMMdd") + UtilDateUtilities.DateToString(UtilDateUtilities.now(), "HHmmss");
            this.fileName = filenamePrefix + fileName;
        }
    }
    
    //Getter/Setter methods...

    public String getDocId() {
        return docId;
    }

    public void setDocId(String docId) {
        this.docId = docId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDateTimeStamp() {
        return dateTimeStamp;
    }

    public void setDateTimeStamp(String dateTimeStamp) {
        this.dateTimeStamp = dateTimeStamp;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getModuleId() {
        return moduleId;
    }

    public void setModuleId(String moduleId) {
        this.moduleId = moduleId;
    }
    
    public String getModuleName() {
        String moduleName = EDocUtil.getModuleName(module, moduleId);
        return moduleName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getHtml() {
        return html;
    }

    public void setHtml(String html) {
        this.html = html;
    }

    public String getCreatorId() {
        return creatorId;
    }
    
    public String getCreatorName() {
        String creatorName = EDocUtil.getModuleName("provider", creatorId);
        return creatorName;
    }

    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }

    public char getStatus() {
        return status;
    }

    public void setStatus(char status) {
        this.status = status;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getDocPublic() {
        return docPublic;
    }

    //docPublic = "checked" for the edoc to be public
    public void setDocPublic(String docPublic) {
        if (docPublic.equalsIgnoreCase("checked"))
            this.docPublic = "1";
        else if ((docPublic == null || docPublic.equals(""))) 
            this.docPublic = "0";
        else 
            this.docPublic = docPublic;
    }
    
    /**
     *Returns true if document a PDF.
     */
    public boolean isPDF(){
        if ( this.contentType != null && this.contentType.equalsIgnoreCase("application/pdf")){
            return true;
        }
        return false;
    }

    public String getObservationDate() {
        return observationDate;
    }

    public void setObservationDate(String observationDate) {
        this.observationDate = observationDate;
    }
    
    public void setObservationDate(Date observationDate) {
        String formattedDate = UtilDateUtilities.DateToString(observationDate, EDocUtil.DMS_DATE_FORMAT);
        this.observationDate = formattedDate;
    }
}
