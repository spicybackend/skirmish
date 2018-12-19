Signal::SEGV.reset
Signal::BUS.reset

ENV["BASE_URL"] ||= "http://#{Amber.settings.host == "0.0.0.0" ? "localhost" : "0.0.0.0"}:#{Amber.settings.port}"
