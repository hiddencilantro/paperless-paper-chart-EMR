module ApplicationHelper
    def full_name(obj)
        "#{obj.first_name} #{obj.last_name}"
    end
end
