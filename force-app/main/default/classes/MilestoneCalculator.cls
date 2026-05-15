global class MilestoneCalculator implements Support.MilestoneTriggerTimeCalculator{

    global Integer calculateMilestoneTriggerTime(String caseId, String milestoneId){
        System.debug('milestone calculator called..!!');
        List<CaseMilestone> cm = [select Id from CaseMilestone where Case.Id = :caseId];
        System.debug('cm ### ' + cm);
        return 100;
    }
}