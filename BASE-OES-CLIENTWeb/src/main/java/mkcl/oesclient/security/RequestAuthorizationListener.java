/**
 * 
 */
package mkcl.oesclient.security;

import java.util.EnumSet;

import javax.servlet.DispatcherType;
import javax.servlet.FilterRegistration;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * @author virajd
 *
 */
public class RequestAuthorizationListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		FilterRegistration fr=sce.getServletContext().addFilter("RequestAuthorizationFilter", RequestAuthorizationFilter.class);
		
		// Request authorization for Admin
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/dashboard/adminDashBoard");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/dashboard/candidateDetails");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/EnableDisableExamEvent/manageExamEvent");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/syncData/selectSyncEvent");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/syncData/examEventSingleCandidate");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/login/SupervisorchangePwd");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/login/resetSupervisorPwd");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/resetExamStatus/resetStatus");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/examEventClosure/examActivityLogSearch");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/examEventClosure/examActivityLog");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/dashboard/uploadStatus");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/examEventClosure/bulkEndExamGet");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/superviserModule/scheduleExam");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/superviserModule/getSubjectWisePaper");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/groupSchedule/scheduleLabSession");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/superviserModule/viewExamSchedule");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/groupSchedule/viewLabSessionSchedule");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/syncDataSMC/dbBackupList");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/loginReport/CandidateLoginReport");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/loginReport/candidateloginReportList");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/TestReport/CandidateTestReport");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/TestReport/CandidateTestReportlist");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/TestReport/AttemptedPaperTestReport");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/adminLogin/scoreCard");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/GroupReport/groupReport");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/report/prAbsReport");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/report/candidateWiseprAbsReport");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/TestReport/sectionwisemarks");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/ExamReports/markDetailsReport");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/ExamReports/ExamWiseMarkDetails");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/TestReport/questAtmptCntRpt");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/candidateAttempt/attemptDetails");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/CandidateInformation/CandidateInformationReport");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/login/changePassword");
		
		// Request authorization for Candidate
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/candidateModule/confExamHomePage");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/candidateModule/viewActivityCalendar");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/endexam/showTestResult");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/exam/instruction");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/exam/TakeTest");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/ResultAnalysis/questionByquestion");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/ResultAnalysis/viewtestscore");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/ResultAnalysis/topicwise");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/ResultAnalysis/difficultylevelwise");
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/candidateModule/homepage");

		// Common for admin and candidate
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/candidateReport/CandidateAcademicSummaryReport");
		
		// for Diabetes Admin
		fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD), true, "/ddtdashboard/ddtDashBoard");

		fr.setInitParameter("adminRequests", "/dashboard/adminDashBoard,/dashboard/candidateDetails,/EnableDisableExamEvent/manageExamEvent,/syncData/selectSyncEvent,/syncData/examEventSingleCandidate,/login/SupervisorchangePwd,/login/resetSupervisorPwd,/resetExamStatus/resetStatus,/examEventClosure/examActivityLogSearch,/examEventClosure/examActivityLog,/dashboard/uploadStatus,/examEventClosure/bulkEndExamGet,/superviserModule/scheduleExam,/superviserModule/getSubjectWisePaper,/groupSchedule/scheduleLabSession,/superviserModule/viewExamSchedule,/groupSchedule/viewLabSessionSchedule,/syncDataSMC/dbBackupList,/loginReport/CandidateLoginReport,/loginReport/candidateloginReportList,/TestReport/CandidateTestReport,/TestReport/CandidateTestReportlist,/TestReport/AttemptedPaperTestReport,/candidateReport/CandidateAcademicSummaryReport,/adminLogin/scoreCard,/GroupReport/groupReport,/report/prAbsReport,/report/candidateWiseprAbsReport,/TestReport/sectionwisemarks,/ExamReports/markDetailsReport,/ExamReports/ExamWiseMarkDetails,/TestReport/questAtmptCntRpt,/candidateAttempt/attemptDetails,/CandidateInformation/CandidateInformationReport,/login/changePassword,/ResultAnalysis/viewtestscore,/ResultAnalysis/questionByquestion,/ResultAnalysis/topicwise,/ResultAnalysis/difficultylevelwise");
		fr.setInitParameter("candidateRequests", "/candidateModule/confExamHomePage,/candidateModule/viewActivityCalendar,/endexam/showTestResult,/exam/instruction,/exam/TakeTest,/ResultAnalysis/questionByquestion,/ResultAnalysis/viewtestscore,/ResultAnalysis/topicwise,/ResultAnalysis/difficultylevelwise,/candidateReport/CandidateAcademicSummaryReport,/candidateModule/homepage");
		fr.setInitParameter("ddtAdminRequests", "/ResultAnalysis/viewtestscore,/ResultAnalysis/questionByquestion,/ResultAnalysis/topicwise,/ResultAnalysis/difficultylevelwise,/ddtdashboard/ddtDashBoard");
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {

	}

}
