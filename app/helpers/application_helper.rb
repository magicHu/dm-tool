module ApplicationHelper
  def param_class(param)
    if param.is_date?
      'datepicker'
    else
      ''
    end
  end
end
