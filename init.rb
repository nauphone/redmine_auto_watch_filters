require 'redmine'

require 'auto_watch_group_issue_hook'
require 'projects_helper_patch'
ActionDispatch::Callbacks.to_prepare  do
  ProjectsHelper.send(:include, ::AutoWatchGroup::ProjectsHelperPatch)
end

Redmine::Plugin.register :redmine_auto_group_watchers do
  name 'Auto Group Watchers'
  author ''
  description ''
  version '0.0.1'

  project_module :auto_watch do
    permission :manage_auto_watch_filters, { :auto_watch_filters => [:index, :new, :edit] }
  end
end
