require "../spec_helper"

def params_from_hash(params_hash : Hash)
  params = [] of String
  params_hash.each { |key, val| params << "#{key}=#{val}" }
  params.join("&")
end
