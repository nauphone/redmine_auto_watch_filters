require_dependency "projects_helper"

module AutoWatchGroup
  module ProjectsHelperPatch
    def self.included(base)
      base.class_eval do
        def project_settings_tabs_with_auto_watch_tabs
          tabs = project_settings_tabs_without_auto_watch_tabs
          unless @project.enabled_modules.find_by_name('auto_watch').nil?
            tabs.push({
              :name => "auto_watch_filters",
              :action => :manage_auto_watch,
              :partial => 'auto_watch_filters/index',
              :label => :label_auto_watch_filter_plural
            })
          end
          tabs
        end
        alias_method_chain :project_settings_tabs, :auto_watch_tabs
      end
    end
  end
end