def delete_all_from_table(table_name : String)
  Granite::Adapter::Mysql.new({
    name: "mysql",
    url: ENV["DATABASE_URL"]? || Amber.settings.database_url
  }).open do |db|
    db.exec "DELETE FROM `#{table_name}`;"
  end
end
