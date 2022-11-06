-- All data sourced from the Statistics Canada website 
-- https://www150.statcan.gc.ca/n1/en/type/data?MM=1.

/*Bank of Canada interest rate expressed as a percent. Inflation rate
expressed as a percent change relative to the previous month. The 
Bank of Canada's target inflation rate is below 3% */

CREATE TABLE  Bank_of_Canada_rates_Sept2019_to_Aug2022
(
	REF_DATE date PRIMARY KEY,

	Unit_of_measure char(20),

	Bank_of_Canada_rate double precision,
	
	Inflation_rate double precision

);



/*Consumer Price index expressed as a percent relative to 2002. Any triple
digit percent value indicates a more than 100% increase in inflation
relative to the year 2002*/

CREATE TABLE  CPI_Data_Canada_Sept2019_to_Aug2022
(REF_DATE date PRIMARY KEY,
	Products_and_product_groups char(20),
	Canada double precision,
	Newfoundland_and_Labrador double precision,
	PEI double precision,
	Nova_Scotia double precision,
	New_Brunswick double precision,
	Quebec	double precision,
	Ontario	double precision,
	Manitoba double precision,
	Saskatchewan double precision,
	Alberta	double precision,
	British_Columbia double precision,
	Whitehorse_Yukon double precision,
	Yellowknife_Northwest_Territories double precision,
	Iqaluit_Nunavut double precision

);


/* Canadian household debt between September 2019 to August 2022 expressed 
in dollar amounts with a scalar factor of 1 million.  */

CREATE TABLE  Total_household_debt_Sept2019_to_Aug2022
(
	REF_DATE date PRIMARY KEY,
	Geography char(20),
	Unit_of_measure_in_millions char(20),
	Total_outstanding_balances_residential_mortgages_insured_and_uninsured double precision,
	total_outstanding_non_mortgage_consumer_debt double precision,
	Total_outstanding_balances_for_non_mortgage_loans_consumer_credit double precision,
	Outstanding_balances_for_non_mortgage_loans_personal_loan_plans double precision,
	Outstanding_balances_for_are_auto_loans double precision,
	Outstanding_balances_for_credit_card_loans double precision,
	Outstanding_balances_personal_lines_of_credit_secured_and_unsecured double precision,
	Outstanding_balances_for_other_personal_loans double precision,
	Total_outstanding_balances_business_loans double precision,
	all_forms_of_outstanding_consumer_debts double precision

);


-- The following commands allow for viewing newly created tables
SELECT 
	* 
FROM 
	public.bank_of_canada_rates_sept2019_to_aug2022
ORDER BY 
	ref_date ASC 
------
SELECT 
	* 
FROM 
	public.total_household_debt_sept2019_to_aug2022
ORDER BY 
	ref_date ASC 
------
SELECT 
	* 
FROM 
	public.cpi_data_canada_sept2019_to_aug2022
ORDER BY 
	ref_date ASC 



-- The following returns the consumer price index (i.e. cpi, or inflation) value 
-- at the beginning and the end of this analysis
-- for Canada as a whole, and for each province and territoy seperately. It is
-- is evident that there has been an increase of 15.7% in inflation
-- nationwide between September 2019 and August 2022.
select 
	ref_date, 
	canada, alberta, british_columbia, iqaluit_nunavut,new_brunswick,
	newfoundland_and_labrador, nova_scotia, ontario, quebec, saskatchewan,
	whitehorse_yukon, yellowknife_northwest_territories
from 
	cpi_data_canada_sept2019_to_aug2022
Where 
	ref_date IN ('2019-09-01','2022-08-01') 






-- The following demonstrates that all of the eight months of 2022 included 
-- in the data have the highest levels of month on month inflation increases
select 
	ref_date, 
	bank_of_canada_rate,
	inflation_rate
from 
	bank_of_canada_rates_sept2019_to_aug2022
order by 
	inflation_rate desc




-- Here we can see the 10 lowest monthly inflation rate changes expressed as
-- a percentage point.
select 
	extract(year from ref_date) as calendar_year, 
	bank_of_canada_rate,
	inflation_rate
from 
	bank_of_canada_rates_sept2019_to_aug2022 
where 
	bank_of_canada_rate <( select 
								avg(bank_of_canada_rate) 
							 from 
								bank_of_canada_rates_sept2019_to_aug2022
						  )
order by inflation_rate asc
limit 10;		





-- the number of unique interest rates set by the Bank of Canada
-- through this study
select 
	
	distinct(bank_of_canada_rate)
		
from 
	bank_of_canada_rates_sept2019_to_aug2022





-- The following demonstrates a positive upward trending correlation between
-- inflation rates and consumer mortgage and non mortgage debts. The incremental
-- increases of the bank rates from it's very lowest point is an attempt to 
-- by the bank of canada to address the monthly percentage based increases
-- in the inflation rate. The desired target rate of the bank is less than 3%.

-- The dollar amounts have a scalar factor of 1 million. Canadian consumer debt
-- as of August 2022 is just over $3 trillion Canadian. 

-- The last column shows changing triple digit percent values for the consumer
-- price index relative to 2002. Prices have more than doubled since. 

select 
	bank_of_canada_rate.ref_date,
	bank_of_canada_rate.bank_of_canada_rate,
	bank_of_canada_rate.inflation_rate,
	total_outstanding_balances_residential_mortgages_insured_and_un as outstanding_residential_mortgage_debt,
	total_outstanding_non_mortgage_consumer_debt as outstanding_non_mortgage_debt,
	all_forms_of_outstanding_consumer_debts as all_debts_combined,
	cpi_data_canada_sept2019_to_aug2022.canada
from 
	total_household_debt_sept2019_to_aug2022 as household_debt
inner join
	bank_of_canada_rates_sept2019_to_aug2022 as bank_of_canada_rate
on	
	household_debt.ref_date = bank_of_canada_rate.ref_date
inner join 
	cpi_data_canada_sept2019_to_aug2022
on 
	household_debt.ref_date = cpi_data_canada_sept2019_to_aug2022.ref_date
order by 
	household_debt.ref_date desc
	








	
