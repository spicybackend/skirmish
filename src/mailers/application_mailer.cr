require "kilt"
require "jasper_helpers"


class ApplicationMailer < Mailer::Message
  include JasperHelpers

  def initialize
    super()
    self.from = "Skirmish <postmaster@mail.skirmish.online>"
  end

  def send
    return if Amber.env.test? || suppress_emails?
    super
  end

  private def suppress_emails?
    ENV["SUPPRESS_EMAILS"]? != "false"
  end

  macro render(filename, layout, *args)
    content = render("{{filename.id}}", {{*args}})
    render("layouts/{{layout.id}}")
  end

  macro render(filename, *args)
    Kilt.render("src/views/{{filename.id}}", {{*args}})
  end
end
