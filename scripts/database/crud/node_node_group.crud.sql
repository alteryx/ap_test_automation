/*******************************************************************************
SourceFile-Automation CRUD DDL for relation table ta.node_node_group
History:
  02/28/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns void (even if the target relation already
exists), and raises an exception upon error.  
*******************************************************************************/
create or replace function ta.createNodeNodeGroup(
  nodeIdIn in bigint,
  nodeGroupIdIn in bigint
)
returns void
as $$
  declare
    tempNodeNodeGroupCount integer;
    tempNodeCount integer;
    tempNodeGroupCount integer;
  begin
    select count(*)
      into tempNodeCount
      from ta.node
      where
        id = nodeIdIn and
        end_datetime is null;
    select count(*)
      into tempNodeGroupCount
      from ta.node_group
      where
        id = nodeGroupIdIn and
        end_datetime is null;
    if(
      tempNodeCount = 0 or 
      tempNodeGroupCount = 0 or
      nodeIdIn is null or
      nodeGroupIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createNodeNodeGroup';
    end if;
    select count(*)
      into tempNodeNodeGroupCount
      from ta.node_node_group
      where
        node_id = nodeIdIn and
        node_group_id = nodeGroupIdIn and
        end_datetime is null;
    if(tempNodeNodeGroupCount > 0) then
      return;
    end if;
    insert into ta.node_node_group(
      create_datetime,
      end_datetime,
      node_id,
      node_group_id
    ) values(
      current_timestamp,
      null,
      nodeIdIn,
      nodeGroupIdIn
    );
    return;
  end
$$
language plpgsql;

/*******************************************************************************
GetNodeNodeGroups function returns a table of IDs of node groups for the input 
node.  
*******************************************************************************/
create or replace function ta.getNodeNodeGroups(nodeIdIn in bigint)
returns table(node_group_id bigint)
as $$
  declare
  begin
    return query select 
      node_group_id
      from ta.node_node_group 
      where 
        node_id = nodeIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
GetNodeGroupNodes function returns a table of IDs of nodes in the input node
group. 
*******************************************************************************/
create or replace function ta.GetNodeGroupNodes(nodeGroupIdIn in bigint)
returns table(node_id bigint)
as $$
  declare
  begin
    return query select 
      node_id
      from ta.node_node_group 
      where 
        node_group_id = nodeGroupIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
No update function; all exposed attributes are in key.
*******************************************************************************/

/*******************************************************************************
Delete function deletes a (node, node group) relation and returns void.
*******************************************************************************/
create or replace function ta.deleteNodeNodeGroup(
  nodeIdIn in bigint,
  nodeGroupIdIn in bigint
)
returns void
as $$
  declare
  begin
     update ta.node_node_group 
      set end_datetime = current_timestamp
      where
        node_id = nodeIdIn and
        node_group_id = nodeGroupIdIn and
        end_datetime is null;
    return;
  end
$$
language plpgsql;
