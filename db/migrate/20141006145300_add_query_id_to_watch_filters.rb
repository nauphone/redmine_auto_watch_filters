class AddQueryIdToWatchFilters < ActiveRecord::Migration
  def self.up
    add_column :auto_watch_filters, :query_id, :integer
  end

  def self.down
    remove_column :auto_watch_filters, :query_id
  end
end
