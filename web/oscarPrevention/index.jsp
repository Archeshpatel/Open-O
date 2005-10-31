<!--  
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
 * McMaster Unviersity test2
 * Hamilton 
 * Ontario, Canada 
 */
-->
<%@page  import="oscar.oscarDemographic.data.*,java.util.*,oscar.oscarPrevention.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/oscar-tag.tld" prefix="oscar" %>
<%@ taglib uri="/WEB-INF/rewrite-tag.tld" prefix="rewrite" %>

<%
  if(session.getValue("user") == null) response.sendRedirect("../logout.jsp");
  //int demographic_no = Integer.parseInt(request.getParameter("demographic_no")); 
  String demographic_no = request.getParameter("demographic_no"); 
  
  PreventionDisplayConfig pdc = PreventionDisplayConfig.getInstance();//new PreventionDisplayConfig();
  ArrayList prevList = pdc.getPreventions();
  
  ArrayList configSets = pdc.getConfigurationSets();
  
  
  
  PreventionData pd = new PreventionData();    
  Prevention p = pd.getPrevention(demographic_no);
  
  PreventionDS pf = PreventionDS.getInstance();
  
  pf.getMessages(p);
  ArrayList warnings = p.getWarnings();      
  System.out.println("warnings size ----"+warnings.size());
  ArrayList recomendations = p.getReminder();
  System.out.println("recomendations size"+warnings.size());
          
%>  


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
      

<html:html locale="true">

<head>
<title>
oscarPrevention <!--I18n-->
</title>
<link rel="stylesheet" type="text/css" href="../share/css/OscarStandardLayout.css" />
<script type="text/javascript" src="../share/javascript/Oscar.js"></script>
<script type="text/javascript" src="../share/javascript/prototype.js"></script>

<style type="text/css">
  div.ImmSet { background-color: #ffffff;clear:left;margin-top:10px;}
  div.ImmSet h2 {  }
  div.ImmSet h2 span { font-size:smaller; }
  div.ImmSet ul {  }
  div.ImmSet li {  }
  div.ImmSet li a { text-decoration:none; color:blue;}
  div.ImmSet li a:hover { text-decoration:none; color:red; }
  div.ImmSet li a:visited { text-decoration:none; color:blue;}  
  
  /*h3{font-size: 100%;margin:0 0 10px;padding: 2px 0;color: #497B7B;text-align: center}*/
</style>

<link rel="stylesheet" type="text/css" href="../share/css/niftyCorners.css" />
<link rel="stylesheet" type="text/css" href="../share/css/niftyPrint.css" media="print" />
<script type="text/javascript" src="../share/javascript/nifty.js"></script>
<script type="text/javascript">
window.onload=function(){
if(!NiftyCheck())
    return;

//Rounded("div.news","all","transparent","#FFF","small border #999");
Rounded("div.headPrevention","all","#CCF","#efeadc","small border blue");
Rounded("div.preventionProcedure","all","transparent","#F0F0E7","small border #999");

Rounded("div.leftBox","top","transparent","#CCCCFF","small border #ccccff");
Rounded("div.leftBox","bottom","transparent","#EEEEFF","small border #ccccff");

}
</script>




<script  type="text/javascript">
<!--
//if (document.all || document.layers)  window.resizeTo(790,580);
function newWindow(file,window) {
  msgWindow=open(file,window,'scrollbars=yes,width=760,height=520,screenX=0,screenY=0,top=0,left=10');
  if (msgWindow.opener == null) msgWindow.opener = self;
} 
//-->
</script>




<style type="text/css">
body {font-size:100%}

//div.news{width: 100px; background: #FFF;margin-bottom: 20px;margin-left: 20px;}
div.leftBox{
   width:90%;
   margin-top: 2px;
   margin-left:3px;
   margin-right:3px;   
   float: left;
}

div.leftBox h3 {  
   background-color: #ccccff; 
   /*font-size: 1.25em;*/
   font-size: 8pt;
   font-variant:small-caps;
   font:bold;
   margin-top:0px;
   padding-top:0px;
   margin-bottom:0px;
   padding-bottom:0px;
}

div.leftBox ul{ 
       /*border-top: 1px solid #F11;*/
       /*border-bottom: 1px solid #F11;*/
       font-size: 1.0em;
       list-style:none;
       list-style-type:none; 
       list-style-position:outside;       
       padding-left:1px;
       margin-left:1px;    
       margin-top:0px;
       padding-top:1px;
       margin-bottom:0px;
       padding-bottom:0px;	
}

div.leftBox li {
padding-right: 15px;
white-space: nowrap;
}


div.headPrevention {  
    position:relative; 
    float:left;     
    width:8.3em;
    height:2.5em;
}

div.headPrevention p {    
    background: #EEF;
    font-family: verdana,tahoma,sans-serif;
    margin:0;
    
    padding: 4px 5px;
    line-height: 1.3;
    text-align: justify
    height:2em;
    font-family: sans-serif;
}

div.headPrevention a {    
    text-decoration:none;
}

div.headPrevention a:active { color:blue; }
div.headPrevention a:hover { color:blue; }
div.headPrevention a:link { color:blue; }
div.headPrevention a:visited { color:blue; }


div.preventionProcedure{    
    width:10em;
    float:left;     
    margin-left:3px; 
    margin-bottom:3px;
}

div.preventionProcedure p {
    font-size: 0.8em;
    font-family: verdana,tahoma,sans-serif;
    background: #F0F0E7;    
    margin:0;
    padding: 1px 2px;
    /*line-height: 1.3;*/
    /*text-align: justify*/
}

div.preventionSection {    
    width: 100%;
    postion:relative;   
    margin-top:5px;
    float:left;
    clear:left;
}

div.preventionSet {
    border: thin solid grey;
    clear:left;
    }
    
div.recommendations{
    font-family: verdana,tahoma,sans-serif;
    font-size: 1.2em;
}    

div.recommendations ul{
    padding-left:15px;
    margin-left:1px;    
    margin-top:0px;
    padding-top:1px;
    margin-bottom:0px;
    padding-bottom:0px;	
}    

div.recommendations li{
    
}    
        
       

</style>

</head>

<body class="BodyStyle" >
<!--  -->
    <table  class="MainTable" id="scrollNumber1" >
        <tr class="MainTableTopRow">
            <td class="MainTableTopRowLeftColumn"  >
      oscarPrevention
            </td>
            <td class="MainTableTopRowRightColumn">
                <table class="TopStatusBar">
                    <tr>
                        <td >                                                        
                            <oscar:nameage demographicNo="<%=demographic_no%>"/>
                        </td>
                        <td  >&nbsp;
							
                        </td>
                        <td style="text-align:right">
                                <a href="javascript:popupStart(300,400,'Help.jsp')"  ><bean:message key="global.help" /></a> | <a href="javascript:popupStart(300,400,'About.jsp')" ><bean:message key="global.about" /></a> | <a href="javascript:popupStart(300,400,'License.jsp')" ><bean:message key="global.license" /></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="MainTableLeftColumn" valign="top">
            
                       
               <div class="leftBox">
                  <h3>&nbsp;Preventions</h3>
                  <div style="background-color: #EEEEFF;" >
                  <ul >               
                  <%for (int i = 0 ; i < prevList.size(); i++){ 
                      Hashtable h = (Hashtable) prevList.get(i);
                      String prevName = (String) h.get("name");%>
                     <li style="margin-top:2px;">
                        <a href="javascript: function myFunction() {return false; }"  onclick="javascript:popup(465,635,'AddPreventionData.jsp?prevention=<%= java.net.URLEncoder.encode(prevName) %>&amp;demographic_no=<%=demographic_no%>','addPreventionData<%=Math.abs(prevName.hashCode()) %>')">                        
                           <%=prevName%>
                        </a>
                     </li>          
                  <%}%>
                  </ul>
                  </div>
               </div>               
               <oscar:oscarPropertiesCheck property="IMMUNIZATION_IN_PREVENTION" value="yes">                                                
                <a href="javascript: function myFunction() {return false; }" onclick="javascript:popup(700,960,'<rewrite:reWrite jspPage="../oscarEncounter/immunization/initSchedule.do"/>','oldImms')">Old <bean:message key="global.immunizations"/></a><br>
               </oscar:oscarPropertiesCheck>
            </td>
            <td valign="top" class="MainTableRightColumn">
            <% if (warnings.size() > 0 || recomendations.size() > 0 ) { %>
               <div class="recommendations">
               <span style="font-size:larger;">Prevention Recommendations</span>               
               <ul >                                        
                    <% for (int i = 0 ;i < warnings.size(); i++){ 
                       String warn = (String) warnings.get(i);%>
                        <li style="color: red;"><%=warn%></li>     
                    <%}%>
                    <% for (int i = 0 ;i < recomendations.size(); i++){ 
                       String warn = (String) recomendations.get(i);%>
                        <li style="color: black;"><%=warn%></li>     
                    <%}%>
                 <!--li style="color: red;">6 month TD overdue</li>
                 <li>12 month MMR due in 2 months</li-->  
               </ul>
               </div>
           <% } %>    
               <div >                                                 
                  <%if (configSets == null ){ configSets = new ArrayList(); }
                    for ( int setNum = 0; setNum < configSets.size(); setNum++){ 
                      Hashtable setHash = (Hashtable) configSets.get(setNum);
                      String[] prevs = (String[]) setHash.get("prevList");
                      System.out.println("length prevs"+prevs.length);%>
                  <div class="immSet" >                     
                     <h2 style="display:block;"><%=setHash.get("title")%> <span ><%=setHash.get("effective")%></span></h2> 
                     <!--a style="font-size:xx-small;" onclick="javascript:showHideItem('<%="prev"+setNum%>')" href="javascript: function myFunction() {return false; }" >show/hide</a-->                                                                                                                               
                     <a href="#" onclick="Element.toggle('<%="prev"+setNum%>'); return false;" style="font-size:xx-small;" >show/hide</a>                    
                     <div class="preventionSet" <%=pdc.getDisplay(setHash,demographic_no)%>;"  id="<%="prev"+setNum%>">                        
                        <%for (int i = 0; i < prevs.length ; i++) {
                           Hashtable h = pdc.getPrevention(prevs[i]); %>
                        <div class="preventionSection" >
                            <div class="headPrevention">
                               <p > 
                               <a href="javascript: function myFunction() {return false; }"  onclick="javascript:popup(465,635,'AddPreventionData.jsp?prevention=<%= response.encodeURL( (String) h.get("name")) %>&amp;demographic_no=<%=demographic_no%>','addPreventionData<%=Math.abs( ((String) h.get("name")).hashCode() ) %>')">
                               <span title="<%=h.get("desc")%>" style="font-weight:bold;"><%=h.get("name")%></span>
                               </a>
                               &nbsp;
                               <a href="<%=h.get("link")%>">#</a>                              
                               <br/>                                 
                               </p>
                            </div>
                            <%ArrayList alist = pd.getPreventionData((String)h.get("name"), demographic_no);                            
                            for (int k = 0; k < alist.size(); k++){
                                Hashtable hdata = (Hashtable) alist.get(k);
                            %>                            
                            <div class="preventionProcedure"  onclick="javascript:popup(465,635,'AddPreventionData.jsp?id=<%=hdata.get("id")%>&amp;demographic_no=<%=demographic_no%>','addPreventionData')" >
                                <p <%=r(hdata.get("refused"))%>>Age: <%=hdata.get("age")%> <br/>
                                <!--<%=refused(hdata.get("refused"))%>-->Date: <%=hdata.get("prevention_date")%>
                                </p>
                            </div>
                           <%}%>                           
                        </div>                                                
                        <%}%>                                       
                     </div>
                  </div><!--immSet-->
                  <%}%>                                                      
               </div>
            </td>
        </tr>
        <tr>
            <td class="MainTableBottomRowLeftColumn">
            &nbsp;
            </td>
            <td class="MainTableBottomRowRightColumn" valign="top">
            &nbsp;
            </td>
        </tr>
    </table>
</body>
</html:html>
<%! 
String refused(Object re){ 
        String ret = "Given";
        if (re instanceof java.lang.String){
                
        if (re != null && re.equals("1")){
           ret = "Refused";
        }
        }
        return ret;
    }
String r(Object re){ 
        String ret = "";
        if (re instanceof java.lang.String){                
           if (re != null && re.equals("1")){
           ret = "style=\"background: #FFDDDD;\"";
           }
        }
        return ret;
    }
%>