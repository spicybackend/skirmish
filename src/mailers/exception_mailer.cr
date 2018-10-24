class ExceptionMailer < ApplicationMailer
  def initialize(exception : Exception, user : User?)
    super()

    to(ERRORS_RECIPIENT_ADDRESS, "Service")
    self.from = FROM_ERRORS

    self.subject = "EXCEPTION: #{exception.message}"
    self.text = render("mailers/exception.text.ecr")
  end
end
