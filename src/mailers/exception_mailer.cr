class ExceptionMailer < ApplicationMailer
  def initialize(exception : Exception)
    super()

    to(ERRORS_RECIPIENT_ADDRESS, "Service")

    self.subject = "EXCEPTION: #{exception.message}"
    self.text = exception.inspect_with_backtrace
  end
end
