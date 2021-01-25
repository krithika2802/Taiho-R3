/*
CCDM SiteMilestone mapping
Notes: Standard mapping to CCDM SiteMilestone table
*/

WITH included_sites AS (
                SELECT DISTINCT studyid, siteid FROM site),

     sitemilestone_data AS (   
	 select studyid,
	 siteid,
	 row_number() over (partition by studyid,siteid order by expecteddate,milestonelabel) as milestoneseq,
	 milestonelabel,
	 milestonetype,
	 expecteddate,
	 ismandatory
	 from
	 (
	 SELECT  			'TAS3681_101'::text AS studyid,
                        sm."site_number"::text AS siteid,
                        null::int AS milestoneseq,
                        sm."milestone_name"::text AS milestonelabel,
                        'Actual'::text AS milestonetype,
                        nullif(sm."actual_date",'')::date AS expecteddate,
                        'yes'::boolean AS ismandatory 
					from tas3681_101_ctms.site_milestones sm
	UNION ALL
	 SELECT  			'TAS3681_101'::text AS studyid,
                        sm."site_number"::text AS siteid,
                        null::int AS milestoneseq,
                        sm."milestone_name"::text AS milestonelabel,
                        'Planned'::text AS milestonetype,
                        nullif(sm."planned_date",'')::date AS expecteddate,
                        'yes'::boolean AS ismandatory 
					from tas3681_101_ctms.site_milestones sm
					)sm
					)

SELECT 
        /*KEY (sm.studyid || '~' || sm.siteid)::text AS comprehendid, KEY*/
        sm.studyid::text AS studyid,
        sm.siteid::text AS siteid,
        sm.milestoneseq::int AS milestoneseq,
        sm.milestonelabel::text AS milestonelabel,
        sm.milestonetype::text AS milestonetype,
        sm.expecteddate::date AS expecteddate,
        sm.ismandatory::boolean AS ismandatory
        /*KEY, (sm.studyid || '~' || sm.siteid || '~' || sm.milestonetype || '~' || sm.milestoneseq)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM sitemilestone_data sm
JOIN included_sites si ON (sm.studyid = si.studyid AND sm.siteid = si.siteid);

