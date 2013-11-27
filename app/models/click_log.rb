class ClickLog < ActiveRecord::Base
  belongs_to :user

  class<<self
    def click config
      obj = config[:ref_obj]
      ClickLog.create user_id: config[:user_id],ref_id: obj.try(:id),ref_clazz: obj.class,ref_url: nil
      obj.update_attributes view_count: (obj.view_count||0)+1 if obj.respond_to?(:view_count)
    end

    def current_controller_name config
      (config.is_a?(Hash) ? config[:controller] : config).split("/").last.singularize
    end
  end
end
