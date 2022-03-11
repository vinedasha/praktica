-- Table: tabl.account

-- DROP TABLE IF EXISTS tabl.account;

CREATE TABLE IF NOT EXISTS tabl.account
(
    id_acc integer NOT NULL DEFAULT nextval('tabl.account_id_acc_seq'::regclass),
    name character varying(50) COLLATE pg_catalog."default",
    familiya character varying(60) COLLATE pg_catalog."default",
    otchestvo character varying(60) COLLATE pg_catalog."default",
    password character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT account_pkey PRIMARY KEY (id_acc)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS tabl.account
    OWNER to hwtyxzqj;
    
    
    -- Table: tabl.note

-- DROP TABLE IF EXISTS tabl.note;

CREATE TABLE IF NOT EXISTS tabl.note
(
    id_note integer NOT NULL DEFAULT nextval('tabl.note_id_note_seq'::regclass),
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

ALTER TABLE IF EXISTS tabl.note
    OWNER to hwtyxzqj;
    
    
    -- Table: tabl.note_permission

-- DROP TABLE IF EXISTS tabl.note_permission;

CREATE TABLE IF NOT EXISTS tabl.note_permission
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

ALTER TABLE IF EXISTS tabl.note_permission
    OWNER to hwtyxzqj;
    
    -- Table: tabl.session

-- DROP TABLE IF EXISTS tabl.session;

CREATE TABLE IF NOT EXISTS tabl.session
(
    id_ses integer NOT NULL DEFAULT nextval('tabl.session_id_ses_seq'::regclass),
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

ALTER TABLE IF EXISTS tabl.session
    OWNER to hwtyxzqj;
    
    
    -- Table: tabl.session_note

-- DROP TABLE IF EXISTS tabl.session_note;

CREATE TABLE IF NOT EXISTS tabl.session_note
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

ALTER TABLE IF EXISTS tabl.session_note
    OWNER to hwtyxzqj;
    
    
    alter table tabl.session ADD CONSTRAINT sesacc FOREIGN KEY (id_acc) references tabl.account(id_acc) ON DELETE CASCADE;

alter table tabl.session_note ADD CONSTRAINT sesnote FOREIGN KEY (id_note) references tabl.note(id_note) ON DELETE CASCADE;

alter table tabl.session_note ADD CONSTRAINT sesnote2 FOREIGN KEY (id_ses) references tabl.session(id_ses) ON DELETE CASCADE;

alter table tabl.note ADD CONSTRAINT noteacc FOREIGN KEY (id_acc) references tabl.account(id_acc) ON DELETE CASCADE;

alter table tabl.note_permission ADD CONSTRAINT noteperm FOREIGN KEY (id_acc) references tabl.account(id_acc) ON DELETE CASCADE;

alter table tabl.note_permission ADD CONSTRAINT noteperm2 FOREIGN KEY (id_dependet_user) references tabl.account(id_acc) ON DELETE CASCADE;

alter table tabl.note_permission ADD CONSTRAINT notepermnote FOREIGN KEY (id_note) references tabl.note(id_note) ON DELETE CASCADE;
