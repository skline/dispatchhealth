- dashboard: csc_scorecard_daily
  title: CSC Scorecard Daily
  layout: newspaper
  elements:
  - title: Call Distribution
    name: Call Distribution
    model: dashboard
    explore: incontact_clone
    type: looker_column
    fields:
    - incontact_clone.start_date
    - incontact_clone.count_distinct
    - incontact_clone.campaign
    pivots:
    - incontact_clone.campaign
    fill_fields:
    - incontact_clone.start_date
    filters:
      incontact_clone.campaign: "-DO NOT USE,-VM,-MA VM"
    sorts:
    - incontact_clone.start_date
    - incontact_clone.campaign
    limit: 500
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
    ordering: desc
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    hidden_series: []
    listen:
      market name: markets.name
      time: incontact_clone.start_date
    row: 6
    col: 8
    width: 8
    height: 6
  - title: Inbound Contacts / Care Requests / Complete Visits
    name: Inbound Contacts / Care Requests / Complete Visits
    model: dashboard
    explore: incontact_clone
    type: looker_column
    fields:
    - incontact_clone.start_date
    - incontact_clone.count_distinct
    - care_request_flat.care_request_count
    - care_request_flat.complete_count
    fill_fields:
    - incontact_clone.start_date
    filters:
      incontact_clone.campaign: Care Phone,Care Electronic
    sorts:
    - incontact_clone.start_date
    limit: 500
    query_timezone: America/Denver
    stacking: ''
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
    hidden_fields: []
    listen:
      market name: markets.name
      time: incontact_clone.start_date
    row: 0
    col: 0
    width: 8
    height: 6
  - title: Call Statistics
    name: Call Statistics
    model: dashboard
    explore: incontact_clone
    type: table
    fields:
    - incontact_clone.start_date
    - incontact_clone.count_distinct_calls
    - incontact_clone.count_distinct_handled
    - incontact_clone.count_distinct_live_answers
    - incontact_clone.count_distinct_abandoned
    - incontact_clone.count_distinct_long_abandoned
    - incontact_clone.live_answer_rate
    - incontact_clone.handled_rate
    - incontact_clone.abandoned_rate
    - incontact_clone.long_abandoned_rate
    - incontact_clone.avg_inqueuetime
    - incontact_clone.avg_abandontime
    filters:
      incontact_clone.campaign: Care Phone,VM
      incontact_clone.contact_type: "-Transfer to Agent"
    sorts:
    - incontact_clone.start_date desc
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
      time: incontact_clone.start_date
    row: 0
    col: 8
    width: 16
    height: 6
  - title: Close Rate
    name: Close Rate
    model: dashboard
    explore: incontact_clone
    type: looker_line
    fields:
    - incontact_clone.start_date
    - incontact_clone.close_rate
    fill_fields:
    - incontact_clone.start_date
    filters:
      incontact_clone.campaign: Care Phone,Care Electronic
    sorts:
    - incontact_clone.start_date
    limit: 500
    column_limit: 50
    query_timezone: America/Denver
    stacking: ''
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
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: []
    series_types: {}
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: incontact_clone.close_rate
        name: Close Rate
        axisId: incontact_clone.close_rate
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    listen:
      market name: markets.name
      time: incontact_clone.start_date
    row: 6
    col: 0
    width: 8
    height: 6
  - title: Referred via Phone Screen
    name: Referred via Phone Screen
    model: dashboard
    explore: care_requests
    type: looker_column
    fields:
    - care_request_flat.requested_date
    - care_request_flat.care_request_count
    - care_request_flat.primary_and_secondary_resolved_reason
    pivots:
    - care_request_flat.primary_and_secondary_resolved_reason
    fill_fields:
    - care_request_flat.requested_date
    filters: {}
    sorts:
    - care_request_flat.primary_and_secondary_resolved_reason
    - care_request_flat.requested_date
    - primary_resolved_reason desc 0
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: care_request_count_if_resolved
      label: Care Request Count if Resolved
      expression: if(contains(${care_request_flat.primary_and_secondary_resolved_reason},
        "Referred - Phone Triage"),${care_request_flat.care_request_count},null)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
    - table_calculation: total
      label: Total
      expression: sum(pivot_row(${care_request_flat.care_request_count}))
      value_format:
      value_format_name:
      _kind_hint: supermeasure
      _type_hint: number
    - table_calculation: percent_of_total
      label: Percent of Total
      expression: "${care_request_count_if_resolved}/${total}"
      value_format:
      value_format_name: percent_0
      _kind_hint: measure
      _type_hint: number
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
    x_axis_reversed: false
    y_axis_reversed: false
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
    hidden_points_if_no:
    hidden_fields:
    - care_request_flat.care_request_count
    - total
    - care_request_count_if_resolved
    column_spacing_ratio:
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: care_request_flat.care_request_count
        name: Care Request Count
        axisId: care_request_flat.care_request_count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hide_legend: false
    listen:
      market name: markets.name
      time: care_request_flat.requested_date
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
    - care_request_flat.requested_date
    - care_request_flat.care_request_count
    - care_request_flat.primary_and_secondary_resolved_reason
    - care_request_flat.lwbs
    pivots:
    - care_request_flat.primary_and_secondary_resolved_reason
    - care_request_flat.lwbs
    fill_fields:
    - care_request_flat.requested_date
    filters: {}
    sorts:
    - care_request_flat.primary_and_secondary_resolved_reason
    - care_request_flat.requested_date
    - care_request_flat.lwbs
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: care_request_count_if_resolved
      label: Care Request Count if Resolved
      expression: if(${care_request_flat.lwbs} = yes,${care_request_flat.care_request_count},null)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
    - table_calculation: total
      label: Total
      expression: sum(pivot_row(${care_request_flat.care_request_count}))
      value_format:
      value_format_name:
      _kind_hint: supermeasure
      _type_hint: number
    - table_calculation: percent_of_total
      label: Percent of Total
      expression: "${care_request_count_if_resolved}/${total}"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
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
    x_axis_reversed: false
    y_axis_reversed: false
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
    hidden_points_if_no:
    hidden_fields:
    - care_request_flat.care_request_count
    - total
    - care_request_count_if_resolved
    column_spacing_ratio:
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: care_request_flat.care_request_count
        name: Care Request Count
        axisId: care_request_flat.care_request_count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hide_legend: false
    listen:
      market name: markets.name
      time: care_request_flat.requested_date
    row: 12
    col: 0
    width: 8
    height: 6
  - title: Inbound Contacts by Time of Day
    name: Inbound Contacts by Time of Day
    model: dashboard
    explore: incontact_clone
    type: looker_line
    fields:
    - incontact_clone.start_hour_of_day
    - incontact_clone.count_distinct
    fill_fields:
    - incontact_clone.start_hour_of_day
    filters:
      incontact_clone.campaign: Care Phone,Care Electronic
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
      time: incontact_clone.start_date
    row: 12
    col: 8
    width: 8
    height: 6
  - title: Average In Queue, Assigned, and Drive Times
    name: Average In Queue, Assigned, and Drive Times
    model: dashboard
    explore: care_requests
    type: looker_column
    fields:
    - care_request_flat.requested_date
    - care_request_flat.average_in_queue_time_minutes
    - care_request_flat.average_assigned_time_minutes
    - care_request_flat.average_drive_time_minutes
    fill_fields:
    - care_request_flat.requested_date
    sorts:
    - care_request_flat.requested_date
    limit: 500
    query_timezone: America/Denver
    stacking: ''
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
    listen:
      market name: markets.name
      time: care_request_flat.requested_date
    row: 18
    col: 13
    width: 8
    height: 6
  - title: General Risk Protocol
    name: General Risk Protocol
    model: dashboard
    explore: care_requests
    type: looker_line
    fields:
    - care_request_flat.created_date
    - risk_assessments.general_complaint_percent
    fill_fields:
    - care_request_flat.created_date
    filters:
      risk_assessments.protocol_name: "-NULL"
    sorts:
    - care_request_flat.created_date 0
    limit: 500
    total: true
    query_timezone: America/Denver
    stacking: ''
    show_value_labels: false
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
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_points_if_no: []
    hidden_fields: []
    series_types: {}
    swap_axes: false
    focus_on_hover: true
    listen:
      market name: markets.name
      time: care_request_flat.created_date
    row: 24
    col: 5
    width: 8
    height: 6
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
    - csc_survey_clone.date_date
    fill_fields:
    - csc_survey_clone.date_date
    filters: {}
    sorts:
    - csc_survey_clone.date_date desc
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
    listen:
      market name: markets.name
      time: csc_survey_clone.date_date
    row: 12
    col: 16
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
    field: markets.name
  - name: time
    title: time
    type: field_filter
    default_value: 3 days ago for 3 days
    allow_multiple_values: true
    required: false
    model: dashboard
    explore: care_requests
    listens_to_filters: []
    field: incontact_clone.start_date
