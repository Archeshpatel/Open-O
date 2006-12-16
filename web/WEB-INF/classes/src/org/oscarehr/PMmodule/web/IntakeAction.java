package org.oscarehr.PMmodule.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.oscarehr.PMmodule.exception.IntegratorException;
import org.oscarehr.PMmodule.exception.IntegratorNotEnabledException;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.web.formbean.ClientSearchFormBean;
import org.oscarehr.PMmodule.web.formbean.PreIntakeForm;

public class IntakeAction extends BaseAction {

	private static Log log = LogFactory.getLog(IntakeAction.class);

	
	public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		request.getSession().setAttribute("demographic",null);
		
		return mapping.findForward("pre-intake");
	}
	
	public ActionForward do_intake(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm preIntakeForm = (DynaActionForm)form;
		PreIntakeForm formBean = (PreIntakeForm)preIntakeForm.get("form");
		request.getSession().setAttribute("demographic",null);
		boolean doLocalSearch=false;
		
		
		Demographic[] results = new Demographic[0];
				
		/* here we want to switch to the integrator, if available */
		Demographic d = new Demographic();		
		d.setFirstName(formBean.getFirstName());
		d.setLastName(formBean.getLastName());
		d.setYearOfBirth(formBean.getYearOfBirth());
		d.setMonthOfBirth(String.valueOf(formBean.getMonthOfBirth()));
		d.setDateOfBirth(String.valueOf(formBean.getDayOfBirth()));
		d.setHin(formBean.getHealthCardNumber());
		d.setVer(formBean.getHealthCardVersion());
		
		try {
			results  = integratorManager.matchClient(d);
			log.debug("integrator found " + results.length + " match(es)");		
		}catch(IntegratorNotEnabledException e) {
			log.info(e);
			doLocalSearch=true;
		} catch(Throwable e) {
			log.error(e);
			doLocalSearch=true;
		}
		if(doLocalSearch) {
			ClientSearchFormBean searchBean = new ClientSearchFormBean();
			searchBean.setFirstName(formBean.getFirstName());
			searchBean.setLastName(formBean.getLastName());
			searchBean.setSearchOutsideDomain(true);
			searchBean.setSearchUsingSoundex(true);
			
			List resultList = clientManager.search(searchBean);
			results = (Demographic[])resultList.toArray(new Demographic[resultList.size()]);
			log.debug("local search found " + results.length + " match(es)");		
			
		}
		
		if(results != null && results.length>0) {
			request.setAttribute("localSearch", new Boolean(doLocalSearch));
			request.setAttribute("clients",results);
			return mapping.findForward("pre-intake");
		}

		return new_client(mapping,form,request,response);
	}
	
	/*
	 * There can be a new client in 2 scenerios
	 * 1) new client button was clicked.
	 * 2) new client, but they are being linked to a record already
	 * 		existing on the integrator; in which case the session variable
	 * 		'demographic' will be set.
	 *  
	 */
	public ActionForward new_client(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm preIntakeForm = (DynaActionForm)form;
		PreIntakeForm formBean = (PreIntakeForm)preIntakeForm.get("form");
		
		/* no matches */
		if(formBean.getClientId().equals("")) {
			return mapping.findForward(getIntakeForward());
		}
		
		
		Demographic demographic = null;
		if(formBean.getAgencyId() != 0) {
			//integrator
			try {
				demographic = integratorManager.getDemographic(formBean.getAgencyId(),Long.valueOf(formBean.getClientId()).longValue());
			}catch(IntegratorException e) {
				log.error(e);
			}
		} else {
			//local...can this even happen?
			//demographic = clientManager.getClientByDemographicNo(formBean.getClientId());
		}
		
		request.getSession().setAttribute("demographic",demographic);
		
		return mapping.findForward(getIntakeForward());
	}
	
	/*
	 * This is just updating the intake form on a client since
	 * he/she are already in the local database.
	 */
	public ActionForward update_client(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm preIntakeForm = (DynaActionForm)form;
		PreIntakeForm formBean = (PreIntakeForm)preIntakeForm.get("form");
		
		String demographicNo = formBean.getClientId();
		
		log.debug("update intake for client " + demographicNo);
		
		request.setAttribute("demographicNo",demographicNo);

		return mapping.findForward(getIntakeForward());
	}
	
	
	private String getIntakeForward() {
		String value = "intakea";
		
		if(intakeAManager.isNewClientForm()) {
			value = "intakea";
		}
		if(intakeCManager.isNewClientForm()) {
			value = "intakec";
		}
		return value;
	}
}
