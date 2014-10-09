class CreateAutoWatchFilters < ActiveRecord::Migration
  def self.up
    create_table :auto_watch_filters do |t|
      t.column "filters", :text
      t.column "group_id", :integer, :null => false
      t.column "project_id", :integer, :null => false
      t.column "name", :string
    end if !table_exists?("auto_watch_filters")
  end

  def self.down
    drop_table :queries
  end
end

