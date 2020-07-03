connection: "athena-intermediate"

include: "*document*"
# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: document_test {

  join: document_results {
    from: document_test
    relationship: one_to_one
    sql_on: ${document_test.document_id} = ${document_results.order_document_id} ;;
  }
}
