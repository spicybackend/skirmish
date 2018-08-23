require "./spec_helper"
require "../../src/models/membership.cr"

describe Membership do
  Spec.before_each do
    delete_all_from_table("memberships")
  end
end
