require "./spec_helper"
require "../../src/models/administrator.cr"

describe Administrator do
  Spec.before_each do
    delete_all_from_table("administrators")
  end
end
