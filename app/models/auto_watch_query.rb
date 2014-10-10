class AutoWatchQuery < IssueQuery
  self.default_scopes = []
  def issue_ids(options={})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)

    Issue.scoped(:conditions => options[:conditions]).scoped(:include => ([:status, :project] + (options[:include] || [])).uniq,
                     :conditions => statement,
                     :order => order_option,
                     :joins => joins_for_order_statement(order_option.join(',')),
                     :limit  => options[:limit],
                     :offset => options[:offset]).find_ids
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end
  ##### HARDCODE FOR SPEED. type_for in query.rb use available_filters #####
  def type_for(field)
    types = {
        "status_id"=>{:type=>:list_status},
        "tracker_id"=>{:type=>:list},
        "priority_id"=>{:type=>:list},
        "author_id"=>{:type=>:list},
        "assigned_to_id"=>{:type=>:list_optional},
        "member_of_group"=>{:type=>:list_optional},
        "assigned_to_role"=>{:type=>:list_optional},
        "fixed_version_id"=>{:type=>:list_optional},
        "category_id"=>{:type=>:list_optional},
        "subject"=>{:type=>:text},
        "created_on"=>{:type=>:date_past},
        "updated_on"=>{:type=>:date_past},
        "closed_on"=>{:type=>:date_past},
        "start_date"=>{:type=>:date},
        "due_date"=>{:type=>:date},
        "estimated_hours"=>{:type=>:float},
        "done_ratio"=>{:type=>:integer},
        "is_private"=>{:type=>:list},
        "watcher_id"=>{:type=>:list},
        "subproject_id"=>{:type=>:list_subprojects},
        "cf_32"=>{:type=>:list_optional},
        "cf_34"=>{:type=>:list_optional},
        "cf_21"=>{:type=>:list_optional},
        "cf_3"=>{:type=>:string},
        "cf_9"=>{:type=>:float},
        "cf_22"=>{:type=>:list},
        "cf_25"=>{:type=>:text},
        "relates"=>{:type=>:relation},
        "duplicates"=>{:type=>:relation},
        "duplicated"=>{:type=>:relation},
        "blocks"=>{:type=>:relation},
        "blocked"=>{:type=>:relation},
        "precedes"=>{:type=>:relation},
        "follows"=>{:type=>:relation},
        "copied_to"=>{:type=>:relation},
        "copied_from"=>{:type=>:relation},
        "parent_id"=>{:type=>:integer},
        "hide_parent"=>{:type=>:list},
        "tags"=>{:type=>:list_optional}
    }
    types[field][:type] if types.has_key?(field)
  end
  ##### END HARDCODE FOR SPEED. type_for in query.rb use available_filters #####
end
