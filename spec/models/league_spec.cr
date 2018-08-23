require "./spec_helper"
require "../../src/models/league.cr"

describe League do
  Spec.before_each do
    delete_all_from_table("leagues")
  end
end
