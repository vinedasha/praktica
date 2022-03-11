-- Table: hasura.account

-- DROP TABLE IF EXISTS hasura.account;

CREATE TABLE IF NOT EXISTS hasura.account
(
    id_acc integer NOT NULL DEFAULT nextval('tabl.account_id_acc_seq'::regclass),
    name character varying(50) COLLATE pg_catalog."default",
    familiya character varying(60) COLLATE pg_catalog."default",
    otchestvo character varying(60) COLLATE pg_catalog."default",
    password character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT account_pkey PRIMARY KEY (id_acc)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.account
    OWNER to hwtyxzqj;
    
    -- Table: hasura.note

-- DROP TABLE IF EXISTS hasura.note;

CREATE TABLE IF NOT EXISTS hasura.note
(
    id_note integer NOT NULL,
    id_acc integer NOT NULL,
    heading character varying(100) COLLATE pg_catalog."default",
    text character varying(600) COLLATE pg_catalog."default",
    img bytea,
    date timestamp without time zone,
    CONSTRAINT note_pkey PRIMARY KEY (id_note),
    CONSTRAINT noteacc FOREIGN KEY (id_acc)
        REFERENCES tabl.account (id_acc) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.note
    OWNER to hwtyxzqj;
    
    -- Table: hasura.note_permission

-- DROP TABLE IF EXISTS hasura.note_permission;

CREATE TABLE IF NOT EXISTS hasura.note_permission
(
    id_acc integer,
    id_dependet_user integer,
    id_note integer,
    permission character varying(64) COLLATE pg_catalog."default",
    CONSTRAINT noteperm FOREIGN KEY (id_acc)
        REFERENCES tabl.account (id_acc) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT noteperm2 FOREIGN KEY (id_dependet_user)
        REFERENCES tabl.account (id_acc) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT notepermnote FOREIGN KEY (id_note)
        REFERENCES tabl.note (id_note) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.note_permission
    OWNER to hwtyxzqj;
    
    
    -- Table: hasura.selecthp

-- DROP TABLE IF EXISTS hasura.selecthp;

CREATE TABLE IF NOT EXISTS hasura.selecthp
(
    id_note integer,
    heading character varying COLLATE pg_catalog."default",
    permision character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.selecthp
    OWNER to hwtyxzqj;
    
    
    -- Table: hasura.selectnoxt

-- DROP TABLE IF EXISTS hasura.selectnoxt;

CREATE TABLE IF NOT EXISTS hasura.selectnoxt
(
    id_note integer,
    text character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.selectnoxt
    OWNER to hwtyxzqj;
    
    
    -- Table: hasura.selectoffsess

-- DROP TABLE IF EXISTS hasura.selectoffsess;

CREATE TABLE IF NOT EXISTS hasura.selectoffsess
(
    id_ses integer,
    id_acc integer,
    token character varying COLLATE pg_catalog."default",
    time_start timestamp without time zone,
    time_end timestamp without time zone
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.selectoffsess
    OWNER to hwtyxzqj;
    
    
    
    -- Table: hasura.selectonsess

-- DROP TABLE IF EXISTS hasura.selectonsess;

CREATE TABLE IF NOT EXISTS hasura.selectonsess
(
    id_ses integer,
    id_acc integer,
    token character varying COLLATE pg_catalog."default",
    time_start timestamp without time zone,
    time_end timestamp without time zone
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.selectonsess
    OWNER to hwtyxzqj;
    
    
    -- Table: hasura.selecusperm

-- DROP TABLE IF EXISTS hasura.selecusperm;

CREATE TABLE IF NOT EXISTS hasura.selecusperm
(
    id_acc integer,
    name character varying COLLATE pg_catalog."default",
    permission character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.selecusperm
    OWNER to hwtyxzqj;
    
    
    -- Table: hasura.session

-- DROP TABLE IF EXISTS hasura.session;

CREATE TABLE IF NOT EXISTS hasura.session
(
    id_ses integer NOT NULL,
    id_acc integer NOT NULL,
    token character varying(256) COLLATE pg_catalog."default",
    time_start timestamp without time zone,
    time_end timestamp without time zone,
    CONSTRAINT session_pkey PRIMARY KEY (id_ses),
    CONSTRAINT sesacc FOREIGN KEY (id_acc)
        REFERENCES tabl.account (id_acc) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.session
    OWNER to hwtyxzqj;
    
    
    -- Table: hasura.session_note

-- DROP TABLE IF EXISTS hasura.session_note;

CREATE TABLE IF NOT EXISTS hasura.session_note
(
    id_ses integer NOT NULL,
    id_note integer NOT NULL,
    CONSTRAINT sesnote FOREIGN KEY (id_note)
        REFERENCES tabl.note (id_note) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT sesnote2 FOREIGN KEY (id_ses)
        REFERENCES tabl.session (id_ses) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hasura.session_note
    OWNER to hwtyxzqj;
    
    
    
alter table hasura.session ADD CONSTRAINT sesacc FOREIGN KEY (id_acc) references tabl.account(id_acc) ON DELETE CASCADE;

alter table hasura.session_note ADD CONSTRAINT sesnote FOREIGN KEY (id_note) references tabl.note(id_note) ON DELETE CASCADE;

alter table hasura.session_note ADD CONSTRAINT sesnote2 FOREIGN KEY (id_ses) references tabl.session(id_ses) ON DELETE CASCADE;

alter table hasura.note ADD CONSTRAINT noteacc FOREIGN KEY (id_acc) references tabl.account(id_acc) ON DELETE CASCADE;

alter table hasura.note_permission ADD CONSTRAINT noteperm FOREIGN KEY (id_acc) references tabl.account(id_acc) ON DELETE CASCADE;

alter table hasura.note_permission ADD CONSTRAINT noteperm2 FOREIGN KEY (id_dependet_user) references tabl.account(id_acc) ON DELETE CASCADE;

alter table hasura.note_permission ADD CONSTRAINT notepermnote FOREIGN KEY (id_note) references tabl.note(id_note) ON DELETE CASCADE;
