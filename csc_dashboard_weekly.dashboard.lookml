- dashboard: csc_scorecard_weekly
  title: CSC Scorecard -- Weekly
  layout: newspaper
  model: dashboard
  elements:
  - title: Call Survey Results
    name: Call Survey Results
    model: dashboard
    explore: csc_survey_clone
    type: table
    fields:
    - csc_survey_clone.count
    - csc_survey_clone.average_care_and_respect
    - csc_survey_clone.average_rate_your_call_experience
    - csc_survey_clone.average_recommend_to_friend
    - csc_survey_clone.interaction_score
    - csc_survey_clone.aggregate_score
    - csc_survey_clone.date_week
    fill_fields:
    - csc_survey_clone.date_week
    filters:
      markets.name: ''
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
      market name: markets.name
      time: csc_survey_clone.date_week
    row: 0
    col: 16
    width: 8
    height: 6
  - title: Inbound Contacts / Care Requests / Billable Visits
    name: Inbound Contacts / Care Requests / Billable Visits
    model: dashboard
    explore: incontact_clone
    type: looker_column
    fields:
    - incontact_clone.start_week
    - incontact_clone.count_distinct
    - care_requests.count_distinct
    - care_request_complete.count_distinct
    fill_fields:
    - incontact_clone.start_week
    filters:
      incontact_clone.skill_category: Care
      markets.name: ''
    sorts:
    - incontact_clone.start_week
    limit: 500
    query_timezone: America/Denver
    stacking: ''
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
    hidden_fields: []
    listen:
      market name: markets.name
      time: care_requests.created_mountain_week
    row: 0
    col: 0
    width: 8
    height: 6
  - title: Call Statistic
    name: Call Statistic
    model: dashboard
    explore: incontact_clone
    type: table
    fields:
    - incontact_clone.start_week
    - incontact_clone.count_distinct
    - incontact_clone.count_distinct_voicemails
    - incontact_clone.count_distinct_abandoned
    - incontact_clone.answer_rate
    fill_fields:
    - incontact_clone.start_week
    filters:
      markets.name: ''
      incontact_clone.campaign: Care
    sorts:
    - incontact_clone.start_week
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
    series_types: {}
    hidden_fields: []
    listen:
      market name: markets.name
      time: care_requests.created_mountain_week
    row: 0
    col: 8
    width: 8
    height: 6
  - title: Call Distribution
    name: Call Distribution
    model: dashboard
    explore: incontact_clone
    type: looker_column
    fields:
    - incontact_clone.start_week
    - incontact_clone.skill_category
    - incontact_clone.count_distinct
    pivots:
    - incontact_clone.skill_category
    fill_fields:
    - incontact_clone.start_week
    sorts:
    - incontact_clone.start_week
    - incontact_clone.skill_category
    limit: 500
    query_timezone: America/Denver
    stacking: normal
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
    ordering: desc
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    hidden_series: []
    listen:
      market name: markets.name
      time: care_requests.created_mountain_week
    row: 6
    col: 0
    width: 8
    height: 6
  - title: Inbound Calls by Time of Day
    name: Inbound Calls by Time of Day
    model: dashboard
    explore: incontact_clone
    type: looker_line
    fields:
    - incontact_clone.start_hour_of_day
    - incontact_clone.count_distinct
    fill_fields:
    - incontact_clone.start_hour_of_day
    filters:
      incontact_clone.skill_category: Care
      markets.name: ''
    sorts:
    - incontact_clone.start_hour_of_day
    limit: 500
    query_timezone: America/Denver
    stacking: ''
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    listen:
      market name: markets.name
      time: care_requests.created_mountain_week
    row: 6
    col: 8
    width: 8
    height: 6
  - title: Referred via Phone Screen
    name: Referred via Phone Screen
    model: dashboard
    explore: care_requests
    type: looker_column
    fields:
    - care_requests.created_mountain_week
    - care_requests.count_distinct
    - care_requests.secondary_resolved_reason
    pivots:
    - care_requests.secondary_resolved_reason
    fill_fields:
    - care_requests.created_mountain_week
    filters:
      markets.name: ''
      care_requests.primary_resolved_reason: Referred - Phone Triage
    sorts:
    - care_requests.created_mountain_week desc
    - care_requests.secondary_resolved_reason
    limit: 500
    query_timezone: America/Denver
    stacking: normal
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
    series_types: {}
    listen:
      market name: markets.name
      time: care_requests.created_mountain_week
    row: 6
    col: 16
    width: 8
    height: 6
  - title: Left Without Being Seen (LWBS)
    name: Left Without Being Seen (LWBS)
    model: dashboard
    explore: care_requests
    type: looker_column
    fields:
    - care_requests.created_mountain_week
    - care_requests.count_distinct
    - care_requests.primary_and_secondary_resolved_reason
    pivots:
    - care_requests.primary_and_secondary_resolved_reason
    fill_fields:
    - care_requests.created_mountain_week
    filters:
      markets.name: ''
      care_requests.lwbs: 'Yes'
    sorts:
    - care_requests.created_mountain_week desc
    - care_requests.primary_and_secondary_resolved_reason
    limit: 500
    column_limit: 50
    query_timezone: America/Denver
    stacking: normal
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
    series_types: {}
    listen:
      market name: markets.name
      time: care_requests.created_mountain_week
    row: 12
    col: 0
    width: 8
    height: 6
  filters:
  - name: market name
    title: market name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: dashboard
    explore: care_requests
    listens_to_filters: []
    field: care_request_accepted.name
  - name: time
    title: time
    type: field_filter
    default_value: 3 weeks ago for 3 weeks
    allow_multiple_values: true
    required: false
    model: dashboard
    explore: care_requests
    listens_to_filters: []
    field: care_requests.created_mountain_week
