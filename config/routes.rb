RedmineApp::Application.routes.draw do
  match 'projects/:project_id/auto_watch_filters/:action', :controller => 'auto_watch_filters'
end

