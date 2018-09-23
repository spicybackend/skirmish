require "./spec_helper"
require "../../src/models/membership.cr"

describe Membership do
  Spec.before_each do
    Membership.all.destroy
  end
end
