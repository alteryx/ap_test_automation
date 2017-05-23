'use strict';

var _ = require("lodash");


// infer properties about a column in our db tables based on its field name
function columnNameProperties(name){
  // set default properties
  var props = {
    dependency:false,
    display:true,
    label:name
  };

  if (name.slice(-3)==="_id") {
    props.dependency = true;

    // remove _id suffix from name
    var dep_table = name.slice(0,-3);


    // handle rare cases where there is a prefix for table
    // (such as owning_team_id on module table, originating_person_id on event
    //  table, and depending_module_id / depended_module_id on the
    //  module_module table)
    if (dep_table.slice(-5)==="_team") dep_table = "team";
    else if (dep_table.slice(-7)==="_module") dep_table = "module";
    else if (dep_table.slice(-7)==="_person") dep_table = "person";

    props.dependent_table = dep_table;
    props.dependent_field = "id";
  }

  // display field (by default) if its field name does not match one of these
  if (name.match( /^(id|create_datetime|end_datetime)$/g )){
    props.display = false;
  }


  // generate human readable/friendly label for column
  // first, remove _id suffix from label
  if (props.label.slice(-3)==="_id") props.label = dep_table;
  // next, identify abbreviations to be replaced
  if (props.label)
  // next, some regexes for additonal cleanup
  props.label = props.label
    // convert underscores to spaces
    .replace(/_/g, ' ')
    // capitalize acronyms
    .replace(
      /(?:\b(dns|id|ip|guid|gb|ram)\b)/g,
      function(acronym, index) {
        return acronym.toUpperCase();
      }
    )
    // replace specific abbreviations
    .replace(/\bdim\b/g,'dimension')
    .replace(/\bmgt\b/g,'management')
    .replace(/\byn\b/g,'(y/n)')
    // capitalize first letter of words
    .replace(
      /(?:^\w|[A-Z]|\b\w)/g,
      function(letter, index) {
        return letter.toUpperCase();
      }
    )
  ;

  return props;
};




/////////////////////////////////////////////////////////////////////////////

module.exports = {
  columnNameProperties: columnNameProperties
};
