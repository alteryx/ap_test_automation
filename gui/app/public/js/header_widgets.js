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
      // get data table name from html data-table-name attribute on select
      var $this = $(this);
      var table_name = $this.data("table-name");


      $.ajax({
        url: "/api/" + table_name + "/fkdropdown",
        data: {
          attr: ""
        },
        success: function( result ) {
          $this.html(result);
          $this
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
