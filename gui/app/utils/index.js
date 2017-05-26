'use strict';

var _ = require("lodash");

function debugLogging(msg,on,label) {
  if (on) {
    console.log  ("==============================================");
    if (label){
      console.log("=== " + label + " ===");
      console.log("----------------------------------------------");
    }
    console.log(msg);
    console.log  ("==============================================");
  }
}


// helper function to convert strings to camel case
// eg, test_priority_level --> TestPriorityLevel
function camelize(str) {
  return str
    .replace(/_/g, ' ')
    .replace(
      /(?:^\w|[A-Z]|\b\w)/g,
      function(letter, index) {
        return index == 0 ? letter.toLowerCase() : letter.toUpperCase();
      }
    )
    .replace(/\s+/g, '')
    .replace(/^./, function (match){
        return match.toUpperCase()
    })
  ;
}


// Get the key names for an object and put them in an array
// eg, getObjKeys({prop1:"value",prop2:"value",prop3:"value"})
//     ==> ["prop1","prop2","prop3"]
function getObjKeys(obj,first_keys=[]){
  var keys = [];
  for (var i=0,l=first_keys.length; i<l; i++){
    var first_key = first_keys[i];
    if (first_key in obj){
      //console.log("true");
      _.concat(keys,first_key);
    }
  }
  //console.log(keys);
  for (var key in obj) {
    if (_.includes(keys,key)==false){
      if (!obj.hasOwnProperty(key)) continue;
      keys = _.concat(keys,key);
    }
  }
  return keys;
}


// sort by one parameter (helper for dynamicSort function)
function dynamicSortSingle(property) {
    var sortOrder = 1;
    if(property[0] === "-") {
        sortOrder = -1;
        property = property.substr(1);
    }
    return function (a,b) {
        var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
        return result * sortOrder;
    }
}

// sort by multiple parameters
// example: People.sort(dynamicSort("Name", "-Surname"));
function dynamicSort() {
    /*
     * save the arguments object as it will be overwritten
     * note that arguments object is an array-like object
     * consisting of the names of the properties to sort by
     */
    var props = arguments;
    return function (obj1, obj2) {
        var i = 0, result = 0, numberOfProperties = props.length;
        /* try getting a different result from 0 (equal)
         * as long as we have extra properties to compare
         */
        while(result === 0 && i < numberOfProperties) {
            result = dynamicSortSingle(props[i])(obj1, obj2);
            i++;
        }
        return result;
    }
}

// convert an object consisting of strings and numbers into a
// comma-delimited string of input parameters for a postgres api function
function convertObjectToSQLFunctionInputString(obj){
  var input_string = "";
  for (var key in obj) {
    if (key != "submit" && obj.hasOwnProperty(key)) {
      if (input_string != "") input_string += ",";
      if (typeof obj[key] === "string"){
        input_string += "'" + obj[key] + "'";
      } else {
        input_string += obj[key];
      }
    }
  }
  return input_string;
}

/////////////////////////////////////////////////////////////////////////////

module.exports = {
  debugLogging:debugLogging,
  camelize: camelize,
  dynamicSort: dynamicSort,
  convertObjectToSQLFunctionInputString: convertObjectToSQLFunctionInputString,
  getObjKeys: getObjKeys
};
