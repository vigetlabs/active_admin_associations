ActiveAdmin.register Tag do
  association_actions

  form :partial => "admin/shared/form"
  
  form_columns [:name]
  
  form_relationships [
    [:posts, [:title, :creator]]
  ]
end
