# Welcome to Looker

Looker is the new DispatchHealth tool for business intelligence and reporting

### Finding content

+ All existing reports reside in the [Browse section](https://dispatchhealth.looker.com/browse)

+ Looker content is organized around spaces. For example, content related to Operations can be found [here](https://dispatchhealth.looker.com/spaces/44)

+ General content that has not been assigned to a space can be found in the [shared space](https://dispatchhealth.looker.com/spaces/home)

+ In addition, a user can create or store content specific to them within their individual user space.  As long as someone has made their space available, it will show up in the [Users section](https://dispatchhealth.looker.com/spaces/users) of Looker

+ Finally, when browsing content, you can click the heart icon to mark that dashboard or look as a favorite.

### Measures and Dimensions

Looker has two basic data types that can be used to create reports: **dimensions** and **measures**

1. dimensions can be:
+ an attribute, which has a direct association to a column in an underlying table
+ a fact or numerical value
 a derived value, computed based on the values of other fields in a single row

1. measures are numeric values that are used to group across a collection of data

### Finding Data

An 'Explore' is a data model that compiles various related data together for comprehensive reporting.
There are two primary explores that you will use: **care requests** and **visit facts**

* Visit Facts is based on the database that currently feeds Jaspersoft.  There are timing issues for this data due to the time in which data is processed through Athena.
* Care Requests is based on the dashboard data, so has information from as recently as the prior day.  At this point, Athena data has not been matched to Care Requests.
* Both explores contain information about patients, channels, providers and care request details.

### Beyond viewing data

[Filtering in Looker](https://docs.looker.com/reference/filter-expressions)

+ Date Ranges
+ Contains
+ Advanced Filters

[Calculated Fields](https://docs.looker.com/exploring-data/using-table-calculations)

+ Basic Table Calculations (NPS)
+ Pivot Table Calculations [sum(pivot_row(${visit_facts.count_billable_visits})](https://discourse.looker.com/t/aggregating-across-rows-row-totals-in-table-calculations-3-36/1894)
+ Top N rows (row() <= 25)
