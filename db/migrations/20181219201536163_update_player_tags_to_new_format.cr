class UpdatePlayerTagsToNewFormat < Jennifer::Migration::Base
  def up
    exec(
      "UPDATE players
      SET tag = replace(
        tag, ' ', '-'
      );"
    )
  end

  def down
  end
end
