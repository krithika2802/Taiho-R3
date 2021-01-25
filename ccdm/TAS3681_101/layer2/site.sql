/*
CCDM Site mapping
Client:taiho
Limits added for PR build efficiency (not applied for standard builds)
Notes: Standard mapping to CCDM Site table
*/

WITH included_studies AS (
                SELECT studyid FROM study ),

    site_data AS (
                SELECT  'TAS3681_101'::text AS studyid,
                        "site_number"::text AS siteid,
                        "facility_name"::text AS sitename,
                        'Syneos'::text AS croid,
                        'Syneos'::text AS sitecro,
						"principal_investigator"::text AS siteinvestigatorname,
						null::text AS sitecraname,
                        case 
						When trim(country_code) = 'KR' then 'South Korea'
						When trim(country_code) = 'JP' then 'Japan'
						When trim(country_code) = 'DE' then 'Germany'
						When trim(country_code) = 'UK' then 'United Kingdom'
						When trim(country_code) = 'ES' then 'Spain'
						When trim(country_code) = 'TR' then 'Turkey'
						When trim(country_code) = 'BE' then 'Belgium'
						When trim(country_code) = 'SG' then 'Singapore'
						When trim(country_code) = 'US' then 'United States of America'
						When trim(country_code) = 'NL' then 'Netherlands'
						When trim(country_code) = 'HK' then 'Hong Kong'
						When trim(country_code) = 'SE' then 'Sweden'
						When trim(country_code) = 'CA' then 'Canada'
						When trim(country_code) = 'FR' then 'France'
						When trim(country_code) = 'PT' then 'Portugal'
						When trim(country_code) = 'IT' then 'Italy'
						When trim(country_code) = 'GB' then 'United Kingdom'
						else 'United States of America'
						end::text AS sitecountry,
                        case
							when length(trim(SUBSTRING( site_number,POSITION('_' in site_number)+1)))=3
								 THEN CASE when substring(substring(site_number,POSITION('_' in site_number)+1),1,1)='1' then 'North America'
										   when substring(substring(site_number,POSITION('_' in site_number)+1),1,1)='2' then 'Europe'
										   when substring(substring(site_number,POSITION('_' in site_number)+1),1,1)='3' then 'Europe'
									  end
						else 'North America' end ::text AS siteregion,
                        nullif(site_selected_date,'')::date AS sitecreationdate,
                        case when site_status = 'Activated' then
                        nullif(site_activated_date,'')
                        end::date AS siteactivationdate,
                        nullif(site_closed_date,'')::date AS sitedeactivationdate,
                        address_line1::text AS siteaddress1,
                        address_line2::text AS siteaddress2,
                        city::text AS sitecity,
                        null::text AS sitestate,
                        postal_code::text AS sitepostal,
                        site_status::text AS sitestatus,
                        null::date AS sitestatusdate
			From tas3681_101_ctms.sites s1
			where length(country_code)<=2 and country_code <> ''--siteid TAS3681101_105 excluded due to invalid data in source
				/*LIMIT LIMIT 100 LIMIT*/)

SELECT 
        /*KEY (s.studyid || '~' || s.siteid)::text AS comprehendid, KEY*/
        s.studyid::text AS studyid,
        s.siteid::text AS siteid,
        s.sitename::text AS sitename,
        s.croid::text AS croid,
        s.sitecro::text AS sitecro,
        s.sitecountry::text AS sitecountry,
        s.siteregion::text AS siteregion,
        s.sitecreationdate::date AS sitecreationdate,
        s.siteactivationdate::date AS siteactivationdate,
        s.sitedeactivationdate::date AS sitedeactivationdate,
        s.siteinvestigatorname::text AS siteinvestigatorname,
        s.sitecraname::text AS sitecraname,
        s.siteaddress1::text AS siteaddress1,
        s.siteaddress2::text AS siteaddress2,
        s.sitecity::text AS sitecity,
        s.sitestate::text AS sitestate,
        s.sitepostal::text AS sitepostal,
        s.sitestatus::text AS sitestatus,
        s.sitestatusdate::date AS sitestatusdate
        /*KEY , now()::timestamp with time zone AS comprehend_update_time KEY*/
FROM site_data s 
JOIN included_studies st ON (s.studyid = st.studyid);

