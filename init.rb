require 'redmine'

require 'auto_watch_group_issue_hook'

Redmine::Plugin.register :redmine_auto_group_watchers do
  name 'Auto Group Watchers'
  author ''
  description ''
  version '0.0.1'

  project_module :auto_watch do
    permission :manage_auto_watch_filters, { :auto_watch_filters => [:index, :new, :edit] }
  end
  menu :project_menu, :auto_watch_filters, {:controller => 'auto_watch_filters', :action => 'index'},
       :caption => 'Auto Watch', :after => :news, :param => :project_id


end
