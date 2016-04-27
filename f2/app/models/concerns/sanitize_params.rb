module SanitizeParams
  extend ActiveSupport::Concern

  protected

  def strip_tags(params)
    stripped_params = { staff_id: current_user.id }
    params.each do |k, v|
      stripped_params[k.to_sym] = if v.is_a? String
                                    ActionController::Base.helpers.strip_tags(v)
                                  else
                                    v
                                  end
    end
    ActionController::Parameters.new(stripped_params)
  end
end
