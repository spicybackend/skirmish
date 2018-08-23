require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  Spec.before_each do
    delete_all_from_table("users")

    # Create an admin user
    admin_user = User.new
    admin_user.email = "admin@example.com"
    admin_user.password = "password"
    admin_user.save!

    admin = Player.create!(
      tag: "admin",
      user_id: admin_user.id
    )

    Administrator.create!(
      user_id: admin.id
    )
  end
end
