require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  Spec.before_each do
    delete_all_from_table("users")
  end
end
