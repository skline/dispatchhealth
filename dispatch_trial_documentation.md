---
navigation:
  - calculated_field_definitions
  - document: document_two
    label: Placeholder for document two label
  - section: DispatchHealth Looker training
  - document_three
---

# Calculated Field Definitions

+ Billable Hours:

```SELECT
	COUNT(CASE WHEN visit_facts.visit_dim_number IS NOT NULL AND visit_facts.no_charge_entry_reason IS NULL  THEN 1 ELSE NULL END) AS `visit_facts.count_of_billable_visits`
FROM jasperdb.visit_facts  AS visit_facts
LEFT JOIN jasperdb.market_dimensions  AS market_dimensions ON market_dimensions.id = visit_facts.market_dim_id```
