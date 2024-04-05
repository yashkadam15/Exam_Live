/**
 * 
 */
package mkcl.oesclient.common;

import org.junit.Test;

/**
 * @author virajd
 *
 */
public class GroupFormationTestCase {

	@Test
	public void testGroupFormation() {
		int minCandidate=2;
		int maxCandidate=5;
		
		int arrCandidates[]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18};
		int startIndex=0;
		int totalCandidate=18;
		System.out.println("Total Candidate:"+totalCandidate);
		while(totalCandidate>0){
			if(totalCandidate >= minCandidate){
				int nextGroupRemaining=0;
				nextGroupRemaining=totalCandidate-maxCandidate;
				if (nextGroupRemaining < minCandidate && nextGroupRemaining !=0) {
					maxCandidate=maxCandidate-1;
					continue;
				}else{
					totalCandidate=totalCandidate-maxCandidate;
					System.out.println("Group size:"+maxCandidate+" Remaining cand:"+totalCandidate);
					for (int i = 0; i < maxCandidate; i++) {
						System.out.println("Candidate"+arrCandidates[startIndex]);
						startIndex++;
					}
					
					if (totalCandidate<=0) {
						break;
					}
					
				}				
			}else{
				totalCandidate=totalCandidate-maxCandidate;
				System.out.println("Group size:"+maxCandidate+" Remaining cand:"+totalCandidate);
				for (int i = 0; i < maxCandidate; i++) {
					System.out.println("Candidate"+arrCandidates[startIndex]);
					startIndex++;
				}
				if (totalCandidate<=0) {
					break;
				}
			}
		}
	}

}
