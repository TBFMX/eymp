module ApplicationHelper

	# Method for removing fields
	def link_to_remove_fields(name, f)
	    link_to_function(name, "remove_fields(this)")
	end
	def remove_child_link(name, f)
		f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "remove_child")
	end

    def link_to_add_fields(name, f, association)  
  	  new_object = f.object.class.reflect_on_association(association).klass.new  
  	  fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
  	    render(association.to_s.singularize + "_fields", :f => builder)  
  	  end  
    	link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))  
    end




	def sortable(search,column, title = nil)
		title ||= column.titleize
		direction= column == sort_column && sort_direction == "asc" ? "desc": "asc"
		link_to title,:sort => column, :direction =>direction, :search => search

		#css_class = column == sort_column ? "current #{sort_direction}" : nil
		#direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		#link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end


end