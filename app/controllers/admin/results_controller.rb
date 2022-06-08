class Admin::ResultsController < Admin::BaseController

    def index
        @results = Result.order(created_at: :desc)
    end
end
