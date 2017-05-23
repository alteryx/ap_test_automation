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
          if (result.replace(/\s/g,'').length>0){
            $this.html(result);
            $(".reference-data-panel").text("success!");
          } else {
            $this.addClass("fk-no-options");
            $(".reference-data-panel").text("no foreign key values");
          }
            $this
              .selectmenu({
                close: function( event, ui ) {
                  $(".reference-data-panel").text("");
                }
              })
              .selectmenu("open")
              ;

        },
        error: function(xhr,status){
          $(".reference-data-panel").text("error");
        }
      });
    })
  ;
});


$( function() {
  $(".read-header-class.fk").each(function(){
    var fk_table = $(this).data("fk-table-name");
    // grab lookup values for each fk reference table
    $.ajax({
      url: "/api/" + fk_table + "/fk/json",
      success: function( json ) {
        $(".fk-"+fk_table).each(function(){
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
  });
});
