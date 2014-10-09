class AutoWatchFilter < ActiveRecord::Base
  unloadable
  belongs_to :project
  belongs_to :group
  belongs_to :query, :foreign_key => "query_id"

  serialize :filters

  validates_presence_of :name, :on => :save
  validates_presence_of :group_id, :on => :save
  validates_presence_of :project_id, :on => :save
end
