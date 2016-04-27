module TagsList
  PER_PAGE_DEFAULT = 10

  extend ActiveSupport::Concern

  included do
    before_action :gather_tag_params!
  end

  module ClassMethods
  end

  def gather_tag_params!
    return if params[:tags].nil?
    @tag_params = [params[:tags].flatten]
  end

  def query_with_tags_list(query)
    return query if params[:tags].nil?
    query.tagged_with(@tag_params)
  end
end
