class AutoWatchGroupIssuesControllerHook < Redmine::Hook::ViewListener

  def controller_issues_new_after_save(context={})
    controller_issues_edit_after_save context
  end

  def controller_issues_edit_after_save(context={})
    issue = context[:issue]
    if Redmine::Plugin.installed? :redmine_advanced_issue_history
      notes=[]
    end
    unless issue.project.enabled_modules.find_by_name('auto_watch').nil?
      AutoWatchFilter.all.each do |watch_filter|
        next if watch_filter.group.nil?
        next if watch_filter.query.nil?
        issue_ids = watch_filter.query.issue_ids
        user_ids = watch_filter.group.user_ids
        unless issue_ids.nil? or user_ids.nil?
          if issue_ids.include? issue.id
            user_ids.each do |user_id|
              user = User.find(user_id)
              unless issue.watcher_user_ids.include? user_id
                watcher = Watcher.new(:user_id => user_id, :watchable_type => "Issue", :watchable_id => issue.id)
                watcher.save
                if Redmine::Plugin.installed? :redmine_advanced_issue_history
                  notes.append("Watcher #{user.name} was added")
                end
              end
            end
          end
        end
      end
      if notes.any? and Redmine::Plugin.installed? :redmine_advanced_issue_history
        add_system_journal(notes, issue)
      end
    end
  end

end

