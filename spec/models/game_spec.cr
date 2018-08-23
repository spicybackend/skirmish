require "./spec_helper"
require "../../src/models/game.cr"

describe Game do
  Spec.before_each do
    delete_all_from_table("games")
  end
end
