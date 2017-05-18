$(function() {
  $(".datepicker").datepicker();
});

$( function() {
  $( document ).tooltip();
} );



// foreign key dropdown
// [note: the loading of dropdown options only happens once since the selectmenu
// function changes the DOM, eliminating the "foreignkey-dropdown" class]
$( function() {
  $(".foreignkey-dropdown")
    .focus(function() {
      var new_dropdown_options = "<option value='1'>one</option><option value='2'>two</option>";

      // get data table name from html data-table-name attribute on select
      var table_name = $(this).data("table-name");

      $.ajax({
        url: "/api/" + table_name + "/fkdropdown",
        data: {
          attr: ""
        },
        success: function( result ) {
          $(".foreignkey-dropdown").html(result);
          console.log("refresh?!?!");
          $(".foreignkey-dropdown")
            .selectmenu({
              close: function( event, ui ) {
                $(".reference-data-panel").text("");
              }
            })
            .selectmenu("open")
            ;
          $(".reference-data-panel").text("success!");
        }
      });
    })
  ;
});
