package mkcl.oesclient.diabetes.controllers;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import mkcl.diabetestest.model.DDT_CategoryMaster;
import mkcl.diabetestest.model.DDT_RuleParts;
import mkcl.diabetestest.model.DDT_Rules;
import mkcl.oesclient.commons.services.OESPartnerServiceImpl;
import mkcl.oesclient.commons.utilities.GatewayConstants;
import mkcl.oesclient.diabetes.services.DiabetesDignosticServiceImpl;
import mkcl.oesclient.diabetes.viewmodel.CandidateRulePartViewModel;
import mkcl.oesclient.diabetes.viewmodel.CandidateRuleViewModel;
import mkcl.oesclient.diabetes.viewmodel.CandidateSuggestionViewModel;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.utilities.SessionHelper;

@Controller
@RequestMapping("DiabetesDiagnosticTestReport")
public class DiabetesDiagnosticTestReportController {
private static final Logger LOGGER = LoggerFactory.getLogger(DiabetesDiagnosticTestReportController.class);     
       
       
       /**
        * Get method for Diabetes Diagnostic Test Report
        * @param model
        * @param request
        * @param candidateUserName
        * @param examEventId
        * @param paperId
        * @param attemptNo
        * @param locale
        * @return String this returns the path of a view
        */
       @RequestMapping(value={"/diabetesDiagnosticTestReport"},method = RequestMethod.GET)
       public String getDiabetesDiagnosticTestReport(Model model,HttpServletRequest request,String candidateUserName,String examEventId,String paperId,String attemptNo,Locale locale) 
       {
              if (!SessionHelper.getLoginStatus(request)) 
              {
                     return "redirect:../login/logoutMsg";
              }
              Long candidateExamId=0l;
              DiabetesDignosticServiceImpl diabetesDignosticServiceImpl=new DiabetesDignosticServiceImpl();
              CandidateExam candidateExam = null;
              int candidateAge=0;
              String dueDate="NA";
              Date attemptDate=new Date();
              
              try 
              {
                     List<CandidateRulePartViewModel> candidateRulePartViewModelList=null;
                     List<CandidateRuleViewModel> candidateRuleViewModelList=null;
                     candidateExamId = diabetesDignosticServiceImpl.getCandidateExamID(Long.parseLong(examEventId),candidateUserName, Long.parseLong(paperId),Integer.parseInt(attemptNo));
                     if(candidateExamId!=null && candidateExamId>0)
                     {                          
                    	 candidateExam = diabetesDignosticServiceImpl.getCandidateExamBycandidateExamID(candidateExamId);
                           
                         List<Integer> suggestionIds = new ArrayList<Integer>();
                           
                           if(candidateExam != null)
                           {
                                  candidateRulePartViewModelList = diabetesDignosticServiceImpl.getCandidateRuleParts(candidateExamId,candidateExam.getFkCandidateID());
                                  candidateRuleViewModelList = diabetesDignosticServiceImpl.getCandidateRules(candidateExamId, candidateExam.getFkCandidateID());
                                  attemptDate= candidateExam.getAttemptDate();
                                  
                                  if(attemptDate!=null) 
                                  {
                               	   DateFormat df = new SimpleDateFormat("E MMM dd HH:mm:ss Z yyyy");
                               	   SimpleDateFormat df2 = new SimpleDateFormat("dd-MM-yyyy");
                               	   Calendar cal = Calendar.getInstance();
                                   cal.setTime(attemptDate);
                                      
                                   cal.add(Calendar.DATE,180);
                                   dueDate = df2.format(df.parse(cal.getTime().toString()));
                                  
                                  if(candidateExam.getCandidate().getCandidateDOB()!=null) 
                                  {
                                	  Calendar birthDate = Calendar.getInstance();
                                      Calendar attemptedDate = Calendar.getInstance();
                                      
	                                  birthDate.setTime(candidateExam.getCandidate().getCandidateDOB());
	                                  attemptedDate.setTime(attemptDate);
	                                  candidateAge = attemptedDate.get(Calendar.YEAR)- birthDate.get(Calendar.YEAR);
                                  }
                                  }
                           }
                           
                           //Evaluate each rule and set whether applicable or not 
                           for(CandidateRuleViewModel candidateRule: candidateRuleViewModelList)
                           {
                                  
                                  String rule = candidateRule.getRule().getRule();                     
                                         
                                  // Summation rule
                                  if(candidateRule.getRule().getLogicalOperationResult() == false)
                                  {
                                         Map<Integer,String> mapScore = new HashMap<Integer, String>();
                                         String ruleString = rule;
                                         int substitutedRule = 0;
                                         
                                         Set<Long> itembankSet=new HashSet<Long>();
                                         
                                         //Parse the entire rule
                                         while(ruleString.length()>0)
                                         {
                                                Integer rulePartID=0;
                                                //Extract rule part
                                                if(ruleString.contains("+"))
                                                {
                                                       rulePartID = Integer.parseInt(ruleString.substring(0, ruleString.indexOf("+")));
                                                       ruleString = ruleString.substring(ruleString.indexOf("+")+1);
                                                }
                                                else
                                                {
                                                       rulePartID = Integer.parseInt(ruleString);
                                                       ruleString = "";
                                                }
                                                CandidateRulePartViewModel rp = new CandidateRulePartViewModel();
                                                rp.setRulePart(new DDT_RuleParts());
                                                rp.getRulePart().setRulePartID(rulePartID);     
                                                
                                                int rpIndex = candidateRulePartViewModelList.indexOf(rp);
                                                //If the extracted rule part is applicable then put its score in mapScore
                                                if(candidateRulePartViewModelList.get(rpIndex).getIsRulePartApplicable())
                                                {
                                                       mapScore.put(rulePartID, String.valueOf(candidateRulePartViewModelList.get(rpIndex).getCandidateScore()));
                                                       // If rule has a condition of minimum item banks then, check for the same and add in itembankSet
                                                       if(candidateRule.getRule().getMinItemBankCount()>0)
                                                              itembankSet.add(candidateRulePartViewModelList.get(rpIndex).getRulePart().getItemBankID());                                                     
                                                }
                                         }      
                                         
                                         // Evaluate the rule  and update of suggestion in the suggestion list
                                         if(mapScore.size()>0)
                                         {
                                                // Substitute scores and evaluate rule
                                                for(String value: mapScore.values())
                                                {
                                                    int score =  Integer.parseInt(value);
                                                    if(score>0)
                                                    	substitutedRule += score;
                                                }
                                                // Check if rule is applicable based on the total score obtained on substitution
                                                if(substitutedRule>=candidateRule.getRule().getMinScore() && substitutedRule<=candidateRule.getRule().getMaxScore())
                                                {                                                                                                      
                                                       if(candidateRule.getRule().getMinItemBankCount()>0)
                                                       {
                                                              // Even though the total score is within the range check if no. of item banks are as required as per the rule 
                                                              if(itembankSet.size() >= candidateRule.getRule().getMinItemBankCount()){
                                                                     candidateRule.setIsRuleApplicable(true);
                                                                     // Add the suggestion to the suggestion list
                                                                     suggestionIds.add(candidateRule.getRule().getFkSuggestionID());
                                                              }                                                      
                                                              
                                                       }
                                                       else
                                                       {
                                                              // Set if the rule is applicable for the candidate and add the suggestion to the list
                                                              candidateRule.setIsRuleApplicable(true);
                                                              suggestionIds.add(candidateRule.getRule().getFkSuggestionID());
                                                       }
                                                }
                                                
                                         }
                                         
                                  }
                                  // Logical Operation Rule
                                  else
                                  {
                                         Map<String,String> mapBoolean = splitIntegers(rule);
                                         String substitutedRule = rule;
                                         
                                         for (String key : mapBoolean.keySet()) 
                                         {
                                                // * means its a rule and not rule part and hence the rule being processed is rule over a rule
                                                if(key.contains("*"))
                                                {
                                                       CandidateRuleViewModel r = new CandidateRuleViewModel();
                                                       r.setRule(new DDT_Rules());
                                                       r.getRule().setRuleID(Integer.parseInt(key.substring(1)));
                                                       int rIndex = candidateRuleViewModelList.indexOf(r);
                                                       // If the rule is applicable then add the *rule to the mapBoolean with the boolean value true
                                                       if(candidateRuleViewModelList.get(rIndex).getIsRuleApplicable())
                                                              mapBoolean.put(key, "true");
                                                }
                                                else
                                                {
                                                       CandidateRulePartViewModel rp = new CandidateRulePartViewModel();
                                                       rp.setRulePart(new DDT_RuleParts());
                                                       rp.getRulePart().setRulePartID(Integer.parseInt(key)); 
                                                       int rpIndex = candidateRulePartViewModelList.indexOf(rp);
                                                       rp = candidateRulePartViewModelList.get(rpIndex);
                                                       
                                                       // If rule part is not based on item but based on item bank instead 
                                                       if(rp.getRulePart().getItemID() == 0)
                                                       {
                                                              // Set the candidate score of the rule part as total obtained item bank score 
                                                              rp.setCandidateScore(diabetesDignosticServiceImpl.getCandidateItemBankScore(candidateExamId, rp.getRulePart().getItemBankID()));
                                                              
                                                              // If the obtained item bank score is in the range of minimum score and maximum score of the rule part then set rule part as applicable 
                                                              if(rp.getCandidateScore() >= rp.getRulePart().getMinScore() && rp.getCandidateScore() <= rp.getRulePart().getMaxScore()) 
                                                                     rp.setIsRulePartApplicable(true);                                                        
                                                              else
                                                                     rp.setIsRulePartApplicable(false);
                                                              
                                                       }
                                                       // If the rule part is applicable then add the rule part to the mapBoolean with the boolean value true
                                                       if(rp.getIsRulePartApplicable())
                                                              mapBoolean.put(key, "true");      
                                                }
                                                
                                                // Substitute boolean values of the respective *rule or rule part in the rule 
                                                // against the *rule and rule parts
                                                substitutedRule = substitutedRule.replace(key.toString(), mapBoolean.get(key));

                                         }
                                         
                                         // Evaluate the boolean operation rule
                                         ScriptEngineManager sem = new ScriptEngineManager();
                                   ScriptEngine se = sem.getEngineByName("JavaScript");
                                   boolean result = (Boolean) se.eval(substitutedRule);                                    
                                         
                                         // Set if the rule is applicable for the candidate and add the suggestion to the list
                                   candidateRule.setIsRuleApplicable(result);            
                                         if(candidateRule.getIsRuleApplicable())
                                         {
                                                suggestionIds.add(candidateRule.getRule().getFkSuggestionID());
                                         }
                                         
                                  }
                                  
                           }
                           // Fetch the details of the distinct suggestions carrying the highest weight-age for each category 
                           // ignoring the rest of the suggestions carrying low weight-age under that category   
                           String suggestionIdStr=suggestionIds.toString().substring(1,suggestionIds.toString().length()-1);
                           List<CandidateSuggestionViewModel> candidateSuggestionViewModelList= diabetesDignosticServiceImpl.getCandidateSuggestions(suggestionIdStr, candidateExamId);
                           List<DDT_CategoryMaster> categoryList=diabetesDignosticServiceImpl.getAllDiabetesCategories();

                           // Display the category wise filtered suggestions 
                           model.addAttribute("candidateSuggestionViewModelList", candidateSuggestionViewModelList);
                           model.addAttribute("candidateExam", candidateExam);
                           model.addAttribute("categoryList", categoryList);
                           model.addAttribute("age", candidateAge);
                           model.addAttribute("dueDate", dueDate);

                          /* System.out.println("Candidate Name : "+candidateExam.getCandidate().getCandidateUserName());
                           for (CandidateSuggestionViewModel sm : candidateSuggestionViewModelList) {
                                  
                                  System.out.println(sm.getSuggestionMaster().getSuggestionID()+" : "+sm.getSuggestionMaster().getSuggestionText());
                           }*/
                            if(SessionHelper.getIsSessionThirdParty(request))
               				{
                            	model.addAttribute("oesPartnerMaster", new OESPartnerServiceImpl().getOESPartnerMaster(Long.parseLong(SessionHelper.getPartnerObject(request).get(GatewayConstants.PARTNERID))));
               				}
                     }
              } 
              catch (Exception e) 
              {
                     LOGGER.error("Error while processing",e);
              }
              if(candidateExam.getCandidatePaperLanguage().equals("ec0f0fd4-dbe6-446b-be59-a6edea276479")) {
            	  //return "diabetesDignostic/diabetesDignosticTestEnResult";
            	  return "diabetesDignostic/aaiTestReportEn";
              }else {
            	 // return "diabetesDignostic/diabetesDignosticTestResult";
            	  return "diabetesDignostic/aaiTestReportMr";
              }
       }
       
       /**
        * Get method for Diabetes Diagnostic Test Report Print
        * @param model
        * @param request
        * @param candidateUserName
        * @param examEventId
        * @param paperId
        * @param attemptNo
        * @param locale
        * @return String this returns the path of a view
        */
       @RequestMapping(value={"/diabetesDiagnosticTestReportPrint"},method = RequestMethod.GET)
       public String getDiabetesDiagnosticTestReportPrint(Model model,HttpServletRequest request,String candidateUserName,String examEventId,
                     String paperId,String attemptNo,Locale locale) 
       {
       
              return "";
       }
       
       /**
        * Method to Split Integers
        * @param expression
        * @return Map<String, String> this returns the integer map
        */
       private  Map<String,String> splitIntegers(String expression)
           {
              Map<String,String> integerMap = new HashMap<String, String>();
              char[] tokens = expression.toCharArray();
               for (int i = 0; i < tokens.length; i++)
                {
                    // Current token is a number, push it to stack for numbers
                    if ((tokens[i] >= '0' && tokens[i] <= '9') || tokens[i] == '*')
                    {
                                    StringBuffer sbuf = new StringBuffer();
                                    // There may be more than one digits in number
                                    while (i < tokens.length && ((tokens[i] >= '0' && tokens[i] <= '9') || tokens[i] == '*'))
                                                    sbuf.append(tokens[i++]);
                                    integerMap.put(sbuf.toString(),"false");
                    }
                }
              
              return integerMap;
           }
}


