
- if Amber.env.development?
  h1 = @ex.message.to_s
  h6.section-header 500 - Internal Server Error

  #accordion
    .card
      #headingOne.card-header
        .mb-0
          button.btn.btn-link data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne"
            | Toggle Backtrace

      #collapseOne.collapse aria-labelledby="headingOne" data-parent="#accordion"
        .card-body
          pre.backtrace = @ex.inspect_with_backtrace

- else
  h1 = I18n.translate("error.title.internal_server_error")
  h6.section-header = I18n.translate("error.message.internal_server_error")
