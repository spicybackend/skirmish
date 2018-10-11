class MailerPreviewController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def show
    if params[:mailer_name]
      user = current_user.not_nil!
      player = user.player!

      render("mailers/welcome.html.slang", layout: "mailer_layout.html.slang")
    else
      flash["warning"] = "Can't find mailer"
      redirect_to "/"
    end
  end
end
