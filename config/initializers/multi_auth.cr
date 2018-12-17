require "multi_auth"

if ENV["GOOGLE_ID"]? && ENV["GOOGLE_SECRET"]?
  MultiAuth.config("google", ENV["GOOGLE_ID"], ENV["GOOGLE_SECRET"])
end
