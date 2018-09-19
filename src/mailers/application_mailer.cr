require "kilt"

class ApplicationMailer < Mailer::Message
  macro render(filename, layout, *args)
    content = render("{{filename.id}}", {{*args}})
    render("layouts/{{layout.id}}")
  end

  macro render(filename, *args)
    Kilt.render("src/views/{{filename.id}}", {{*args}})
  end
end
