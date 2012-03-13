class AutoWatchGroupIssuesControllerHook < Redmine::Hook::ViewListener

  def controller_issues_new_after_save(context={})
    controller_issues_edit_after_save context
  end

  def controller_issues_edit_after_save(context={})
    issue = context[:issue]
    unless context[:project].enabled_modules.find_by_name('auto_watch').nil?
      AutoWatchFilter.all.each { |auto_watch_filter|
        if auto_watch_filter.issues.include?(issue)
          auto_watch_filter.group.users.each { |user|
            if issue.addable_watcher_users.include?(user)
              issue.add_watcher(user)
            end
          }
        end
      }
    end
  end

end

