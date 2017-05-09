/*******************************************************************************
CRUD DDL for table ta.date
Note:  No update or delete operations are possible.  This table is seeded only.
History:
  04/10/2017  Todd Morley   created file
*******************************************************************************/

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getDateId(
  dateIn in date
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.date_dim
      where the_date = dateIn;
    return(tempId);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
getDateId returns the ID of the input date in the date_dim dimension table.
*******************************************************************************/
create or replace function ta.getDateId(timestampIn in timestamp)
returns bigint
as $$
  declare
    tempDateDimId bigint;
  begin
    select id
      into tempDateDimId
      from ta.date_dim
      where ta.date_dim.the_date = timestampIn::date;
    return(tempDateDimId);
  end
$$
language plpgsql;

/*******************************************************************************
Get function returns table rowtype, or null if no entity with the input ID was
found.
*******************************************************************************/
create or replace function ta.getDate(idIn in bigint)
returns ta.date_dim
as $$
  declare
    tempRecord ta.date_dim%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.date_dim
      where id = idIn;
    return(tempRecord);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
getDateDescription returns a text description of the date with ID idIn, or null 
if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getDateDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select to_char(the_date, "Mon-DD-YYYY")
      into tempDescription
      from ta.date_dim
      where id = idIn;
    return(tempDescription);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;
