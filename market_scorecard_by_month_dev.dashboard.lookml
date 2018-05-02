- dashboard: market_scorecard_by_month
  title: Market Scorecard by Month
  layout: newspaper
  query_timezone: query_saved
  elements:
  - name: Patient Demographics - Gender
    title: Patient Demographics - Gender
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - visit_dimensions.local_visit_month
    - patient_dimensions.gender
    - visit_facts.count_complete_visits
    pivots:
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      visit_dimensions.local_visit_month: Last 3 Months
      patient_dimensions.gender: "-NULL"
    sorts:
    - visit_dimensions.local_visit_month
    - visit_facts.count_complete_visits desc 0
    limit: 500
    dynamic_fields:
    - table_calculation: percentage
      label: Percentage
      expression: "${visit_facts.count_complete_visits} / sum(${visit_facts.count_complete_visits})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    hidden_fields:
    - visit_facts.count_complete_visits
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 12
    col: 9
    width: 7
    height: 3
  - name: Patient Demographics - Age
    title: Patient Demographics - Age
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - patient_dimensions.age_band
    - visit_facts.count_complete_visits
    - visit_dimensions.local_visit_month
    pivots:
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      patient_dimensions.age_band: "-NULL"
      visit_dimensions.local_visit_month: Last 3 Months
    sorts:
    - patient_dimensions.age_band
    limit: 500
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_labels:
      visit_facts.count_complete_visits: Complete Visits
      patient_dimensions.age_band: Age Group
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 23
    col: 0
    width: 9
    height: 7
  - name: Net Promoter Score
    title: Net Promoter Score
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - survey_response_facts.detractor_count
    - survey_response_facts.promoter_count
    - visit_dimensions.local_visit_month
    - survey_response_facts.nps_total_count
    fill_fields:
    - visit_dimensions.local_visit_month
    sorts:
    - visit_dimensions.local_visit_month
    limit: 500
    dynamic_fields:
    - table_calculation: nps
      label: NPS
      expression: "((${survey_response_facts.promoter_count} - ${survey_response_facts.detractor_count})\
        \ / ${survey_response_facts.nps_total_count}) * 100"
      value_format:
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Denver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    hidden_fields:
    - survey_response_facts.detractor_count
    - survey_response_facts.nsp_total_count
    - survey_response_facts.promoter_count
    single_value_title: NPS
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 8
    col: 9
    width: 7
    height: 4
  - name: 30-Day Bounce Back Rate
    title: 30-Day Bounce Back Rate
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - visit_facts.bb_30_day_count
    - visit_facts.count_complete_visits
    - visit_dimensions.local_visit_month
    - visit_facts.followup_removed_count
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      visit_dimensions.local_visit_month: 3 months ago for 3 months
      channel_dimensions.organization: "%centura%"
      market_dimensions.market_name: ''
    sorts:
    - visit_dimensions.local_visit_month
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: 30_day_bb_rate
      label: 30-Day BB Rate
      expression: |-
        ${visit_facts.bb_30_day_count}/
        (${visit_facts.count_complete_visits} - ${visit_facts.followup_removed_count})
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Denver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: 30-Day Bounce Back
    hidden_fields:
    - visit_facts.count_complete_visits
    - visit_facts.bb_30_day_count
    - visit_facts.followup_removed_count
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 4
    col: 9
    width: 7
    height: 4
  - title: Medical Cost Savings
    name: Medical Cost Savings
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - visit_facts.est_ed_diversion_savings
    - visit_facts.est_911_diversion_savings
    - visit_facts.est_vol_ed_diversion
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: total_cost_savings
      label: Total Cost Savings
      expression: "${hospitalization_diversion_cost_savings} + ${er_diversion_cost_savings}\
        \ + ${911_diversion_cost_savings}"
      value_format:
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: 911_diversion_cost_savings
      label: 911 Diversion Cost Savings
      expression: "${visit_facts.est_911_diversion_savings} * 1"
      value_format:
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: er_diversion_cost_savings
      label: ER Diversion Cost Savings
      expression: "${visit_facts.est_ed_diversion_savings} * 1"
      value_format:
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    - table_calculation: hospitalization_diversion_cost_savings
      label: Hospitalization Diversion Cost Savings
      expression: "${visit_facts.est_vol_ed_diversion} * 600"
      value_format:
      value_format_name: usd_0
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    hidden_points_if_no: []
    series_types: {}
    hidden_fields:
    - visit_facts.est_ed_diversion_savings
    - visit_facts.est_vol_ed_diversion
    - visit_facts.est_911_diversion_savings
    single_value_title: Cost Savings - ER Avoidance
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 14
    col: 0
    width: 9
    height: 4
  - name: Care Escalation Volume to ED
    title: Care Escalation Volume to ED
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - market_dimensions.market_name
    - visit_facts.resolve_reason
    - visit_facts.count
    - visit_dimensions.local_visit_month
    pivots:
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      visit_facts.resolve_reason: "%Referred%"
      visit_dimensions.local_visit_month: Last 3 Months
    sorts:
    - visit_facts.count desc 0
    - visit_dimensions.local_visit_month
    limit: 500
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_labels:
      visit_facts.count: Count
      visit_facts.resolve_reason: Escalation Type
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 12
    col: 16
    width: 8
    height: 6
  - title: Billable Visits
    name: Billable Visits
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - visit_facts.count_of_billable_visits
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    sorts:
    - visit_dimensions.local_visit_month
    limit: 500
    query_timezone: America/Denver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: Billable Visits
    series_types: {}
    series_labels:
      visit_facts.count_of_billable_visits: BIllable Visits
      visit_dimensions.local_visit_month: Month
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    conditional_formatting:
    - type: low to high
      value:
      background_color:
      font_color:
      palette:
        name: Red to Yellow to Green
        colors:
        - "#F36254"
        - "#FCF758"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields:
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 0
    col: 9
    width: 7
    height: 4
  - name: Top 10 ICD Codes
    title: Top 10 ICD Codes
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - icd_code_dimensions.diagnosis_code
    - icd_code_dimensions.diagnosis_description
    - visit_dimensions.local_visit_month
    - visit_facts.count_complete_visits
    pivots:
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      icd_code_dimensions.diagnosis_code: "-NULL"
      visit_dimensions.local_visit_month: Last 3 Months
    sorts:
    - visit_dimensions.local_visit_month 0
    - visit_facts.count_complete_visits desc 2
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: top_ten
      label: Top Ten
      expression: row() <= 10
      value_format:
      value_format_name:
      _kind_hint: dimension
      _type_hint: yesno
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_points_if_no:
    - top_ten
    series_types: {}
    hidden_fields:
    - icd_code_dimensions.diagnosis_code
    series_labels:
      icd_code_dimensions.diagnosis_description: ICD Code Description
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 18
    col: 9
    width: 15
    height: 7
  - name: Operations - Wait Time (month)
    title: Operations - Wait Time (month)
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - visit_facts.avg_queue_mins
    - visit_facts.avg_accepted_queue_mins
    - visit_facts.avg_on_route_queue_mins
    - visit_facts.avg_on_scene_queue_mins
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      visit_dimensions.local_visit_month: 3 months ago for 3 months
      channel_dimensions.organization: "%centura%"
      market_dimensions.market_name: ''
    sorts:
    - visit_dimensions.local_visit_month desc
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: in_queue
      label: In Queue
      expression: "${visit_facts.avg_queue_mins} * 1"
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: in_accepted_queue
      label: In Accepted Queue
      expression: "${visit_facts.avg_accepted_queue_mins} * 1"
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: on_route_time
      label: On Route Time
      expression: "${visit_facts.avg_on_route_queue_mins} * 1"
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: total_wait_time
      label: Total Wait Time
      expression: "${in_queue} + ${in_accepted_queue} + ${on_route_time}"
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    - table_calculation: on_scene_time
      label: On Scene Time
      expression: "${visit_facts.avg_on_scene_queue_mins}"
      value_format:
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Denver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      icd_code_dimensions.diagnosis_description: ICD Code Description
    hidden_fields:
    - visit_facts.avg_on_scene_queue_mins
    - visit_facts.avg_on_route_queue_mins
    - visit_facts.avg_accepted_queue_mins
    - visit_facts.avg_queue_mins
    series_types: {}
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 18
    col: 0
    width: 9
    height: 5
  - name: Clinical Notes Sent (month)
    title: Clinical Notes Sent (month)
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - visit_facts.clinical_notes_sent
    - visit_facts.count_of_billable_visits
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      visit_dimensions.local_visit_month: 3 months ago for 3 months
      channel_dimensions.organization: "%centura%"
      market_dimensions.market_name: ''
    sorts:
    - visit_dimensions.local_visit_month desc
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: clinical_notes_sent_to_care_team
      label: Clinical Notes Sent to Care Team
      expression: "${visit_facts.clinical_notes_sent} / ${visit_facts.count_of_billable_visits}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Denver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    hidden_fields:
    - visit_facts.clinical_notes_sent
    - visit_facts.count_of_billable_visits
    single_value_title: Clinical Notes Sent
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 15
    col: 9
    width: 7
    height: 3
  - name: Volume by Channel (month)
    title: Volume by Channel (month)
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - visit_facts.count_of_billable_visits
    - channel_dimensions.sub_type
    - visit_dimensions.local_visit_month
    pivots:
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      market_dimensions.market_name: ''
      channel_dimensions.organization: ''
      visit_dimensions.local_visit_month: 3 months ago for 3 months
    sorts:
    - visit_facts.count_of_billable_visits desc 0
    - visit_dimensions.local_visit_month
    limit: 500
    column_limit: 50
    total: true
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    conditional_formatting:
    - type: low to high
      value:
      background_color:
      font_color:
      palette:
        name: White to Green
        colors:
        - "#FFFFFF"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields: []
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 0
    col: 0
    width: 9
    height: 8
  - name: OPS - LWBS Cancelled by Hour of Day
    title: OPS - LWBS Cancelled by Hour of Day
    model: dispatch
    explore: visit_facts
    type: looker_column
    fields:
    - visit_facts.local_requested_hour_of_day
    - visit_facts.count
    - visit_facts.secondary_resolve_reason
    pivots:
    - visit_facts.secondary_resolve_reason
    filters:
      visit_facts.resolve_reason: Cancelled by Patient
      market_dimensions.market_name: ''
      visit_facts.local_requested_hour_of_day: "[6, 23]"
      visit_facts.secondary_resolve_reason: Going to an Emergency Department,Going
        to an Urgent Care,Wait time too long,Payer denied service,Other
    sorts:
    - visit_facts.local_requested_hour_of_day
    - visit_facts.secondary_resolve_reason
    limit: 500
    column_limit: 50
    query_timezone: America/Denver
    stacking: normal
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_null_points: true
    point_style: none
    interpolation: linear
    series_types: {}
    hidden_series: []
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 25
    col: 9
    width: 9
    height: 5
  - name: Avg Expected Allowable by Month
    title: Avg Expected Allowable by Month
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - visit_facts.average_expected_allowable
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      visit_dimensions.local_visit_month: 24 months
    sorts:
    - visit_dimensions.local_visit_month desc
    limit: 500
    query_timezone: America/Denver
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 25
    col: 18
    width: 6
    height: 5
  - name: Payer Volume by Class (month)
    title: Payer Volume by Class (month)
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - primary_payer_dimensions.custom_insurance_label
    - visit_facts.count_of_billable_visits
    - visit_dimensions.local_visit_month
    pivots:
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      visit_dimensions.local_visit_month: 3 months ago for 3 months
      channel_dimensions.organization: "%centura%"
      market_dimensions.market_name: ''
    sorts:
    - visit_dimensions.local_visit_month 0
    - visit_facts.count_of_billable_visits desc 2
    limit: 500
    column_limit: 50
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_labels:
      primary_payer_dimensions.custom_insurance_label: Primary Payer Type
      visit_facts.count_of_billable_visits: Count
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 0
    col: 16
    width: 8
    height: 6
  - name: Payer Volume by Plan (month)
    title: Payer Volume by Plan (month)
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - primary_payer_dimensions.custom_insurance_label
    - visit_facts.count_of_billable_visits
    - primary_payer_dimensions.insurance_reporting_category
    - visit_dimensions.local_visit_month
    pivots:
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      primary_payer_dimensions.custom_insurance_label: Commercial,Medicare Advantage
      visit_dimensions.local_visit_month: 3 months ago for 3 months
      channel_dimensions.organization: "%centura%"
      market_dimensions.market_name: ''
    sorts:
    - visit_dimensions.local_visit_month 0
    - visit_facts.count_of_billable_visits desc 2
    limit: 500
    column_limit: 50
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_labels:
      primary_payer_dimensions.custom_insurance_label: Primary Payer Type
      visit_facts.count_of_billable_visits: Count
      primary_payer_dimensions.insurance_reporting_category: Primary Payer Category
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 6
    col: 16
    width: 8
    height: 6
  - name: Patient Volume by Channel (month)
    title: Patient Volume by Channel (month)
    model: dispatch
    explore: visit_facts
    type: table
    fields:
    - channel_dimensions.organization
    - visit_facts.count_complete_visits
    - visit_dimensions.local_visit_month
    pivots:
    - visit_dimensions.local_visit_month
    fill_fields:
    - visit_dimensions.local_visit_month
    filters:
      visit_dimensions.local_visit_month: 3 months ago for 3 months
      channel_dimensions.organization: "%centura%"
      market_dimensions.market_name: ''
    sorts:
    - visit_dimensions.local_visit_month 0
    - visit_facts.count_complete_visits desc 2
    limit: 500
    column_limit: 50
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      channel_dimensions.organization: Channel
      visit_facts.count_complete_visits: Complete Visits
    listen:
      Market: market_dimensions.market_name
      Date Range: visit_dimensions.local_visit_month
      Channel Type: channel_dimensions.sub_type
      Channel Organization: channel_dimensions.organization
      Patient Age: patient_dimensions.age
    row: 8
    col: 0
    width: 9
    height: 6
  filters:
  - name: Market
    title: Market
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: dispatch
    explore: visit_facts
    listens_to_filters: []
    field: market_dimensions.market_name
  - name: Date Range
    title: Date Range
    type: field_filter
    default_value: 3 months ago for 3 months
    allow_multiple_values: true
    required: false
    model: dispatch
    explore: visit_facts
    listens_to_filters: []
    field: visit_dimensions.local_visit_month
  - name: Channel Type
    title: Channel Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: dispatch
    explore: visit_facts
    listens_to_filters: []
    field: channel_dimensions.sub_type
  - name: Channel Organization
    title: Channel Organization
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: dispatch
    explore: visit_facts
    listens_to_filters: []
    field: channel_dimensions.organization
  - name: Patient Age
    title: Patient Age
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: dispatch
    explore: visit_facts
    listens_to_filters: []
    field: patient_dimensions.age
