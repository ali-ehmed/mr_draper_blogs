# This controller is the Base controller of devise inside config/devise.rb, as we want to support the
# respond to formats other than only HTML
module People
  class DeviseController < ApplicationController
    respond_to :html, :js, :json
  end
end