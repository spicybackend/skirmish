require "./spec_helper"
require "../../src/models/player.cr"

describe Player do
  Spec.before_each do
    delete_all_from_table("players")
  end
end
