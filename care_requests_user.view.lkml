include: "care_requests.view.lkml"

view: care_requests_user {
  extends: [care_requests]

  dimension: accepted_visit {
    hidden: yes
  }

}
