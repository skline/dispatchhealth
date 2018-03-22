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

1. measures are numeric values thatt are used to group across a collection of data

### Beyond viewing data

[Filtering in Looker](https://docs.looker.com/reference/filter-expressions)

+ Date Ranges
+ Contains
+ Advanced Filters

[Calculated Fields](https://docs.looker.com/exploring-data/using-table-calculations)

+ Basic Table Calculations (NPS)
+ Pivot Table Calculations [sum(pivot_row(${visit_facts.count_billable_visits})](https://discourse.looker.com/t/aggregating-across-rows-row-totals-in-table-calculations-3-36/1894)
+ Top N rows (row() <= 25)
