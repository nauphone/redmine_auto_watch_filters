class AddQueryIdToWatchFilters < ActiveRecord::Migration
  def self.up
    add_column :auto_watch_filters, :query_id, :integer
    AutoWatchFilter.all.each do |watch_filter|
      if watch_filter.query.nil?
        @project = Project.find(watch_filter.project_id)
        new_query = AutoWatchQuery.new(:filters => watch_filter.filters, :name => watch_filter.name, :is_public => true, :user_id => 0)
        new_query.project_id = watch_filter.project_id.to_i
        new_query.save
        watch_filter.query_id = new_query.id
        watch_filter.save
      end
    end
    remove_column :auto_watch_filters, :filters
  end

  def self.down
    add_column :auto_watch_filters, :filters, :text
    AutoWatchFilter.all.each do |watch_filter|
      unless watch_filter.query.nil?
        watch_filter.filters = watch_filter.query.filters
        watch_filter.save
        watch_filter.query.destroy
      end
    end
    remove_column :auto_watch_filters, :query_id
  end
end
