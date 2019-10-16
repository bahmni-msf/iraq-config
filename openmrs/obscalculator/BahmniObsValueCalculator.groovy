import org.apache.commons.lang.StringUtils
import org.apache.commons.lang.ObjectUtils
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniEncounterTransaction
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniObservation
import org.openmrs.module.bahmniemrapi.obscalculator.ObsValueCalculator
import org.openmrs.module.emrapi.encounter.domain.EncounterTransaction
import org.bahmni.module.bahmnicore.service.impl.BahmniBridge
import java.text.DecimalFormat

public class BahmniObsValueCalculator implements ObsValueCalculator {
    static BahmniBridge bahmniBridge = BahmniBridge.create();
    static def logger = new File("/tmp/groovy_debug.txt");
    static final String FIELD_PATH_PREFIX = "Physiotherapy Assessment";
    static String FIELD_PATH = "Physiotherapy Assessment.1";
    static String NAMESPACE = "Bahmni";
    static boolean isLower = false;
    static boolean isUpper = false;

    static final String OBS_BALANCE_SECTION = "/148-0";
    static final String OBS_GAIT_SECTION = "/155-0";
    static final String OBS_TINETTI_TOTAL = "/40-0";
    static final String OBS_RISK_OF_FALLS = "/41-0";
    static final String OBS_LEFI_TOTAL = "/175-0";
    static final String OBS_PEDIATRIC_LOWER_TOTAL = "/195-0";
    static final String OBS_BASIC_GRIP_TOTAL = "/288-0";
    static final String OBS_UEFI_TOTAL = "/303-0";
    static final String OBS_FINAL_SCORE_TOTAL = "/304-0";
    static final String OBS_PEDIATRIC_UPPER_TOTAL = "/323-0";

    static List<String> balanceSectionControlIDs = Arrays.asList("/35-0", "/36-0", "/139-0", "/140-0", "/141-0", "/325-0", "/144-0", "/145-0", "/146-0", "/147-0");
    static List<String> gaitSectionControlIDs = Arrays.asList("/38-0", "/39-0", "/149-0", "/150-0", "/151-0", "/152-0", "/153-0", "/154-0");
    static List<String> lefiSectionControlIDs = Arrays.asList("/44-0", "/45-0", "/156-0", "/157-0", "/158-0", "/159-0", "/160-0", "/161-0", "/162-0", "/163-0", "/165-0", "/166-0", "/167-0", "/168-0", "/169-0", "/170-0", "/171-0", "/172-0", "/173-0","/174-0");
    static List<String> pediatricLowerSectionControlIDs = Arrays.asList("/47-0", "/48-0", "/176-0", "/177-0", "/178-0", "/179-0", "/181-0", "/182-0", "/183-0", "/184-0", "/185-0", "/186-0", "/187-0", "/188-0", "/189-0", "/190-0", "/191-0", "/192-0", "/193-0","/194-0");

    static List<String> basicGripControlIDs = Arrays.asList("/66-0", "/67-0", "/284-0", "/285-0", "/286-0", "/287-0");
    static List<String> uefiControlIDs = Arrays.asList("/70-0", "/71-0", "/289-0", "/290-0", "/291-0", "/293-0", "/294-0", "/295-0", "/491-0", "/297-0", "/298-0", "/299-0", "/300-0", "/301-0", "/302-0");
    static List<String> pediatricUpperSectionControlIDs = Arrays.asList("/73-0", "/74-0", "/305-0", "/306-0", "/307-0", "/308-0", "/309-0", "/310-0", "/311-0", "/312-0", "/313-0", "/314-0", "/315-0", "/316-0", "/317-0", "/318-0", "/319-0", "/320-0","/321-0","/322-0");

    def finalScore = ["0.0", "8.5", "14.4", "18.6", "21.7", "24.3", "26.5", "28.4", "30.1", "31.7",
                      "33.1", "34.4", "35.6", "36.7", "37.8", "38.9", "39.9", "40.8", "41.8", "42.7",
                      "43.5", "44.4", "45.2", "46.0", "46.9", "47.6", "48.4", "49.2", "50.0", "50.7",
                      "51.5", "52.3", "53.0", "53.8", "54.6", "55.3", "56.1", "56.9", "57.7", "58.5",
                      "59.4", "60.2", "61.1", "62.0", "63.0", "64.0", "65.0", "66.1", "67.3", "68.5",
                      "69.9", "71.3", "72.9", "74.8", "76.8", "79.3", "82.3", "86.2", "91.8", "100.0"] as String[]

    public void run(BahmniEncounterTransaction bahmniEncounterTransaction) {
        logger.append( "*********************************************** "+ new Date() + "*********************************\n");

        Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap = new HashMap<>();
        verifySections(bahmniEncounterTransaction.getObservations());

        if(isLower) {
            Map<String, BahmniObservation> balanceSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(balanceSectionControlIDs, bahmniEncounterTransaction.getObservations(), balanceSectionObsConceptMap);
            int balanceTotal = 0;
            balanceTotal  = findSumOfObservations(bahmniEncounterTransaction, balanceSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Balance Score", OBS_BALANCE_SECTION, 1, false);

            Map<String, BahmniObservation> gaitSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(gaitSectionControlIDs, bahmniEncounterTransaction.getObservations(), gaitSectionObsConceptMap);
            findObsForMultiSelectConceptsOfForm(gaitSectionControlIDs, bahmniEncounterTransaction.getObservations(), bahmniMultiSelectObsConceptMap);
            int gaitTotal = 0;
            gaitTotal = findSumOfObservations(bahmniEncounterTransaction, gaitSectionObsConceptMap, bahmniMultiSelectObsConceptMap,"PA, Gait Score", OBS_GAIT_SECTION,1, false);

            bahmniMultiSelectObsConceptMap.clear();

            int total = balanceTotal + gaitTotal;
            updateObservation(bahmniEncounterTransaction, total+"", "PA, Total Score Tinetti Balance Assessment Tool", OBS_TINETTI_TOTAL);

            String risk = "";
            if(total <= 18)
                risk = "High";
            else if(total < 24)
                risk = "Moderate";
            else if(total >= 24)
                risk = "Low";
            updateObservation(bahmniEncounterTransaction, risk, "PA, Risk of falls", OBS_RISK_OF_FALLS);

            Map<String, BahmniObservation> lefiSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(lefiSectionControlIDs, bahmniEncounterTransaction.getObservations(), lefiSectionObsConceptMap);
            int lefiTotal = findSumOfObservations(bahmniEncounterTransaction, lefiSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Total Score Lower Extremity Functional Index (LEFI)", OBS_LEFI_TOTAL, 0, false);

            Map<String, BahmniObservation> pediatricLowerSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(pediatricLowerSectionControlIDs, bahmniEncounterTransaction.getObservations(), pediatricLowerSectionObsConceptMap);
            int pediatricLowerTotal = findSumOfObservations(bahmniEncounterTransaction, pediatricLowerSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Total Score Pediatric Lower Extremity Function - Mobility", OBS_PEDIATRIC_LOWER_TOTAL, 0, true);
        }
        if(isUpper) {
            Map<String, BahmniObservation> basicGripObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(basicGripControlIDs, bahmniEncounterTransaction.getObservations(), basicGripObsConceptMap);
            int basicGripTotal = findSumOfObservations(bahmniEncounterTransaction, basicGripObsConceptMap, bahmniMultiSelectObsConceptMap,"PA, Basic grip test, total score", OBS_BASIC_GRIP_TOTAL, 0, false);

            Map<String, BahmniObservation> uefiObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(uefiControlIDs, bahmniEncounterTransaction.getObservations(), uefiObsConceptMap);
            int uefiTotal  = findSumOfObservations(bahmniEncounterTransaction, uefiObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Total raw score", OBS_UEFI_TOTAL, 0, false);

            updateObservation(bahmniEncounterTransaction, finalScore[uefiTotal], "PA, Final score", OBS_FINAL_SCORE_TOTAL);

            Map<String, BahmniObservation> pediatricUpperSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(pediatricUpperSectionControlIDs, bahmniEncounterTransaction.getObservations(), pediatricUpperSectionObsConceptMap);
            int pediatricUpperTotal = findSumOfObservations(bahmniEncounterTransaction, pediatricUpperSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Total score Pediatric Upper Extremity Function - Fine Motor, ADL", OBS_PEDIATRIC_UPPER_TOTAL, 0, true);
        }
    }

    static void verifySections(Collection<BahmniObservation> observations) {
        for (BahmniObservation observation : observations) {
            if(observation.getFormFieldPath() != null) {
                String controlID = observation.getFormFieldPath().substring(observation.getFormFieldPath().indexOf("/"));
                //logger.append("Control ID " + controlID + "\n")
                if(balanceSectionControlIDs.contains(controlID) || gaitSectionControlIDs.contains(controlID) || lefiSectionControlIDs.contains(controlID) || pediatricLowerSectionControlIDs.contains(controlID))
                    isLower = true;
                else if(basicGripControlIDs.contains(controlID) || uefiControlIDs.contains(controlID) || pediatricUpperSectionControlIDs.contains(controlID))
                    isUpper = true;
            }
        }
        logger.append("isLower " + isLower + "\n");
        logger.append("isUpper " + isUpper + "\n");
    }

    static void findObsForConceptsOfForm(List<String> ControlIDsList, Collection<BahmniObservation> observations, Map<String, BahmniObservation> bahmniObsConceptMap) {
        for (BahmniObservation observation : observations) {
            //logger.append("Concept Name - " + observation.getConcept().getName() + "\n");
            if(observation.getFormFieldPath() != null) {
                FIELD_PATH = observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf("/"));
                if (ControlIDsList.contains(observation.getFormFieldPath().substring(observation.getFormFieldPath().indexOf("/"))) &&
                        !observation.getVoided() &&
                        FIELD_PATH_PREFIX.equals(observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf(".")))) {
                    if(!"PA, Step length and height".equals(observation.getConcept().getName()) && !"PA, Foot clearance".equals(observation.getConcept().getName())) {
                        bahmniObsConceptMap.put(observation.getConcept().getName(), observation);
                    }
                }
            }
        }
        logger.append("Map Size " + bahmniObsConceptMap.size() + "\n");
    }

    static void findObsForMultiSelectConceptsOfForm(List<String> ControlIDsList, Collection<BahmniObservation> observations, Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap) {
        for (BahmniObservation observation : observations) {
            if(observation.getFormFieldPath() != null) {
                if (ControlIDsList.contains(observation.getFormFieldPath().substring(observation.getFormFieldPath().indexOf("/"))) &&
                        !observation.getVoided() &&
                        FIELD_PATH_PREFIX.equals(observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf(".")))) {
                    if("PA, Step length and height".equals(observation.getConcept().getName()) || "PA, Foot clearance".equals(observation.getConcept().getName())) {
                        //logger.append("Multi Select Concept Name - " + observation.getConcept().getName() + "\n");
                        List<BahmniObservation> obsList =  ObjectUtils.defaultIfNull(bahmniMultiSelectObsConceptMap.get(observation.getConcept().getName()),new ArrayList<BahmniObservation>())
                        obsList.add(observation);
                        bahmniMultiSelectObsConceptMap.put(observation.getConcept().getName(),obsList);
                    }
                }
            }
        }
        logger.append("Multi Select Map Size " + bahmniMultiSelectObsConceptMap.size() + "\n");
    }

    static int findSumOfObservations(BahmniEncounterTransaction bahmniEncounterTransaction, Map<String, BahmniObservation> bahmniObsConceptMap, Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap, String conceptName, String controlID, int valueIndex, boolean isPercentageRequired) {
        logger.append("Final -> " + FIELD_PATH + controlID + "\n")
        BahmniObservation bmiObservation = getObservation(bahmniEncounterTransaction.getObservations(), FIELD_PATH + controlID);
        def nowAsOfEncounter = bahmniEncounterTransaction.getEncounterDateTime() != null ? bahmniEncounterTransaction.getEncounterDateTime() : new Date();
        Date obsDatetime = bahmniObsConceptMap.size() > 0 ? getDate(bahmniObsConceptMap.values().iterator().next()) : nowAsOfEncounter;
        bmiObservation = bmiObservation != null ? bmiObservation : createObs(conceptName, bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
        bmiObservation.setValue("");
        bmiObservation.setFormFieldPath(FIELD_PATH + controlID)
        bmiObservation.setFormNamespace(NAMESPACE)
        int total = 0;
        int numberOfQuestionsAnswered = 0;
        for (entry in bahmniObsConceptMap) {
            if(entry.getValue().getValue().name.name != null) {
                int currentValue = Integer.parseInt(entry.getValue().getValue().name.name.split("=")[valueIndex].trim());
                total += currentValue;
                numberOfQuestionsAnswered++;
            }
        }

        if(bahmniMultiSelectObsConceptMap.size() > 0) {
            for (entry in bahmniMultiSelectObsConceptMap) {
                numberOfQuestionsAnswered++;
                List<BahmniObservation> obsList = entry.getValue();
                for(int i = 0; i < obsList.size(); i++) {
                    if(obsList.get(i).getValue().name.name != null) {
                        int currentValue = Integer.parseInt(obsList.get(i).getValue().name.name.split("=")[valueIndex].trim());
                        total += currentValue;
                    }
                }
            }
        }
        logger.append("total : " + total + "\n");
        if(isPercentageRequired) {
            String totalStr = "0.0";
            if(total > 0) {
                DecimalFormat df = new DecimalFormat("0.00");
                float percentage = total / (4 * numberOfQuestionsAnswered) * 100;
                totalStr = df.format(percentage) ;
            }
            bmiObservation.setValue(totalStr);
        } else {
            bmiObservation.setValue(total);
        }
        return total;
    }

    static void updateObservation(BahmniEncounterTransaction bahmniEncounterTransaction, String value, String conceptName, String controlID) {
        BahmniObservation bmiObservation = getObservation(bahmniEncounterTransaction.getObservations(), FIELD_PATH +  controlID);
        logger.append("updateObservation -> [" + value + "] " + conceptName +  controlID + "\n")
        def nowAsOfEncounter = bahmniEncounterTransaction.getEncounterDateTime() != null ? bahmniEncounterTransaction.getEncounterDateTime() : new Date();
        Date obsDatetime = bmiObservation != null ? bmiObservation.getEncounterDateTime() : nowAsOfEncounter;
        bmiObservation = bmiObservation != null ? bmiObservation : createObs(conceptName, bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
        //logger.append("Value [" + bmiObservation.getValue() + "]\n");
        bmiObservation.setValue(value);
        bmiObservation.setFormFieldPath(FIELD_PATH + controlID)
        bmiObservation.setFormNamespace(NAMESPACE)
    }

    private static boolean hasValue(BahmniObservation observation) {
        return observation != null && observation.getValue() != null && !StringUtils.isEmpty(observation.getValue().toString());
    }

    private static Date getDate(BahmniObservation observation) {
        return hasValue(observation) && !observation.voided ? observation.getObservationDateTime() : null;
    }

    static BahmniObservation createObs(String conceptName, BahmniEncounterTransaction encounterTransaction, Date obsDatetime) {
        def concept = bahmniBridge.getConceptByFullySpecifiedName(conceptName)
        BahmniObservation newObservation = new BahmniObservation()
        newObservation.setConcept(new EncounterTransaction.Concept(concept.getUuid(), conceptName))
        newObservation.setObservationDateTime(obsDatetime);
        encounterTransaction.addObservation(newObservation)
        return newObservation
    }

    static BahmniObservation getObservation(Collection<BahmniObservation> observations, String observationFullName) {
        for (BahmniObservation observation : observations) {
            if(observation.getFormFieldPath().equals(observationFullName))
                return observation;
        }
        return null;
    }
}