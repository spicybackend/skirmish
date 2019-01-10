module SharedPartials
  include ViewModel::Helpers

  def_partial :error_messages, errors
end
