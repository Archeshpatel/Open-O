// javac -classpath .;C:\jakarta-tomcat-4.0.6\common\lib;%CLASSPATH% SAClient.java
/*activation.jar
commons-logging.jar
dom.jar
dom4j.jar
jaxm-api.jar
jaxm-runtime.jar
jaxp-api.jar
mail.jar
sax.jar
saaj-api.jar
saaj-ri.jar
xalan.jar
xercesImpl.jar
xsltc.jar
javac -d . FrmStudyXMLClientSend.java
java -classpath .:%CLASSPATH% oscar.form.study.FrmStudyXMLClientSend /root/oscar_sfhc.properties https://67.69.12.115:8443/OscarComm/DummyReceiver
java -classpath .:%CLASSPATH% oscar.form.study.FrmStudyXMLClientSend /root/oscar_sfhc.properties https://192.168.42.180:15000/ /root/oscarComm/oscarComm.keystore

java -classpath .:%CLASSPATH% oscar.form.study.FrmStudyXMLClientSend /root/oscar_sfhc.properties https://130.113.150.203:15501/ /root/oscarComm/enleague.keystore
java -classpath .:%CLASSPATH% oscar.form.study.FrmStudyXMLClientSend /root/oscar_sfhc.properties https://192.168.42.180:15000/ /root/oscarComm/compete.keystore
java oscar.form.study.FrmStudyXMLClientSend c:\\root\\oscar_sfhc.properties https://67.69.12.115:8443/OscarComm/DummyReceiver
*/

package oscar.form.study;

import java.io.*;
import java.util.*;
import java.sql.*;
import javax.xml.soap.*;
import javax.xml.messaging.*;
import java.net.URL;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import oscar.oscarDB.*;
import oscar.util.*;
import org.w3c.dom.*;
import org.xml.sax.InputSource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;


public class FrmStudyXMLClientSend {
//	private String DBName = null;
	private String URLService = null;

	Properties param = new Properties();
	Vector studyContent = new Vector();
	Vector studyNo = new Vector();
	DBHandler db = null; 
	String sql = null; 
	ResultSet rs = null; 

//	Properties studyTableName = null;
	String dateYesterday = null;
	String dateTomorrow = null;

	public static void main (String[] args) throws java.sql.SQLException, java.io.IOException  {
		if (args.length != 3) {
			System.out.println("Please run: java path/FrmStudyXMLClient dbname WebServiceUrl");
			return; 
		}
		FrmStudyXMLClientSend aStudy = new FrmStudyXMLClientSend();

		//initial
		aStudy.init(args[0], args[1]);
		aStudy.getStudyContent();
		if (aStudy.studyContent.size() == 0) {aStudy.db.CloseConn(); return;}

		//loop for each content record
		for (int i = 0; i < aStudy.studyContent.size() ; i++ )	{
			aStudy.sendJaxmMsg((String)aStudy.studyContent.get(i), args[2]);
			aStudy.updateStatus((String)aStudy.studyNo.get(i));
		}
/*		for (Enumeration e = aStudy.studyContent.propertyNames() ; e.hasMoreElements() ;)	{
			String tempStudyNo = (String) e.nextElement();

			aStudy.sendJaxmMsg(aStudy.studyContent.getProperty(tempStudyNo), args[2]);
			aStudy.updateStatus(tempStudyNo);
		}
*/ 
		aStudy.db.CloseConn();

	}

	private synchronized void init (String file, String url) throws java.sql.SQLException, java.io.IOException  {
		URLService = url;
		param.load(new FileInputStream(file)); 
		DBHandler.init(param.getProperty("db_name"),param.getProperty("db_driver"),param.getProperty("db_uri") ,param.getProperty("db_username"),param.getProperty("db_password") );
        db = new DBHandler(DBHandler.OSCAR_DATA);

		GregorianCalendar now=new GregorianCalendar();
		now.add(now.DATE, -1);
		dateYesterday = now.get(Calendar.YEAR) +"-" +(now.get(Calendar.MONTH)+1) +"-"+now.get(Calendar.DAY_OF_MONTH) ;
		now.add(now.DATE, +2);
		dateTomorrow = now.get(Calendar.YEAR) +"-" +(now.get(Calendar.MONTH)+1) +"-"+now.get(Calendar.DAY_OF_MONTH) ;
	}

	private synchronized void getStudyContent () throws java.sql.SQLException  {
        sql = "SELECT studydata_no, content from studydata where timestamp > '" + dateYesterday + "' and timestamp < '" + dateTomorrow + "' and status='ready' order by studydata_no";
        rs = db.GetSQL(sql);
        while(rs.next()) {
			studyContent.add(rs.getString("content")); 
			studyNo.add(rs.getString("studydata_no")); 
		}
        rs.close();
	}

	private synchronized void updateStatus (String studyDataNo) throws java.sql.SQLException  {
        sql = "update studydata set status='sent' where studydata_no=" + studyDataNo ;
		if (db.RunSQL(sql)) throw new java.sql.SQLException();
        rs.close();
	}


	private void sendJaxmMsg (String aMsg, String u) throws java.sql.SQLException  {
		try	{
			//System.setProperty("javax.net.ssl.trustStore", "c:\\root\\oscarComm\\oscarComm.keystore");
			//System.setProperty("javax.net.ssl.trustStore", "/root/oscarComm/compete.keystore");
			System.setProperty("javax.net.ssl.trustStore", u);
            //System.setProperty("javax.net.debug", "ssl,handshake,trustmanager");

			//URL endPoint = new URL (" https://67.69.12.115:8443");
			//javax.xml.soap.SOAPConnectionFactory=com.sun.xml.messaging.saaj.client.p2p.HttpSOAPConnectionFactory
			SOAPConnectionFactory scf = SOAPConnectionFactory.newInstance();
			SOAPConnection connection = scf.createConnection();

			MessageFactory mf = MessageFactory.newInstance();
		    SOAPMessage message = mf.createMessage();

			SOAPPart sp = message.getSOAPPart();
		    SOAPEnvelope envelope = sp.getEnvelope();

			SOAPHeader header = envelope.getHeader();
		    SOAPBody body = envelope.getBody();

			SOAPHeaderElement headerElement = header.addHeaderElement(envelope.createName("OSCAR", "DT", "http://www.oscarhome.org/"));
		    headerElement.addTextNode("header");
			//SOAPBodyElement bodyElement = body.addBodyElement(envelope.createName("Text", "jaxm", "http://java.sun.com/jaxm"));

			SOAPBodyElement bodyElement = body.addBodyElement(envelope.createName("Service"));
		    bodyElement.addTextNode("compete");

			AttachmentPart ap1 = message.createAttachmentPart();
			ap1.setContent(aMsg, "text/plain");
			//DOMSource aSource = new DOMSource(UtilXML.parseXML(aMsg) );
			//ap1.setContent(aSource, "text/xml");
		    //URL url = new URL("../../../../webapps/oscar_sfhc/images/sfhc.jpg");
		    //AttachmentPart ap1 = message.createAttachmentPart(new DataHandler(url));
		    //message.addAttachmentPart(ap1);

			message.addAttachmentPart(ap1);

			//AttachmentPart ap2 = message.createAttachmentPart("hello", "text/plain; charset=ISO-8859-1");	//message.addAttachmentPart(ap2);
			
			URLEndpoint endPoint = new URLEndpoint (URLService);  //"https://67.69.12.115:8443/OscarComm/DummyReceiver");
			SOAPMessage reply = connection.call(message, endPoint);
//			message.writeTo(System.out);
			connection.close();
		} catch (Throwable e)	{
			e.printStackTrace();
		}
	}
}
