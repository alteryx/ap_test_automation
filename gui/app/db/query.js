
var utils = require('../utils');


/*function getTablesQueryString(schema){
  return `
    SELECT distinct(table_name) as table_name
    FROM information_schema.columns
    WHERE table_schema = '${schema}'
    ORDER BY table_name
  `;
}*/

function debug_query(query,debug,fn){
  //console.log("QUERY: " + str);
  utils.debugLogging(
    query,
    debug,
    "QUERY: " + fn
  );
}

/*function getTablesQueryString(schema,debug=false){
  var str = `
    SELECT distinct(table_name) as table_name
    FROM information_schema.columns
    WHERE table_schema = '${schema}'
    ORDER BY table_name
  `;
  if (debug) debug_query(str);
  return str;
}*/


function getTablesQueryString(schema,debug=false){
  var str = `
  SELECT
  	a.table_name, a.column_count, a.id_field_exists, a.create_datetime_field_exists, a.end_datetime_field_exists,
      sum(case when left(b.api_fn,3) = 'get' then 1 else 0 end)>0 as api_get_fn_exists,
      sum(case when left(b.api_fn,6) = 'create' then 1 else 0 end)>0 as api_create_fn_exists,
      sum(case when left(b.api_fn,6) = 'update' then 1 else 0 end)>0 as api_update_fn_exists,
      sum(case when left(b.api_fn,6) = 'delete' then 1 else 0 end)>0 as api_delete_fn_exists,
      sum(case when left(b.api_fn,3) NOT IN ('del','cre','upd','get') then 1 else 0 end) as api_other_fns
  FROM (
      SELECT
          table_name,
          replace(table_name,'_','') as fn_table_suffix,
          count(*) as column_count,
          sum(case when column_name = 'id' then 1 else 0 end)>0 as id_field_exists,
          sum(case when column_name = 'create_datetime' then 1 else 0 end)>0 as create_datetime_field_exists,
          sum(case when column_name = 'end_datetime' then 1 else 0 end)>0 as end_datetime_field_exists
      FROM information_schema.columns
      WHERE table_schema = '${schema}'
      GROUP BY table_name
      ) a
      LEFT JOIN (
          SELECT routine_name as api_fn
          FROM information_schema.routines
          WHERE
              routine_schema = '${schema}'
              and routine_type = 'FUNCTION'
      ) b
      	ON right(api_fn,length(a.fn_table_suffix))=a.fn_table_suffix
  GROUP BY a.table_name, a.column_count, a.id_field_exists, a.create_datetime_field_exists, a.end_datetime_field_exists
  ORDER BY a.table_name
  `;
  debug_query(str,debug,"getTablesQueryString");
  return str;
}


function getTablesQueryString2(schema,debug=false){
  /*var str = `
  SELECT *
  FROM (`*/
  var str = `
    SELECT
    	a.table_name, a.column_count, a.id_field_exists, a.create_datetime_field_exists, a.end_datetime_field_exists,
        sum(case when "get"||a.fn_table_suffix = b.api_fn then 1 else 0 end)>0 as api_get_fn_exists,
        sum(case when "create"||a.fn_table_suffix = b.api_fn then 1 else 0 end)>0 as api_create_fn_exists,
        sum(case when "update"||a.fn_table_suffix = b.api_fn then 1 else 0 end)>0 as api_update_fn_exists,
        sum(case when "delete"||a.fn_table_suffix = b.api_fn then 1 else 0 end)>0 as api_delete_fn_exists
    FROM (
        SELECT
            table_name,
            replace(table_name,'_','') as fn_table_suffix,
            count(*) as column_count,
            sum(case when column_name = 'id' then 1 else 0 end)>0 as id_field_exists,
            sum(case when column_name = 'create_datetime' then 1 else 0 end)>0 as create_datetime_field_exists,
            sum(case when column_name = 'end_datetime' then 1 else 0 end)>0 as end_datetime_field_exists
        FROM information_schema.columns
        WHERE table_schema = '${schema}'
        GROUP BY table_name
        ) a
        LEFT JOIN (
            SELECT routine_name as api_fn
            FROM information_schema.routines
            WHERE
                routine_schema = '${schema}'
                and routine_type = 'FUNCTION'
        ) b
        	ON right(api_fn,length(a.fn_table_suffix))=a.fn_table_suffix
    GROUP BY a.table_name, a.column_count, a.id_field_exists, a.create_datetime_field_exists, a.end_datetime_field_exists
    `;
  /*) c
  ORDER BY c.table_name
  `;*/
  debug_query(str,debug,"getTablesQueryString2");
  return str;
}


function getDataQueryString(schema,table,id,debug=false){
  var str = `SELECT * FROM ${schema}.${table} `;
  if (typeof id === "string") str += `WHERE id=${id}`;
  debug_query(str,debug,"getDataQueryString");
  return str;
}

function editDataQueryString(schema,table,edit_mode='create',data,debug=false){
  // example: SELECT ta.createTestPriorityLevel('Low')
  // need to generate comma separated list of data inputs
  var TableNameAsCamelCase = utils.camelize(table);
  var str = `SELECT ${schema}.${edit_mode}${TableNameAsCamelCase}(${data})`;
  debug_query(str,debug,"editDataQueryString");
  return str;
}


function deleteDataQueryString(schema,table,id,debug=false){
  var TableNameAsCamelCase = utils.camelize(table);
  var str = `SELECT ${schema}.delete${TableNameAsCamelCase}(${id})`;
  debug_query(str,debug,"deleteDataQueryString");
  return str;
}


function getColumnsQueryString(schema,table,debug=false){
  var table_name_smashed = table
    .toLowerCase()
    .replace(/[^a-z]/g, '')
  ;
  var fns = {
    create: 'create' + table_name_smashed + '_',
    update: 'update' + table_name_smashed + '_',
    delete: 'delete' + table_name_smashed + '_',
  }

  var str = `
    SELECT
    	a.column_name, a.is_nullable, a.data_type, a.column_index,
      b.param_index as create_param_index,
      c.param_index as update_param_index,
      d.param_index as delete_param_index
    FROM (
      SELECT
        column_name,
        lower(replace(column_name,'_',''))||'in' as param_name,
        ordinal_position as column_index,
        is_nullable,
        data_type
      FROM information_schema.columns
      WHERE
        table_schema = '${schema}' and table_name = '${table}'
      ) a
      LEFT JOIN (
          SELECT parameter_name as param_name, ordinal_position as param_index
          FROM information_schema.parameters
          WHERE
          	specific_schema = '${schema}' and
            left(specific_name,${fns.create.length})='${fns.create}'
      ) b
      	ON a.param_name = b.param_name
      LEFT JOIN (
          SELECT parameter_name as param_name, ordinal_position as param_index
          FROM information_schema.parameters
          WHERE
          	specific_schema = '${schema}' and
            left(specific_name,${fns.update.length})='${fns.update}'
      ) c
      	ON a.param_name = c.param_name
      LEFT JOIN (
          SELECT parameter_name as param_name, ordinal_position as param_index
          FROM information_schema.parameters
          WHERE
          	specific_schema = '${schema}' and
            left(specific_name,${fns.delete.length})='${fns.delete}'
      ) d
      	ON a.param_name = d.param_name
    ORDER BY a.column_index
  `;
  debug_query(str,debug,"getColumnsQueryString");
  return str;
}


module.exports = {
  getTablesQueryString: getTablesQueryString,
  getDataQueryString: getDataQueryString,
  editDataQueryString: editDataQueryString,
  deleteDataQueryString: deleteDataQueryString,
  getColumnsQueryString: getColumnsQueryString
};
