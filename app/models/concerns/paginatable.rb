module Paginatable
  extend ActiveSupport::Concern

  module ClassMethods
    def paginate(page = 1, per_page = 20)
      page = 1 if page < 1
      per_page = 20 if per_page < 1
      limit(per_page).offset((page - 1) * per_page)
    end
  end
end