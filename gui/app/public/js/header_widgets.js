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
        url: "/api/" + table_name + "/fk/dropdown",
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


// foreign key value replacement on read page
$( function() {
  var foreignkey_tables = $(".read-header-class.fk")
    .map(function(){
      return $(this).data("fk-table-name")
    })
    .get()
  ;

  for (var i=0,l=foreignkey_tables.length;i<l;i++){
    var fk_table = foreignkey_tables[i];

    $.ajax({
      url: "/api/" + fk_table + "/fk/json",
      success: function( json ) {
        $(".fk-"+fk_table).each(function(i){
          var $this = $(this);

          // replace value with label
          $this.html(
            json.filter(function(obj){
              return obj.value === $this.data("fk-value").toString();
            })[0].label
          );

        })
      }
    });


  }
});
