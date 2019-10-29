Bahmni.ConceptSet.FormConditions.rules = {
    'Diastolic Data' : function (formName, formFieldValues) {
        var systolic = formFieldValues['Systolic'];
        var diastolic = formFieldValues['Diastolic'];
        if (systolic || diastolic) {
            return {
                enable: ["Posture"]
            }
        } else {
            return {
                disable: ["Posture"]
            }
        }
    },
    'Systolic Data' : function (formName, formFieldValues) {
        var systolic = formFieldValues['Systolic'];
        var diastolic = formFieldValues['Diastolic'];
        if (systolic || diastolic) {
            return {
                enable: ["Posture"]
            }
        } else {
            return {
                disable: ["Posture"]
            }
        }
    },
    'Results, Growth': function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };
        var conditionConcept = formFieldValues['Results, Growth'];

        if (conditionConcept == "Growth" )
        {
            conditions.show.push("Final Identification Section");

            var conditionConcept = formFieldValues['Final Identification Section'];


            if  (conditionConcept == "Citrobacter freundii" || conditionConcept == "Enterobacter aerogenes" || conditionConcept == "Enterobacter cloacae" || conditionConcept == "Escherichia coli" || conditionConcept == "Escherichia coli O157:H7" || conditionConcept == "Klebsiella oxytoca" || conditionConcept == "Klebsiella pneumoniae ss. pneumoniae" || conditionConcept == "Morganella morganii ss. morganii" || conditionConcept == "Proteus mirabilis" || conditionConcept == "Raoultella spp" || conditionConcept == "Salmonella enteritidis" || conditionConcept == "Salmonella sp." || conditionConcept == "Salmonella typhi" || conditionConcept == "Salmonella typhimurium" || conditionConcept == "Serratia marcescens" || conditionConcept == "Shigella boydii" || conditionConcept == "Shigella boydii serotype 1")
            {
                conditions.show.push("ENTEROBACTERIA")
                conditions.hide.push("PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }
            else if (conditionConcept == "Pseudomonas aeruginosa" || conditionConcept == "Pseudomonas fluorescens" || conditionConcept == "Pseudomonas putida" || conditionConcept == "Pseudomonas stutzeri")
            {
                conditions.show.push("PSEUDOMONAS SPP.")
                conditions.hide.push("ENTEROBACTERIA","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }
            else if (conditionConcept == "Acinetobacter baumannii" || conditionConcept == "Acinetobacter nosocomialis" || conditionConcept == "Acinetobacter pittii" || conditionConcept == "Acinetobacter dijkshoorniae" || conditionConcept == "Acinetobacter seifertii" || conditionConcept == "Acinetobacter haemolyticus" || conditionConcept == "Acinetobacter junii" || conditionConcept == "Acinetobacter lwoffii" || conditionConcept == "Acinetobacter ursingii" || conditionConcept == "Acinetobacter variabilis")
            {
                conditions.show.push("ACINETOBACTER SP")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }else if (conditionConcept == "Staphylococcus aureus ss. aureus")
            {

                conditions.show.push("STAPHYLOCOCCUS AUREUS")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            } else if (conditionConcept == "Staphylococcus, coagulase negative" || conditionConcept == "Staphylococcus haemolyticus" || conditionConcept == "Staphylococcus lugdunensis" || conditionConcept == "Staphylococcus pseudintermedius" || conditionConcept == "Staphylococcus schleiferi" || conditionConcept == "Staphylococcus capitis" || conditionConcept == "Staphylococcus cohnii" || conditionConcept == "Staphylococcus hominis" || conditionConcept == "Staphylococcus hyicus" || conditionConcept == "Staphylococcus saprophyticus ss. saprophyticus" || conditionConcept == "Staphylococcus epidermidis")
            {
                conditions.show.push("COAGULASE NEGATIVE STAPHYLOCOCCI")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }else if (conditionConcept == "Streptococcus, beta-haem. Group A" || conditionConcept == "Streptococcus, beta-haem. Group B") {
                conditions.show.push("STREPTOCOCCUS SPP (Group A, B, C, G)")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS PNEUMONIAE Section")
            }else if (conditionConcept == "Streptococcus pneumoniae")
            {
                conditions.show.push("STREPTOCOCCUS PNEUMONIAE Section")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)")
            }else if (conditionConcept == "Streptococcus viridans, alpha-hem" || conditionConcept == "Streptococcus salivarius" || conditionConcept == "Streptococcus mutans" || conditionConcept == "Streptococcus bovis" || conditionConcept == "Streptococcus anginosus" || conditionConcept == "Streptococcus mitis" || conditionConcept == "Streptococcus sanguinis")
            {
                conditions.show.push("STREPTOCOCCUS VIRIDANS")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }else if (conditionConcept == "Enterococcus avium" || conditionConcept == "Enterococcus faecalis" || conditionConcept == "Enterococcus faecium" || conditionConcept == "Enterococcus sp." || conditionConcept == "Enterococcus casseliflavus" || conditionConcept == "Enterococcus durans" || conditionConcept == "Enterococcus gallinarum" || conditionConcept == "Enterococcus hirae" || conditionConcept == "Enterococcus mundtii" || conditionConcept == "Enterococcus raffinosus")
            {
                conditions.show.push("ENTEROCOCCUS SPP")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }else if (conditionConcept == "Haemophilus influenzae" || conditionConcept == "Haemophilus influenzae (non type b)" || conditionConcept == "Haemophilus influenzae (type b)")
            {
                conditions.show.push("HAEMOPHILUS INFLUENZAE Section")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }else if(conditionConcept == "Neisseria meningitidis")
            {
                conditions.show.push("NEISSERIA MENINGITIDIS Section")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }else if(conditionConcept == "Neisseria gonorrhoeae")
            {
                conditions.show.push("NEISSERIA GONORRHOEAE Section")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }else if(conditionConcept == "Bacteroides fragilis" || conditionConcept == "Burkholderia cepacia" || conditionConcept == "Campylobacter coli" || conditionConcept == "Campylobacter jejuni ss. jejuni" || conditionConcept == "Candida albicans" || conditionConcept == "Corynebacterium sp. (diphtheroids)" || conditionConcept == "Listeria monocytogenes" || conditionConcept == "Mixed bacterial species present" || conditionConcept == "Moraxella (Branh.) catarrhalis" || conditionConcept == "Mycobacterium avium-intracellulare complex" || conditionConcept == "Mycobacterium tuberculosis" || conditionConcept == "Normal flora" || conditionConcept == "Oral flora" || conditionConcept == "Stenotrophomonas maltophilia")
            {
                conditions.show.push("Comments")
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
            }
            else
            {
                conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")

            }
            conditions.hide.push("Results, Comments, no growth")
        }
        else if (conditionConcept == "No growth")
        {
            conditions.show.push("Results, Comments, no growth");
            conditions.hide.push("Final Identification Section");
        }
        else
        {

            conditions.hide.push("Final Identification Section","Results, Comments, no growth")
        }
        return conditions;
    },

    'FI, Final identification': function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };
        var conditionConcept = formFieldValues['FI, Final identification'];


        if  (conditionConcept == "Citrobacter freundii" || conditionConcept == "Enterobacter aerogenes" || conditionConcept == "Enterobacter cloacae" || conditionConcept == "Escherichia coli" || conditionConcept == "Escherichia coli O157:H7" || conditionConcept == "Klebsiella oxytoca" || conditionConcept == "Klebsiella pneumoniae ss. pneumoniae" || conditionConcept == "Morganella morganii ss. morganii" || conditionConcept == "Proteus mirabilis" || conditionConcept == "Raoultella spp" || conditionConcept == "Salmonella enteritidis" || conditionConcept == "Salmonella sp." || conditionConcept == "Salmonella typhi" || conditionConcept == "Salmonella typhimurium" || conditionConcept == "Serratia marcescens" || conditionConcept == "Shigella boydii" || conditionConcept == "Shigella boydii serotype 1")
        {
            conditions.show.push("ENTEROBACTERIA")
            conditions.hide.push("PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }
        else if (conditionConcept == "Pseudomonas aeruginosa" || conditionConcept == "Pseudomonas fluorescens" || conditionConcept == "Pseudomonas putida" || conditionConcept == "Pseudomonas stutzeri")
        {
            conditions.show.push("PSEUDOMONAS SPP.")
            conditions.hide.push("ENTEROBACTERIA","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if (conditionConcept == "Acinetobacter baumannii" || conditionConcept == "Acinetobacter nosocomialis" || conditionConcept == "Acinetobacter pittii" || conditionConcept == "Acinetobacter dijkshoorniae" || conditionConcept == "Acinetobacter seifertii" || conditionConcept == "Acinetobacter haemolyticus" || conditionConcept == "Acinetobacter junii" || conditionConcept == "Acinetobacter lwoffii" || conditionConcept == "Acinetobacter ursingii" || conditionConcept == "Acinetobacter variabilis")
        {
            conditions.show.push("ACINETOBACTER SP")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if (conditionConcept == "Staphylococcus aureus ss. aureus")
        {
            conditions.show.push("STAPHYLOCOCCUS AUREUS")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if (conditionConcept == "Staphylococcus, coagulase negative" || conditionConcept == "Staphylococcus haemolyticus" || conditionConcept == "Staphylococcus lugdunensis" || conditionConcept == "Staphylococcus pseudintermedius" || conditionConcept == "Staphylococcus schleiferi" || conditionConcept == "Staphylococcus capitis" || conditionConcept == "Staphylococcus cohnii" || conditionConcept == "Staphylococcus hominis" || conditionConcept == "Staphylococcus hyicus" || conditionConcept == "Staphylococcus saprophyticus ss. saprophyticus" || conditionConcept == "Staphylococcus epidermidis")
        {
            conditions.show.push("COAGULASE NEGATIVE STAPHYLOCOCCI")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if (conditionConcept == "Streptococcus, beta-haem. Group A" || conditionConcept == "Streptococcus, beta-haem. Group B") {
            conditions.show.push("STREPTOCOCCUS SPP (Group A, B, C, G)")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS PNEUMONIAE Section")
        }else if (conditionConcept == "Streptococcus pneumoniae")
        {
            conditions.show.push("STREPTOCOCCUS PNEUMONIAE Section")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)")
        }else if (conditionConcept == "Streptococcus viridans, alpha-hem" || conditionConcept == "Streptococcus salivarius" || conditionConcept == "Streptococcus mutans" || conditionConcept == "Streptococcus bovis" || conditionConcept == "Streptococcus anginosus" || conditionConcept == "Streptococcus mitis" || conditionConcept == "Streptococcus sanguinis")
        {
            conditions.show.push("STREPTOCOCCUS VIRIDANS")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if (conditionConcept == "Enterococcus avium" || conditionConcept == "Enterococcus faecalis" || conditionConcept == "Enterococcus faecium" || conditionConcept == "Enterococcus sp." || conditionConcept == "Enterococcus casseliflavus" || conditionConcept == "Enterococcus durans" || conditionConcept == "Enterococcus gallinarum" || conditionConcept == "Enterococcus hirae" || conditionConcept == "Enterococcus mundtii" || conditionConcept == "Enterococcus raffinosus")
        {
            conditions.show.push("ENTEROCOCCUS SPP")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if (conditionConcept == "Haemophilus influenzae" || conditionConcept == "Haemophilus influenzae (non type b)" || conditionConcept == "Haemophilus influenzae (type b)")
        {
            conditions.show.push("HAEMOPHILUS INFLUENZAE Section")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if(conditionConcept == "Neisseria meningitidis")
        {
            conditions.show.push("NEISSERIA MENINGITIDIS Section")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if(conditionConcept == "Neisseria gonorrhoeae")
        {
            conditions.show.push("NEISSERIA GONORRHOEAE Section")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }else if(conditionConcept == "Bacteroides fragilis" || conditionConcept == "Burkholderia cepacia" || conditionConcept == "Campylobacter coli" || conditionConcept == "Campylobacter jejuni ss. jejuni" || conditionConcept == "Candida albicans" || conditionConcept == "Corynebacterium sp. (diphtheroids)" || conditionConcept == "Listeria monocytogenes" || conditionConcept == "Mixed bacterial species present" || conditionConcept == "Moraxella (Branh.) catarrhalis" || conditionConcept == "Mycobacterium avium-intracellulare complex" || conditionConcept == "Mycobacterium tuberculosis" || conditionConcept == "Normal flora" || conditionConcept == "Oral flora" || conditionConcept == "Stenotrophomonas maltophilia")
        {
            conditions.show.push("Comments")
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")
        }
        else
        {
            conditions.hide.push("ENTEROBACTERIA","PSEUDOMONAS SPP.","ACINETOBACTER SP","STAPHYLOCOCCUS AUREUS","COAGULASE NEGATIVE STAPHYLOCOCCI","STREPTOCOCCUS VIRIDANS","ENTEROCOCCUS SPP","HAEMOPHILUS INFLUENZAE Section","NEISSERIA MENINGITIDIS Section","NEISSERIA GONORRHOEAE Section","Comments","STREPTOCOCCUS SPP (Group A, B, C, G)","STREPTOCOCCUS PNEUMONIAE Section")

        }
        return conditions;
    }
};