ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/auto_watch_filters/:action', :controller => 'auto_watch_filters'
end


