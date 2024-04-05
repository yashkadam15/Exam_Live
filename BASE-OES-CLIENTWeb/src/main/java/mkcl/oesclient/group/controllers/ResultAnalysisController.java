package mkcl.oesclient.group.controllers;

/**
 * @author virajd
 *
 */

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.GroupMaster;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.utilities.SessionHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("GroupResultAnalysisController")
@RequestMapping("GroupResultAnalysis")
public class ResultAnalysisController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ResultAnalysisController.class);
	private static final String EXAMEVENTID = "examEventId";
	private static final String PAPERID = "paperId";
	
	/**
	 * Get method for Group Analysis Candidate List
	 * @param model
	 * @param request
	 * @return 	String this returns the path of a view
	 */
	@RequestMapping(value = { "/groupAnalysisCandidateList" }, method = RequestMethod.GET)
	public String groupAnalysisCandidateList(Model model, HttpServletRequest request) {
		try {
			String examEventID = request.getParameter(EXAMEVENTID);
			String paperID = request.getParameter(PAPERID);
			long examEventId = 0;
			long paperId = 0;

			if (examEventID != null && !examEventID.equals("")) {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && !paperID.equals("")) {
				paperId = Long.valueOf(paperID);
			}
			List<Candidate> listCandidates=new ArrayList<Candidate>();
			CandidateServiceImpl candidateServiceImplObj=new CandidateServiceImpl();
			CandidateExamServiceImpl objCandidateExamServiceImpl=new CandidateExamServiceImpl();
			// Get listCandidates from session
			listCandidates=SessionHelper.getCandidates(request);

			// Get group object from session
			GroupMaster groupMasterObj= SessionHelper.getGroupMaster(request);			

			// Fill candidate object of listCandidates
			listCandidates=candidateServiceImplObj.getCandidateList(listCandidates);
			Map<Candidate, Boolean> mapCandidateAndPaperAttemptStatus=new HashMap<Candidate, Boolean>();
			if (listCandidates !=null && listCandidates.size()>0) {
				for (Candidate candidate : listCandidates) {
					boolean paperAttemptStatus=false;
					paperAttemptStatus=objCandidateExamServiceImpl.isExamCompleated(candidate.getCandidateID(), examEventId, paperId,1);
					mapCandidateAndPaperAttemptStatus.put(candidate, paperAttemptStatus);
				}
			}
			//model.addAttribute("listCandidates", listCandidates);
			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);
			model.addAttribute("loginType", LoginType.Group);
			model.addAttribute("groupMasterObj", groupMasterObj);
			model.addAttribute("mapCandidateAndPaperAttemptStatus", mapCandidateAndPaperAttemptStatus);
		} catch (Exception e) {
			LOGGER.error("Error in groupCandidateList: " , e);
		}
		return "Group/candidateModule/GroupAnalysisCandidateList";

	}

	/**
	 * Get method for Group Score Card Candidate List
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/groupScoreCardCandidateList" }, method = RequestMethod.GET)
	public String groupScoreCardCandidateList(Model model, HttpServletRequest request) {
		try {
			String examEventID = request.getParameter(EXAMEVENTID);
			String paperID = request.getParameter(PAPERID);
			String attemptNo = request.getParameter("attemptNo");
			long examEventId = 0;
			long paperId = 0;
			long attemptNoLong = 0;

			if (examEventID != null && !examEventID.equals("")) {
				examEventId = Long.valueOf(examEventID);
			}
			if (paperID != null && !paperID.equals("")) {
				paperId = Long.valueOf(paperID);
			}
			if (attemptNo != null && !attemptNo.isEmpty()) {
				attemptNoLong = Long.valueOf(attemptNo);
			}
			List<Candidate> listCandidates=new ArrayList<Candidate>();
			CandidateServiceImpl candidateServiceImplObj=new CandidateServiceImpl();
			// Get listCandidates from session
			listCandidates=SessionHelper.getCandidates(request);

			// Get group object from session
			GroupMaster groupMasterObj= SessionHelper.getGroupMaster(request);

			// temp code for candidate list
			/*for (int i = 231; i < 233; i++) {
				Candidate candidate=new Candidate();
				candidate.setCandidateID(Long.valueOf(i));
				listCandidates.add(candidate);
			}*/

			// Fill candidate object of listCandidates
			
			model.addAttribute("listCandidates", candidateServiceImplObj.getCandidateExamListFromCandidateID(listCandidates,examEventId,paperId,attemptNoLong));
			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);
			model.addAttribute("attemptNo", attemptNoLong);
			model.addAttribute("loginType", LoginType.Group);
			model.addAttribute("groupMasterObj", groupMasterObj);
		} catch (Exception e) {
			LOGGER.error("Error in groupCandidateList: " , e);
		}
		return "Group/candidateModule/GroupScoreCardCandidateList";

	}

}
