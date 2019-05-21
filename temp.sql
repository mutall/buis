SELECT 
`agreement`.`agreement` AS `agreement`, 
`agreement`.`room` AS `room`, 
`agreement`.`client` AS `client`, 
`agreement`.`rent` AS `rent`, 
`agreement`.`rate` AS `rate`, 
`agreement`.`start_date` AS `start_date`, 
`agreement`.`duration` AS `duration`, 
`agreement`.`review` AS `review`, 
`agreement`.`end_date` AS `end_date`, 
`agreement`.`terminated` AS `terminated` 
FROM ((((agreement INNER JOIN `client` ON `client`.`client`=`agreement`.`client`) INNER JOIN `room` ON `room`.`room`=`agreement`.`room`) LEFT JOIN (SELECT `room`.`room` AS `_primary`, concat(`room`.`uid`) AS `_output`, concat(`room`.`uid`) AS `_id` FROM room ) AS `room_ext` ON `room_ext`.`_primary`=`agreement`.`room`) LEFT JOIN (SELECT `client`.`client` AS `_primary`, concat(`client`.`name`) AS `_output`, concat(`client`.`name`) AS `_id` FROM client ) AS `client_ext` ON `client_ext`.`_primary`=`agreement`.`client`) ;

select * from client where client_meter is null;


insert into `table`(`database`, `name`, serial_edit) values ('1', 'test', 'test');

select * from client LIMIT 5 OFFSET 5;

select * from information_schema.columns;


select
    `table_name` as entity_name, 
    table_schema as dbase_name
    from tables
    where table_type='base table'
    and not table_schema in ('information_schema', 'mysql', 'performance_schema', 'phpmyadmin', 'webauth')
    limit 3;

  
SELECT 
    period.year,
    month.num,
    `invoice`.`invoice` AS `_primary`, 
    concat(`client`.`code`,'/',`invoice`.`valid`,'/',`period`.`year`,'/',`month`.`num`) AS `_id`, 
    concat(`client`.`code`,'/',`client`.`full_name`,'/',`invoice`.`valid`,'/',`period`.`year`,'/',`month`.`num`,'/',`month`.`name`,'/',`month`.`long_name`) AS `_output`, 
    `client_ext`.`_primary` AS `client_ext_primary`, 
    `client_ext`.`_id` AS `client_ext_id`, 
    `client_ext`.`_output` AS `client_ext_output`, 
    `period_ext`.`_primary` AS `period_ext_primary`, 
    `period_ext`.`_id` AS `period_ext_id`, 
    `period_ext`.`_output` AS `period_ext_output`, 
    `invoice`.`valid` AS `valid` 
FROM (((((
    `invoice` INNER JOIN 
    `client` ON `client`.`client`=`invoice`.`client`) INNER JOIN 
    `period` ON `period`.`period`=`invoice`.`period`) INNER JOIN 
    `month` ON `month`.`month`=`period`.`month`) left JOIN 
    (SELECT 
        `client`.`client` AS `_primary`, 
        concat(`client`.`code`,'/',`client`.`full_name`) AS `_output`, 
        concat(`client`.`code`) AS `_id` 
    FROM `client` ) AS `client_ext` ON `client_ext`.`_primary`=`invoice`.`client`) left JOIN 
    (SELECT 
        `period`.`period` AS `_primary`, 
        concat(`period`.`year`,'/',`month`.`num`,'/',`month`.`name`,'/',`month`.`long_name`) AS `_output`, 
        concat(`period`.`year`,'/',`month`.`num`) AS `_id` FROM 
        (`period` inner JOIN `month` ON `month`.`month`=`period`.`month`) ) AS `period_ext` ON `period_ext`.`_primary`=`invoice`.`period`) 
    WHERE client.code='dm008' and period.year=2017 and month.num=3;
 

SELECT `invoice`.`invoice` AS `_primary`, concat(`client`.`code`,'/',`invoice`.`valid`,'/',`period`.`year`,'/',`month`.`num`) AS `_id`, concat(`client`.`code`,'/',`client`.`full_name`,'/',`invoice`.`valid`,'/',`period`.`year`,'/',`month`.`num`,'/',`month`.`name`,'/',`month`.`long_name`) AS `_output`, `client_ext`.`_primary` AS `client_ext_primary`, `client_ext`.`_id` AS `client_ext_id`, `client_ext`.`_output` AS `client_ext_output`, `period_ext`.`_primary` AS `period_ext_primary`, `period_ext`.`_id` AS `period_ext_id`, `period_ext`.`_output` AS `period_ext_output`, `invoice`.`valid` AS `valid` FROM (((((`invoice` INNER JOIN `client` ON `client`.`client`=`invoice`.`client`) INNER JOIN `period` ON `period`.`period`=`invoice`.`period`) INNER JOIN `month` ON `month`.`month`=`period`.`month`) LEFT JOIN (SELECT `client`.`client` AS `_primary`, concat(`client`.`code`,'/',`client`.`full_name`) AS `_output`, concat(`client`.`code`) AS `_id` FROM `client` ) AS `client_ext` ON `client_ext`.`_primary`=`invoice`.`client`) LEFT JOIN (SELECT `period`.`period` AS `_primary`, concat(`period`.`year`,'/',`month`.`num`,'/',`month`.`name`,'/',`month`.`long_name`) AS `_output`, concat(`period`.`year`,'/',`month`.`num`) AS `_id` FROM (`period` INNER JOIN `month` ON `month`.`month`=`period`.`month`) ) AS `period_ext` ON `period_ext`.`_primary`=`invoice`.`period`)  
WHERE client.code='dm008' and period.year=2017
limit 40 offset 0;
   

SELECT `
    posted_item`.`posted_item` AS `_primary`, 
    concat(`source`.`title`,'/',`posted_item`.`code`) AS `_id`, 
    concat(`source`.`title`,'/',`source`.`name`,'/',`posted_item`.`code`,'/',`posted_item`.`description`) AS `_output`, 
    `invoice_ext`.`_primary` AS `invoice_ext_primary`, 
    `invoice_ext`.`_id` AS `invoice_ext_id`, 
    `invoice_ext`.`_output` AS `invoice_ext_output`, `source_ext`.`_primary` AS `source_ext_primary`, 
    `source_ext`.`_id` AS `source_ext_id`, 
    `source_ext`.`_output` AS `source_ext_output`, 
    `posted_item`.`date` AS `date`, 
    `posted_item`.`code` AS `code`, 
    `posted_item`.`description` AS `description`, 
    `posted_item`.`debit` AS `debit`, 
    `posted_item`.`credit` AS `credit` 
FROM (((`posted_item` INNER JOIN `source` ON `source`.`source`=`posted_item`.`source`) 
LEFT JOIN (SELECT 
            `invoice`.`invoice` AS `_primary`, 
            concat(`client`.`code`,'/',`client`.`full_name`,'/',`invoice`.`valid`,'/',`period`.`year`,'/',`month`.`num`,'/',`month`.`name`,'/',`month`.`long_name`) AS `_output`, 
            concat(`client`.`code`,'/',`invoice`.`valid`,'/',`period`.`year`,'/',`month`.`num`) AS `_id` 
            FROM (((`invoice` INNER JOIN `client` ON `client`.`client`=`invoice`.`client`) INNER JOIN 
                    `period` ON `period`.`period`=`invoice`.`period`) INNER JOIN 
                    `month` ON `month`.`month`=`period`.`month`) ) AS `invoice_ext` ON `invoice_ext`.`_primary`=`posted_item`.`invoice`) LEFT JOIN 
            (SELECT 
                    `source`.`source` AS `_primary`, 
                    concat(`source`.`title`,'/',`source`.`name`) AS `_output`, 
                    concat(`source`.`title`) AS `_id` FROM `source` ) AS `source_ext` ON `source_ext`.`_primary`=`posted_item`.`source`) 
        WHERE client.code='dm008' LIMIT 40 OFFSET 0;

select * from client where code like 'dm%';


SELECT 
    [attribute].[name] as attribute_name, 
    [entity].[name] as entity_name, 
    [entity].[name] as entity_name, 
    [dbase].[name] as dbase_name, 
    [dbase].[name] as dbase_name 
FROM ( ( ( (  
            [relation]  LEFT JOIN 
            [attribute] ON [relation].[attribute]=[attribute].[attribute] ) LEFT JOIN 
            [entity] ON [attribute].[entity]=[entity].[entity] ) LEFT JOIN 
            [dbase] ON [entity].[dbase]=[dbase].[dbase];


select info.tname, x.dbase 
from
    (select  table_name as tname,  table_schema as dbname from 
        information_schema.tables where table_type='base table') as info 
        left join (select entity, entity.name as tname, entity.dbase,
            dbase.name as dbname from entity inner join dbase on
            entity.dbase = dbase.dbase) as mutall 
                on mutall.tname=info.tname and mutall.dbname=info.dbname
            where isnull(mutall.tname);

SELECT mutall.attribute
FROM (select
                attribute.attribute,
                attribute.name,
                attribute.entity,
                dbase.dbase
            from( 
                attribute inner join
                entity on entity.entity=attribute.entity) inner join
                dbase on dbase.dbase=entity.dbase
            )  AS mutall LEFT JOIN (select 
                dbase.dbase,
                entity.entity,
                i.*
            from(
                information_schema.columns as i inner join
                dbase on dbase.name = table_schema) inner join
                entity on entity.name = table_name
        )  AS info ON (mutall.entity=info.entity) AND (mutall.name=info.column_name)
WHERE isnull(info.entity);

select 
                schema_name as dbname 
            from 
                information_schema.schemata
            where 
                schema_name not in ($system_dbs);

select
                entity.entity as entity,
                entity.name as tname
            from
                entity inner join 
                dbase on dbase.dbase=entity.dbase
            where
                dbase.name='mutallco_rental' and 
                not exists(
                    select * 
                    from( 
                        serialization inner join
                        entity on serialization.entity=entity.entity) inner join
                        dbase on dbase.dbase = entity.dbase
                    where
                        dbase.name='mutallco_rental'
                );

select 
    entity.name 
from( 
    serialization inner join
    entity on entity.entity = serialization.entity) inner join
    dbase on entity.dbase = dbase.dbase
where
    dbase.name="mutallco_rental";

-- all rental entities
select
    entity.entity as entity,
    entity.name as tname,
from
    entity inner join 
    dbase on dbase.dbase=entity.dbase
where
    dbase.name='mutallco_rental';

-- All serialized mutall rental entities 
    select 
        entity 
    from( 
        serialization inner join
        entity on serialization.entity=entity.entity) inner join
        dbase on dbase.dbase = entity.dbase
    where
        dbase.name='mutallco_rental';

select
   rental.entity,
   rental.tname
from
    (select
    entity.entity as entity,
    entity.name as tname
from
    entity inner join 
    dbase on dbase.dbase=entity.dbase
where
    dbase.name='mutallco_rental') as rental left join
    (select 
        entity.entity 
    from( 
        serialization inner join
        entity on serialization.entity=entity.entity) inner join
        dbase on dbase.dbase = entity.dbase
    where
        dbase.name='mutallco_rental') as serial on rental.entity=serial.entity
where serial.entity is null;


select
    wreading.wreading,
    max(previous.date)
from
    wreading inner join 
    wreading as previous on previous.wmeter=wreading.wmeter
where
    previous.date<wreading.date
group by
    wreading.wreading;






















select
               '95555' as kplc,
               emeter.account
            from
                emeter inner join
                (
            select 
                emeter.emeter,
                emeter.account as account_no, 
                emeter.no as meter_no
            from 
                emeter inner join
                (
            SELECT 
                emeter.emeter
            FROM 
                emeter LEFT JOIN 
                ( 
            SELECT DISTINCT 
                emeter.emeter
            FROM 
                emeter INNER JOIN 
                ebill ON emeter.emeter = ebill.emeter
            WHERE
                date>'2018-01-01'
        ) as emeter_available ON emeter_available.emeter = emeter.emeter
            WHERE 
                isnull(emeter_available.emeter)
        ) as emeter_unavailable on emeter_unavailable.emeter=emeter.emeter
        ) as resend inner join resend.emeter=emeter.emeter;


select emeter.account 
from 
  emeter inner join
(select 
                emeter.emeter,
                emeter.account as account_no, 
                emeter.no as meter_no
            from 
                emeter inner join
                (
            SELECT 
                emeter.emeter
            FROM 
                emeter LEFT JOIN 
                ( 
            SELECT DISTINCT 
                emeter.emeter
            FROM 
                emeter INNER JOIN 
                ebill ON emeter.emeter = ebill.emeter
            WHERE
                date>'2018-01-01'
        ) as emeter_available ON emeter_available.emeter = emeter.emeter
            WHERE 
                isnull(emeter_available.emeter)
        ) as emeter_unavailable on emeter_unavailable.emeter=emeter.emeter) as resend on ;


select
                wmeter.wmeter, 
                max(wreading.date) as `date`
            from
                wreading inner join
                wmeter on wmeter.wmeter=wreading.wmeter
            where
                wreading.date < '2018-01-01' 
            group by 
                wmeter.wmeter;



      select
                wreading.reading,
                wreading.date
            from
                wreading inner join
                (
            select
                wmeter.wmeter, 
                max(wreading.date) as `date`
            from
                wreading inner join
                wmeter on wmeter.wmeter=wreading.wmeter
            where
                wreading.date < '2018-01-01' 
            group by 
                wmeter.wmeter    
        ) as last_reading on 
                    wreading.date=last_reading.date and
                    wreading.wmeter=last_reading.wmeter;




            select
                wreading.reading,
                wreading.date
            from
                wreading inner join
                (
            select
                wmeter.wmeter, 
                max(date) as `date`
            from
                wreading inner join
                wmeter on wmeter.wmeter=wreading.wmeter
            where
                wreading.date < '2018-05-30' and
                wmeter.wmeter = 5
            group by 
                wmeter.wmeter    
        ) as last_reading on 
                    wreading.date=last_reading.date and
                    wreading.wmeter=last_reading.wmeter;


select
                wreading.date,
                wreading.reading
            from
                wreading inner join
                (
            select
                wmeter.wmeter, 
                max(wreading.date) as maxdate
            from
                wreading inner join
                wmeter on wmeter.wmeter=wreading.wmeter
            where
                wreading.date < '2018-06-04' and
                wmeter.wmeter = '5'
            group by 
                wmeter.wmeter    
        ) as last_reading on 
                    wreading.date=last_reading.maxdate and
                    wreading.wmeter=last_reading.wmeter;

delete   from wreading where wmeter is null;

select * from eaccount;

select 
   
from 
    serialization inner join
    entity on serialization.entity = entity.entity;

select
    wreading.wreading,
    max(previous.date)
from
    wreading inner join 
    wreading as previous on previous.wmeter=wreading.wmeter
where
    previous.date<wreading.date
group by
    wreading.wreading;


insert
    month
    (num)    
    values
        (1),
        (2) 
    on duplicate key update num=values(num);   

update
    reading
set
    reading.is_consumed=false;

delete
    posted_item.*
from
   posted_item; 