# ref: https://github.com/plataformatec/devise/wiki/Redirect-to-new-registration-(sign-up)-path-if-unauthenticated
# ref: https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-when-the-user-can-not-be-authenticated
#
# To redirect to user to specific path after authentication failed through Warden Rack Authentication Framework
#
class WardenFailureApp < Devise::FailureApp
  def route(scope)
    :root_url
  end
end