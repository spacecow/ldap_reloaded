module ApplicationHelper
  def sortable(col, title = t(col))
    css_class = col == sort_column ? sort_direction : nil
    direction = col == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, {:sort => col, :direction => direction, :start_month => @start_month && @start_month.id}, {:class => css_class}
  end
end
