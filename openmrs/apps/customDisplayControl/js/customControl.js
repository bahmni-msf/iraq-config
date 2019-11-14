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
}]).service("physioSummaryService", ["$http", "$q", function ($http, $q) {

    var self = this;

    const isEmpty = function (record, key) {
        return _.isEmpty(_.compact(_.get(record, key)));
    };

    const isEmptyRow = function (row) {
        return isEmpty(row, "left") && isEmpty(row, "right");
    };

    const getTableName = function(conceptName, tableTitles) {
        for (var i = 0; i < tableTitles.length; i++) {
            var table = tableTitles[i];
            if (table.dataConcepts.indexOf(conceptName) !== -1)
                return table.name;
        }
    };

    const getFormattedConceptName = function(conceptName) {
        return conceptName.split(" : ")[1]
    };

    this.map = function (tableTitles, encountersData) {
        var finalTableData = {};
        var isDataPresent = {};
        var latestEncounterIndexes = {};
        _.forEach(tableTitles, function (title) {
            isDataPresent[title.name] = [];
            latestEncounterIndexes[title.name] = 0;
        });
        for (var i = 0; i < encountersData.length; i++) {
            var encounter = encountersData[i];
            for (var j = 0; j < encounter.observations.length; j++) {
                var obs = encounter.observations[j];
                var conceptName = obs.conceptName;
                var temp = conceptName.split(" : ")[0].trim().split(" ");
                var side = temp[temp.length-1].toLowerCase();

                if (['PA, Date recorded', 'PA, Type of assessment', 'AA, Type of assessment'].indexOf(conceptName) !== -1) {
                    _.forEach(tableTitles, function (table) {
                        var tableName = table.name;
                        finalTableData[tableName] = finalTableData[tableName] || {};
                        var tableData = finalTableData[tableName];
                        var formattedConceptName = conceptName.split(',')[1].trim();
                        tableData[formattedConceptName] = tableData[formattedConceptName] || {};
                        var conceptData = tableData[formattedConceptName];
                        var finalValue;
                        if ('PA, Date recorded' === conceptName) {
                            finalValue = obs.value;
                        } else {
                            finalValue = obs.value.shortName;
                        }
                        _.forEach(table.sides, function (side) {
                            conceptData[side] = conceptData[side] || {};
                            conceptData[side][latestEncounterIndexes[tableName] + 1] = finalValue;
                        });
                    });
                    continue;
                }

                var tableName = getTableName(conceptName, tableTitles);
                var value = obs.value;
                isDataPresent[tableName][i] = true;
                const displayConceptName = getFormattedConceptName(conceptName);

                finalTableData[tableName] = finalTableData[tableName] || {};
                var tableData = finalTableData[tableName];

                tableData[displayConceptName] = tableData[displayConceptName] || {};
                var conceptData = tableData[displayConceptName];


                conceptData[side] = conceptData[side] || {};
                conceptData[side][latestEncounterIndexes[tableName] + 1] = value;
            }
            _.forEach(latestEncounterIndexes, function (value, key) {
                if(isDataPresent[key][i])
                    ++latestEncounterIndexes[key];
            })
        }

        var finalRecords = [];
        _.forEach(tableTitles, function (title) {
            var rec = {};
            rec.title = title.name;
            var numberOfHeaders = isDataPresent[title.name].filter(v => v).length;
            rec.leftHeaders = _.range(numberOfHeaders);
            rec.rightHeaders = _.range(numberOfHeaders);
            rec.data = [];
            _.forEach(title.groupConceptNames, function (groupConcept) {
                var row = {};
                row.display = groupConcept.name;
                row.sort = groupConcept.sort;
                row.left = [];
                row.right = [];
                _.forEach(_.range(1, numberOfHeaders + 1), function (index) {
                    if (finalTableData[title.name][row.display]) {
                        var left = finalTableData[title.name][row.display].left || finalTableData[title.name][row.display].flex;
                        row.left.push(left ? left[index] : "");
                        var right = finalTableData[title.name][row.display].right || finalTableData[title.name][row.display].ext;
                        row.right.push(right ? right[index] : "");
                    } else {
                        row.left.push("");
                        row.right.push("");
                    }
                });
                rec.data.push(row);
            });
            if (!_.isEmpty(rec.leftHeaders) || !_.isEmpty(rec.rightHeaders)) {
                if (title.sides.includes('left', 'right'))
                    rec.data.push({sort: 3, left: "Left", right: "Right", display: "Movement", isSubHeader: true});
                if (title.sides.includes('flex', 'ext'))
                    rec.data.push({sort: 3, left: "flex", right: "ext", display: "Movement", isSubHeader: true});
            }
            else {
                delete rec.data;
            }
            finalRecords.push(rec);
        });
        return finalRecords;
    };

    this.fetchObservationsData = function (conceptNames, patientUuid, numberOfVisits, scope) {
        var params = {
            concept: conceptNames,
            patientUuid: patientUuid,
            scope: scope,
            numberOfVisits: numberOfVisits,
            loadComplexData: false
        };
        return $http.get('/openmrs/ws/rest/v1/bahmnicore/observations', {
            params: params,
            withCredentials: true
        });
    };

    this.isEmptySummary = function (records, key) {
        return _.every(records, function (record) {
            return isEmpty(record, key);
        });
    };

    const isEmptyStumpCircumference = function (records) {
        return self.isEmptySummary(_.get(records, "data"), "values");
    };

    this.isEmptyRecord = function (records, key) {
        return isEmpty(records, key);
    };

    this.mapDataForDisplay = function ($scope, configBaseUrl, allConcepts, tableTitles) {
        var defer = $q.defer();
        $scope.contentUrl = configBaseUrl + "/customDisplayControl/views/limbPhysioSummary.html";

        $scope.isEmptyRow = isEmptyRow;
        $scope.isEmptyRecord = self.isEmptyRecord;

        var numberOfEncounters = 5;
        var promise1 = self.fetchObservationsData(allConcepts, $scope.patient.uuid, numberOfEncounters).then(function (response) {
            var groupedObservations = {};
            for (var i = 0; i < response.data.length; i++) {
                var obs = response.data[i];

                if (groupedObservations[obs.encounterUuid]) {
                    var encounter = groupedObservations[obs.encounterUuid];
                    encounter.observations.push({conceptName: obs.concept.name, value: obs.value})
                } else {
                    var encounter = {};
                    encounter.encounterUuid = obs.encounterUuid;
                    encounter.encounterDateTime = obs.encounterDateTime;
                    encounter.observations = [{conceptName: obs.concept.name, value: obs.value}];
                    groupedObservations[obs.encounterUuid] = encounter;
                }
            }
            const encountersWithLimbData = getEncountersWithGroupConcepts(groupedObservations);
            var latestEncounterData = _.sortBy(Object.values(encountersWithLimbData, 'encounterDateTime')).slice(0, numberOfEncounters);
            $scope.groupRecords = self.map(tableTitles, latestEncounterData);
        });

        var getEncountersWithGroupConcepts = function (groupedObservations) {
            var encountersWithGroupConcepts = {};
            _.forEach(groupedObservations, function (value, key) {
                if (value.observations.length <= 2) {
                    var observationsInEncounter = [];
                    value.observations[0] && observationsInEncounter.push(value.observations[0].conceptName);
                    value.observations[1] && observationsInEncounter.push(value.observations[1].conceptName);
                    _.without(observationsInEncounter, 'PA, Date recorded', 'AA, Type of assessment', 'PA, Type of assessment').length === 0
                        ? undefined : encountersWithGroupConcepts[key] = value;
                } else {
                    encountersWithGroupConcepts[key] = value;
                }
            });
            return encountersWithGroupConcepts;
        };

        $q.all([promise1]).then(function () {
            $scope.isEmptyStumpCircumference = isEmptyStumpCircumference($scope.stumpCircumferences);
            $scope.isEmptySummary = self.isEmptySummary($scope.groupRecords, "data");
            defer.resolve();
        });

        return defer.promise;
    }

}]).directive('lowerLimbPhysioSummary', ['appService', 'physioSummaryService', 'spinner', function (appService, physioSummaryService, spinner) {

    const subConcept = [{
        position: 2, member: {
            sort: 3,
            left: "Left",
            right: "Right",
            display: "Movement",
            isSubHeader: true
        }
    }];
    const conceptNames = [
        "PA, Left : Hip flexion",
        "PA, Left : Hip extension",
        "PA, Left : Hip abduction",
        "PA, Left : Hip adduction",
        "PA, Left : Hip int. rotation",
        "PA, Left : Hip ext. rotation",
        "PA, Left : Knee flexion.",
        "PA, Left : Knee extension",
        "PA, Left : Ankle dorsiflex.",
        "PA, Left : Ankle planterflex",
        "PA, Left : Ankle inversion",
        "PA, Left : Ankle eversion",
        "PA, Left : Big toe flexion",
        "PA, Left : Big toe extension",
        "PA, Right : Hip flexion",
        "PA, Right : Hip extension",
        "PA, Right : Hip abduction",
        "PA, Right : Hip adduction",
        "PA, Right : Hip int. rotation",
        "PA, Right : Hip ext. rotation",
        "PA, Right : Knee flexion.",
        "PA, Right : Knee extension",
        "PA, Right : Ankle dorsiflex.",
        "PA, Right : Ankle planterflex",
        "PA, Right : Ankle inversion",
        "PA, Right : Ankle eversion",
        "PA, Right : Big toe flexion",
        "PA, Right : Big toe extension",
        "PA, Date recorded",
        "PA, Type of assessment",
        "AA, Type of assessment",
        "PA, Left : Hip flexors",
        "PA, Right : Hip flexors",
        "PA, Left : Hip extensors",
        "PA, Right : Hip extensors",
        "PA, Left : Hip abductors",
        "PA, Right : Hip abductors",
        "PA, Left : Hip adductors",
        "PA, Right : Hip adductors",
        "PA, Left : Hip int. rotators",
        "PA, Right : Hip int. rotators",
        "PA, Left : Hip ext. rotators",
        "PA, Right : Hip ext. rotators",
        "PA, Left : Knee flexors",
        "PA, Right : Knee flexors",
        "PA, Left : Knee extensors",
        "PA, Right : Knee extensors",
        "PA, Left : Ankle dorsiflexors",
        "PA, Right : Ankle dorsiflexors",
        "PA, Left : Ankle planterflexors",
        "PA, Right : Ankle planterflexors",
        "PA, Left : Ankle invertors",
        "PA, Right : Ankle invertors",
        "PA, Left : Ankle evertors",
        "PA, Right : Ankle evertors",
        "PA, Left : Big toe flexors",
        "PA, Right : Big toe flexors",
        "PA, Left : Big toe extensors",
        "PA, Right : Big toe extensors"
    ];

    const tableTitles = [
        {
            name: 'R.O.M Test for Lower Limbs',
            additionalConcepts: subConcept,
            crucialConcepts: ['PA, Date recorded', 'PA, Type of assessment'],
            sides: ['left', 'right'],
            groupConceptNames: [
                {name: "Date recorded", sort: 1},
                {name: "Type of assessment", sort: 2},
                {name: "Hip flexion", sort: 4},
                {name: "Hip extension", sort: 5},
                {name: "Hip abduction", sort: 6},
                {name: "Hip adduction", sort: 7},
                {name: "Hip int. rotation", sort: 8},
                {name: "Hip ext. rotation", sort: 9},
                {name: "Knee flexion.", sort: 10},
                {name: "Knee extension", sort: 11},
                {name: "Ankle dorsiflex.", sort: 12},
                {name: "Ankle planterflex", sort: 13},
                {name: "Ankle inversion", sort: 14},
                {name: "Ankle eversion", sort: 15},
                {name: "Big toe flexion", sort: 16},
                {name: "Big toe extension", sort: 17}],
            dataConcepts: ["PA, Left : Hip flexion",
                "PA, Left : Hip extension",
                "PA, Left : Hip abduction",
                "PA, Left : Hip adduction",
                "PA, Left : Hip int. rotation",
                "PA, Left : Hip ext. rotation",
                "PA, Left : Knee flexion.",
                "PA, Left : Knee extension",
                "PA, Left : Ankle dorsiflex.",
                "PA, Left : Ankle planterflex",
                "PA, Left : Ankle inversion",
                "PA, Left : Ankle eversion",
                "PA, Left : Big toe flexion",
                "PA, Left : Big toe extension",
                "PA, Right : Hip flexion",
                "PA, Right : Hip extension",
                "PA, Right : Hip abduction",
                "PA, Right : Hip adduction",
                "PA, Right : Hip int. rotation",
                "PA, Right : Hip ext. rotation",
                "PA, Right : Knee flexion.",
                "PA, Right : Knee extension",
                "PA, Right : Ankle dorsiflex.",
                "PA, Right : Ankle planterflex",
                "PA, Right : Ankle inversion",
                "PA, Right : Ankle eversion",
                "PA, Right : Big toe flexion",
                "PA, Right : Big toe extension"
            ]
        },
        {
            name: 'Muscle Test for Lower Limbs',
            additionalConcepts: subConcept,
            crucialConcepts: ['PA, Date recorded', 'PA, Type of assessment'],
            sides: ['left', 'right'],
            groupConceptNames: [
                {name: "Date recorded", sort: 1},
                {name: "Type of assessment", sort: 2},
                {name: "Hip flexors", sortOrder: 4},
                {name: "Hip extensors", sortOrder: 5},
                {name: "Hip abductors", sortOrder: 6},
                {name: "Hip adductors", sortOrder: 7},
                {name: "Hip int. rotators", sortOrder: 8},
                {name: "Hip ext. rotators", sortOrder: 9},
                {name: "Knee flexors", sortOrder: 10},
                {name: "Knee extensors", sortOrder: 11},
                {name: "Ankle dorsiflexors", sortOrder: 12},
                {name: "Ankle planterflexors", sortOrder: 13},
                {name: "Ankle invertors", sortOrder: 14},
                {name: "Ankle evertors", sortOrder: 15},
                {name: "Big toe flexors", sortOrder: 16},
                {name: "Big toe extensors", sortOrder: 17}],
            dataConcepts: ["PA, Left : Hip flexors",
                "PA, Right : Hip flexors",
                "PA, Left : Hip extensors",
                "PA, Right : Hip extensors",
                "PA, Left : Hip abductors",
                "PA, Right : Hip abductors",
                "PA, Left : Hip adductors",
                "PA, Right : Hip adductors",
                "PA, Left : Hip int. rotators",
                "PA, Right : Hip int. rotators",
                "PA, Left : Hip ext. rotators",
                "PA, Right : Hip ext. rotators",
                "PA, Left : Knee flexors",
                "PA, Right : Knee flexors",
                "PA, Left : Knee extensors",
                "PA, Right : Knee extensors",
                "PA, Left : Ankle dorsiflexors",
                "PA, Right : Ankle dorsiflexors",
                "PA, Left : Ankle planterflexors",
                "PA, Right : Ankle planterflexors",
                "PA, Left : Ankle invertors",
                "PA, Right : Ankle invertors",
                "PA, Left : Ankle evertors",
                "PA, Right : Ankle evertors",
                "PA, Left : Big toe flexors",
                "PA, Right : Big toe flexors",
                "PA, Left : Big toe extensors",
                "PA, Right : Big toe extensors"]
        }
    ];

    var link = function ($scope, element) {
        var promise = physioSummaryService.mapDataForDisplay($scope, appService.configBaseUrl(), conceptNames, tableTitles);
        spinner.forPromise(promise, element);
    };

    return {
        link: link,
        scope: {
            patient: "=",
            section: "="
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]).directive('upperLimbPhysioSummary', ['appService', 'physioSummaryService', 'spinner', '$q', function (appService, physioSummaryService, spinner, $q) {

    const conceptNames = [
        "PA, Date recorded",
        "PA, Type of assessment",
        "AA, Type of assessment",
        "PA, Left : Shoulder flexion",
        "PA, Right : Shoulder flexion",
        "PA, Left : Shoulder extension",
        "PA, Right : Shoulder extension",
        "PA, Left : Shoulder abduction",
        "PA, Right : Shoulder abduction",
        "PA, Left : Shoulder adduction",
        "PA, Right : Shoulder adduction",
        "PA, Left : Shoulder int. rotation",
        "PA, Right : Shoulder int. rotation",
        "PA, Left : Shoulder ext. rotation",
        "PA, Right : Shoulder ext. rotation",
        "PA, Left : Elbow flexion",
        "PA, Right : Elbow flexion",
        "PA, Left : Elbow extension",
        "PA, Right : Elbow extension",
        "PA, Left : Forearm pronation",
        "PA, Right : Forearm pronation",
        "PA, Left : Forearm supination",
        "PA, Right : Forearm supination",
        "PA, Left : Wrist flexion",
        "PA, Right : Wrist flexion",
        "PA, Left : Wrist extension",
        "PA, Right : Wrist extension",
        "PA, Left : Ulnar Dev.",
        "PA, Right : Ulnar Dev.",
        "PA, Left : Radial Dev.",
        "PA, Right : Radial Dev.",
        "PA, Left : Fingers flexion",
        "PA, Right : Fingers flexion",
        "PA, Left : Fingers extension",
        "PA, Right : Fingers extension",
        "PA, Flex : Thumb MC",
        "PA, Ext. : Thumb MC",
        "PA, Flex : Thumb DIP",
        "PA, Ext. : Thumb DIP",
        "PA, Flex : 2nd Finger MC",
        "PA, Ext. : 2nd Finger MC",
        "PA, Flex : 3rd Finger MC",
        "PA, Ext. : 3rd Finger MC",
        "PA, Flex : 4th Finger MC",
        "PA, Ext. : 4th Finger MC",
        "PA, Flex : 5th Finger MC",
        "PA, Ext. : 5th Finger MC",
        "PA, Flex : 2nd Finger PIP",
        "PA, Ext : 2nd Finger PIP",
        "PA, Flex : 3rd Finger PIP",
        "PA, Ext : 3rd Finger PIP",
        "PA, Flex : 4th Finger PIP",
        "PA, Ext : 4th Finger PIP",
        "PA, Flex : 5th Finger PIP",
        "PA, Ext : 5th Finger PIP",
        "PA, Flex : 2nd Finger DIP",
        "PA, Ext. : 2nd Finger DIP",
        "PA, Flex : 3rd Finger DIP",
        "PA, Ext. : 3rd Finger DIP",
        "PA, Flex : 4th Finger DIP",
        "PA, Ext. : 4th Finger DIP",
        "PA, Flex : 5th Finger DIP",
        "PA, Ext. : 5th Finger DIP",
        "PA, Left : Shoulder flexors",
        "PA, Right : Shoulder flexors",
        "PA, Left : Shoulder extensors",
        "PA, Right : Shoulder extensors",
        "PA, Left : Shoulder abductors",
        "PA, Right : Shoulder abductors",
        "PA, Left : Shoulder adductors",
        "PA, Right : Shoulder adductors",
        "PA, Left : Shoulder int. rotators",
        "PA, Right : Shoulder int. rotators",
        "PA, Left : Shoulder ext. rotators",
        "PA, Right : Shoulder ext. rotators",
        "PA, Left : Elbow flexors",
        "PA, Right : Elbow flexors",
        "PA, Left : Elbow extensors",
        "PA, Right : Elbow extensors",
        "PA, Left : Forearm pronators",
        "PA, Right : Forearm pronators",
        "PA, Left : Forearm supinators",
        "PA, Right : Forearm supinators",
        "PA, Left : Wrist flexors",
        "PA, Right : Wrist flexors",
        "PA, Left : Wrist extensors",
        "PA, Right : Wrist extensors",
        "PA, Left : Ulnar Dev.",
        "PA, Right : Ulnar Dev.",
        "PA, Left : Radial Dev.",
        "PA, Right : Radial Dev.",
        "PA, Left : Fingers flexors",
        "PA, Right : Fingers flexors",
        "PA, Left : Fingers extensors",
        "PA, Right : Fingers extensors"];

    const tableTitles = [
        {
            name: 'R.O.M Test for Upper Limbs',
            sides: ['left', 'right'],
            groupConceptNames: [
                {name: "Date recorded", sort: 1},
                {name: "Type of assessment", sort: 2},
                {name: "Shoulder flexion", sort: 4},
                {name: "Shoulder extension", sort: 5},
                {name: "Shoulder abduction", sort: 6},
                {name: "Shoulder adduction", sort: 7},
                {name: "Shoulder int. rotation", sort: 8},
                {name: "Shoulder ext. rotation", sort: 9},
                {name: "Elbow flexion", sort: 10},
                {name: "Elbow extension", sort: 11},
                {name: "Forearm pronation", sort: 12},
                {name: "Forearm supination", sort: 13},
                {name: "Wrist flexion", sort: 14},
                {name: "Wrist extension", sort: 15},
                {name: "Ulnar Dev.", sort: 16},
                {name: "Radial Dev.", sort: 17},
                {name: "Fingers flexion", sort: 18},
                {name: "Fingers extension", sort: 19}],
            dataConcepts: [
                "PA, Left : Shoulder flexion",
                "PA, Right : Shoulder flexion",
                "PA, Left : Shoulder extension",
                "PA, Right : Shoulder extension",
                "PA, Left : Shoulder abduction",
                "PA, Right : Shoulder abduction",
                "PA, Left : Shoulder adduction",
                "PA, Right : Shoulder adduction",
                "PA, Left : Shoulder int. rotation",
                "PA, Right : Shoulder int. rotation",
                "PA, Left : Shoulder ext. rotation",
                "PA, Right : Shoulder ext. rotation",
                "PA, Left : Elbow flexion",
                "PA, Right : Elbow flexion",
                "PA, Left : Elbow extension",
                "PA, Right : Elbow extension",
                "PA, Left : Forearm pronation",
                "PA, Right : Forearm pronation",
                "PA, Left : Forearm supination",
                "PA, Right : Forearm supination",
                "PA, Left : Wrist flexion",
                "PA, Right : Wrist flexion",
                "PA, Left : Wrist extension",
                "PA, Right : Wrist extension",
                "PA, Left : Ulnar Dev.",
                "PA, Right : Ulnar Dev.",
                "PA, Left : Radial Dev.",
                "PA, Right : Radial Dev.",
                "PA, Left : Fingers flexion",
                "PA, Right : Fingers flexion",
                "PA, Left : Fingers extension",
                "PA, Right : Fingers extension",]
        },
        {
            name: 'Hand and Finger',
            sides: ['flex', 'ext'],
            groupConceptNames: [
                {name: "Date recorded", sort: 1},
                {name: "Type of assessment", sort: 2},
                {name: "Thumb MC", sort: 4},
                {name: "Thumb DIP", sort: 5},
                {name: "2nd Finger MC", sort: 6},
                {name: "3rd Finger MC", sort: 7},
                {name: "4th Finger MC", sort: 8},
                {name: "5th Finger MC", sort: 9},
                {name: "2nd Finger PIP", sort: 10},
                {name: "3rd Finger PIP", sort: 11},
                {name: "4th Finger PIP", sort: 12},
                {name: "5th Finger PIP", sort: 13},
                {name: "2nd Finger DIP", sort: 14},
                {name: "3rd Finger DIP", sort: 15},
                {name: "4th Finger DIP", sort: 16},
                {name: "5th Finger DIP", sort: 17}],
            dataConcepts: ["PA, Flex : Thumb MC",
                "PA, Ext. : Thumb MC",
                "PA, Flex : Thumb DIP",
                "PA, Ext. : Thumb DIP",
                "PA, Flex : 2nd Finger MC",
                "PA, Ext. : 2nd Finger MC",
                "PA, Flex : 3rd Finger MC",
                "PA, Ext. : 3rd Finger MC",
                "PA, Flex : 4th Finger MC",
                "PA, Ext. : 4th Finger MC",
                "PA, Flex : 5th Finger MC",
                "PA, Ext. : 5th Finger MC",
                "PA, Flex : 2nd Finger PIP",
                "PA, Ext : 2nd Finger PIP",
                "PA, Flex : 3rd Finger PIP",
                "PA, Ext : 3rd Finger PIP",
                "PA, Flex : 4th Finger PIP",
                "PA, Ext : 4th Finger PIP",
                "PA, Flex : 5th Finger PIP",
                "PA, Ext : 5th Finger PIP",
                "PA, Flex : 2nd Finger DIP",
                "PA, Ext. : 2nd Finger DIP",
                "PA, Flex : 3rd Finger DIP",
                "PA, Ext. : 3rd Finger DIP",
                "PA, Flex : 4th Finger DIP",
                "PA, Ext. : 4th Finger DIP",
                "PA, Flex : 5th Finger DIP",
                "PA, Ext. : 5th Finger DIP",]
        },
        {
            name: 'Muscle Test for Upper Limbs',
            sides: ['left', 'right'],
            groupConceptNames: [
                {name: "Date recorded", sort: 1},
                {name: "Type of assessment", sort: 2},
                {name: "Shoulder flexors", sort: 4},
                {name: "Shoulder extensors", sort: 5},
                {name: "Shoulder abductors", sort: 6},
                {name: "Shoulder adductors", sort: 7},
                {name: "Shoulder int. rotators", sort: 8},
                {name: "Shoulder ext. rotators", sort: 9},
                {name: "Elbow flexors", sort: 10},
                {name: "Elbow extensors", sort: 11},
                {name: "Forearm pronators", sort: 12},
                {name: "Forearm supinators", sort: 13},
                {name: "Wrist flexors", sort: 14},
                {name: "Wrist extensors", sort: 15},
                {name: "Ulnar Dev.", sort: 16},
                {name: "Radial Dev.", sort: 17},
                {name: "Fingers flexors", sort: 18},
                {name: "Fingers extensors", sort: 19}],
            dataConcepts: ["PA, Left : Shoulder flexors",
                "PA, Right : Shoulder flexors",
                "PA, Left : Shoulder extensors",
                "PA, Right : Shoulder extensors",
                "PA, Left : Shoulder abductors",
                "PA, Right : Shoulder abductors",
                "PA, Left : Shoulder adductors",
                "PA, Right : Shoulder adductors",
                "PA, Left : Shoulder int. rotators",
                "PA, Right : Shoulder int. rotators",
                "PA, Left : Shoulder ext. rotators",
                "PA, Right : Shoulder ext. rotators",
                "PA, Left : Elbow flexors",
                "PA, Right : Elbow flexors",
                "PA, Left : Elbow extensors",
                "PA, Right : Elbow extensors",
                "PA, Left : Forearm pronators",
                "PA, Right : Forearm pronators",
                "PA, Left : Forearm supinators",
                "PA, Right : Forearm supinators",
                "PA, Left : Wrist flexors",
                "PA, Right : Wrist flexors",
                "PA, Left : Wrist extensors",
                "PA, Right : Wrist extensors",
                "PA, Left : Ulnar Dev.",
                "PA, Right : Ulnar Dev.",
                "PA, Left : Radial Dev.",
                "PA, Right : Radial Dev.",
                "PA, Left : Fingers flexors",
                "PA, Right : Fingers flexors",
                "PA, Left : Fingers extensors",
                "PA, Right : Fingers extensors"]
        }
    ];

    var link = function ($scope, element) {
        var promise = physioSummaryService.mapDataForDisplay($scope, appService.configBaseUrl(), conceptNames, tableTitles);
        spinner.forPromise(promise, element);
    };

    return {
        link: link,
        scope: {
            patient: "=",
            section: "="
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]);
