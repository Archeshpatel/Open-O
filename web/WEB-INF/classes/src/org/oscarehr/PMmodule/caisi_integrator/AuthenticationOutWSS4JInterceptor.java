package org.oscarehr.PMmodule.caisi_integrator;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.UnsupportedCallbackException;
import javax.xml.namespace.QName;

import org.apache.cxf.binding.soap.SoapHeader;
import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.headers.Header;
import org.apache.cxf.helpers.DOMUtils;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.ws.security.wss4j.WSS4JOutInterceptor;
import org.apache.ws.security.WSConstants;
import org.apache.ws.security.WSPasswordCallback;
import org.apache.ws.security.handler.WSHandlerConstants;
import org.oscarehr.PMmodule.dao.SecUserRoleDao;
import org.oscarehr.PMmodule.model.SecUserRole;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.SpringUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class AuthenticationOutWSS4JInterceptor extends WSS4JOutInterceptor implements CallbackHandler {
	private static final String AUDIT_TRAIL_KEY = "auditTrail";
	private static QName AUDIT_TRAIL_QNAME = new QName("http://oscarehr.org/caisi", AUDIT_TRAIL_KEY, "caisi");
	private static final String REQUESTING_USER_ROLES_KEY = "requestingUserRoles";
	private static QName REQUESTING_USER_ROLES_QNAME = new QName("http://oscarehr.org/caisi", REQUESTING_USER_ROLES_KEY, "caisi");

	private String password = null;

	public AuthenticationOutWSS4JInterceptor(String user, String password) {
		this.password = password;

		HashMap<String, Object> properties = new HashMap<String, Object>();
		properties.put(WSHandlerConstants.ACTION, WSHandlerConstants.USERNAME_TOKEN);
		properties.put(WSHandlerConstants.USER, user);
		properties.put(WSHandlerConstants.PASSWORD_TYPE, WSConstants.PW_TEXT);
		properties.put(WSHandlerConstants.PW_CALLBACK_REF, this);

		setProperties(properties);
	}

	// don't like @override until jdk1.6?
	// @Override
	public void handle(Callback[] callbacks) throws IOException, UnsupportedCallbackException {
		for (Callback callback : callbacks) {
			if (callback instanceof WSPasswordCallback) {
				WSPasswordCallback wsPasswordCallback = (WSPasswordCallback) callback;
				wsPasswordCallback.setPassword(password);
			}
		}
	}

	public void handleMessage(SoapMessage message) throws Fault {
		addAuditTrail(message);
		addRequestionUserRoles(message);
		super.handleMessage(message);
	}

	private static void addRequestionUserRoles(SoapMessage message) {
		List<Header> headers = message.getHeaders();

		// here is where we should get the roles and set the header, probably csv of roles should be fine.
		// SecUserRole should be the one we want, it should be the oscar role.
		LoggedInInfo loggedInInfo = LoggedInInfo.loggedInInfo.get();
		if (loggedInInfo.loggedInProvider != null) {
			SecUserRoleDao secUserRoleDao = (SecUserRoleDao) SpringUtils.getBean("secUserRoleDao");
			List<SecUserRole> roles = secUserRoleDao.getUserRoles(loggedInInfo.loggedInProvider.getProviderNo());
			String rolesString = SecUserRole.getRoleNameAsCsv(roles);

			headers.add(createHeader(REQUESTING_USER_ROLES_QNAME, REQUESTING_USER_ROLES_KEY, rolesString));
		}
	}

	private static void addAuditTrail(SoapMessage message) {
		List<Header> headers = message.getHeaders();

		StringBuilder auditTrail = new StringBuilder();

		LoggedInInfo loggedInInfo = LoggedInInfo.loggedInInfo.get();
		if (loggedInInfo.initiatingCode != null) auditTrail.append("oscar_caisi.code=").append(loggedInInfo.initiatingCode);

		if (loggedInInfo.currentFacility != null) {
			if (auditTrail.length() > 0) auditTrail.append(", ");
			auditTrail.append("oscar_caisi.facilityId=").append(loggedInInfo.currentFacility.getId());
		}

		if (loggedInInfo.loggedInProvider != null) {
			if (auditTrail.length() > 0) auditTrail.append(", ");
			auditTrail.append("oscar_caisi.providerNo=").append(loggedInInfo.loggedInProvider.getProviderNo());
		}

		headers.add(createHeader(AUDIT_TRAIL_QNAME, AUDIT_TRAIL_KEY, auditTrail.toString()));
	}

	private static Header createHeader(QName qName, String key, String value) {
		Document document = DOMUtils.createDocument();

		Element element = document.createElementNS("http://oscarehr.org/caisi", "caisi:" + key);
		element.setTextContent(value);

		SoapHeader header = new SoapHeader(qName, element);
		return (header);
	}
}
