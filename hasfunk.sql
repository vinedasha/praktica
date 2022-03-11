CREATE
OR REPLACE FUNCTION hasura.createaccount(
  nam character varying,
  familiy character varying,
  otchestv character varying,
  passwor character varying
) RETURNS SETOF hasura.account LANGUAGE plpgsql AS $ function $ declare id_u int;
begin
insert into
  tabl.account(name, familiya, otchestvo, password)
values
  (nam, familiy, otchestv, passwor) returning id_acc into id_u;
return query (
    select
      *
    from
      tabl.account
    where
      id = id_u
  );
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.createnote(
  acc_id integer,
  headingn character varying,
  textn character varying,
  imgn bytea
) RETURNS SETOF hasura.note LANGUAGE plpgsql AS $ function $ declare datatimen timestamp;
id_noten int;
id_sessn int;
begin
SELECT
  NOW() :: timestamp into datatimen;
insert into
  tabl.note(id_acc, heading, text, img, date)
values
  (acc_id, headingn, textn, imgn, datatimen) returning id_note into id_noteN;
select
  id_ses
from
  tabl.session
where
  id_acc = acc_id
  and time_end is null
limit
  1 into id_sessn;
insert into
  tabl.session_note
values(id_sessn, id_noten);
insert into
  tabl.note_permission
values(acc_id, acc_id, id_noten, 'owner');
return query (
    select
      *
    from
      tabl.note
    where
      id_note = id_noten
  );
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.ddeleteaccount(id_account integer) RETURNS SETOF hasura.account LANGUAGE plpgsql AS $ function $ declare begin
delete from
  tabl.account
where
  id_acc = id_account;
return query (
    select
      *
    from
      tabl.naccount
    where
      id_acc = id_account
  );
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.ddeletenote(id_accn integer, id_noten integer) RETURNS SETOF hasura.note LANGUAGE plpgsql AS $ function $ declare id_session int;
datatimen timestamp;
permissions varchar(64);
begin
select
  permission
from
  tabl.note_permission
where
  id_acc = id_accn
  and id_note = id_noten into permissions;
if(
    permissions = 'owner'
    or permissions = 'editor'
  ) then
SELECT
  NOW() :: timestamp into datatimen;
select
  id_ses
from
  tabl.session
where
  id_acc = id_accn
  and time_end is null
limit
  1 into id_session;
delete from
  tabl.note
where
  id_note = id_noten;
end if;
return query (
  select
    *
  from
    tabl.note
  where
    id_note = id_noten
);
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.endsess(id_session integer) RETURNS SETOF hasura.session LANGUAGE plpgsql AS $ function $ declare datatimeE timestamp;
id_acc int;
begin
SELECT
  NOW() :: timestamp into datatimeE;
update
  tabl.session
set
  time_end = datatimeE
where
  id_ses = id_session;
return query (
    select
      *
    from
      tabl.session
    where
      id_ses = id_session
  );
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.selectheadingperm() RETURNS SETOF hasura.selecthp LANGUAGE plpgsql AS $ function $ declare begin return query(
  SELECT
    tabl.note_permission.id_note,
    tabl.note.heading,
    tabl.note_permission.permission
  FROM
    tabl.note_permission,
    tabl.note
  WHERE
    tabl.note_permission.id_note = tabl.note.id_note
);
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.selectnotetext(id_n integer) RETURNS SETOF hasura.selectnoxt LANGUAGE plpgsql AS $ function $ declare begin return query(
  SELECT
    tabl.note.id_note,
    tabl.note.text
  FROM
    tabl.note
  WHERE
    tabl.note.id_note = id_n
);
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.selectoffses() RETURNS SETOF hasura.selectoffsess LANGUAGE plpgsql AS $ function $ declare begin return query(
  SELECT
    tabl.session.id_ses,
    tabl.session.id_acc,
    tabl.session.token,
    tabl.session.time_start,
    tabl.session.time_end
  FROM
    tabl.session
  WHERE
    tabl.session.time_end is NOT NULL
);
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.selectonses() RETURNS SETOF hasura.selectonsess LANGUAGE plpgsql AS $ function $ declare begin return query(
  SELECT
    tabl.session.id_ses,
    tabl.session.id_acc,
    tabl.session.token,
    tabl.session.time_start,
    tabl.session.time_end
  FROM
    tabl.session
  WHERE
    tabl.session.time_end is NULL
);
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.selecuserperm() RETURNS SETOF hasura.selecusperm LANGUAGE plpgsql AS $ function $ declare begin return query(
  SELECT
    tabl.account.id_acc,
    tabl.account.name,
    tabl.note_permission.permission
  FROM
    tabl.account,
    tabl.note_permission
  WHERE
    tabl.account.id_acc = tabl.note_permission.id_acc
);
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.strartsess(id_account integer, passwd character varying) RETURNS SETOF hasura.session LANGUAGE plpgsql AS $ function $ declare datatimeB timestamp;
begin if(
  passwd = (
    select
      password
    from
      tabl.account
    where
      id_acc = id_account
  )
) then
SELECT
  NOW() :: timestamp into datatimeB;
insert into
  tabl.session(id_acc, token, time_start, time_end)
values
  (id_account, uuid_generate_v4(), datatimeB, NULL);
end if;
return query (
  select
    *
  from
    tabl.session
);
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.updateaccountfioo(
  id_account integer,
  namen character varying,
  familiyan character varying,
  otchestvon character varying
) RETURNS SETOF hasura.account LANGUAGE plpgsql AS $ function $ declare begin
update
  tabl.account
set
  name = namen,
  familiya = familiyan,
  otchestvo = otchestvon
where
  id_acc = id_account;
return query (
    select
      *
    from
      tabl.account
    where
      id_acc = id_account
  );
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.updateaccountpas(id_account integer, passwordn character varying) RETURNS SETOF hasura.account LANGUAGE plpgsql AS $ function $ declare begin
update
  tabl.account
set
  password = passwordN
where
  id_acc = id_account;
return query (
    select
      *
    from
      tabl.account
    where
      id_acc = id_account
  );
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.updateaccountpas(id_account integer, passwordn character varying) RETURNS SETOF hasura.account LANGUAGE plpgsql AS $ function $ declare begin
update
  tabl.account
set
  password = passwordN
where
  id_acc = id_account;
return query (
    select
      *
    from
      tabl.account
    where
      id_acc = id_account
  );
end;
$ function $


CREATE
OR REPLACE FUNCTION hasura.uupdatenotetext(
  id_accn integer,
  id_noten integer,
  textn character varying,
  imgn bytea
) RETURNS SETOF hasura.note LANGUAGE plpgsql AS $ function $ declare datatimen timestamp;
permissions varchar(64);
id_session int;
begin
select
  permission
from
  tabl.note_permission
where
  id_acc = id_accn
  and id_note = id_noten into permissions;
if(
    permissions = 'owner'
    or permissions = 'editor'
  ) then
SELECT
  NOW() :: timestamp into datatimen;
Update
  tabl.note
set
  text = textn,
  img = imgn
where
  id_note = id_noten;
select
  id_ses
from
  tabl.session
where
  id_acc = id_accn
  and time_end is null
limit
  1 into id_session;
end if;
return query (
  select
    *
  from
    tabl.note
  where
    id_note = id_noten
);
end;
$ function $
