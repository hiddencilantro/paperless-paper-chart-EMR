module ApplicationHelper
    def full_name(obj)
        "#{obj.first_name.capitalize} #{obj.last_name.capitalize}"
    end
end
