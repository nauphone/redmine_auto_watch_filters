module AutoWatchFiltersHelper
  unloadable
  def autowatchfilter_retrieve_query
    if !params[:query_id].blank?
      cond = "project_id IS NULL"
      cond << " OR project_id = #{@project.id}" if @project
      @query = AutoWatchQuery.find(params[:query_id], :conditions => cond)
      raise ::Unauthorized unless @query.visible?
      @query.project = @project
      session[:watch_query] = {:id => @query.id, :project_id => @query.project_id}
      sort_clear
    elsif api_request? || params[:set_filter] || session[:watch_query].nil? || session[:watch_query][:project_id] != (@project ? @project.id : nil)
      # Give it a name, required to be valid
      @query = AutoWatchQuery.new(:name => "_")
      @query.project = @project
      @query.build_from_params(params)
      session[:watch_query] = {:project_id => @query.project_id, :filters => @query.filters, :group_by => @query.group_by, :column_names => @query.column_names}
    else
      # retrieve from session
      @query = AutoWatchQuery.find_by_id(session[:watch_query][:id]) if session[:watch_query][:id]
      @query ||= AutoWatchQuery.new(:name => "_", :filters => session[:watch_query][:filters], :group_by => session[:watch_query][:group_by], :column_names => session[:watch_query][:column_names])
      @query.project = @project
    end
  end
end