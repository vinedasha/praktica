-- FUNCTION: funk.createaccountu(character varying, character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS funk.createaccountu(character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION funk.createaccountu(
	nam character varying,
	familiy character varying,
	otchestv character varying,
	passwor character varying)
    RETURNS TABLE(namen character varying, familiyan character varying, otchestvon character varying, passwordn character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
id_u int;
begin
insert into tabl.account(name, familiya, otchestvo, password) values
(nam, familiy, otchestv, passwor) returning id_acc into id_u;
end;
$BODY$;

ALTER FUNCTION funk.createaccountu(character varying, character varying, character varying, character varying)
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.createnote(integer, character varying, character varying, bytea)

-- DROP FUNCTION IF EXISTS funk.createnote(integer, character varying, character varying, bytea);

CREATE OR REPLACE FUNCTION funk.createnote(
	acc_id integer,
	headingn character varying,
	textn character varying,
	imgn bytea)
    RETURNS TABLE(text character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
datatimen timestamp;
id_noten int;
id_sessn int;
begin
SELECT NOW()::timestamp into datatimen;
insert into tabl.note(id_acc,  heading,  text, img, date) values
(acc_id, headingn, textn, imgn, datatimen) returning id_note into id_noteN;
select id_ses from tabl.session where id_acc = acc_id and time_end is null limit 1 into id_sessn;
insert into tabl.session_note values(id_sessn, id_noten);
insert into tabl.note_permission values(acc_id, acc_id, id_noten,'owner');
end;
$BODY$;

ALTER FUNCTION funk.createnote(integer, character varying, character varying, bytea)
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.ddeleteaccount(integer)

-- DROP FUNCTION IF EXISTS funk.ddeleteaccount(integer);

CREATE OR REPLACE FUNCTION funk.ddeleteaccount(
	id_account integer)
    RETURNS TABLE(name character varying, familiya character varying, otchestvo character varying, password character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
begin
delete from tabl.account where id_acc = id_account;
end;
$BODY$;

ALTER FUNCTION funk.ddeleteaccount(integer)
    OWNER TO hwtyxzqj;


-- FUNCTION: funk.ddeletenote(integer, integer)

-- DROP FUNCTION IF EXISTS funk.ddeletenote(integer, integer);

CREATE OR REPLACE FUNCTION funk.ddeletenote(
	id_accn integer,
	id_noten integer)
    RETURNS TABLE(text character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
id_session int;
datatimen timestamp;
permissions varchar(64);
begin
select permission from tabl.note_permission where id_acc = id_accn and id_note = id_noten into permissions;
if(permissions = 'owner' or permissions = 'editor')
then
SELECT NOW()::timestamp into datatimen;
select id_ses from tabl.session where id_acc = id_accn and time_end is null limit 1 into id_session;
delete from tabl.note where id_note = id_noten;
end if;
end;
$BODY$;

ALTER FUNCTION funk.ddeletenote(integer, integer)
    OWNER TO hwtyxzqj;


-- FUNCTION: funk.endsess(integer)

-- DROP FUNCTION IF EXISTS funk.endsess(integer);

CREATE OR REPLACE FUNCTION funk.endsess(
	id_session integer)
    RETURNS TABLE(token character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
datatimeE timestamp;
id_acc int;
begin
SELECT NOW()::timestamp into datatimeE;
update tabl.session set time_end = datatimeE where id_ses = id_session;
end;
$BODY$;

ALTER FUNCTION funk.endsess(integer)
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.selectheadingperm()

-- DROP FUNCTION IF EXISTS funk.selectheadingperm();

CREATE OR REPLACE FUNCTION funk.selectheadingperm(
	)
    RETURNS TABLE(id_note integer, heading character varying, permision character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
begin
return query(
SELECT tabl.note_permission.id_note, tabl.note.heading, tabl.note_permission.permission 
FROM tabl.note_permission, tabl.note
WHERE tabl.note_permission.id_note = tabl.note.id_note);
end;
$BODY$;

ALTER FUNCTION funk.selectheadingperm()
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.selectnotetext(integer)

-- DROP FUNCTION IF EXISTS funk.selectnotetext(integer);

CREATE OR REPLACE FUNCTION funk.selectnotetext(
	id_n integer)
    RETURNS TABLE(id_note integer, text character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
begin
return query(
SELECT tabl.note.id_note, tabl.note.text
FROM tabl.note
WHERE tabl.note.id_note = id_n);
end;
$BODY$;

ALTER FUNCTION funk.selectnotetext(integer)
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.selectoffses()

-- DROP FUNCTION IF EXISTS funk.selectoffses();

CREATE OR REPLACE FUNCTION funk.selectoffses(
	)
    RETURNS TABLE(id_ses integer, id_acc integer, token character varying, time_start timestamp without time zone, time_end timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
begin
return query(
SELECT tabl.session.id_ses, tabl.session.id_acc, tabl.session.token,  tabl.session.time_start, tabl.session.time_end
FROM tabl.session
WHERE tabl.session.time_end is NOT NULL);
end;
$BODY$;

ALTER FUNCTION funk.selectoffses()
    OWNER TO hwtyxzqj;


-- FUNCTION: funk.selectonses()

-- DROP FUNCTION IF EXISTS funk.selectonses();

CREATE OR REPLACE FUNCTION funk.selectonses(
	)
    RETURNS TABLE(id_ses integer, id_acc integer, token character varying, time_start timestamp without time zone, time_end timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
begin
return query(
SELECT tabl.session.id_ses, tabl.session.id_acc, tabl.session.token,  tabl.session.time_start, tabl.session.time_end
FROM tabl.session
WHERE tabl.session.time_end is NULL);
end;
$BODY$;

ALTER FUNCTION funk.selectonses()
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.selecuserperm()

-- DROP FUNCTION IF EXISTS funk.selecuserperm();

CREATE OR REPLACE FUNCTION funk.selecuserperm(
	)
    RETURNS TABLE(id_acc integer, name character varying, permission character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
begin
return query(
SELECT tabl.account.id_acc, tabl.account.name, tabl.note_permission.permission
FROM tabl.account, tabl.note_permission
WHERE tabl.account.id_acc = tabl.note_permission.id_acc);
end;
$BODY$;

ALTER FUNCTION funk.selecuserperm()
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.strartsess(integer, character varying)

-- DROP FUNCTION IF EXISTS funk.strartsess(integer, character varying);

CREATE OR REPLACE FUNCTION funk.strartsess(
	id_account integer,
	passwd character varying)
    RETURNS TABLE(token character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
datatimeB timestamp;
begin
if(passwd = (select password from tabl.account where id_acc = id_account))
then
SELECT NOW()::timestamp into datatimeB;
insert into tabl.session(id_acc, token, time_start, time_end) values
(id_account ,uuid_generate_v4(),datatimeB, NULL);
end if;
end;
$BODY$;

ALTER FUNCTION funk.strartsess(integer, character varying)
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.updateaccountfioo(integer, character varying, character varying, character varying)

-- DROP FUNCTION IF EXISTS funk.updateaccountfioo(integer, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION funk.updateaccountfioo(
	id_account integer,
	namen character varying,
	familiyan character varying,
	otchestvon character varying)
    RETURNS TABLE(name character varying, familiya character varying, otchestvo character varying, password character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
begin
update tabl.account set name = namen, familiya = familiyan, otchestvo = otchestvon
where id_acc = id_account;
end;
$BODY$;

ALTER FUNCTION funk.updateaccountfioo(integer, character varying, character varying, character varying)
    OWNER TO hwtyxzqj;


-- FUNCTION: funk.updateaccountpas(integer, character varying)

-- DROP FUNCTION IF EXISTS funk.updateaccountpas(integer, character varying);

CREATE OR REPLACE FUNCTION funk.updateaccountpas(
	id_account integer,
	passwordn character varying)
    RETURNS TABLE(name character varying, familiya character varying, otchestvo character varying, password character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
begin
update tabl.account set password = passwordN where id_acc = id_account;
end;
$BODY$;

ALTER FUNCTION funk.updateaccountpas(integer, character varying)
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.uupdatenotehead(integer, integer, character varying)

-- DROP FUNCTION IF EXISTS funk.uupdatenotehead(integer, integer, character varying);

CREATE OR REPLACE FUNCTION funk.uupdatenotehead(
	id_accn integer,
	id_noten integer,
	headingn character varying)
    RETURNS TABLE(text character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
datatimen timestamp;
permissions varchar(64);
id_session int;
begin
select permission from tabl.note_permission where id_acc = id_accn and id_note = id_noten into permissions;
if(permissions = 'owner' or permissions = 'editor')
then
SELECT NOW()::timestamp into datatimen;
Update tabl.note set heading = headingn where id_note = id_noten;
select id_ses from tabl.session where id_acc = id_accn and time_end is null limit 1 into id_session;
end if;
end;
$BODY$;

ALTER FUNCTION funk.uupdatenotehead(integer, integer, character varying)
    OWNER TO hwtyxzqj;



-- FUNCTION: funk.uupdatenotetext(integer, integer, character varying, bytea)

-- DROP FUNCTION IF EXISTS funk.uupdatenotetext(integer, integer, character varying, bytea);

CREATE OR REPLACE FUNCTION funk.uupdatenotetext(
	id_accn integer,
	id_noten integer,
	textn character varying,
	imgn bytea)
    RETURNS TABLE(text character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare
datatimen timestamp;
permissions varchar(64);
id_session int;
begin
select permission from tabl.note_permission where id_acc = id_accn and id_note = id_noten into permissions;
if(permissions = 'owner' or permissions = 'editor')
then
SELECT NOW()::timestamp into datatimen;
Update tabl.note set text = textn, img = imgn where id_note = id_noten;
select id_ses from tabl.session where id_acc = id_accn and time_end is null limit 1 into id_session;
end if;
end;
$BODY$;

ALTER FUNCTION funk.uupdatenotetext(integer, integer, character varying, bytea)
    OWNER TO hwtyxzqj;
