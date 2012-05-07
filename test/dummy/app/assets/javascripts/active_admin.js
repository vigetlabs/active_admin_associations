//= require active_admin/base
//= require active_admin_associations

$(document).ready(function(){
  $('#main_content').on('ajax:success', '.relationship-table .pagination a', function(e, html){
    $(this).closest('.relationship-table').replaceWith(html);
  });
});
