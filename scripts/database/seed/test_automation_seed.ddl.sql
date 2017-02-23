/*******************************************************************************
Test-Automation seed-data DDL
History:
  02/22/2017  Todd Morley   initial file creation
*******************************************************************************/

create or replace function ta.populateDateDim()
returns void 
as $$
  declare
    tempDate date;
    upperLimit date;
  begin
    tempDate := to_date('01 Jan 2000', 'DD Mon YYYY');
    upperLimit := to_date('31 Dec 2099', 'DD Mon YYYY');
    delete from ta.date_dim;
    loop
      insert into ta.date_dim(id, the_date, year, quarter, month, day)
        values(
          nextval('ta.date_dim_id_s'),
          tempDate,
          date_part('year', tempDate),
          date_part('quarter', tempDate),
          date_part('month', tempDate),
          date_part('day', tempDate)
        );
      tempDate := tempDate + 1;
      if(tempDate > upperLimit) then
        exit;
      end if;
    end loop;
  end
$$
language plpgsql;
