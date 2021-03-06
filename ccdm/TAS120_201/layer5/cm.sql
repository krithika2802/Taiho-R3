/*
CCDM CM mapping
Notes: Standard mapping to CCDM CM table
*/

WITH included_subjects AS (
                SELECT DISTINCT studyid, siteid, usubjid FROM subject ),

          cm_data AS (
                SELECT 
				"project"	::text	AS	studyid	,
				"SiteNumber"	::text	AS	siteid	,
				"Subject"	::text	AS	usubjid	,
				"RecordPosition"::integer AS cmseq,
				"CMTRT"::text	AS	cmtrt	,
				"CMINDC"::text	AS	cmmodify	,
				"CMTRT_PT"::text	AS	cmdecod	,
				"CMTRT_ATC"::text	AS	cmcat	,
				'Concomitant Medications'::text	AS	cmscat	,
				"CMINDC"::text	AS	cmindc	,
				Null::numeric 	AS	cmdose	,
				NULL::text	AS	cmdosu	,
				NULL::text	AS	cmdosfrm	,
				NULL::text	AS	cmdosfrq	,
				NULL::text 	AS	cmdostot	,
				CASE WHEN "CMROUTE"='Other' then  "CMROUTE" || "CMROUTEOTH"   ELSE  "CMROUTE"::text END	AS	cmroute	,
				case when cmstdtc='' or cmstdtc like '%0000%' then null
							else to_date(cmstdtc,'DD Mon YYYY') 
						end ::timestamp without time zone AS cmstdtc,
						case when cmendtc='' or cmendtc like '%0000%' then null
							else to_date(cmendtc,'DD Mon YYYY') 
						end ::timestamp without time zone AS cmendtc,
				NULL::time without time zone	AS	cmsttm	,
				NULL::time without time zone	AS	cmentm
				FROM  
( select *,concat(replace(substring(upper("CMSTDAT_RAW"),1,2),'UN','01'),replace(substring(upper("CMSTDAT_RAW"),3),'UNK','Jan')) AS cmstdtc,
	     concat(replace(substring(upper("CMENDAT_RAW"),1,2),'UN','01'),replace(substring(upper("CMENDAT_RAW"),3),'UNK','Jan')) AS cmendtc
from tas120_201."CM"	
)cm  )

SELECT 
        /*KEY (cm.studyid || '~' || cm.siteid || '~' || cm.usubjid)::text AS comprehendid,KEY*/
        cm.studyid::text AS studyid,
        cm.siteid::text AS siteid,
        cm.usubjid::text AS usubjid,
        cm.cmseq::integer AS cmseq,
        cm.cmtrt::text AS cmtrt,
        cm.cmmodify::text AS cmmodify,
        cm.cmdecod::text AS cmdecod,
        cm.cmcat::text AS cmcat,
        cm.cmscat::text AS cmscat,
        cm.cmindc::text AS cmindc,
        cm.cmdose::numeric AS cmdose,
        cm.cmdosu::text AS cmdosu,
        cm.cmdosfrm::text AS cmdosfrm,
        cm.cmdosfrq::text AS cmdosfrq,
        cm.cmdostot::text AS cmdostot,
        cm.cmroute::text AS cmroute,
        cm.cmstdtc::timestamp without time zone cmstdtc, --client requested change
        cm.cmendtc::timestamp without time zone AS cmendtc, --client requested change
        cm.cmsttm::time without time zone AS cmsttm,
        cm.cmentm::time without time zone AS cmentm
       /*KEY ,(cm.studyid || '~' || cm.siteid || '~' || cm.usubjid || '~' || cm.cmseq)::text  AS objectuniquekey KEY*/
       /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM cm_data cm
JOIN included_subjects s ON (cm.studyid = s.studyid AND cm.siteid = s.siteid AND cm.usubjid = s.usubjid);

