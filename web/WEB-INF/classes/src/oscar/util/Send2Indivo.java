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
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada
 *
 * Send2Indivo.java
 *
 * Created on January 10, 2007, 3:43 PM 
 */

package oscar.util;

import java.util.Map;
import java.util.HashMap;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;

import org.indivo.IndivoException;
import org.indivo.client.ActionNotPerformedException;
import org.indivo.client.TalkClient;
import org.indivo.client.TalkClientImpl;
import org.indivo.xml.talk.AuthenticateResultType;

import org.indivo.xml.phr.urns.ContentTypeQNames;
import org.indivo.xml.phr.urns.DocumentClassificationUrns;

import org.indivo.xml.phr.contact.NameType;
import org.indivo.xml.phr.contact.ConciseContactInformationType;

import org.indivo.xml.phr.binarydata.BinaryDataType;
import org.indivo.xml.phr.binarydata.BinaryData;
import org.indivo.xml.phr.binarydata.ObjectFactory;

import org.indivo.xml.phr.document.IndivoDocumentType;
import org.indivo.xml.phr.document.DocumentHeaderType;
import org.indivo.xml.phr.document.ContentDescriptionType;

import org.indivo.xml.phr.medication.Medication;
import org.indivo.xml.phr.medication.MedicationType;

import org.indivo.xml.phr.types.CodedValueType;
import org.indivo.xml.phr.types.CodingSystemReferenceType;

import org.indivo.xml.talk.AddDocumentResultType;

import org.w3c.dom.Element;

import oscar.oscarRx.data.RxPrescriptionData.Prescription;

/**
 *
 * @author rjonasz
 */
public class Send2Indivo {
    
    private String indivoId;
    private String indivoPasswd;
    private String indivoFullName;
    private String indivoRole;
    private String sessionTicket;
    private String errorMsg;
    private Map connParams;
    private TalkClient client;
    
    /** Creates a new instance of Send2Indivo */
    public Send2Indivo(String id, String passwd, String fullName, String role) {
        indivoId = id;
        indivoPasswd = passwd;
        indivoFullName = fullName;
        indivoRole = role;
        errorMsg = null;
        
        connParams = new HashMap();
        connParams.put(TalkClient.CERT_TRUST_KEY, TalkClient.ALL_CERTS_ACCEPTED);
    }
    
    public void setServer(String addr) {        
        connParams.put(TalkClient.SERVER_LOCATION, addr);
    }
    
    public boolean authenticate() {
        try {
            
            client = new TalkClientImpl(connParams);
            AuthenticateResultType authResult = client.authenticate(indivoId, indivoPasswd);
            sessionTicket = authResult.getActorTicket();
            
        }
        catch(ActionNotPerformedException e ) {
            errorMsg = e.getMessage();
            System.out.println("INDIVO Error Authenticating: " + errorMsg);
            return false;
        }
        catch(IndivoException e ) {
            errorMsg = e.getMessage();
            System.out.println("INDIVO Authenticating Network Error: " + errorMsg);
            return false;
        }
        
        return true;
    }
    
    private byte[] getFile(String fpath) {
        byte[] fdata = null;
        try {
            //first we get length of file and allocate mem for file
            File file = new File(fpath);
            long length = file.length();
            fdata = new byte[(int)length];
            System.out.println("Size of file is " + length);

            //now we read file into array buffer
            FileInputStream fis = new FileInputStream(file);
            fis.read(fdata);
            fis.close();

        }
        catch( NullPointerException ex ) {
            errorMsg = ex.getMessage();
            System.out.println(errorMsg);
        }
        catch( FileNotFoundException ex ) {
            errorMsg = ex.getMessage();
            System.out.println("File " + fpath + " does not exist: " + errorMsg);
        }
        catch( IOException ex ) {
            errorMsg = ex.getMessage();
            System.out.println("File IO Error " + errorMsg);
        }

        return fdata;
    }
    
    private void sendDocument(String recipientId, IndivoDocumentType doc) throws IndivoException,ActionNotPerformedException {        
        AddDocumentResultType addDocumentResultType = client.addDocument(sessionTicket,recipientId, doc);
    }
    
    /**Create a Medication Type with prescription and send it to indivo server */
     public boolean sendMedication(Prescription drug, String providerFname, String providerLname, String recipientId) {
        NameType name = new NameType();
        name.setFirstName(providerFname);
        name.setLastName(providerLname);

        ConciseContactInformationType contactInfo = new ConciseContactInformationType();
        contactInfo.getPersonName().add(name);

        MedicationType medType = new MedicationType();
        medType.setPrescription(true);
        medType.setDose(drug.getDosageDisplay() + " " + drug.getUnit());
                
        medType.setName(drug.getDrugName());
        medType.setDuration(drug.getDuration());
        medType.setRefills(String.valueOf(drug.getRepeat()));
        medType.setSubstitutionPermitted(drug.getNosubs());
        medType.setProvider(contactInfo);

        org.indivo.xml.phr.DocumentGenerator generator  = new   org.indivo.xml.phr.DocumentGenerator();
        org.indivo.xml.JAXBUtils jaxbUtils              = new   org.indivo.xml.JAXBUtils();
        org.indivo.xml.phr.medication.ObjectFactory medFactory = new org.indivo.xml.phr.medication.ObjectFactory();
        Medication med = medFactory.createMedication(medType);

        try {
            Element element = jaxbUtils.marshalToElement(med, JAXBContext.newInstance("org.indivo.xml.phr.medication"));            
            IndivoDocumentType doc = generator.generateDefaultDocument(indivoId, indivoFullName, indivoRole, DocumentClassificationUrns.MEDICATION, ContentTypeQNames.MEDICATION, element);
            sendDocument(recipientId, doc);
        }
        catch(javax.xml.bind.JAXBException e ) {
            errorMsg = e.getMessage();
            System.out.println("JAXB Error " + errorMsg);
            return false;
        }
        catch(ActionNotPerformedException e) {
            errorMsg = e.getMessage();
            System.out.println("Indivo Unaccepted Medication " + drug.getDrugName() + " " + errorMsg);
            return false;
        }
        catch(IndivoException e ) {
            errorMsg = e.getMessage();
            System.out.println("Indivo Network Error " + errorMsg);
            return false;
        } 

         return true;
     }
    
    /**Send file to indivo as a raw sequence of bytes */
    public boolean sendBinaryFile(String file, String description, String recipientId) {        
        byte[] bfile = getFile(file);
        if( bfile == null )
            return false;
        
        BinaryDataType binaryDataType = new BinaryDataType();
        binaryDataType.setData(bfile);
        binaryDataType.setMimeType("application/pdf");

        org.indivo.xml.phr.DocumentGenerator generator  = new   org.indivo.xml.phr.DocumentGenerator();
        org.indivo.xml.JAXBUtils jaxbUtils              = new   org.indivo.xml.JAXBUtils();

        org.indivo.xml.phr.binarydata.ObjectFactory binFactory = new org.indivo.xml.phr.binarydata.ObjectFactory();

        BinaryData bd = binFactory.createBinaryData(binaryDataType);

        try {
            Element element = jaxbUtils.marshalToElement(bd, JAXBContext.newInstance("org.indivo.xml.phr.binarydata"));
             
            IndivoDocumentType doc = generator.generateDefaultDocument(indivoId, indivoFullName, indivoRole,  DocumentClassificationUrns.BINARYDATA, ContentTypeQNames.BINARYTYPE, element);

            DocumentHeaderType header = doc.getDocumentHeader();
            ContentDescriptionType contentDescription = header.getContentDescription();
            contentDescription.setDescription(description);
            sendDocument(recipientId, doc);
        }
        catch(javax.xml.bind.JAXBException e ) {
            errorMsg = e.getMessage();
            System.out.println("JAXB Error " + errorMsg);
            return false;
        }
        catch(ActionNotPerformedException e) {
            errorMsg = e.getMessage();
            System.out.println("Indivo Unaccepted File " + file + " " + errorMsg);
            return false;
        }
        catch(IndivoException e ) {
            errorMsg = e.getMessage();
            System.out.println("Indivo Network Error " + errorMsg);
            return false;
        }        

        return true;
    }
    
    public String getErrorMsg() {
        return errorMsg;
    }
    
    public String getSessionId() {
        return sessionTicket;
    }
    
    public void setSessionId(String session) {
        sessionTicket = session;
    }
}
