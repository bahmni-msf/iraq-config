import org.apache.commons.lang.StringUtils
import org.apache.commons.lang.ObjectUtils
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniEncounterTransaction
import org.openmrs.module.bahmniemrapi.encountertransaction.contract.BahmniObservation
import org.openmrs.module.bahmniemrapi.obscalculator.ObsValueCalculator
import org.openmrs.module.emrapi.encounter.domain.EncounterTransaction
import org.bahmni.module.bahmnicore.service.impl.BahmniBridge
import java.text.DecimalFormat
import java.util.Set;
import java.util.HashSet;


public class BahmniObsValueCalculator implements ObsValueCalculator {
    static BahmniBridge bahmniBridge = BahmniBridge.create();
    static def logger = new File("/tmp/groovy_debug.txt");

    static String FIELD_PATH_PREFIX = "Physiotherapy Assessment";
    static String FIELD_PATH = "Physiotherapy Assessment.1";
    static String NAMESPACE = "Bahmni";

    static String PA_FIELD_PATH_PREFIX = "Physiotherapy Assessment";
    static String PA_FIELD_PATH = "Physiotherapy Assessment.1";
    static String AA_FIELD_PATH_PREFIX = "Amputee Assessment";
    static String AA_FIELD_PATH = "Amputee Assessment.1";
    static String OPD_FIELD_PATH_PREFIX = "OPD Progress Note MD";
    static String OPD_FIELD_PATH = "OPD Progress Note MD.1";
    static String IME_FIELD_PATH_PREFIX = "Initial Medical Examination";
    static String IME_FIELD_PATH = "Initial Medical Examination.1";
    static String IPN_FIELD_PATH_PREFIX = "IPD Progress Note MD";
    static String IPN_FIELD_PATH = "IPD Progress Note MD.1";
    static String ANA_FIELD_PATH_PREFIX = "Admission Nursing Assessment";
    static String ANA_FIELD_PATH = "Admission Nursing Assessment.1";


    static boolean isLower = false;
    static boolean isUpper = false;
    static boolean isPhysiotherapy = false;
    static boolean isAmputee = false;
    static boolean isOPD = false;
    static boolean isIME = false;
    static boolean isIPN = false;
    static boolean isANA = false;

    static final String PA_OBS_BALANCE_SECTION = "/492-0";
    static final String PA_OBS_GAIT_SECTION = "/493-0";
    static final String PA_OBS_TINETTI_TOTAL = "/543-0";
    static final String PA_OBS_RISK_OF_FALLS = "/510-0";
    static final String PA_OBS_LEFI_TOTAL = "/544-0";
    static final String PA_OBS_PEDIATRIC_LOWER_TOTAL = "/567-0";
    static final String PA_OBS_BASIC_GRIP_TOTAL = "/498-0";
    static final String PA_OBS_UEFI_TOTAL = "/499-0";
    static final String PA_OBS_FINAL_SCORE_TOTAL = "/500-0";
    static final String PA_OBS_PEDIATRIC_UPPER_TOTAL = "/566-0";

    static final String AA_OBS_BALANCE_SECTION = "/335-0";
    static final String AA_OBS_GAIT_SECTION = "/336-0";
    static final String AA_OBS_TINETTI_TOTAL = "/337-0";
    static final String AA_OBS_RISK_OF_FALLS = "/298-0";

    static final String OPD_OBS_DN4_SUM = "/76-0";
    static final String IME_OBS_DN4_SUM = "/61-0/136-0";
    static final String IPN_OBS_DN4_SUM = "/74-0";
    static final String ANA_OBS_DN4_SUM = "/46-0";

    static List<String> paBalanceSectionControlIDs = Arrays.asList("/35-0", "/36-0", "/139-0", "/140-0", "/141-0", "/325-0", "/144-0", "/145-0", "/146-0", "/147-0");
    static List<String> paGaitSectionControlIDs = Arrays.asList("/38-0", "/39-0", "/149-0", "/150-0", "/151-0", "/152-0", "/153-0", "/154-0");
    static List<String> paLefiSectionControlIDs = Arrays.asList("/549-0", "/45-0", "/156-0", "/157-0", "/158-0", "/159-0", "/160-0", "/161-0", "/162-0", "/163-0", "/165-0", "/166-0", "/167-0", "/168-0", "/169-0", "/170-0", "/171-0", "/172-0", "/173-0","/174-0");
    static List<String> paPediatricLowerSectionControlIDs = Arrays.asList("/47-0", "/48-0", "/176-0", "/177-0", "/178-0", "/179-0", "/181-0", "/182-0", "/183-0", "/184-0", "/185-0", "/186-0", "/187-0", "/188-0", "/189-0", "/190-0", "/191-0", "/192-0", "/193-0","/194-0");

    static List<String> paBasicGripControlIDs = Arrays.asList("/66-0", "/67-0", "/284-0", "/285-0", "/286-0", "/287-0");
    static List<String> paUefiControlIDs = Arrays.asList("/565-0", "/71-0", "/289-0", "/290-0", "/291-0", "/293-0", "/294-0", "/295-0", "/491-0", "/297-0", "/298-0", "/299-0", "/300-0", "/301-0", "/302-0");
    static List<String> paPediatricUpperSectionControlIDs = Arrays.asList("/73-0", "/74-0", "/305-0", "/306-0", "/307-0", "/308-0", "/309-0", "/310-0", "/311-0", "/312-0", "/313-0", "/314-0", "/315-0", "/316-0", "/317-0", "/318-0", "/319-0", "/320-0","/321-0","/322-0");

    static List<String> amputeeBalanceSectionControlIDs = Arrays.asList("/272-0", "/273-0", "/274-0", "/275-0", "/277-0", "/279-0", "/280-0","/281-0", "/282-0", "/283-0");
    static List<String> amputeeGaitSectionControlIDs = Arrays.asList("/324-0", "/289-0", "/290-0", "/291-0", "/292-0", "/293-0", "/294-0","/295-0");

    static List<String> opdDN4SectionControlIDs = Arrays.asList("/65-0", "/66-0", "/67-0", "/68-0", "/69-0", "/70-0", "/71-0","/72-0", "/73-0", "/74-0");
    static List<String> imeDN4SectionControlIDs = Arrays.asList("/61-0/62-0", "/61-0/63-0", "/61-0/64-0", "/61-0/65-0", "/61-0/67-0", "/61-0/68-0","/61-0/69-0", "/61-0/70-0", "/61-0/71-0", "/61-0/72-0");
    static List<String> ipnDN4SectionControlIDs = Arrays.asList("/26-0", "/27-0", "/28-0", "/30-0", "/31-0", "/33-0", "/34-0","/36-0", "/37-0", "/40-0");
    static List<String> anaSectionControlIDs = Arrays.asList("/7-0", "/50-0");
    static String imePrefix = "/49-";

    def static finalScore = ["0.0", "8.5", "14.4", "18.6", "21.7", "24.3", "26.5", "28.4", "30.1", "31.7",
                             "33.1", "34.4", "35.6", "36.7", "37.8", "38.9", "39.9", "40.8", "41.8", "42.7",
                             "43.5", "44.4", "45.2", "46.0", "46.9", "47.6", "48.4", "49.2", "50.0", "50.7",
                             "51.5", "52.3", "53.0", "53.8", "54.6", "55.3", "56.1", "56.9", "57.7", "58.5",
                             "59.4", "60.2", "61.1", "62.0", "63.0", "64.0", "65.0", "66.1", "67.3", "68.5",
                             "69.9", "71.3", "72.9", "74.8", "76.8", "79.3", "82.3", "86.2", "91.8", "100.0"] as String[]

    public void run(BahmniEncounterTransaction bahmniEncounterTransaction) {

        verifySections(bahmniEncounterTransaction.getObservations());

        if(isPhysiotherapy) {
            FIELD_PATH_PREFIX = PA_FIELD_PATH_PREFIX;
            FIELD_PATH = PA_FIELD_PATH;

            processPhysiotherapyAssessment(bahmniEncounterTransaction);
        }
        if(isAmputee && isLower) {
            FIELD_PATH_PREFIX = AA_FIELD_PATH_PREFIX;
            FIELD_PATH = AA_FIELD_PATH;
            processAmputeeAssessment(bahmniEncounterTransaction);
        }
        if(isOPD) {
            FIELD_PATH_PREFIX = OPD_FIELD_PATH_PREFIX;
            FIELD_PATH = OPD_FIELD_PATH;
            processOPD(bahmniEncounterTransaction);
        }
        if(isIME) {
            FIELD_PATH_PREFIX = IME_FIELD_PATH_PREFIX;
            FIELD_PATH = IME_FIELD_PATH;
            processIME(bahmniEncounterTransaction);
        }
        if(isIPN) {
            FIELD_PATH_PREFIX = IPN_FIELD_PATH_PREFIX;
            FIELD_PATH = IPN_FIELD_PATH;
            processIPN(bahmniEncounterTransaction);
        }
        if(isANA) {
            FIELD_PATH_PREFIX = ANA_FIELD_PATH_PREFIX;
            FIELD_PATH = ANA_FIELD_PATH;
            processANA(bahmniEncounterTransaction);
        }
    }

    static void verifySections(Collection<BahmniObservation> observations) {
        for (BahmniObservation observation : observations) {
            if(observation.getFormFieldPath() != null) {
                String controlID = observation.getFormFieldPath().substring(observation.getFormFieldPath().indexOf("/"));
                if(observation.getFormFieldPath().startsWith(PA_FIELD_PATH_PREFIX)) {
                    isPhysiotherapy = true;
                    PA_FIELD_PATH = observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf("/"));
                    if(paBalanceSectionControlIDs.contains(controlID) || paGaitSectionControlIDs.contains(controlID) || paLefiSectionControlIDs.contains(controlID) || paPediatricLowerSectionControlIDs.contains(controlID))
                        isLower = true;
                    else if(paBasicGripControlIDs.contains(controlID) || paUefiControlIDs.contains(controlID) || paPediatricUpperSectionControlIDs.contains(controlID)) {
                        isUpper = true;
                    }
                }
                if(observation.getFormFieldPath().startsWith(AA_FIELD_PATH_PREFIX)) {
                    isAmputee = true;
                    AA_FIELD_PATH = observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf("/"));
                    if(amputeeBalanceSectionControlIDs.contains(controlID) || amputeeGaitSectionControlIDs.contains(controlID))
                        isLower = true;
                }
                if(observation.getFormFieldPath().startsWith(OPD_FIELD_PATH_PREFIX)) {
                    isOPD = true;
                    OPD_FIELD_PATH = observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf("/"));
                }
                if(observation.getFormFieldPath().startsWith(IME_FIELD_PATH_PREFIX)) {
                    isIME = true;
                    IME_FIELD_PATH = observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf("/"));
                }
                if(observation.getFormFieldPath().startsWith(IPN_FIELD_PATH_PREFIX)) {
                    isIPN = true;
                    IPN_FIELD_PATH = observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf("/"));
                }

                if(observation.getFormFieldPath().startsWith(ANA_FIELD_PATH_PREFIX)) {
                    isANA = true;
                    ANA_FIELD_PATH = observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf("/"));
                }
            }
        }
    }

    static void processPhysiotherapyAssessment(BahmniEncounterTransaction bahmniEncounterTransaction) {
        Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap = new HashMap<>();
        if(isLower) {
            Map<String, BahmniObservation> balanceSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(paBalanceSectionControlIDs, bahmniEncounterTransaction.getObservations(), balanceSectionObsConceptMap);
            int balanceTotal = 0;
            balanceTotal  = findSumOfObservations(bahmniEncounterTransaction, balanceSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Balance Score", PA_OBS_BALANCE_SECTION, 1, false);
            if(balanceTotal == -1)
                updateObservation(bahmniEncounterTransaction, "", "PA, Balance Score", PA_OBS_BALANCE_SECTION);

            Map<String, BahmniObservation> gaitSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(paGaitSectionControlIDs, bahmniEncounterTransaction.getObservations(), gaitSectionObsConceptMap);
            findObsForMultiSelectConceptsOfForm(paGaitSectionControlIDs, bahmniEncounterTransaction.getObservations(), bahmniMultiSelectObsConceptMap);
            int gaitTotal = 0;
            gaitTotal = findSumOfObservations(bahmniEncounterTransaction, gaitSectionObsConceptMap, bahmniMultiSelectObsConceptMap,"PA, Gait Score", PA_OBS_GAIT_SECTION,1, false);
            if(gaitTotal == -1)
                updateObservation(bahmniEncounterTransaction, "", "PA, Gait Score", PA_OBS_GAIT_SECTION);
            bahmniMultiSelectObsConceptMap.clear();

            int total = balanceTotal + gaitTotal;
            String totalStr = "";
            if( gaitTotal == -1 && balanceTotal == -1) {
                totalStr = "";
            } else if(gaitTotal == -1) {
                totalStr = "" + balanceTotal;
            } else if(balanceTotal == -1) {
                totalStr = "" + gaitTotal;
            } else {
                totalStr = "" + total;
            }
            updateObservation(bahmniEncounterTransaction, totalStr, "PA, Total Score Tinetti Balance Assessment Tool", PA_OBS_TINETTI_TOTAL);

            String risk = "";
            if(gaitTotal != -1 || balanceTotal != -1 ) {
                if(total <= 18)
                    risk = "High";
                else if(total < 24)
                    risk = "Moderate";
                else if(total >= 24)
                    risk = "Low";
            }
            updateObservation(bahmniEncounterTransaction, risk, "PA, Risk of falls", PA_OBS_RISK_OF_FALLS);

            Map<String, BahmniObservation> lefiSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(paLefiSectionControlIDs, bahmniEncounterTransaction.getObservations(), lefiSectionObsConceptMap);
            int lefiTotal = findSumOfObservations(bahmniEncounterTransaction, lefiSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Total Score Lower Extremity Functional Index (LEFI)", PA_OBS_LEFI_TOTAL, 0, false);

            Map<String, BahmniObservation> pediatricLowerSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(paPediatricLowerSectionControlIDs, bahmniEncounterTransaction.getObservations(), pediatricLowerSectionObsConceptMap);
            int pediatricLowerTotal = findSumOfObservations(bahmniEncounterTransaction, pediatricLowerSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Total Score Pediatric Lower Extremity Function - Mobility", PA_OBS_PEDIATRIC_LOWER_TOTAL, 0, true);
        }
        if(isUpper) {
            Map<String, BahmniObservation> basicGripObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(paBasicGripControlIDs, bahmniEncounterTransaction.getObservations(), basicGripObsConceptMap);
            int basicGripTotal = findSumOfObservations(bahmniEncounterTransaction, basicGripObsConceptMap, bahmniMultiSelectObsConceptMap,"PA, Basic grip test, total score", PA_OBS_BASIC_GRIP_TOTAL, 0, false);

            Map<String, BahmniObservation> uefiObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(paUefiControlIDs, bahmniEncounterTransaction.getObservations(), uefiObsConceptMap);
            int uefiTotal  = findSumOfObservations(bahmniEncounterTransaction, uefiObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Total raw score", PA_OBS_UEFI_TOTAL, 0, false);

            String finalScoreStr = "";
            if(uefiTotal != -1)
                finalScoreStr = finalScore[uefiTotal] + "";
            updateObservation(bahmniEncounterTransaction, finalScoreStr, "PA, Final score", PA_OBS_FINAL_SCORE_TOTAL);

            Map<String, BahmniObservation> pediatricUpperSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(paPediatricUpperSectionControlIDs, bahmniEncounterTransaction.getObservations(), pediatricUpperSectionObsConceptMap);
            int pediatricUpperTotal = findSumOfObservations(bahmniEncounterTransaction, pediatricUpperSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Total score Pediatric Upper Extremity Function - Fine Motor, ADL", PA_OBS_PEDIATRIC_UPPER_TOTAL, 0, true);
        }

    }

    static void processAmputeeAssessment(BahmniEncounterTransaction bahmniEncounterTransaction) {
        Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap = new HashMap<>();

        if(isLower) {
            Map<String, BahmniObservation> balanceSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(amputeeBalanceSectionControlIDs, bahmniEncounterTransaction.getObservations(), balanceSectionObsConceptMap);
            int balanceTotal = 0;
            balanceTotal  = findSumOfObservations(bahmniEncounterTransaction, balanceSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "PA, Balance Score", AA_OBS_BALANCE_SECTION, 1, false);
            if(balanceTotal == -1)
                updateObservation(bahmniEncounterTransaction, "", "PA, Balance Score", AA_OBS_BALANCE_SECTION);

            Map<String, BahmniObservation> gaitSectionObsConceptMap = new HashMap<>();
            findObsForConceptsOfForm(amputeeGaitSectionControlIDs, bahmniEncounterTransaction.getObservations(), gaitSectionObsConceptMap);
            findObsForMultiSelectConceptsOfForm(amputeeGaitSectionControlIDs, bahmniEncounterTransaction.getObservations(), bahmniMultiSelectObsConceptMap);
            int gaitTotal = 0;
            gaitTotal = findSumOfObservations(bahmniEncounterTransaction, gaitSectionObsConceptMap, bahmniMultiSelectObsConceptMap,"PA, Gait Score", AA_OBS_GAIT_SECTION,1, false);
            if(gaitTotal == -1)
                updateObservation(bahmniEncounterTransaction, "", "PA, Gait Score", AA_OBS_GAIT_SECTION);
            bahmniMultiSelectObsConceptMap.clear();

            int total = balanceTotal + gaitTotal;
            String totalStr = "";
            if( gaitTotal == -1 && balanceTotal == -1) {
                totalStr = "";
            } else if(gaitTotal == -1) {
                totalStr = "" + balanceTotal;
            } else if(balanceTotal == -1) {
                totalStr = "" + gaitTotal;
            } else {
                totalStr = "" + total;
            }
            updateObservation(bahmniEncounterTransaction, totalStr, "PA, Total Score Tinetti Balance Assessment Tool", AA_OBS_TINETTI_TOTAL);

            String risk = "";
            if(gaitTotal != -1 || balanceTotal != -1 ) {
                if(total <= 18)
                    risk = "High";
                else if(total < 24)
                    risk = "Moderate";
                else if(total >= 24)
                    risk = "Low";
            }
            updateObservation(bahmniEncounterTransaction, risk, "PA, Risk of falls", AA_OBS_RISK_OF_FALLS);
        }

    }

    static void processOPD(BahmniEncounterTransaction bahmniEncounterTransaction) {
        Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap = new HashMap<>();
        Map<String, BahmniObservation> opdDN4SectionObsConceptMap = new HashMap<>();
        findObsForConceptsOfForm(opdDN4SectionControlIDs, bahmniEncounterTransaction.getObservations(), opdDN4SectionObsConceptMap);
        int balanceTotal = 0;
        balanceTotal  = findSumOfObservations(bahmniEncounterTransaction, opdDN4SectionObsConceptMap, bahmniMultiSelectObsConceptMap, "OPN, Neuropathic pain score", OPD_OBS_DN4_SUM, 0, false);
        if(balanceTotal == -1)
            updateObservation(bahmniEncounterTransaction, "", "OPD, Neuropathic pain score", OPD_OBS_DN4_SUM);
    }

    static void processIME(BahmniEncounterTransaction bahmniEncounterTransaction) {
        Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap = new HashMap<>();
        Map<String, BahmniObservation> imeDN4SectionObsConceptMap = new HashMap<>();
        Set<String> addMorePrefixes = getNumberOfAddMoreSections(imePrefix, imeDN4SectionControlIDs, bahmniEncounterTransaction.getObservations(), imeDN4SectionObsConceptMap);
        Iterator<String> it = addMorePrefixes.iterator();
        while(it.hasNext()) {
            String addMoreID = it.next();
//            logger.append("Processing " +  addMoreID + "\n");
            int balanceTotal = 0;
            findObsForAddMoreConceptsOfForm(addMoreID, imeDN4SectionControlIDs, bahmniEncounterTransaction.getObservations(), imeDN4SectionObsConceptMap);
            balanceTotal  = findSumOfObservations(bahmniEncounterTransaction, imeDN4SectionObsConceptMap, bahmniMultiSelectObsConceptMap, "IME, Neuropathic pain score", "/" + addMoreID + IME_OBS_DN4_SUM, 0, false);
            if(balanceTotal == -1)
                updateObservation(bahmniEncounterTransaction, "", "IME, Neuropathic pain score", "/" + addMoreID + IME_OBS_DN4_SUM);
            imeDN4SectionObsConceptMap.clear();
        }
    }


    static void processIPN(BahmniEncounterTransaction bahmniEncounterTransaction) {
        Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap = new HashMap<>();
        Map<String, BahmniObservation> ipnSectionObsConceptMap = new HashMap<>();
        findObsForConceptsOfForm(ipnDN4SectionControlIDs, bahmniEncounterTransaction.getObservations(), ipnSectionObsConceptMap);
        int balanceTotal = 0;
        balanceTotal  = findSumOfObservations(bahmniEncounterTransaction, ipnSectionObsConceptMap, bahmniMultiSelectObsConceptMap, "IPN, Neuropathic pain score", IPN_OBS_DN4_SUM, 0, false);
        if(balanceTotal == -1)
            updateObservation(bahmniEncounterTransaction, "", "IPN, Neuropathic pain score", IPN_OBS_DN4_SUM);
    }

    static void processANA(BahmniEncounterTransaction bahmniEncounterTransaction) {
        Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap = new HashMap<>();
        Map<String, BahmniObservation> anaSectionObsConceptMap = new HashMap<>();
        BahmniObservation bmiObservation = getObservation(bahmniEncounterTransaction.getObservations(), FIELD_PATH +  ANA_OBS_DN4_SUM);
        findObsForConceptsOfForm(anaSectionControlIDs, bahmniEncounterTransaction.getObservations(), anaSectionObsConceptMap);
        if ( !hasValue(anaSectionObsConceptMap.values()[0]) ||  !hasValue(anaSectionObsConceptMap.values()[1])){
            if(bmiObservation != null)
                voidObs(bmiObservation);
        }
        if ( hasValue(anaSectionObsConceptMap.values()[0]) &&  hasValue(anaSectionObsConceptMap.values()[1]))
        {
            def weight = anaSectionObsConceptMap.values()[0].getValue().toFloat();
            def height = anaSectionObsConceptMap.values()[1].getValue().toFloat();
            float BMI = weight / (height/100 * height/100);

            DecimalFormat df = new DecimalFormat("0.00");
            BMI = df.format(BMI).toFloat() ;


            def nowAsOfEncounter = bahmniEncounterTransaction.getEncounterDateTime() != null ? bahmniEncounterTransaction.getEncounterDateTime() : new Date();
            Date obsDatetime = bmiObservation != null ? bmiObservation.getEncounterDateTime() : nowAsOfEncounter;
            bmiObservation = bmiObservation != null ? bmiObservation : createObs("ANA, BMI", bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
            logger.append("\nValue [" + bmiObservation.getValue() + "]\n");
            bmiObservation.setFormFieldPath(FIELD_PATH + ANA_OBS_DN4_SUM)
            bmiObservation.setFormNamespace(NAMESPACE)
            if("".equals(BMI))
                voidObs(bmiObservation);
            else
                bmiObservation.setValue(BMI);
        }
    }

    static Set<String> getNumberOfAddMoreSections(String prefix, List<String> ControlIDsList, Collection<BahmniObservation> observations, Map<String, BahmniObservation> bahmniObsConceptMap) {
        int addMoreCount = 0;
        Set<String> allObs = new HashSet<>();
        for (BahmniObservation observation : observations) {
            if(observation.getFormFieldPath() != null) {
                if (observation.getFormFieldPath().startsWith(IME_FIELD_PATH + prefix) && !observation.getVoided()) {
                    String controlID = observation.getFormFieldPath().substring(IME_FIELD_PATH.length() + 1);
                    allObs.add(controlID.substring(0,controlID.indexOf("/")));
                }
            }
        }
        return allObs;
    }

    static void findObsForAddMoreConceptsOfForm(String prefix, List<String> ControlIDsList, Collection<BahmniObservation> observations, Map<String, BahmniObservation> bahmniObsConceptMap) {
        for (BahmniObservation observation : observations) {
            if(observation.getFormFieldPath() != null) {
                if (observation.getFormFieldPath().startsWith(IME_FIELD_PATH + "/" + prefix) &&
                        !observation.getVoided() &&
                        !observation.getFormFieldPath().contains(IME_OBS_DN4_SUM) &&
                        !observation.getFormFieldPath().contains("/112") &&
                        !observation.getFormFieldPath().contains("/135") &&
                        !observation.getFormFieldPath().contains("/127") &&
                        !observation.getFormFieldPath().contains("/55") &&
                        !observation.getFormFieldPath().contains("/57") &&
                        !observation.getFormFieldPath().contains("/59") &&
                        !observation.getFormFieldPath().contains("/132") &&
                        !observation.getFormFieldPath().contains("/74")) {
                    bahmniObsConceptMap.put(observation.getConcept().getName(), observation);
                }
            }
        }
    }

    static void findObsForConceptsOfForm(List<String> ControlIDsList, Collection<BahmniObservation> observations, Map<String, BahmniObservation> bahmniObsConceptMap) {
        for (BahmniObservation observation : observations) {
            if(observation.getFormFieldPath() != null) {
                if (ControlIDsList.contains(observation.getFormFieldPath().substring(observation.getFormFieldPath().indexOf("/"))) &&
                        !observation.getVoided() &&
                        FIELD_PATH_PREFIX.equals(observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf(".")))) {
                    if(!"PA, Step length and height".equals(observation.getConcept().getName()) && !"PA, Foot clearance".equals(observation.getConcept().getName())) {
                        bahmniObsConceptMap.put(observation.getConcept().getName(), observation);
                    }
                }
            }
        }
    }

    static void findObsForMultiSelectConceptsOfForm(List<String> ControlIDsList, Collection<BahmniObservation> observations, Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap) {
        for (BahmniObservation observation : observations) {
            if(observation.getFormFieldPath() != null) {
                if (ControlIDsList.contains(observation.getFormFieldPath().substring(observation.getFormFieldPath().indexOf("/"))) &&
                        !observation.getVoided() &&
                        FIELD_PATH_PREFIX.equals(observation.getFormFieldPath().substring(0, observation.getFormFieldPath().indexOf(".")))) {
                    if((isPhysiotherapy || isAmputee) && ("PA, Step length and height".equals(observation.getConcept().getName()) || "PA, Foot clearance".equals(observation.getConcept().getName()))) {
                        List<BahmniObservation> obsList =  ObjectUtils.defaultIfNull(bahmniMultiSelectObsConceptMap.get(observation.getConcept().getName()),new ArrayList<BahmniObservation>())
                        obsList.add(observation);
                        bahmniMultiSelectObsConceptMap.put(observation.getConcept().getName(),obsList);
                    }
                }
            }
        }
    }

    static int findSumOfObservations(BahmniEncounterTransaction bahmniEncounterTransaction, Map<String, BahmniObservation> bahmniObsConceptMap, Map<String, List<BahmniObservation>> bahmniMultiSelectObsConceptMap, String conceptName, String controlID, int valueIndex, boolean isPercentageRequired) {
        BahmniObservation observation = getObservation(bahmniEncounterTransaction.getObservations(), FIELD_PATH + controlID);
        Date obsDatetime = new Date();
        observation = observation != null ? observation : createObs(conceptName, bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
        observation.setValue("");
        observation.setFormFieldPath(FIELD_PATH + controlID)
        observation.setFormNamespace(NAMESPACE)
        int total = 0;
        int numberOfQuestionsAnswered = 0;
        for (entry in bahmniObsConceptMap) {
            if(entry.getValue().getValue().name.name != null) {
                int currentValue = 0;
                if(entry.getValue().getValue().name.name.contains("="))
                    currentValue = Integer.parseInt(entry.getValue().getValue().name.name.split("=")[valueIndex].trim());
                else {
                    if("No".equals(entry.getValue().getValue().name.name))
                        currentValue = 0;
                    else if("Yes".equals(entry.getValue().getValue().name.name))
                        currentValue = 1;
                    else
                        currentValue = Integer.parseInt(entry.getValue().getValue().name.name);
                }
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
        if(isPercentageRequired) {
            String totalStr = "0.0";
            if(numberOfQuestionsAnswered > 0) {
                DecimalFormat df = new DecimalFormat("0.00");
                float percentage = total / (4 * numberOfQuestionsAnswered) * 100;
                totalStr = df.format(percentage) ;
                observation.setValue(totalStr);
            } else {
                voidObs(observation);
            }
        } else {
            if(numberOfQuestionsAnswered == 0)
                voidObs(observation);
            else {
                observation.setValue(total);
            }
        }
        if(numberOfQuestionsAnswered == 0)
            return -1;
        return total;
    }

    static void updateObservation(BahmniEncounterTransaction bahmniEncounterTransaction, String value, String conceptName, String controlID) {
        BahmniObservation observation = getObservation(bahmniEncounterTransaction.getObservations(), FIELD_PATH +  controlID);
        def nowAsOfEncounter = bahmniEncounterTransaction.getEncounterDateTime() != null ? bahmniEncounterTransaction.getEncounterDateTime() : new Date();
        Date obsDatetime = observation != null ? observation.getEncounterDateTime() : nowAsOfEncounter;
        observation = observation != null ? observation : createObs(conceptName, bahmniEncounterTransaction, obsDatetime) as BahmniObservation;
        observation.setFormFieldPath(FIELD_PATH + controlID)
        observation.setFormNamespace(NAMESPACE)
        if("".equals(value))
            voidObs(observation);
        else
            observation.setValue(value);

    }
    private static boolean hasValue(BahmniObservation observation) {
        return observation != null && observation.getValue() != null && !StringUtils.isEmpty(observation.getValue().toString());
    }

    private static Date getDate(BahmniObservation observation) {
        return hasValue(observation) && !observation.voided ? observation.getObservationDateTime() : null;
    }

    private static void voidObs(BahmniObservation bahmniObservation) {
        if (bahmniObservation != null) {
            bahmniObservation.voided = true
        }
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