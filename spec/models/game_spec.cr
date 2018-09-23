require "./spec_helper"
require "../../src/models/game.cr"

describe Game do
  Spec.before_each do
    Game.all.destroy
  end
end
