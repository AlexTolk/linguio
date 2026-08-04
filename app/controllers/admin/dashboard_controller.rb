module Admin
  class DashboardController < Admin::BaseController
    def index
      @courses_count = Course.count
    end
  end
end