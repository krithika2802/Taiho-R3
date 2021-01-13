/*
CCDM SiteResource mapping
Notes: Standard mapping to CCDM SiteResource table
*/

WITH included_sites AS (
                SELECT DISTINCT studyid, siteid FROM site),

     siteresource_data AS (
                SELECT  'TAS0612_101'::text AS studyid,
                        "site_id"::text AS siteid,
                        null::text AS resourcetype,
                        null::text AS resourcename,
                        null::integer AS resourceseq,
                        null::date AS resourcestdtc,
                        null::date AS resourceenddtc 
						from tas0612_101_ctms.site_closeout)

SELECT 
        /*KEY (sr.studyid || '~' || sr.siteid)::text AS comprehendid, KEY*/
        sr.studyid::text AS studyid,
        sr.siteid::text AS siteid,
        sr.resourcetype::text AS resourcetype,
        sr.resourcename::text AS resourcename,
        sr.resourceseq::integer AS resourceseq,
        sr.resourcestdtc::date AS resourcestdtc,
        sr.resourceenddtc::date AS resourceenddtc
        /*KEY , (sr.studyid || '~' || sr.siteid || '~' || sr.resourceseq)::text  AS objectuniquekey KEY*/
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM siteresource_data sr
JOIN included_sites si ON (sr.studyid = si.studyid AND sr.siteid = si.siteid); 

