class AutoWatchGroupIssuesControllerHook < Redmine::Hook::ViewListener

  def controller_issues_new_after_save(context={})
    controller_issues_edit_after_save context
  end

  def controller_issues_edit_after_save(context={})
    issue = context[:issue]
    unless issue.project.enabled_modules.find_by_name('auto_watch').nil?
      AutoWatchFilter.all.each do |watch_filter|
        next if watch_filter.group.nil?
        next if watch_filter.query.nil?
        issue_ids = watch_filter.query.issue_ids
        user_ids = watch_filter.group.user_ids
        unless issue_ids.nil? or user_ids.nil?
          if issue_ids.include? issue.id
            user_ids.each do |user_id|
              watcher = Watcher.new(:user_id => user_id, :watchable_type => "Issue", :watchable_id => issue.id)
              watcher.save
            end
          end
        end
      end
    end
  end

end

