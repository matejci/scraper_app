--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: image_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE image_items (
    id integer NOT NULL,
    source character varying,
    source_url character varying,
    name character varying,
    description text,
    category character varying,
    item_type character varying,
    item_sub_type character varying,
    manufacturer character varying,
    is_scraped boolean DEFAULT false,
    is_downloaded boolean DEFAULT false,
    tags hstore,
    image_url character varying,
    image_path character varying,
    s3_image_url character varying,
    keywords hstore,
    sim_hashes hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: image_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE image_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: image_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE image_items_id_seq OWNED BY image_items.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE items (
    id integer NOT NULL,
    source character varying,
    source_url character varying,
    name character varying,
    description text,
    category character varying,
    item_type character varying,
    item_sub_type character varying,
    manufacturer character varying,
    is_scraped boolean DEFAULT false,
    is_downloaded boolean DEFAULT false,
    tags hstore,
    image_urls hstore,
    image_paths hstore,
    s3_image_urls hstore,
    keywords hstore,
    sim_hashes hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_url character varying,
    s3_image_url character varying
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY image_items ALTER COLUMN id SET DEFAULT nextval('image_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- Name: image_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY image_items
    ADD CONSTRAINT image_items_pkey PRIMARY KEY (id);


--
-- Name: items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: index_image_items_on_image_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_image_items_on_image_path ON image_items USING btree (image_path);


--
-- Name: index_image_items_on_image_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_image_items_on_image_url ON image_items USING btree (image_url);


--
-- Name: index_image_items_on_keywords; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_image_items_on_keywords ON image_items USING gin (keywords);


--
-- Name: index_image_items_on_s3_image_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_image_items_on_s3_image_url ON image_items USING btree (s3_image_url);


--
-- Name: index_image_items_on_sim_hashes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_image_items_on_sim_hashes ON image_items USING gin (sim_hashes);


--
-- Name: index_image_items_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_image_items_on_tags ON image_items USING gin (tags);


--
-- Name: index_items_on_image_paths; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_image_paths ON items USING gin (image_paths);


--
-- Name: index_items_on_image_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_image_url ON items USING btree (image_url);


--
-- Name: index_items_on_image_urls; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_image_urls ON items USING gin (image_urls);


--
-- Name: index_items_on_keywords; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_keywords ON items USING gin (keywords);


--
-- Name: index_items_on_s3_image_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_s3_image_url ON items USING btree (s3_image_url);


--
-- Name: index_items_on_s3_image_urls; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_s3_image_urls ON items USING gin (s3_image_urls);


--
-- Name: index_items_on_sim_hashes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_sim_hashes ON items USING gin (sim_hashes);


--
-- Name: index_items_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_tags ON items USING gin (tags);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20161001155342');

INSERT INTO schema_migrations (version) VALUES ('20161002122955');

INSERT INTO schema_migrations (version) VALUES ('20161002135532');

INSERT INTO schema_migrations (version) VALUES ('20170114010514');

INSERT INTO schema_migrations (version) VALUES ('20170114010630');

INSERT INTO schema_migrations (version) VALUES ('20170131102218');

INSERT INTO schema_migrations (version) VALUES ('20170131103620');

