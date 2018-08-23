require "./spec_helper"
require "../../src/models/participation.cr"

describe Participation do
  Spec.before_each do
    delete_all_from_table("participations")
  end
end
