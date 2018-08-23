def delete_all_from_table(table_name : String)
  database_adapter.open do |database|
    database.exec "DELETE FROM `#{table_name}`;"
  end
end

def database_adapter
  Granite::Adapters.registered_adapters.first
end
