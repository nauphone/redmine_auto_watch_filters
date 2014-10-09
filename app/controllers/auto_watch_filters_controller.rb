class AutoWatchFiltersController < ApplicationController
  unloadable
  helper :projects
  include ProjectsHelper
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  helper :custom_fields
  include CustomFieldsHelper
  include AutoWatchFiltersHelper
  before_filter :find_project_by_project_id

  def new
    autowatchfilter_retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @auto_watch_filter = AutoWatchFilter.new(params[:auto_watch_filter])
    @groups = Group.find(:all, :order => 'lastname')
    @auto_watch_filter.project_id = @project.id
    render :layout => false if request.xhr?
  end

  def create
    autowatchfilter_retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.update_attributes(:name => params[:auto_watch_filter][:name], :is_public => true)
    if @query.valid?
      @query.save
      @auto_watch_filter = AutoWatchFilter.new(params[:auto_watch_filter])
      @groups = Group.find(:all, :order => 'lastname')
      @auto_watch_filter.project_id = @project.id
      @auto_watch_filter.query_id = @query.id

      if @auto_watch_filter.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => :projects, :action => :settings, :tab => "auto_watch_filters", :id => @project
      else
        flash.now[:error] = "Filter is invalid"
        render :new
      end
    else
      flash.now[:error] = "Filter is invalid"
      render :new
    end
  end

  def edit
    @auto_watch_filter = AutoWatchFilter.find(params[:id])
    @groups = Group.find(:all, :order => 'lastname')
    unless 'set_filter'.in? params and 'f'.in? params and 'v'.in? params
      unless @auto_watch_filter.query.nil?
        params[:query_id] = @auto_watch_filter.query_id 
      end
    end
    autowatchfilter_retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
  end

  def update
    @auto_watch_filter = AutoWatchFilter.find(params[:id])
    @groups = Group.find(:all, :order => 'lastname')
    unless 'set_filter'.in? params and 'f'.in? params and 'v'.in? params
      unless @auto_watch_filter.query.nil?
        params[:query_id] = @auto_watch_filter.query_id 
      end
    end
    @auto_watch_filter.update_attributes(params[:auto_watch_filter])
    autowatchfilter_retrieve_query
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    @query.update_attributes(:name => params[:auto_watch_filter][:name], :is_public => true)
    @query.build_from_params(params)
    if @query.valid?
      @query.save
      @auto_watch_filter.project_id = @project.id
      @auto_watch_filter.query_id = @query.id
      if @auto_watch_filter.save
        flash[:notice] = l(:notice_successful_update)
        redirect_to :controller => :projects, :action => :settings, :tab => "auto_watch_filters", :id => @project
      else
        flash.now[:error] = "Filter is invalid"
        render :new
      end
    else
      flash.now[:error] = "Filter is invalid"
      render :new
    end
  end

  def destroy
    @auto_watch_filter = AutoWatchFilter.find(params[:id])
    @project = Project.visible.find(:first, :conditions => {:identifier => params[:project_id]})
    if request.post?
      unless @auto_watch_filter.query.nil?
        @auto_watch_filter.query.destroy
      end
      @auto_watch_filter.destroy
    end
    redirect_to :controller => :projects, :action => :settings, :tab => "auto_watch_filters", :id => @project
  end
end
