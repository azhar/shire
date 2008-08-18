# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
<<<<<<< HEAD:app/controllers/application.rb
  protect_from_forgery # :secret => '77e682db1807bf50590962968b5eae4b'
=======
  protect_from_forgery # :secret => 'fcda309b7ef59a6887a72f884a0aa688'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
>>>>>>> FETCH_HEAD:app/controllers/application.rb
end
