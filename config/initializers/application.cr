Signal::SEGV.reset
Signal::BUS.reset

ENV["BASE_URL"] ||= "http://#{Amber.settings.host}:#{Amber.settings.port}"
