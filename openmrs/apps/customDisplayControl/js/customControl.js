'use strict';

angular.module('bahmni.common.displaycontrol.custom')
    .directive('birthCertificate', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
            var link = function ($scope) {
                var conceptNames = ["HEIGHT"];
                $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/birthCertificate.html";
                spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "latest", undefined, $scope.visitUuid, undefined).then(function (response) {
                    $scope.observations = response.data;
                }));
            };

            return {
                restrict: 'E',
                template: '<ng-include src="contentUrl"/>',
                link: link
            }
    }]).directive('deathCertificate', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
        var link = function ($scope) {
            var conceptNames = ["WEIGHT"];
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/deathCertificate.html";
            spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "latest", undefined, $scope.visitUuid, undefined).then(function (response) {
                $scope.observations = response.data;
            }));
        };

        return {
            restrict: 'E',
            link: link,
            template: '<ng-include src="contentUrl"/>'
        }
    }]).directive('customTreatmentChart', ['appService', 'treatmentConfig', 'TreatmentService', 'spinner', '$q', function (appService, treatmentConfig, treatmentService, spinner, $q) {
    var link = function ($scope) {
        var Constants = Bahmni.Clinical.Constants;
        var days = [
            'Sunday',
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday'
        ];
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/customTreatmentChart.html";

        $scope.atLeastOneDrugForDay = function (day) {
            var atLeastOneDrugForDay = false;
            $scope.ipdDrugOrders.getIPDDrugs().forEach(function (drug) {
                if (drug.isActiveOnDate(day.date)) {
                    atLeastOneDrugForDay = true;
                }
            });
            return atLeastOneDrugForDay;
        };

        $scope.getVisitStopDateTime = function () {
            return $scope.visitSummary.stopDateTime || Bahmni.Common.Util.DateUtil.now();
        };

        $scope.getStatusOnDate = function (drug, date) {
            var activeDrugOrders = _.filter(drug.orders, function (order) {
                if ($scope.config.frequenciesToBeHandled.indexOf(order.getFrequency()) !== -1) {
                    return getStatusBasedOnFrequency(order, date);
                } else {
                    return drug.getStatusOnDate(date) === 'active';
                }
            });
            if (activeDrugOrders.length === 0) {
                return 'inactive';
            }
            if (_.every(activeDrugOrders, function (order) {
                    return order.getStatusOnDate(date) === 'stopped';
                })) {
                return 'stopped';
            }
            return 'active';
        };

        var getStatusBasedOnFrequency = function (order, date) {
            var activeBetweenDate = order.isActiveOnDate(date);
            var frequencies = order.getFrequency().split(",").map(function (day) {
                return day.trim();
            });
            var dayNumber = moment(date).day();
            return activeBetweenDate && frequencies.indexOf(days[dayNumber]) !== -1;
        };

        var init = function () {
            var getToDate = function () {
                return $scope.visitSummary.stopDateTime || Bahmni.Common.Util.DateUtil.now();
            };

            var programConfig = appService.getAppDescriptor().getConfigValue("program") || {};

            var startDate = null, endDate = null, getEffectiveOrdersOnly = false;
            if (programConfig.showDetailsWithinDateRange) {
                startDate = $stateParams.dateEnrolled;
                endDate = $stateParams.dateCompleted;
                if (startDate || endDate) {
                    $scope.config.showOtherActive = false;
                }
                getEffectiveOrdersOnly = true;
            }

            return $q.all([treatmentConfig(), treatmentService.getPrescribedAndActiveDrugOrders($scope.config.patientUuid, $scope.config.numberOfVisits,
                $scope.config.showOtherActive, $scope.config.visitUuids || [], startDate, endDate, getEffectiveOrdersOnly)])
                .then(function (results) {
                    var config = results[0];
                    var drugOrderResponse = results[1].data;
                    var createDrugOrderViewModel = function (drugOrder) {
                        return Bahmni.Clinical.DrugOrderViewModel.createFromContract(drugOrder, config);
                    };
                    for (var key in drugOrderResponse) {
                        drugOrderResponse[key] = drugOrderResponse[key].map(createDrugOrderViewModel);
                    }

                    var groupedByVisit = _.groupBy(drugOrderResponse.visitDrugOrders, function (drugOrder) {
                        return drugOrder.visit.startDateTime;
                    });
                    var treatmentSections = [];

                    for (var key in groupedByVisit) {
                        var values = Bahmni.Clinical.DrugOrder.Util.mergeContinuousTreatments(groupedByVisit[key]);
                        treatmentSections.push({visitDate: key, drugOrders: values});
                    }
                    if (!_.isEmpty(drugOrderResponse[Constants.otherActiveDrugOrders])) {
                        var mergedOtherActiveDrugOrders = Bahmni.Clinical.DrugOrder.Util.mergeContinuousTreatments(drugOrderResponse[Constants.otherActiveDrugOrders]);
                        treatmentSections.push({
                            visitDate: Constants.otherActiveDrugOrders,
                            drugOrders: mergedOtherActiveDrugOrders
                        });
                    }
                    $scope.treatmentSections = treatmentSections;
                    if ($scope.visitSummary) {
                        $scope.ipdDrugOrders = Bahmni.Clinical.VisitDrugOrder.createFromDrugOrders(drugOrderResponse.visitDrugOrders, $scope.visitSummary.startDateTime, getToDate());
                    }
                });
        };
        spinner.forPromise(init());
    };

    return {
        restrict: 'E',
        link: link,
        scope: {
            config: "=",
            visitSummary: '='
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]).directive('patientAppointmentsDashboard', ['$http', '$q', '$window','appService', function ($http, $q, $window, appService) {
    var link = function ($scope) {
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/patientAppointmentsDashboard.html";
        var getUpcomingAppointments = function () {
            var params = {
                q: "bahmni.sqlGet.upComingAppointments",
                v: "full",
                patientUuid: $scope.patient.uuid
            };
            return $http.get('/openmrs/ws/rest/v1/bahmnicore/sql', {
                method: "GET",
                params: params,
                withCredentials: true
            });
        };
        var getPastAppointments = function () {
            var params = {
                q: "bahmni.sqlGet.pastAppointments",
                v: "full",
                patientUuid: $scope.patient.uuid
            };
            return $http.get('/openmrs/ws/rest/v1/bahmnicore/sql', {
                method: "GET",
                params: params,
                withCredentials: true
            });
        };
        $q.all([getUpcomingAppointments(), getPastAppointments()]).then(function (response) {
            $scope.upcomingAppointments = response[0].data;
            $scope.upcomingAppointmentsHeadings = _.keys($scope.upcomingAppointments[0]);
            $scope.pastAppointments = response[1].data;
            $scope.pastAppointmentsHeadings = _.keys($scope.pastAppointments[0]);
        });

        $scope.goToListView = function () {
            $window.open('/bahmni/appointments/#/home/manage/appointments/list');
        };
    };
    return {
        restrict: 'E',
        link: link,
        scope: {
            patient: "=",
            section: "="
        },
        template: '<ng-include src="contentUrl"/>'
    };
}]).directive('patientInformation', ['appService', 'conceptSetService', '$http', function (appService, conceptSetService, $http) {

    const filterValueByConcept = function (records, conceptName) {
        return _.filter(records, function (eachObs) {
            return eachObs.concept.name === conceptName;
        })
    };

    const fetchObservationsData = function (conceptNames, scope, angularScope) {
        var params = {
            concept: conceptNames,
            patientUuid: angularScope.patient.uuid,
            scope: scope,
            loadComplexData: false
        };
        return $http.get('/openmrs/ws/rest/v1/bahmnicore/observations', {
            params: params,
            withCredentials: true
        });
    };

    const getValidInformation = function (patientInformation) {
        return _.filter(patientInformation, function (eachConcept) {
            return !_.isEmpty(eachConcept.answer) || eachConcept.answer > 0;
        });
    };

    var link = function ($scope) {

        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/patientSummary.html";
        var conceptNames = ["IME, Date of admission","OPN, Date of discharge","Hospital of Origin","Treating Surgeon","Other Hospital of Origin"];

        fetchObservationsData(conceptNames,"latest", $scope).then(function (response) {

            const dateofAdmissionConcept = filterValueByConcept(response.data, "IME, Date of admission");
            const dateOfDischargeConcept = filterValueByConcept(response.data, "OPN, Date of discharge");
            const hospitalOfOriginConcept = filterValueByConcept(response.data, "Hospital of Origin");
            const treatingSurgeonConcept = filterValueByConcept(response.data, "Treating Surgeon");

            if (!_.isEmpty(dateOfDischargeConcept)) {
                var dateOfDischargeConcepts = dateOfDischargeConcept[0].value;
            }

            if (!_.isEmpty(dateofAdmissionConcept)) {
                var dateofAdmissionConcepts = dateofAdmissionConcept[0].value;
            }

            var hospitalOfOriginConcepts = undefined;

            if (!_.isEmpty(hospitalOfOriginConcept)) {
                hospitalOfOriginConcepts = hospitalOfOriginConcept[0].value.name;
            }

            if (hospitalOfOriginConcepts === 'Other') {
                const otherHospitalOfOriginConcept = filterValueByConcept(response.data, "Other Hospital of Origin");
                hospitalOfOriginConcepts = otherHospitalOfOriginConcept[0].value;
            }

            if (!_.isEmpty(treatingSurgeonConcept)) {
                var treatingSurgeonConcepts = treatingSurgeonConcept[0].value;
            }

            var patientInformation = [
                {name: "Date of admission", answer: dateofAdmissionConcepts},
                {name: "Date of discharge", answer: dateOfDischargeConcepts},
                {name: "Hospital of Origin", answer: hospitalOfOriginConcepts},
                {name: "Treating Surgeon", answer: treatingSurgeonConcepts}
            ];
            $scope.concepts = getValidInformation(patientInformation);

            $scope.isDataPresent = function () {
                return _.isEmpty($scope.concepts);
            };
        });
    };

    return {
        link: link,
        scope: {
            patient: "=",
            section: "=",
            enrollment: "="
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]).directive('initialClinicalExamination', ['$http', '$stateParams', '$q', 'appService', 'spinner', function ($http, $stateParams, $q, appService, spinner) {
    var controller = function ($scope) {
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/initialClinicalExamination.html";
        $scope.title = $scope.config.title;
        console.log($scope.title);
        var getResponseFromQuery = function (queryParameter) {
            var params = {
                patientUuid: $scope.patient.uuid,
                q: queryParameter,
                v: "full"
            };
            return $http.get('/openmrs/ws/rest/v1/bahmnicore/sql', {
                method: "GET",
                params: params,
                withCredentials: true
            });
        };

        spinner.forPromise($q.all([getResponseFromQuery("bahmni.sqlGet.initialClinicalExaminationData")]).then(function (response) {
            $scope.initialClinicalExamination = response[0].data;
            console.log($scope.initialClinicalExamination);
            $scope.diagnosis_date = $scope.initialClinicalExamination[0] && $scope.initialClinicalExamination[0].enc_date;
        }));
    };

    return {
        restrict: 'E',
        controller: controller,
        template: '<ng-include src="contentUrl"/>'
    }
}]).directive('surgicalDiagnosis', ['$http', '$stateParams', '$q', 'appService', 'spinner', function ($http, $stateParams, $q, appService, spinner) {
    var controller = function ($scope) {
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/surgicalDiagnosis.html";
        $scope.title = $scope.config.title;

        var getResponseFromQuery = function (queryParameter) {
            var params = {
                patientUuid: $scope.patient.uuid,
                q: queryParameter,
                v: "full"
            };
            return $http.get('/openmrs/ws/rest/v1/bahmnicore/sql', {
                method: "GET",
                params: params,
                withCredentials: true
            });
        };

        spinner.forPromise($q.all([getResponseFromQuery("bahmni.sqlGet.surgicalDiagnosisData"), getResponseFromQuery("bahmni.sqlGet.medicalDiagnosisData")]).then(function (response) {
            $scope.headings = ["Surgical Diagnosis", "Side and Site"];
            $scope.medicalDiagnosisHeadings = ["Medical Diagnosis"];
            $scope.surgicalDiagnosis = response[0].data;
            $scope.medicalDiagnosis = response[1].data;
        }));
    };

    return {
        restrict: 'E',
        controller: controller,
        template: '<ng-include src="contentUrl"/>'
    }
}]).directive('pastMedicalHistory', ['appService', 'conceptSetService', '$http', function (appService, conceptSetService, $http) {
    var link = function ($scope) {
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/pastMedicalHistory.html";
        var conceptNames = [
            "IME, Date of Injury",
            "Date of injury",
            "Cause of injury",
            "IME, Cause of Injury",
            "IME, Past Medical History",
            "IME, Significant findings, social history",
            "IME, History of present illness (context)"
        ];
        const fetchObservationsData = function (conceptNames, scope, angularScope) {
            var params = {
                concept: conceptNames,
                patientUuid: angularScope.patient.uuid,
                loadComplexData: false,
                scope: scope
            };
            return $http.get('/openmrs/ws/rest/v1/bahmnicore/observations', {
                params: params,
                withCredentials: true
            });
        };
        const getPastMedicalHistoryData = function (encounterData) {
            var concepts = new Map();
            var imeDateOfInjuryObsDateTime = undefined;
            var dateOfInjuryObsDateTime = undefined;
            var imeCauseOfInjuryObsDateTime = undefined;
            var causeOfInjuryObsDateTime = undefined;
            var key = '';
            _.each(encounterData, function (observation) {
                if (observation.concept.name === 'IME, Date of Injury')
                    imeDateOfInjuryObsDateTime = observation.observationDateTime;
                if (observation.concept.name === 'Date of injury')
                    dateOfInjuryObsDateTime = observation.observationDateTime;
                if (observation.concept.name === 'IME, Cause of Injury')
                    imeCauseOfInjuryObsDateTime = observation.observationDateTime;
                if (observation.concept.name === 'Cause of injury')
                    causeOfInjuryObsDateTime = observation.observationDateTime;
                if (observation.concept.name === 'IME, Date of Injury')
                    key = observation.concept.name;
                else if (observation.concept.name === 'IME, Cause of Injury')
                    key = observation.concept.name;
                else
                    key = observation.conceptNameToDisplay;
                const value = observation.valueAsString;
                if (concepts.has(key)) {
                    var values = concepts.get(key);
                    values.push(value);
                } else {
                    concepts.set(key, [value])
                }
            });
            // Keep only latest date of injury and cause of injury
            if (imeCauseOfInjuryObsDateTime && dateOfInjuryObsDateTime) {
                if (imeDateOfInjuryObsDateTime > dateOfInjuryObsDateTime) {
                    concepts.set('Date of injury', concepts.get('IME, Date of Injury'));
                    concepts.delete('IME, Date of Injury');
                } else {
                    concepts.delete('IME, Date of Injury');
                }
            } else if (imeCauseOfInjuryObsDateTime) {
                concepts.set('Date of injury', concepts.get('IME, Date of Injury'));
                concepts.delete('IME, Date of Injury');
            } else {
            }
            if(imeCauseOfInjuryObsDateTime && causeOfInjuryObsDateTime) {
                if (imeCauseOfInjuryObsDateTime > causeOfInjuryObsDateTime) {
                    concepts.set('Cause of injury', concepts.get('IME, Cause of Injury'));
                    concepts.delete('IME, Cause of Injury');
                } else {
                    concepts.delete('IME, Cause of Injury');
                }
            } else if (imeCauseOfInjuryObsDateTime) {
                concepts.set('Cause of injury', concepts.get('IME, Cause of Injury'));
                concepts.delete('IME, Cause of Injury');
            } else {
            }

            const newConceptMap = new Map();
            concepts.has('Date of injury') ? newConceptMap.set('Date of injury', concepts.get('Date of injury')) : undefined;
            concepts.has('Cause of injury') ? newConceptMap.set('Cause of injury', concepts.get('Cause of injury')) : undefined;
            concepts.has('Cause of injury') ? newConceptMap.set('Cause of injury', concepts.get('Cause of injury')) : undefined;
            concepts.has("Past Medical History") ? newConceptMap.set('Past Medical History', concepts.get('Past Medical History')) : undefined;
            concepts.has("Significant findings, social history") ? newConceptMap.set('Significant findings, social history', concepts.get('Significant findings, social history')) : undefined;
            concepts.has("History of present illness (context)") ? newConceptMap.set('History of present illness (context)', concepts.get('History of present illness (context)')) : undefined;
            return newConceptMap;
        };
        fetchObservationsData(conceptNames, "latest", $scope).then(function (response) {
            if (response.data.length > 0) {
                $scope.allEncounter = getPastMedicalHistoryData(response.data);
                $scope.allEncounterKeys = Array.from($scope.allEncounter.keys())
            } else {
                $scope.allEncounter = []
            }
            $scope.isDataPresent = function () {
                return _.isEmpty(Array.from($scope.allEncounter.keys()));
            }
        });
    };
    return {
        link: link,
        scope: {
            patient: "=",
            section: "=",
            enrollment: "="
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]);
