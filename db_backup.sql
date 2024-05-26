--
-- PostgreSQL database dump
--

-- Dumped from database version 13.8 (Debian 13.8-1.pgdg110+1)
-- Dumped by pg_dump version 13.8 (Debian 13.8-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: directus
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO directus;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: directus
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO directus;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: directus
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO directus;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: directus
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.categories (
    id uuid NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE public.categories OWNER TO directus;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.comments (
    id uuid NOT NULL,
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    comment text,
    user_id uuid,
    comment_id uuid
);


ALTER TABLE public.comments OWNER TO directus;

--
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_activity (
    id integer NOT NULL,
    action character varying(45) NOT NULL,
    "user" uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip character varying(50),
    user_agent character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    comment text,
    origin character varying(255)
);


ALTER TABLE public.directus_activity OWNER TO directus;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_activity_id_seq OWNER TO directus;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_collections (
    collection character varying(64) NOT NULL,
    icon character varying(30),
    note text,
    display_template character varying(255),
    hidden boolean DEFAULT false NOT NULL,
    singleton boolean DEFAULT false NOT NULL,
    translations json,
    archive_field character varying(64),
    archive_app_filter boolean DEFAULT true NOT NULL,
    archive_value character varying(255),
    unarchive_value character varying(255),
    sort_field character varying(64),
    accountability character varying(255) DEFAULT 'all'::character varying,
    color character varying(255),
    item_duplication_fields json,
    sort integer,
    "group" character varying(64),
    collapse character varying(255) DEFAULT 'open'::character varying NOT NULL,
    preview_url character varying(255),
    versioning boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_collections OWNER TO directus;

--
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_dashboards (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(30) DEFAULT 'dashboard'::character varying NOT NULL,
    note text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    color character varying(255)
);


ALTER TABLE public.directus_dashboards OWNER TO directus;

--
-- Name: directus_extensions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_extensions (
    name character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.directus_extensions OWNER TO directus;

--
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_fields (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    field character varying(64) NOT NULL,
    special character varying(64),
    interface character varying(64),
    options json,
    display character varying(64),
    display_options json,
    readonly boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    sort integer,
    width character varying(30) DEFAULT 'full'::character varying,
    translations json,
    note text,
    conditions json,
    required boolean DEFAULT false,
    "group" character varying(64),
    validation json,
    validation_message text
);


ALTER TABLE public.directus_fields OWNER TO directus;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_fields_id_seq OWNER TO directus;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- Name: directus_files; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_files (
    id uuid NOT NULL,
    storage character varying(255) NOT NULL,
    filename_disk character varying(255),
    filename_download character varying(255) NOT NULL,
    title character varying(255),
    type character varying(255),
    folder uuid,
    uploaded_by uuid,
    uploaded_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by uuid,
    modified_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    charset character varying(50),
    filesize bigint,
    width integer,
    height integer,
    duration integer,
    embed character varying(200),
    description text,
    location text,
    tags text,
    metadata json,
    focal_point_x integer,
    focal_point_y integer
);


ALTER TABLE public.directus_files OWNER TO directus;

--
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_flows (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(30),
    color character varying(255),
    description text,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    trigger character varying(255),
    accountability character varying(255) DEFAULT 'all'::character varying,
    options json,
    operation uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_flows OWNER TO directus;

--
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);


ALTER TABLE public.directus_folders OWNER TO directus;

--
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.directus_migrations OWNER TO directus;

--
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);


ALTER TABLE public.directus_notifications OWNER TO directus;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_notifications_id_seq OWNER TO directus;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_operations (
    id uuid NOT NULL,
    name character varying(255),
    key character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    options json,
    resolve uuid,
    reject uuid,
    flow uuid NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_operations OWNER TO directus;

--
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_panels (
    id uuid NOT NULL,
    dashboard uuid NOT NULL,
    name character varying(255),
    icon character varying(30) DEFAULT NULL::character varying,
    color character varying(10),
    show_header boolean DEFAULT false NOT NULL,
    note text,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    options json,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_panels OWNER TO directus;

--
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_permissions (
    id integer NOT NULL,
    role uuid,
    collection character varying(64) NOT NULL,
    action character varying(10) NOT NULL,
    permissions json,
    validation json,
    presets json,
    fields text
);


ALTER TABLE public.directus_permissions OWNER TO directus;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_permissions_id_seq OWNER TO directus;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_presets (
    id integer NOT NULL,
    bookmark character varying(255),
    "user" uuid,
    role uuid,
    collection character varying(64),
    search character varying(100),
    layout character varying(100) DEFAULT 'tabular'::character varying,
    layout_query json,
    layout_options json,
    refresh_interval integer,
    filter json,
    icon character varying(30) DEFAULT 'bookmark'::character varying,
    color character varying(255)
);


ALTER TABLE public.directus_presets OWNER TO directus;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_presets_id_seq OWNER TO directus;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_relations (
    id integer NOT NULL,
    many_collection character varying(64) NOT NULL,
    many_field character varying(64) NOT NULL,
    one_collection character varying(64),
    one_field character varying(64),
    one_collection_field character varying(64),
    one_allowed_collections text,
    junction_field character varying(64),
    sort_field character varying(64),
    one_deselect_action character varying(255) DEFAULT 'nullify'::character varying NOT NULL
);


ALTER TABLE public.directus_relations OWNER TO directus;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_relations_id_seq OWNER TO directus;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_revisions (
    id integer NOT NULL,
    activity integer NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    data json,
    delta json,
    parent integer,
    version uuid
);


ALTER TABLE public.directus_revisions OWNER TO directus;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_revisions_id_seq OWNER TO directus;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_roles (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(30) DEFAULT 'supervised_user_circle'::character varying NOT NULL,
    description text,
    ip_access text,
    enforce_tfa boolean DEFAULT false NOT NULL,
    admin_access boolean DEFAULT false NOT NULL,
    app_access boolean DEFAULT true NOT NULL
);


ALTER TABLE public.directus_roles OWNER TO directus;

--
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_sessions (
    token character varying(64) NOT NULL,
    "user" uuid,
    expires timestamp with time zone NOT NULL,
    ip character varying(255),
    user_agent character varying(255),
    share uuid,
    origin character varying(255)
);


ALTER TABLE public.directus_sessions OWNER TO directus;

--
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_settings (
    id integer NOT NULL,
    project_name character varying(100) DEFAULT 'Directus'::character varying NOT NULL,
    project_url character varying(255),
    project_color character varying(255) DEFAULT '#6644FF'::character varying NOT NULL,
    project_logo uuid,
    public_foreground uuid,
    public_background uuid,
    public_note text,
    auth_login_attempts integer DEFAULT 25,
    auth_password_policy character varying(100),
    storage_asset_transform character varying(7) DEFAULT 'all'::character varying,
    storage_asset_presets json,
    custom_css text,
    storage_default_folder uuid,
    basemaps json,
    mapbox_key character varying(255),
    module_bar json,
    project_descriptor character varying(100),
    default_language character varying(255) DEFAULT 'en-US'::character varying NOT NULL,
    custom_aspect_ratios json,
    public_favicon uuid,
    default_appearance character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    default_theme_light character varying(255),
    theme_light_overrides json,
    default_theme_dark character varying(255),
    theme_dark_overrides json
);


ALTER TABLE public.directus_settings OWNER TO directus;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_settings_id_seq OWNER TO directus;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_shares (
    id uuid NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    role uuid,
    password character varying(255),
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_start timestamp with time zone,
    date_end timestamp with time zone,
    times_used integer DEFAULT 0,
    max_uses integer
);


ALTER TABLE public.directus_shares OWNER TO directus;

--
-- Name: directus_translations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_translations (
    id uuid NOT NULL,
    language character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.directus_translations OWNER TO directus;

--
-- Name: directus_users; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_users (
    id uuid NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(128),
    password character varying(255),
    location character varying(255),
    title character varying(50),
    description text,
    tags json,
    avatar uuid,
    language character varying(255) DEFAULT NULL::character varying,
    tfa_secret character varying(255),
    status character varying(16) DEFAULT 'active'::character varying NOT NULL,
    role uuid,
    token character varying(255),
    last_access timestamp with time zone,
    last_page character varying(255),
    provider character varying(128) DEFAULT 'default'::character varying NOT NULL,
    external_identifier character varying(255),
    auth_data json,
    email_notifications boolean DEFAULT true,
    appearance character varying(255),
    theme_dark character varying(255),
    theme_light character varying(255),
    theme_light_overrides json,
    theme_dark_overrides json,
    username character varying(255),
    birth_date date,
    phone_number character varying(15),
    town character varying(15),
    municipality character varying(15),
    street character varying(25) DEFAULT NULL::character varying,
    zip_code character varying(15),
    twitter character varying(255),
    facebook character varying(255),
    youtube character varying(255),
    instagram character varying(255),
    tiktok character varying(255),
    reputation integer DEFAULT 0,
    user_id uuid
);


ALTER TABLE public.directus_users OWNER TO directus;

--
-- Name: directus_versions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_versions (
    id uuid NOT NULL,
    key character varying(64) NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    hash character varying(255),
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.directus_versions OWNER TO directus;

--
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.directus_webhooks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    method character varying(10) DEFAULT 'POST'::character varying NOT NULL,
    url character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'active'::character varying NOT NULL,
    data boolean DEFAULT true NOT NULL,
    actions character varying(100) NOT NULL,
    collections character varying(255) NOT NULL,
    headers json
);


ALTER TABLE public.directus_webhooks OWNER TO directus;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_webhooks_id_seq OWNER TO directus;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_webhooks_id_seq OWNED BY public.directus_webhooks.id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.ingredients (
    id uuid NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.ingredients OWNER TO directus;

--
-- Name: macronutrients; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.macronutrients (
    id uuid NOT NULL,
    name character varying(30),
    macronutrient_id uuid,
    quantity real
);


ALTER TABLE public.macronutrients OWNER TO directus;

--
-- Name: rating_comments; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.rating_comments (
    id uuid NOT NULL,
    user_id uuid,
    valuation boolean DEFAULT false,
    rating_comment_id uuid
);


ALTER TABLE public.rating_comments OWNER TO directus;

--
-- Name: rating_recipes; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.rating_recipes (
    id uuid NOT NULL,
    rating_recipes_id uuid NOT NULL,
    user_id uuid NOT NULL,
    valuation boolean NOT NULL
);


ALTER TABLE public.rating_recipes OWNER TO directus;

--
-- Name: recipes; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.recipes (
    id uuid NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    title character varying(255),
    description text,
    video character varying(255),
    difficulty character varying(255),
    preparation_time integer,
    calories integer,
    cooking_time integer,
    portion_numbers integer,
    api_inserted boolean DEFAULT false
);


ALTER TABLE public.recipes OWNER TO directus;

--
-- Name: recipes_categories; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.recipes_categories (
    id integer NOT NULL,
    recipes_id uuid,
    categories_id uuid
);


ALTER TABLE public.recipes_categories OWNER TO directus;

--
-- Name: recipes_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.recipes_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipes_categories_id_seq OWNER TO directus;

--
-- Name: recipes_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.recipes_categories_id_seq OWNED BY public.recipes_categories.id;


--
-- Name: recipes_files; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.recipes_files (
    id integer NOT NULL,
    recipes_id uuid,
    directus_files_id uuid
);


ALTER TABLE public.recipes_files OWNER TO directus;

--
-- Name: recipes_files_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.recipes_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipes_files_id_seq OWNER TO directus;

--
-- Name: recipes_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.recipes_files_id_seq OWNED BY public.recipes_files.id;


--
-- Name: recipes_ingredients; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.recipes_ingredients (
    id integer NOT NULL,
    recipes_id uuid,
    ingredients_id uuid,
    quantity real,
    measure_unit character varying(255)
);


ALTER TABLE public.recipes_ingredients OWNER TO directus;

--
-- Name: recipes_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE public.recipes_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipes_ingredients_id_seq OWNER TO directus;

--
-- Name: recipes_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.recipes_ingredients_id_seq OWNED BY public.recipes_ingredients.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.reports (
    id uuid NOT NULL,
    date_created timestamp with time zone,
    report_id uuid,
    report character varying(255),
    user_id uuid
);


ALTER TABLE public.reports OWNER TO directus;

--
-- Name: steps; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.steps (
    id uuid NOT NULL,
    instructions text,
    "order" integer,
    steps_id uuid
);


ALTER TABLE public.steps OWNER TO directus;

--
-- Name: users_followed; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE public.users_followed (
    id uuid NOT NULL,
    user_id uuid,
    follower_id uuid
);


ALTER TABLE public.users_followed OWNER TO directus;

--
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_webhooks ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- Name: recipes_categories id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_categories ALTER COLUMN id SET DEFAULT nextval('public.recipes_categories_id_seq'::regclass);


--
-- Name: recipes_files id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_files ALTER COLUMN id SET DEFAULT nextval('public.recipes_files_id_seq'::regclass);


--
-- Name: recipes_ingredients id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_ingredients ALTER COLUMN id SET DEFAULT nextval('public.recipes_ingredients_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.categories (id, name) FROM stdin;
c2a859e7-cf51-4295-afed-197c3d4a5e8e	Entrantes
3804069d-68e8-4d7a-be43-f30d0faba482	Platos principales
14174f77-7e4b-4e93-b899-4e2edc7c1c34	Guarniciones
e061a50f-b291-4393-ae24-2ad93591fe2c	Postres
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.comments (id, date_created, date_updated, comment, user_id, comment_id) FROM stdin;
f4979c8a-ad74-411e-954e-67d0f9e12d7c	2024-04-24 12:42:04.04+00	\N	<p>Comentario 2....</p>	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	13b26b73-441c-4511-8369-d976ce3dc737
e67a320e-dede-43df-ba28-d5c8efaa4f8f	2024-04-24 12:08:13.852+00	2024-04-24 12:49:38.969+00	<p>esto seria un comentario</p>	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	13b26b73-441c-4511-8369-d976ce3dc737
\.


--
-- Data for Name: directus_activity; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_activity (id, action, "user", "timestamp", ip, user_agent, collection, item, comment, origin) FROM stdin;
1	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 07:59:59.598+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
2	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:04:23.708+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	1	\N	http://localhost:8055
3	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:05:23.681+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	2	\N	http://localhost:8055
4	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:06:47.753+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	3	\N	http://localhost:8055
5	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:11:29.968+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	4	\N	http://localhost:8055
6	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:11:48.013+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	5	\N	http://localhost:8055
7	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:12:07.934+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	6	\N	http://localhost:8055
8	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:13:08.572+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	7	\N	http://localhost:8055
9	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:13:29.356+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	8	\N	http://localhost:8055
10	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:13:52.293+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	9	\N	http://localhost:8055
11	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:14:08.916+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	10	\N	http://localhost:8055
12	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:14:17.393+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	11	\N	http://localhost:8055
13	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:14:22.93+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	12	\N	http://localhost:8055
14	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:15:02.652+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	13	\N	http://localhost:8055
15	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:15:49.166+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	14	\N	http://localhost:8055
16	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:15:49.175+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	15	\N	http://localhost:8055
17	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:15:49.18+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	16	\N	http://localhost:8055
18	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:15:49.186+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	17	\N	http://localhost:8055
19	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:15:49.193+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
20	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:16:42.8+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	18	\N	http://localhost:8055
21	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:17:40.198+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	19	\N	http://localhost:8055
22	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:18:03.915+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	20	\N	http://localhost:8055
23	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:19:54.745+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	21	\N	http://localhost:8055
24	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:21:27.348+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	22	\N	http://localhost:8055
25	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:21:36.44+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	23	\N	http://localhost:8055
26	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:21:51.22+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	24	\N	http://localhost:8055
27	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:22:38.426+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	25	\N	http://localhost:8055
28	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:23:19.82+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	26	\N	http://localhost:8055
29	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:23:57.339+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	27	\N	http://localhost:8055
30	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:23:57.349+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
31	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:24:15.936+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	28	\N	http://localhost:8055
32	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:24:46.149+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	29	\N	http://localhost:8055
33	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:24:46.156+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	30	\N	http://localhost:8055
34	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:24:46.162+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	31	\N	http://localhost:8055
35	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:24:46.171+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
36	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:24:54.884+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	32	\N	http://localhost:8055
37	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:25:37.735+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	33	\N	http://localhost:8055
38	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:25:37.742+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
39	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:26:06.229+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	34	\N	http://localhost:8055
40	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:27:20.755+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	35	\N	http://localhost:8055
41	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:27:38.505+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	36	\N	http://localhost:8055
42	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:27:38.515+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
43	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:27:52.152+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	37	\N	http://localhost:8055
44	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:28:07.056+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	37	\N	http://localhost:8055
45	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:30:06.546+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	38	\N	http://localhost:8055
46	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:30:14.548+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	39	\N	http://localhost:8055
47	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:30:59.036+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	40	\N	http://localhost:8055
48	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:30:59.043+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	41	\N	http://localhost:8055
49	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:30:59.05+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
50	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:31:10.63+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	42	\N	http://localhost:8055
51	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:31:25.035+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	43	\N	http://localhost:8055
52	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:31:25.041+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	44	\N	http://localhost:8055
53	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:31:25.046+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
54	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:31:37.146+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	45	\N	http://localhost:8055
55	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:32:36.701+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	46	\N	http://localhost:8055
56	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:32:36.71+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	47	\N	http://localhost:8055
57	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:32:36.717+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	48	\N	http://localhost:8055
58	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:32:36.724+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
59	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:32:46.41+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	49	\N	http://localhost:8055
60	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:33:19.509+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	50	\N	http://localhost:8055
61	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:33:19.521+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	51	\N	http://localhost:8055
62	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:33:19.528+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
63	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:33:26.728+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	52	\N	http://localhost:8055
64	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:35:32.15+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	53	\N	http://localhost:8055
65	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:35:32.158+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
66	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:42:40.818+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	54	\N	http://localhost:8055
67	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:43:50.456+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	55	\N	http://localhost:8055
68	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:47:27.943+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	56	\N	http://localhost:8055
69	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:47:30.098+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	53	\N	http://localhost:8055
70	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:47:30.152+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	56	\N	http://localhost:8055
71	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:47:30.199+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	54	\N	http://localhost:8055
72	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.055+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
73	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.055+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
74	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.07+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
75	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.082+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
76	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.093+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
77	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.101+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
78	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.109+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
79	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.118+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
80	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.131+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
81	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:31.147+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
82	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.917+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
83	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.926+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
84	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.933+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
85	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.941+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
86	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.948+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
87	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.954+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
88	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.966+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
89	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.979+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
90	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:33.995+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
91	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:34.001+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
92	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.338+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
93	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.344+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
94	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.35+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
95	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.358+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
96	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.365+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
97	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.376+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
98	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.383+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
99	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.389+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
100	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.395+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
101	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:37.41+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
103	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.905+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
102	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.905+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
104	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.914+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
105	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.924+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
106	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.932+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
107	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.953+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
108	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.96+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
109	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.967+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
110	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.975+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
111	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:39.982+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
112	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.794+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
113	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.814+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
114	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.82+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
115	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.828+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
116	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.834+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
117	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.842+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
118	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.848+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
119	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.855+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
120	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.863+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
121	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:47.869+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
122	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.105+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
123	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.157+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
124	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.164+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
125	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.172+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
126	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.179+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
127	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.185+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
128	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.191+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
129	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.199+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
130	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.205+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
131	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:51.212+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
132	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.13+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
133	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.13+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
134	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.14+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
135	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.147+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
136	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.155+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
137	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.161+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
138	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.169+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
139	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.186+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
140	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:54.193+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
145	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.906+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
147	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.916+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
149	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.927+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
155	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.167+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
157	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.177+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
159	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.186+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
162	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.197+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
175	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:23.1+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
176	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:23.106+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
177	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:23.115+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
178	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:23.121+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
179	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:23.128+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
141	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:57.398+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
142	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:57.411+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
143	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:59.458+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
144	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:52:59.464+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
146	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.908+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
148	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.918+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
150	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.928+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
151	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.938+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
152	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.949+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
153	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.957+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
154	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:04.972+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
156	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.168+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
158	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.177+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
160	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.186+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
161	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.196+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
163	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.216+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
164	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:09.231+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
166	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.588+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
167	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.6+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
169	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.611+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
171	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.621+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
173	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.631+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
165	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.588+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
168	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.601+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
170	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.612+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
172	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.622+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
174	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:13.632+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
180	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:27.774+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
181	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:27.774+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
182	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:27.784+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
183	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:27.792+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
184	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:27.8+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
185	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:37.558+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
186	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:37.558+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
187	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:37.566+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
188	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:37.567+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
189	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:37.575+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
190	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:46.624+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
191	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:46.625+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
192	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:46.643+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
193	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:46.644+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
194	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:46.66+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
195	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:46.68+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
196	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:46.688+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
197	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:53:46.704+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
198	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:05.206+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
199	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:05.206+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
200	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:05.222+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
201	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:05.235+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
202	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:05.24+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
203	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:05.251+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
204	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:05.26+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
205	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:05.271+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
206	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:06.089+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
208	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:06.112+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
209	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:06.122+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
210	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:06.13+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
211	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:07.615+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
212	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:07.624+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
213	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:07.63+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
214	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:07.637+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
215	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:08.927+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
216	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:08.933+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
217	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:08.939+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
218	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:08.95+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
219	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:08.966+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
207	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:06.089+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
220	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:08.979+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
221	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:08.99+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
222	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:08.997+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
223	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:11.602+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
224	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:11.602+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
225	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:11.616+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
226	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:11.626+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
227	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:11.636+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
228	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:11.639+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
229	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:11.658+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
230	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:11.678+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
231	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:13.514+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
232	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:13.514+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
233	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:13.523+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
234	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:13.532+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
235	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:13.54+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
236	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:13.555+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
237	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:13.564+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
238	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:13.57+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
239	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:14.945+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
240	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:14.946+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
241	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:14.958+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
242	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:14.966+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
243	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:14.972+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
244	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:14.985+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
245	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:14.994+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
246	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:15.001+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
247	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:15.013+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
248	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.056+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
249	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.064+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
250	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.07+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
251	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.077+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
252	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.095+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
253	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.114+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
254	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.122+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
255	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.129+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
256	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:16.137+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
257	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.841+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
258	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.847+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
259	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.853+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
260	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.862+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
261	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.868+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
262	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.873+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
263	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.879+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
264	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.885+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
265	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.895+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
266	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:19.903+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
267	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.632+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes	\N	http://localhost:8055
268	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.638+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_recipes	\N	http://localhost:8055
269	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.644+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	reports	\N	http://localhost:8055
270	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.65+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	rating_comments	\N	http://localhost:8055
271	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.655+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	comments	\N	http://localhost:8055
272	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.66+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	steps	\N	http://localhost:8055
273	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.668+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	ingredients	\N	http://localhost:8055
274	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.675+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	categories	\N	http://localhost:8055
275	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.681+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
276	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:54:22.687+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	users_followed	\N	http://localhost:8055
277	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:55:15.454+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	dbb73b63-b531-476b-9069-124ad96707d5	\N	http://localhost:8055
278	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 08:55:40.334+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	dbb73b63-b531-476b-9069-124ad96707d5	\N	http://localhost:8055
279	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 09:22:05.163+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	categories	c2a859e7-cf51-4295-afed-197c3d4a5e8e	\N	http://localhost:8055
280	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 09:22:17.454+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	categories	3804069d-68e8-4d7a-be43-f30d0faba482	\N	http://localhost:8055
281	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 09:22:26.211+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	categories	14174f77-7e4b-4e93-b899-4e2edc7c1c34	\N	http://localhost:8055
282	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 09:22:29.57+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	categories	e061a50f-b291-4393-ae24-2ad93591fe2c	\N	http://localhost:8055
283	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:08:42.907+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	57	\N	http://localhost:8055
284	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:11:48.039+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	01d5b8e7-3081-4dc7-8db5-4e3cb1585d9b	\N	http://localhost:8055
285	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:12:10.268+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	191af4d4-8949-4050-b5f1-1ba7dfe717ec	\N	http://localhost:8055
286	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:13:13.677+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	191af4d4-8949-4050-b5f1-1ba7dfe717ec	\N	http://localhost:8055
287	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:13:56.89+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	58	\N	http://localhost:8055
288	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:14:26.738+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	59	\N	http://localhost:8055
289	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:15:55.474+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	60	\N	http://localhost:8055
290	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:16:19.183+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	61	\N	http://localhost:8055
295	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:17:22.288+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
296	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:17:22.297+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	94d6a66e-95ff-4834-a9a2-0a355a2cef7c	\N	http://localhost:8055
297	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:18:08.316+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	56	\N	http://localhost:8055
298	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:19:34.955+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	62	\N	http://localhost:8055
299	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:19:40.724+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	94d6a66e-95ff-4834-a9a2-0a355a2cef7c	\N	http://localhost:8055
300	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:19:45.834+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	79a070ce-8be1-4de8-9eb1-caaeb4da08b1	\N	http://localhost:8055
301	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:19:51.773+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	0516b6cb-cd98-4f80-843a-d04a033c44ac	\N	http://localhost:8055
302	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:24:02.148+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	60	\N	http://localhost:8055
303	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:25:51.933+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	0516b6cb-cd98-4f80-843a-d04a033c44ac	\N	http://localhost:8055
304	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:25:51.937+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	79a070ce-8be1-4de8-9eb1-caaeb4da08b1	\N	http://localhost:8055
305	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:27:21.232+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	df91c1bb-8443-41c2-aa02-566f08631e04	\N	http://localhost:8055
306	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:28:15.177+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	63	\N	http://localhost:8055
307	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:28:49.341+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	b7f3a7af-4407-429a-9e25-03412b8b6515	\N	http://localhost:8055
308	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:29:17.698+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	df91c1bb-8443-41c2-aa02-566f08631e04	\N	http://localhost:8055
309	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:29:17.7+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	01d5b8e7-3081-4dc7-8db5-4e3cb1585d9b	\N	http://localhost:8055
310	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:29:24.109+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	5d2311ba-e16d-41c9-aba6-35b214248bd5	\N	http://localhost:8055
311	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:29:30.37+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	826e0729-ccee-4247-8e28-e7775fe11550	\N	http://localhost:8055
312	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:30:28.074+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	\N	http://localhost:8055
313	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:30:42.269+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	users_followed	625df489-026b-4dee-addd-94748e14c81a	\N	http://localhost:8055
314	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:31:55.157+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	64	\N	http://localhost:8055
315	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:31:55.283+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	65	\N	http://localhost:8055
316	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:31:55.289+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes_categories	\N	http://localhost:8055
317	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:31:55.345+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	66	\N	http://localhost:8055
318	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:31:55.414+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	67	\N	http://localhost:8055
319	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:33:53.461+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	1	\N	http://localhost:8055
320	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:33:53.489+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	2	\N	http://localhost:8055
321	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:33:53.495+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	3	\N	http://localhost:8055
322	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:33:53.499+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	9e96d043-77b8-492f-aaa2-ed3e362e465c	\N	http://localhost:8055
323	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:37:07.217+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	9e96d043-77b8-492f-aaa2-ed3e362e465c	\N	http://localhost:8055
324	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:37:47.262+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	68	\N	http://localhost:8055
325	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:38:28.885+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	69	\N	http://localhost:8055
326	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:39:13.507+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	70	\N	http://localhost:8055
327	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:40:03.75+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	29	\N	http://localhost:8055
328	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:41:02.167+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	71	\N	http://localhost:8055
329	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:41:25.093+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	72	\N	http://localhost:8055
330	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:44:23.329+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	73	\N	http://localhost:8055
331	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:44:23.459+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	74	\N	http://localhost:8055
332	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:44:23.466+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes_files	\N	http://localhost:8055
333	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:44:23.527+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	75	\N	http://localhost:8055
334	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:44:23.609+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	76	\N	http://localhost:8055
335	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:34.038+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_files	5448e639-7980-49fe-b191-fb2b8871fcec	\N	http://localhost:8055
336	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:56.254+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_files	1ed25831-f0b4-4838-ba3d-bfce8b45d748	\N	http://localhost:8055
337	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:59.967+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	4	\N	http://localhost:8055
338	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:59.977+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	5	\N	http://localhost:8055
339	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:59.988+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_files	1	\N	http://localhost:8055
340	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:59.993+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_files	2	\N	http://localhost:8055
341	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:59.997+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	56c32335-6624-4f24-908a-4091faf5a0d5	\N	http://localhost:8055
342	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:46:13.156+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	images	\N	http://localhost:8055
343	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:47:24.874+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	77	\N	http://localhost:8055
344	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:47:24.973+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	78	\N	http://localhost:8055
345	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:47:24.98+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	recipes_ingredients	\N	http://localhost:8055
346	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:47:25.033+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	79	\N	http://localhost:8055
347	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:47:25.107+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	80	\N	http://localhost:8055
348	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:10:37.566+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	81	\N	http://localhost:8055
349	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:10:37.574+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_collections	macronutrients	\N	http://localhost:8055
350	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:10:52.277+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	82	\N	http://localhost:8055
351	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:11:04.702+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	83	\N	http://localhost:8055
352	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:11:14.098+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	82	\N	http://localhost:8055
353	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:12:25.403+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	84	\N	http://localhost:8055
354	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:12:49.261+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	85	\N	http://localhost:8055
364	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:15:42.051+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	821168c8-b40b-4184-bd00-d067166ca1b9	\N	http://localhost:8055
365	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:15:42.056+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	bd3b3a32-b50c-4301-a3dd-804e18b7fede	\N	http://localhost:8055
366	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:15:42.061+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	2d8b9fbb-22cf-4830-9656-5328dc1e4455	\N	http://localhost:8055
367	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:15:42.065+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	ingredients	c868ba45-670d-432d-ac4b-7d9d7351ed03	\N	http://localhost:8055
368	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:32+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	ingredients	c868ba45-670d-432d-ac4b-7d9d7351ed03	\N	http://localhost:8055
369	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:38.076+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	2d8b9fbb-22cf-4830-9656-5328dc1e4455	\N	http://localhost:8055
370	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:38.078+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	821168c8-b40b-4184-bd00-d067166ca1b9	\N	http://localhost:8055
371	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:38.079+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	bd3b3a32-b50c-4301-a3dd-804e18b7fede	\N	http://localhost:8055
372	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:55.385+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	86	\N	http://localhost:8055
373	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:57.389+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	81	\N	http://localhost:8055
374	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:57.433+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	82	\N	http://localhost:8055
375	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:57.466+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	86	\N	http://localhost:8055
376	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:16:57.505+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	84	\N	http://localhost:8055
377	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:17:15.314+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	ingredients	540b300c-fb17-4363-b233-2ef352f7eb6f	\N	http://localhost:8055
378	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:17:52.75+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	4d41d9b7-77ba-41ba-8374-5c423c1d4ab8	\N	http://localhost:8055
379	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:17:52.756+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	9f6a8ec3-0473-4d56-9824-88b4d25db08a	\N	http://localhost:8055
380	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:17:52.761+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	macronutrients	1f85e0fc-0e11-4f77-b86e-84c1d0dc1788	\N	http://localhost:8055
381	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:17:52.764+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	ingredients	540b300c-fb17-4363-b233-2ef352f7eb6f	\N	http://localhost:8055
382	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:19:31.278+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	87	\N	http://localhost:8055
383	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:22:03.487+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	88	\N	http://localhost:8055
384	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:22:13.916+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	87	\N	http://localhost:8055
385	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:22:56.8+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	6	\N	http://localhost:8055
386	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:22:56.809+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	7	\N	http://localhost:8055
387	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:22:56.817+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_files	3	\N	http://localhost:8055
388	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:22:56.821+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_files	4	\N	http://localhost:8055
389	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:22:56.833+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_ingredients	1	\N	http://localhost:8055
390	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:22:56.836+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	\N	http://localhost:8055
391	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:23:11.909+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_ingredients	1	\N	http://localhost:8055
392	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:23:11.916+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	\N	http://localhost:8055
393	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:23:21.43+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_ingredients	1	\N	http://localhost:8055
394	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:23:21.439+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	\N	http://localhost:8055
395	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:24:42.235+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	89	\N	http://localhost:8055
396	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:24:59.718+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	90	\N	http://localhost:8055
397	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:25:32.756+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	steps	9eda8226-7339-471c-9511-94de6345f3cb	\N	http://localhost:8055
398	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:25:32.764+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	\N	http://localhost:8055
399	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:28:03.747+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	91	\N	http://localhost:8055
400	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:28:34.817+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	92	\N	http://localhost:8055
401	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:28:54.617+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	93	\N	http://localhost:8055
402	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:29:11.816+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	steps	9eda8226-7339-471c-9511-94de6345f3cb	\N	http://localhost:8055
403	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:29:11.823+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	56c32335-6624-4f24-908a-4091faf5a0d5	\N	http://localhost:8055
404	login	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 11:30:11.474+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	\N	http://localhost:8055
405	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.155+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_roles	d442c489-354a-4884-b239-9c9138853f39	\N	http://localhost:8055
406	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.215+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	1	\N	http://localhost:8055
407	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.219+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	2	\N	http://localhost:8055
408	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.223+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	3	\N	http://localhost:8055
409	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.23+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	4	\N	http://localhost:8055
410	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.237+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	5	\N	http://localhost:8055
411	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.247+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	6	\N	http://localhost:8055
412	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.262+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	7	\N	http://localhost:8055
413	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.266+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	8	\N	http://localhost:8055
414	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.27+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	9	\N	http://localhost:8055
415	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.274+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	10	\N	http://localhost:8055
416	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.278+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	11	\N	http://localhost:8055
417	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.282+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	12	\N	http://localhost:8055
418	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.286+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	13	\N	http://localhost:8055
419	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.29+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	14	\N	http://localhost:8055
420	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.295+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	15	\N	http://localhost:8055
421	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.3+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	16	\N	http://localhost:8055
422	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.306+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	17	\N	http://localhost:8055
423	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.309+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	18	\N	http://localhost:8055
424	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.313+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	19	\N	http://localhost:8055
425	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.317+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	20	\N	http://localhost:8055
426	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.321+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	21	\N	http://localhost:8055
427	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.325+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	22	\N	http://localhost:8055
428	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.329+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	23	\N	http://localhost:8055
429	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:30:53.333+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	24	\N	http://localhost:8055
430	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:01.028+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	25	\N	http://localhost:8055
431	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:02.644+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	26	\N	http://localhost:8055
432	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:04.177+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	27	\N	http://localhost:8055
433	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:14.884+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	28	\N	http://localhost:8055
434	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:17.404+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	29	\N	http://localhost:8055
435	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:18.204+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	30	\N	http://localhost:8055
436	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:19.025+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	31	\N	http://localhost:8055
437	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:19.834+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	32	\N	http://localhost:8055
438	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:45.499+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	\N	http://localhost:8055
439	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:31:45.506+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_roles	d442c489-354a-4884-b239-9c9138853f39	\N	http://localhost:8055
440	login	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 11:31:52.191+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	\N	http://localhost:8055
441	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:32:44.714+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	33	\N	http://localhost:8055
442	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:32:47.116+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	34	\N	http://localhost:8055
443	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:32:48.496+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	35	\N	http://localhost:8055
444	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:32:49.594+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	36	\N	http://localhost:8055
445	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:33:26.115+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	37	\N	http://localhost:8055
446	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:33:27.343+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	38	\N	http://localhost:8055
447	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:33:28.205+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	39	\N	http://localhost:8055
448	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:33:29.073+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	40	\N	http://localhost:8055
449	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 11:33:53.958+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	8	\N	http://localhost:8055
450	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 11:33:53.99+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	9	\N	http://localhost:8055
451	update	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 11:33:53.999+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	steps	9eda8226-7339-471c-9511-94de6345f3cb	\N	http://localhost:8055
452	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 11:33:54.005+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	0ae4d4d8-0f66-42aa-bc45-50bde2a963ac	\N	http://localhost:8055
453	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:34:29.559+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	93	\N	http://localhost:8055
454	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:39:53.908+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	94	\N	http://localhost:8055
455	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:40:21.566+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	95	\N	http://localhost:8055
456	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:24.579+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	96	\N	http://localhost:8055
457	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:34.298+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	46	\N	http://localhost:8055
458	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:34.348+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	94	\N	http://localhost:8055
459	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:34.382+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	47	\N	http://localhost:8055
460	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:34.419+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	48	\N	http://localhost:8055
461	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:34.46+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	49	\N	http://localhost:8055
462	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:34.501+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	96	\N	http://localhost:8055
463	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:49.343+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	33	\N	http://localhost:8055
464	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:49.385+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	92	\N	http://localhost:8055
465	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:49.417+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	34	\N	http://localhost:8055
466	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:49.453+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	35	\N	http://localhost:8055
467	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:55.735+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	81	\N	http://localhost:8055
468	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:55.81+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	84	\N	http://localhost:8055
469	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:55.842+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	82	\N	http://localhost:8055
470	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 11:44:55.872+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	86	\N	http://localhost:8055
471	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:02:57.983+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	97	\N	http://localhost:8055
472	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:03:36.725+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	0ae4d4d8-0f66-42aa-bc45-50bde2a963ac	\N	http://localhost:8055
473	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:03:36.726+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	\N	http://localhost:8055
474	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:03:36.727+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	56c32335-6624-4f24-908a-4091faf5a0d5	\N	http://localhost:8055
475	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:03:56.464+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	98	\N	http://localhost:8055
476	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:05:00.583+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	99	\N	http://localhost:8055
477	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:05:55.094+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	100	\N	http://localhost:8055
478	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:06:01.777+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	1a5de822-f256-4c90-ba17-e1b035bc42e4	\N	http://localhost:8055
479	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:06:16.957+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	1a5de822-f256-4c90-ba17-e1b035bc42e4	\N	http://localhost:8055
480	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:06:34.724+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	101	\N	http://localhost:8055
481	delete	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:06:53.187+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	1a5de822-f256-4c90-ba17-e1b035bc42e4	\N	http://localhost:8055
482	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:07:14.639+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	102	\N	http://localhost:8055
483	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:01.667+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	10	\N	http://localhost:8055
484	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:01.672+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_categories	11	\N	http://localhost:8055
485	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:01.682+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_files	5	\N	http://localhost:8055
486	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:01.687+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_files	6	\N	http://localhost:8055
487	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:01.695+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_ingredients	2	\N	http://localhost:8055
488	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:01.703+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	steps	c8e80c71-24fd-415a-a288-f21dfb0c0088	\N	http://localhost:8055
489	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:01.707+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	13b26b73-441c-4511-8369-d976ce3dc737	\N	http://localhost:8055
490	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:13.854+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
491	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:13.86+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	13b26b73-441c-4511-8369-d976ce3dc737	\N	http://localhost:8055
492	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:10:04.81+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	103	\N	http://localhost:8055
493	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:26:05.351+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	104	\N	http://localhost:8055
494	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:26:45.53+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	105	\N	http://localhost:8055
495	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:27:37.214+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	106	\N	http://localhost:8055
496	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:27:53.183+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	rating_comments	39ebf191-a8e6-481a-9e1e-e12fef666f87	\N	http://localhost:8055
497	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:27:53.193+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
498	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:28:15.331+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	\N	http://localhost:8055
499	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:28:15.35+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_roles	525a4819-e516-42c3-82bb-33558d3e82b4	\N	http://localhost:8055
500	login	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:28:30.486+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	\N	http://localhost:8055
501	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:28:48.161+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	rating_comments	890ef304-4733-44c2-88d3-b191fd8fecd5	\N	http://localhost:8055
502	update	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:28:48.17+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
503	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:29:54.159+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	107	\N	http://localhost:8055
504	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:30:18.65+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	108	\N	http://localhost:8055
505	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:30:33.359+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	109	\N	http://localhost:8055
506	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:30:59.168+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	110	\N	http://localhost:8055
509	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:32:11.043+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	rating_recipes	6b1ede2d-4f11-4fe7-8621-b3c93745d205	\N	http://localhost:8055
510	update	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:32:11.051+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	steps	c8e80c71-24fd-415a-a288-f21dfb0c0088	\N	http://localhost:8055
511	update	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:32:11.062+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	13b26b73-441c-4511-8369-d976ce3dc737	\N	http://localhost:8055
512	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:34:16.447+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes_ingredients	2	\N	http://localhost:8055
513	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:34:16.466+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	steps	c8e80c71-24fd-415a-a288-f21dfb0c0088	\N	http://localhost:8055
514	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:34:16.472+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	13b26b73-441c-4511-8369-d976ce3dc737	\N	http://localhost:8055
515	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:34:28.51+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	rating_recipes	66243f51-f7e8-4e46-bbc6-885a4bf777a3	\N	http://localhost:8055
516	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:34:28.518+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	13b26b73-441c-4511-8369-d976ce3dc737	\N	http://localhost:8055
517	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:35:17.073+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	steps	3341a51f-b731-46cc-91cb-922deee173a1	\N	http://localhost:8055
518	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:35:17.08+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	13b26b73-441c-4511-8369-d976ce3dc737	\N	http://localhost:8055
519	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:35:33.56+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	steps	3341a51f-b731-46cc-91cb-922deee173a1	\N	http://localhost:8055
520	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:35:33.573+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	13b26b73-441c-4511-8369-d976ce3dc737	\N	http://localhost:8055
521	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:10.674+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	111	\N	http://localhost:8055
522	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:18.329+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	50	\N	http://localhost:8055
523	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:18.38+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	111	\N	http://localhost:8055
524	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:18.427+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	51	\N	http://localhost:8055
525	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:18.478+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	52	\N	http://localhost:8055
526	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:35.409+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	112	\N	http://localhost:8055
527	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:55.583+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	50	\N	http://localhost:8055
528	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:55.635+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	111	\N	http://localhost:8055
529	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:55.692+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	112	\N	http://localhost:8055
530	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:55.74+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	51	\N	http://localhost:8055
531	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:36:55.795+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	52	\N	http://localhost:8055
532	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:39:44.383+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	113	\N	http://localhost:8055
533	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:40:07.313+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	114	\N	http://localhost:8055
534	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:41:12.103+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	6787df23-2698-4f0d-81db-dbf3641aca2b	\N	http://localhost:8055
535	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:41:12.115+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
536	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:42:04.042+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	f4979c8a-ad74-411e-954e-67d0f9e12d7c	\N	http://localhost:8055
537	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:42:04.051+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	recipes	13b26b73-441c-4511-8369-d976ce3dc737	\N	http://localhost:8055
538	login	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:42:45.472+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	\N	http://localhost:8055
539	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:44:16.868+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	0610ca37-7dda-4778-9b0d-679a5048c4ca	\N	http://localhost:8055
540	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:44:16.875+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
541	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:44:22.868+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	fc6bc99b-dba3-47a8-96ab-6d1d981c410f	\N	http://localhost:8055
542	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:44:22.875+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
543	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:44:30.104+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	0610ca37-7dda-4778-9b0d-679a5048c4ca	\N	http://localhost:8055
544	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:44:30.107+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	6787df23-2698-4f0d-81db-dbf3641aca2b	\N	http://localhost:8055
545	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:44:30.109+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	fc6bc99b-dba3-47a8-96ab-6d1d981c410f	\N	http://localhost:8055
546	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:44:30.119+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
547	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:45:30.66+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	ef5cdc31-c57c-46b1-9906-da8b8562d6b8	\N	http://localhost:8055
548	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:45:30.674+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
549	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:46:55.297+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_fields	115	\N	http://localhost:8055
550	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:47:11.173+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	324ca7c1-19e0-4a4f-8eb7-544e4e78b5bb	\N	http://localhost:8055
551	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:47:11.187+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
552	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:47:25.756+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	324ca7c1-19e0-4a4f-8eb7-544e4e78b5bb	\N	http://localhost:8055
553	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:47:25.757+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	ef5cdc31-c57c-46b1-9906-da8b8562d6b8	\N	http://localhost:8055
554	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:47:25.766+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
555	update	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:48:21.104+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
556	delete	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:48:39.965+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	6787df23-2698-4f0d-81db-dbf3641aca2b	\N	http://localhost:8055
557	delete	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:48:39.967+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	ef5cdc31-c57c-46b1-9906-da8b8562d6b8	\N	http://localhost:8055
558	delete	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:48:39.969+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	fc6bc99b-dba3-47a8-96ab-6d1d981c410f	\N	http://localhost:8055
559	delete	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:48:39.971+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	324ca7c1-19e0-4a4f-8eb7-544e4e78b5bb	\N	http://localhost:8055
560	delete	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:48:39.972+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	0610ca37-7dda-4778-9b0d-679a5048c4ca	\N	http://localhost:8055
561	create	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:48:59.123+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	c58fda7f-991c-4db8-84ea-20a9a3909d65	\N	http://localhost:8055
562	update	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	2024-04-24 12:48:59.133+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
563	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:49:38.974+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	reports	89d08a07-40b9-48f6-93f2-b96382bd392b	\N	http://localhost:8055
564	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:49:38.985+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	\N	http://localhost:8055
565	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 13:14:01.852+00	99.82.162.187	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://ubh0ah2ys27z.share.zrok.io
566	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 13:28:58.829+00	99.82.162.188	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://ubh0ah2ys27z.share.zrok.io
567	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 19:03:35.999+00	99.82.162.147	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://ubh0ah2ys27z.share.zrok.io
568	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 21:32:26.009+00	99.82.162.184	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Mobile Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://ubh0ah2ys27z.share.zrok.io
569	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 21:45:16.143+00	99.82.162.148	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Mobile Safari/537.36	reports	89d08a07-40b9-48f6-93f2-b96382bd392b	\N	https://ubh0ah2ys27z.share.zrok.io
570	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 21:45:28.121+00	99.82.162.148	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Mobile Safari/537.36	reports	89d08a07-40b9-48f6-93f2-b96382bd392b	\N	https://ubh0ah2ys27z.share.zrok.io
571	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-25 14:48:25.403+00	99.82.162.149	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://ubh0ah2ys27z.share.zrok.io
572	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-25 19:22:02.367+00	99.82.162.148	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://ubh0ah2ys27z.share.zrok.io
573	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:13:25.12+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
574	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:14:04.938+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
575	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:14:05.533+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
576	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:14:06.488+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
577	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:18:28.868+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
578	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:20:31.007+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
579	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:20:31.46+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
580	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:20:32.282+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
581	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:22:15.265+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
582	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:26:55.392+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
583	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:33:11.823+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
584	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-29 02:33:31.265+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
585	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-30 15:30:58.581+00	99.82.162.186	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://n50txuv5aerm.share.zrok.io
586	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-05 19:29:54.974+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
587	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:05:11.91+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
588	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:06:09.432+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
589	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:06:12.425+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
590	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:09:24.25+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
591	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:10:11.834+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
592	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:12:15.93+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
593	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:12:53.343+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
594	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:14:56.813+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
595	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:15:27.837+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
596	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:16:31.564+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
597	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:17:44.899+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
598	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:28:42.261+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
599	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:30:38.568+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
600	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:30:41.018+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
601	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:30:59.919+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
602	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:32:37.609+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
603	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:36:50.182+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
604	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:37:32.587+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
605	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:37:32.591+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
606	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:37:32.595+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
607	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:37:51.777+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
608	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:44:20.131+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
609	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:44:37.96+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
610	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:45:16.341+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
611	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:45:33.568+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
612	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:46:01.315+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
613	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:48:03.827+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
614	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:50:12.219+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
615	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:52:50.408+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
616	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:52:57.626+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
617	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-11 20:53:07.821+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
618	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 15:01:25.518+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
619	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 15:04:04.79+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
620	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 15:10:43.49+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
621	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 15:10:53.831+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
622	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 15:14:36.256+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
655	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 16:59:21.973+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
656	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:00:09.024+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
657	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:02:38.53+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
658	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:03:24.306+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
659	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:04:21.836+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
660	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:06:00.83+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
661	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:06:19.82+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
662	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:06:56.132+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
663	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:11:24.893+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
664	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:13:30.381+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
665	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:15:11.343+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
666	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:22:04.706+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
667	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:22:10.062+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
668	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:22:48.313+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
669	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:23:37.101+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
670	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:29:58.192+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
671	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:30:36.9+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
672	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:30:57.622+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
673	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:31:39.835+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
674	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:32:47.95+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
675	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:33:46.644+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
676	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:35:22.455+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
677	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:37:19.718+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
678	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:39:02.536+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
679	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:39:50.26+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
680	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:40:38.829+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
681	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:41:50.815+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
682	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:42:56.692+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
683	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:43:34.267+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
684	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:44:53.294+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
685	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:45:51.386+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
686	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:47:41.655+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
687	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:48:51.875+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
688	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:54:30.981+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
689	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:56:45.045+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
690	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:56:59.809+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
691	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:57:22.733+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
692	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:59:23.282+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
693	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 17:59:56.906+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
694	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:03:08.218+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
695	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:05:42.586+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
696	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:09:44.66+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
697	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:21:13.453+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
698	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:23:02.053+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
699	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:36:03.109+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
700	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:38:27.032+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
701	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:40:49.634+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
702	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:41:54.957+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
703	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:43:44.429+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:56892
704	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:48:05.17+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
705	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 18:59:47.011+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
706	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 19:02:44.302+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
707	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 19:03:18.339+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
708	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 19:18:38.33+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:58217
709	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 19:20:57.101+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:58217
710	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 19:23:48.799+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:58217
711	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 19:30:20.528+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:58217
712	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 19:31:51.345+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:58217
713	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 19:32:57.079+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:58217
714	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-12 21:28:46.389+00	193.152.119.174	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://yhydf2awm25r.share.zrok.io
715	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-15 15:49:39.743+00	88.21.14.228	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://yhydf2awm25r.share.zrok.io
716	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-15 15:50:45.559+00	88.21.14.228	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://yhydf2awm25r.share.zrok.io
717	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-15 15:51:46.335+00	88.21.14.228	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://yhydf2awm25r.share.zrok.io
718	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-15 15:52:46.904+00	88.21.14.228	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://yhydf2awm25r.share.zrok.io
719	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-15 15:55:04.167+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
720	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-15 18:49:48.942+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
721	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-15 18:51:00.451+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
722	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:27:06.7+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
723	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:31:37.621+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
724	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:34:26.283+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
725	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:37:17.159+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	41	\N	http://localhost:8055
726	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:37:32.707+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_permissions	42	\N	http://localhost:8055
727	update	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:38:29.783+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	\N	http://localhost:8055
728	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:43:19.118+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
729	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:47:42.294+00	46.6.51.173	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	https://ed8n69ihxbp1.share.zrok.io
730	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 15:51:38.322+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
731	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 16:04:30.873+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
732	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-23 16:25:14.562+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
733	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 16:23:59.16+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
734	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 16:25:24.766+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
735	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 16:29:43.86+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
736	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 16:34:15.469+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
737	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 16:35:06.008+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
738	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 16:36:00.236+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
739	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 16:42:45.365+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
740	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 16:44:00.94+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
741	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 18:25:23.993+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:4200
742	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 18:35:30.944+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
743	create	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 18:38:36.033+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_permissions	43	\N	http://localhost:8055
744	login	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-26 19:16:30.91+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	http://localhost:8055
\.


--
-- Data for Name: directus_collections; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_collections (collection, icon, note, display_template, hidden, singleton, translations, archive_field, archive_app_filter, archive_value, unarchive_value, sort_field, accountability, color, item_duplication_fields, sort, "group", collapse, preview_url, versioning) FROM stdin;
comments	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	5	\N	open	\N	f
steps	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	6	\N	open	\N	f
ingredients	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	7	\N	open	\N	f
categories	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	8	\N	open	\N	f
users_followed	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	10	\N	open	\N	f
recipes_categories	import_export	\N	\N	t	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
recipes_files	import_export	\N	\N	t	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
recipes_ingredients	import_export	\N	\N	t	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
macronutrients	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
recipes	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	1	\N	open	\N	f
rating_recipes	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	2	\N	open	\N	f
reports	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	3	\N	open	\N	f
rating_comments	\N	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	4	\N	open	\N	f
\.


--
-- Data for Name: directus_dashboards; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_dashboards (id, name, icon, note, date_created, user_created, color) FROM stdin;
\.


--
-- Data for Name: directus_extensions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_extensions (name, enabled) FROM stdin;
\.


--
-- Data for Name: directus_fields; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_fields (id, collection, field, special, interface, options, display, display_options, readonly, hidden, sort, width, translations, note, conditions, required, "group", validation, validation_message) FROM stdin;
1	directus_users	username	\N	input	\N	\N	\N	f	f	1	full	\N	\N	\N	t	\N	\N	\N
2	directus_users	birth_date	\N	datetime	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
3	directus_users	phone_number	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
4	directus_users	town	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
5	directus_users	municipality	\N	input	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
6	directus_users	street	\N	input	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
7	directus_users	zip_code	\N	input	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
8	directus_users	twitter	\N	input	\N	\N	\N	f	f	8	full	\N	\N	\N	f	\N	\N	\N
9	directus_users	facebook	\N	input	\N	\N	\N	f	f	9	full	\N	\N	\N	f	\N	\N	\N
10	directus_users	youtube	\N	input	\N	\N	\N	f	f	10	full	\N	\N	\N	f	\N	\N	\N
11	directus_users	instagram	\N	input	\N	\N	\N	f	f	11	full	\N	\N	\N	f	\N	\N	\N
12	directus_users	tiktok	\N	input	\N	\N	\N	f	f	12	full	\N	\N	\N	f	\N	\N	\N
13	directus_users	reputation	\N	input	\N	\N	\N	f	f	13	full	\N	\N	\N	t	\N	\N	\N
14	recipes	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
15	recipes	user_created	user-created	select-dropdown-m2o	{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}	user	\N	t	t	2	half	\N	\N	\N	f	\N	\N	\N
16	recipes	date_created	date-created	datetime	\N	datetime	{"relative":true}	t	t	3	half	\N	\N	\N	f	\N	\N	\N
17	recipes	date_updated	date-updated	datetime	\N	datetime	{"relative":true}	t	t	4	half	\N	\N	\N	f	\N	\N	\N
18	recipes	title	\N	input	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
19	recipes	description	\N	input-rich-text-html	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
20	recipes	video	\N	input	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
21	recipes	difficulty	\N	select-dropdown	{"choices":[{"text":"Easy","value":"easy"},{"text":"Medium","value":"medium"},{"text":"Hard","value":"hard"}]}	\N	\N	f	f	8	full	\N	\N	\N	f	\N	\N	\N
22	recipes	preparation_time	\N	input	\N	\N	\N	f	f	9	full	\N	\N	\N	f	\N	\N	\N
23	recipes	calories	\N	input	\N	\N	\N	f	f	10	full	\N	\N	\N	f	\N	\N	\N
24	recipes	cooking_time	\N	input	\N	\N	\N	f	f	11	full	\N	\N	\N	f	\N	\N	\N
25	recipes	portion_numbers	\N	input	\N	\N	\N	f	f	12	full	\N	\N	\N	f	\N	\N	\N
26	recipes	api_inserted	cast-boolean	boolean	\N	\N	\N	f	f	13	full	\N	\N	\N	t	\N	\N	\N
27	categories	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
28	categories	name	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
36	ingredients	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
37	ingredients	name	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
40	rating_comments	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
43	rating_recipes	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
53	users_followed	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
56	users_followed	user_id	user-created,user-updated	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
62	users_followed	follower_id	m2o	select-dropdown-m2o	\N	\N	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N
73	recipes	images	files	files	\N	\N	\N	f	f	15	full	\N	\N	\N	f	\N	\N	\N
63	directus_users	user_id	uuid	input	\N	\N	\N	f	f	14	full	\N	\N	\N	f	\N	\N	\N
64	recipes	categories	m2m	list-m2m	\N	\N	\N	f	f	14	full	\N	\N	\N	t	\N	\N	\N
65	recipes_categories	id	\N	\N	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
66	recipes_categories	recipes_id	\N	\N	\N	\N	\N	f	t	2	full	\N	\N	\N	f	\N	\N	\N
67	recipes_categories	categories_id	\N	\N	\N	\N	\N	f	t	3	full	\N	\N	\N	f	\N	\N	\N
82	macronutrients	name	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N
74	recipes_files	id	\N	\N	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
75	recipes_files	recipes_id	\N	\N	\N	\N	\N	f	t	2	full	\N	\N	\N	f	\N	\N	\N
76	recipes_files	directus_files_id	\N	\N	\N	\N	\N	f	t	3	full	\N	\N	\N	f	\N	\N	\N
77	recipes	ingredients	m2m	list-m2m	\N	\N	\N	f	f	16	full	\N	\N	\N	f	\N	\N	\N
78	recipes_ingredients	id	\N	\N	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
79	recipes_ingredients	recipes_id	\N	\N	\N	\N	\N	f	t	2	full	\N	\N	\N	f	\N	\N	\N
80	recipes_ingredients	ingredients_id	\N	\N	\N	\N	\N	f	t	3	full	\N	\N	\N	f	\N	\N	\N
85	ingredients	macronutrients	o2m	list-o2m	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
86	macronutrients	quantity	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	t	\N	\N	\N
88	recipes_ingredients	measure_unit	\N	select-dropdown	{"choices":[{"text":"Gramos","value":"g"},{"text":"Kilogramos","value":"kg"},{"text":"Litros","value":"l"},{"text":"Mililitros","value":"ml"},{"text":"Unidades","value":"unidad"},{"text":"Cucharadas","value":"cucharada"},{"text":"Cucharadita","value":"cucharadita"},{"text":"Tazas","value":"taza"}]}	\N	\N	f	f	5	full	\N	\N	\N	t	\N	\N	\N
87	recipes_ingredients	quantity	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	t	\N	\N	\N
93	recipes	steps	o2m	list-o2m	{"enableSelect":false}	\N	\N	f	f	17	full	\N	\N	\N	f	\N	\N	\N
46	comments	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
47	comments	date_created	date-created	datetime	\N	datetime	{"relative":true}	t	t	3	half	\N	\N	\N	f	\N	\N	\N
48	comments	date_updated	date-updated	datetime	\N	datetime	{"relative":true}	t	t	4	half	\N	\N	\N	f	\N	\N	\N
49	comments	comment	\N	input-rich-text-html	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
100	comments	comment_id	uuid	input	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
33	steps	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
92	steps	steps_id	uuid	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
34	steps	instructions	\N	input-rich-text-html	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
35	steps	order	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
81	macronutrients	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
84	macronutrients	macronutrient_id	uuid	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
99	comments	user_id	user-created	input	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
102	recipes	comments	o2m	list-o2m	\N	\N	\N	f	f	18	full	\N	\N	\N	f	\N	\N	\N
103	rating_comments	user_id	user-created	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
104	rating_comments	valuation	cast-boolean	\N	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
105	rating_comments	rating_comment_id	uuid	input	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
106	comments	rating_comment	o2m	list-o2m	\N	\N	\N	f	f	8	full	\N	\N	\N	f	\N	\N	\N
107	rating_recipes	rating_recipes_id	uuid	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
108	rating_recipes	user_id	user-created	input	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
109	rating_recipes	valuation	cast-boolean	\N	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
110	recipes	rating_recipes	o2m	list-o2m	\N	\N	\N	f	f	19	full	\N	\N	\N	f	\N	\N	\N
111	reports	report_id	uuid	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
50	reports	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
51	reports	date_created	date-created	datetime	\N	datetime	{"relative":true}	t	t	4	half	\N	\N	\N	f	\N	\N	\N
113	reports	report	\N	select-dropdown	{"choices":[{"text":"Contenido violento o explícito","value":"violent_content"},{"text":"Contenido irrelevante","value":"irrelevant_content"},{"text":"Spam o engañoso","value":"spam_content"}]}	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
114	comments	reports	o2m	list-o2m	\N	\N	\N	f	f	9	full	\N	\N	\N	f	\N	\N	\N
115	reports	user_id	user-created	input	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
\.


--
-- Data for Name: directus_files; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_files (id, storage, filename_disk, filename_download, title, type, folder, uploaded_by, uploaded_on, modified_by, modified_on, charset, filesize, width, height, duration, embed, description, location, tags, metadata, focal_point_x, focal_point_y) FROM stdin;
5448e639-7980-49fe-b191-fb2b8871fcec	local	5448e639-7980-49fe-b191-fb2b8871fcec.jpeg	macarrones-con-queso.jpeg	Macarrones Con Queso	image/jpeg	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:34.028481+00	\N	2024-04-24 10:45:34.066+00	\N	98858	1000	750	\N	\N	\N	\N	\N	{}	\N	\N
1ed25831-f0b4-4838-ba3d-bfce8b45d748	local	1ed25831-f0b4-4838-ba3d-bfce8b45d748.jpg	macarrones_queso_2.jpg	Macarrones Queso 2	image/jpeg	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 10:45:56.25117+00	\N	2024-04-24 10:45:56.271+00	\N	10921	335	150	\N	\N	\N	\N	\N	{}	\N	\N
\.


--
-- Data for Name: directus_flows; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_flows (id, name, icon, color, description, status, trigger, accountability, options, operation, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_folders; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_folders (id, name, parent) FROM stdin;
\.


--
-- Data for Name: directus_migrations; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_migrations (version, name, "timestamp") FROM stdin;
20201028A	Remove Collection Foreign Keys	2024-04-24 07:59:34.534983+00
20201029A	Remove System Relations	2024-04-24 07:59:34.541337+00
20201029B	Remove System Collections	2024-04-24 07:59:34.550091+00
20201029C	Remove System Fields	2024-04-24 07:59:34.56001+00
20201105A	Add Cascade System Relations	2024-04-24 07:59:34.633449+00
20201105B	Change Webhook URL Type	2024-04-24 07:59:34.641+00
20210225A	Add Relations Sort Field	2024-04-24 07:59:34.648506+00
20210304A	Remove Locked Fields	2024-04-24 07:59:34.652921+00
20210312A	Webhooks Collections Text	2024-04-24 07:59:34.660625+00
20210331A	Add Refresh Interval	2024-04-24 07:59:34.665966+00
20210415A	Make Filesize Nullable	2024-04-24 07:59:34.674539+00
20210416A	Add Collections Accountability	2024-04-24 07:59:34.684153+00
20210422A	Remove Files Interface	2024-04-24 07:59:34.690242+00
20210506A	Rename Interfaces	2024-04-24 07:59:34.714514+00
20210510A	Restructure Relations	2024-04-24 07:59:34.761623+00
20210518A	Add Foreign Key Constraints	2024-04-24 07:59:34.780942+00
20210519A	Add System Fk Triggers	2024-04-24 07:59:34.827434+00
20210521A	Add Collections Icon Color	2024-04-24 07:59:34.832813+00
20210525A	Add Insights	2024-04-24 07:59:34.893489+00
20210608A	Add Deep Clone Config	2024-04-24 07:59:34.89864+00
20210626A	Change Filesize Bigint	2024-04-24 07:59:34.93803+00
20210716A	Add Conditions to Fields	2024-04-24 07:59:34.942544+00
20210721A	Add Default Folder	2024-04-24 07:59:34.952715+00
20210802A	Replace Groups	2024-04-24 07:59:34.962298+00
20210803A	Add Required to Fields	2024-04-24 07:59:34.969147+00
20210805A	Update Groups	2024-04-24 07:59:34.976206+00
20210805B	Change Image Metadata Structure	2024-04-24 07:59:34.986564+00
20210811A	Add Geometry Config	2024-04-24 07:59:34.991681+00
20210831A	Remove Limit Column	2024-04-24 07:59:34.99703+00
20210903A	Add Auth Provider	2024-04-24 07:59:35.031193+00
20210907A	Webhooks Collections Not Null	2024-04-24 07:59:35.040873+00
20210910A	Move Module Setup	2024-04-24 07:59:35.047507+00
20210920A	Webhooks URL Not Null	2024-04-24 07:59:35.058605+00
20210924A	Add Collection Organization	2024-04-24 07:59:35.068989+00
20210927A	Replace Fields Group	2024-04-24 07:59:35.083612+00
20210927B	Replace M2M Interface	2024-04-24 07:59:35.08798+00
20210929A	Rename Login Action	2024-04-24 07:59:35.092634+00
20211007A	Update Presets	2024-04-24 07:59:35.104451+00
20211009A	Add Auth Data	2024-04-24 07:59:35.109171+00
20211016A	Add Webhook Headers	2024-04-24 07:59:35.115359+00
20211103A	Set Unique to User Token	2024-04-24 07:59:35.127714+00
20211103B	Update Special Geometry	2024-04-24 07:59:35.132088+00
20211104A	Remove Collections Listing	2024-04-24 07:59:35.136481+00
20211118A	Add Notifications	2024-04-24 07:59:35.190745+00
20211211A	Add Shares	2024-04-24 07:59:35.237227+00
20211230A	Add Project Descriptor	2024-04-24 07:59:35.244199+00
20220303A	Remove Default Project Color	2024-04-24 07:59:35.254786+00
20220308A	Add Bookmark Icon and Color	2024-04-24 07:59:35.261248+00
20220314A	Add Translation Strings	2024-04-24 07:59:35.267315+00
20220322A	Rename Field Typecast Flags	2024-04-24 07:59:35.273881+00
20220323A	Add Field Validation	2024-04-24 07:59:35.280283+00
20220325A	Fix Typecast Flags	2024-04-24 07:59:35.287044+00
20220325B	Add Default Language	2024-04-24 07:59:35.301322+00
20220402A	Remove Default Value Panel Icon	2024-04-24 07:59:35.314787+00
20220429A	Add Flows	2024-04-24 07:59:35.428+00
20220429B	Add Color to Insights Icon	2024-04-24 07:59:35.432533+00
20220429C	Drop Non Null From IP of Activity	2024-04-24 07:59:35.437549+00
20220429D	Drop Non Null From Sender of Notifications	2024-04-24 07:59:35.441093+00
20220614A	Rename Hook Trigger to Event	2024-04-24 07:59:35.444939+00
20220801A	Update Notifications Timestamp Column	2024-04-24 07:59:35.453512+00
20220802A	Add Custom Aspect Ratios	2024-04-24 07:59:35.457697+00
20220826A	Add Origin to Accountability	2024-04-24 07:59:35.464671+00
20230401A	Update Material Icons	2024-04-24 07:59:35.479099+00
20230525A	Add Preview Settings	2024-04-24 07:59:35.484788+00
20230526A	Migrate Translation Strings	2024-04-24 07:59:35.517234+00
20230721A	Require Shares Fields	2024-04-24 07:59:35.526721+00
20230823A	Add Content Versioning	2024-04-24 07:59:35.573281+00
20230927A	Themes	2024-04-24 07:59:35.603568+00
20231009A	Update CSV Fields to Text	2024-04-24 07:59:35.60934+00
20231009B	Update Panel Options	2024-04-24 07:59:35.613971+00
20231010A	Add Extensions	2024-04-24 07:59:35.625664+00
20231215A	Add Focalpoints	2024-04-24 07:59:35.631268+00
\.


--
-- Data for Name: directus_notifications; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_notifications (id, "timestamp", status, recipient, sender, subject, message, collection, item) FROM stdin;
\.


--
-- Data for Name: directus_operations; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_operations (id, name, key, type, position_x, position_y, options, resolve, reject, flow, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_panels; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_panels (id, dashboard, name, icon, color, show_header, note, type, position_x, position_y, width, height, options, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_permissions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_permissions (id, role, collection, action, permissions, validation, presets, fields) FROM stdin;
1	d442c489-354a-4884-b239-9c9138853f39	directus_files	create	{}	\N	\N	*
2	d442c489-354a-4884-b239-9c9138853f39	directus_files	read	{}	\N	\N	*
3	d442c489-354a-4884-b239-9c9138853f39	directus_files	update	{}	\N	\N	*
4	d442c489-354a-4884-b239-9c9138853f39	directus_files	delete	{}	\N	\N	*
5	d442c489-354a-4884-b239-9c9138853f39	directus_dashboards	create	{}	\N	\N	*
6	d442c489-354a-4884-b239-9c9138853f39	directus_dashboards	read	{}	\N	\N	*
7	d442c489-354a-4884-b239-9c9138853f39	directus_dashboards	update	{}	\N	\N	*
8	d442c489-354a-4884-b239-9c9138853f39	directus_dashboards	delete	{}	\N	\N	*
9	d442c489-354a-4884-b239-9c9138853f39	directus_panels	create	{}	\N	\N	*
10	d442c489-354a-4884-b239-9c9138853f39	directus_panels	read	{}	\N	\N	*
11	d442c489-354a-4884-b239-9c9138853f39	directus_panels	update	{}	\N	\N	*
12	d442c489-354a-4884-b239-9c9138853f39	directus_panels	delete	{}	\N	\N	*
13	d442c489-354a-4884-b239-9c9138853f39	directus_folders	create	{}	\N	\N	*
14	d442c489-354a-4884-b239-9c9138853f39	directus_folders	read	{}	\N	\N	*
15	d442c489-354a-4884-b239-9c9138853f39	directus_folders	update	{}	\N	\N	*
16	d442c489-354a-4884-b239-9c9138853f39	directus_folders	delete	{}	\N	\N	\N
17	d442c489-354a-4884-b239-9c9138853f39	directus_users	read	{}	\N	\N	*
18	d442c489-354a-4884-b239-9c9138853f39	directus_users	update	{"id":{"_eq":"$CURRENT_USER"}}	\N	\N	first_name,last_name,email,password,location,title,description,avatar,language,appearance,theme_light,theme_dark,theme_light_overrides,theme_dark_overrides,tfa_secret
19	d442c489-354a-4884-b239-9c9138853f39	directus_roles	read	{}	\N	\N	*
20	d442c489-354a-4884-b239-9c9138853f39	directus_shares	read	{"_or":[{"role":{"_eq":"$CURRENT_ROLE"}},{"role":{"_null":true}}]}	\N	\N	*
21	d442c489-354a-4884-b239-9c9138853f39	directus_shares	create	{}	\N	\N	*
22	d442c489-354a-4884-b239-9c9138853f39	directus_shares	update	{"user_created":{"_eq":"$CURRENT_USER"}}	\N	\N	*
23	d442c489-354a-4884-b239-9c9138853f39	directus_shares	delete	{"user_created":{"_eq":"$CURRENT_USER"}}	\N	\N	*
24	d442c489-354a-4884-b239-9c9138853f39	directus_flows	read	{"trigger":{"_eq":"manual"}}	\N	\N	id,status,name,icon,color,options,trigger
25	d442c489-354a-4884-b239-9c9138853f39	recipes	create	{}	{}	\N	*
26	d442c489-354a-4884-b239-9c9138853f39	recipes	read	{}	{}	\N	*
27	d442c489-354a-4884-b239-9c9138853f39	recipes	update	{}	{}	\N	*
28	d442c489-354a-4884-b239-9c9138853f39	recipes	delete	{}	{}	\N	*
29	d442c489-354a-4884-b239-9c9138853f39	steps	create	{}	{}	\N	*
30	d442c489-354a-4884-b239-9c9138853f39	steps	read	{}	{}	\N	*
31	d442c489-354a-4884-b239-9c9138853f39	steps	update	{}	{}	\N	*
32	d442c489-354a-4884-b239-9c9138853f39	steps	delete	{}	{}	\N	*
33	d442c489-354a-4884-b239-9c9138853f39	categories	create	{}	{}	\N	*
34	d442c489-354a-4884-b239-9c9138853f39	categories	read	{}	{}	\N	*
35	d442c489-354a-4884-b239-9c9138853f39	categories	update	{}	{}	\N	*
36	d442c489-354a-4884-b239-9c9138853f39	categories	delete	{}	{}	\N	*
37	d442c489-354a-4884-b239-9c9138853f39	recipes_categories	create	{}	{}	\N	*
38	d442c489-354a-4884-b239-9c9138853f39	recipes_categories	read	{}	{}	\N	*
39	d442c489-354a-4884-b239-9c9138853f39	recipes_categories	update	{}	{}	\N	*
40	d442c489-354a-4884-b239-9c9138853f39	recipes_categories	delete	{}	{}	\N	*
41	\N	recipes	read	{}	{}	\N	*
42	\N	recipes	share	{}	{}	\N	*
43	\N	directus_users	create	{}	{}	\N	*
\.


--
-- Data for Name: directus_presets; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_presets (id, bookmark, "user", role, collection, search, layout, layout_query, layout_options, refresh_interval, filter, icon, color) FROM stdin;
8	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	macronutrients	\N	\N	{"tabular":{"fields":["macronutrient_id","name","quantity"]}}	{"tabular":{"widths":{"macronutrient_id":239}}}	\N	\N	bookmark	\N
2	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	users_followed	\N	\N	{"tabular":{"fields":["user_id","follower_id","follower_id.first_name"]}}	{"tabular":{"widths":{"user_id":327,"follower_id":345}}}	\N	\N	bookmark	\N
3	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	directus_activity	\N	tabular	{"tabular":{"sort":["-timestamp"],"fields":["action","collection","timestamp","user"],"page":1}}	{"tabular":{"widths":{"action":120,"collection":210,"timestamp":240,"user":240}}}	\N	\N	bookmark	\N
4	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	ingredients	\N	\N	{"tabular":{"fields":["name","macronutrients"]}}	{"tabular":{"widths":{"macronutrients":274}}}	\N	\N	bookmark	\N
9	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	directus_files	\N	cards	{"cards":{"sort":["-uploaded_on"],"page":1}}	{"cards":{"icon":"insert_drive_file","title":"{{ title }}","subtitle":"{{ type }} • {{ filesize }}","size":4,"imageFit":"crop"}}	\N	\N	bookmark	\N
5	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	recipes	\N	\N	{"tabular":{"fields":["title","description","difficulty","video"]}}	{"tabular":{"widths":{}}}	\N	\N	bookmark	\N
1	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	directus_users	\N	cards	{"cards":{"sort":["email"],"page":1}}	{"cards":{"icon":"account_circle","title":"{{ first_name }} {{ last_name }}","subtitle":"{{ email }}","size":4}}	\N	\N	bookmark	\N
6	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	comments	\N	\N	{"tabular":{"fields":["id","comment_id","comment","rating_comment","user_id"]}}	{"tabular":{"widths":{"id":275,"comment_id":354,"rating_comment":403,"user_id":399}}}	\N	\N	bookmark	\N
7	\N	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	\N	rating_recipes	\N	\N	{"tabular":{"fields":["id","user_id","valuation"]}}	{"tabular":{"widths":{"id":350}}}	\N	\N	bookmark	\N
\.


--
-- Data for Name: directus_relations; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_relations (id, many_collection, many_field, one_collection, one_field, one_collection_field, one_allowed_collections, junction_field, sort_field, one_deselect_action) FROM stdin;
1	recipes	user_created	directus_users	\N	\N	\N	\N	\N	nullify
5	users_followed	follower_id	directus_users	\N	\N	\N	\N	\N	nullify
6	recipes_categories	categories_id	categories	\N	\N	\N	recipes_id	\N	nullify
7	recipes_categories	recipes_id	recipes	categories	\N	\N	categories_id	\N	nullify
10	recipes_files	directus_files_id	directus_files	\N	\N	\N	recipes_id	\N	nullify
11	recipes_files	recipes_id	recipes	images	\N	\N	directus_files_id	\N	nullify
12	recipes_ingredients	ingredients_id	ingredients	\N	\N	\N	recipes_id	\N	nullify
13	recipes_ingredients	recipes_id	recipes	ingredients	\N	\N	ingredients_id	\N	nullify
14	macronutrients	macronutrient_id	ingredients	macronutrients	\N	\N	\N	\N	nullify
16	steps	steps_id	recipes	steps	\N	\N	\N	\N	nullify
18	comments	comment_id	recipes	comments	\N	\N	\N	\N	nullify
19	rating_comments	rating_comment_id	comments	rating_comment	\N	\N	\N	\N	nullify
20	rating_recipes	rating_recipes_id	recipes	rating_recipes	\N	\N	\N	\N	nullify
21	reports	report_id	comments	reports	\N	\N	\N	\N	nullify
\.


--
-- Data for Name: directus_revisions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_revisions (id, activity, collection, item, data, delta, parent, version) FROM stdin;
1	2	directus_fields	1	{"sort":1,"interface":"input","special":null,"required":true,"collection":"directus_users","field":"username"}	{"sort":1,"interface":"input","special":null,"required":true,"collection":"directus_users","field":"username"}	\N	\N
2	3	directus_fields	2	{"sort":2,"interface":"datetime","special":null,"collection":"directus_users","field":"birth_date"}	{"sort":2,"interface":"datetime","special":null,"collection":"directus_users","field":"birth_date"}	\N	\N
3	4	directus_fields	3	{"sort":3,"interface":"input","special":null,"collection":"directus_users","field":"phone_number"}	{"sort":3,"interface":"input","special":null,"collection":"directus_users","field":"phone_number"}	\N	\N
4	5	directus_fields	4	{"sort":4,"interface":"input","special":null,"collection":"directus_users","field":"town"}	{"sort":4,"interface":"input","special":null,"collection":"directus_users","field":"town"}	\N	\N
5	6	directus_fields	5	{"sort":5,"interface":"input","special":null,"collection":"directus_users","field":"municipality"}	{"sort":5,"interface":"input","special":null,"collection":"directus_users","field":"municipality"}	\N	\N
6	7	directus_fields	6	{"sort":6,"interface":"input","special":null,"collection":"directus_users","field":"street"}	{"sort":6,"interface":"input","special":null,"collection":"directus_users","field":"street"}	\N	\N
7	8	directus_fields	7	{"sort":7,"interface":"input","special":null,"collection":"directus_users","field":"zip_code"}	{"sort":7,"interface":"input","special":null,"collection":"directus_users","field":"zip_code"}	\N	\N
8	9	directus_fields	8	{"sort":8,"interface":"input","special":null,"collection":"directus_users","field":"twitter"}	{"sort":8,"interface":"input","special":null,"collection":"directus_users","field":"twitter"}	\N	\N
9	10	directus_fields	9	{"sort":9,"interface":"input","special":null,"collection":"directus_users","field":"facebook"}	{"sort":9,"interface":"input","special":null,"collection":"directus_users","field":"facebook"}	\N	\N
10	11	directus_fields	10	{"sort":10,"interface":"input","special":null,"collection":"directus_users","field":"youtube"}	{"sort":10,"interface":"input","special":null,"collection":"directus_users","field":"youtube"}	\N	\N
11	12	directus_fields	11	{"sort":11,"interface":"input","special":null,"collection":"directus_users","field":"instagram"}	{"sort":11,"interface":"input","special":null,"collection":"directus_users","field":"instagram"}	\N	\N
12	13	directus_fields	12	{"sort":12,"interface":"input","special":null,"collection":"directus_users","field":"tiktok"}	{"sort":12,"interface":"input","special":null,"collection":"directus_users","field":"tiktok"}	\N	\N
13	14	directus_fields	13	{"sort":13,"interface":"input","special":null,"required":true,"collection":"directus_users","field":"reputation"}	{"sort":13,"interface":"input","special":null,"required":true,"collection":"directus_users","field":"reputation"}	\N	\N
14	15	directus_fields	14	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"recipes"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"recipes"}	\N	\N
15	16	directus_fields	15	{"sort":2,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"recipes"}	{"sort":2,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created","collection":"recipes"}	\N	\N
16	17	directus_fields	16	{"sort":3,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"recipes"}	{"sort":3,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"recipes"}	\N	\N
17	18	directus_fields	17	{"sort":4,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"recipes"}	{"sort":4,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"recipes"}	\N	\N
18	19	directus_collections	recipes	{"singleton":false,"collection":"recipes"}	{"singleton":false,"collection":"recipes"}	\N	\N
19	20	directus_fields	18	{"sort":5,"interface":"input","special":null,"collection":"recipes","field":"title"}	{"sort":5,"interface":"input","special":null,"collection":"recipes","field":"title"}	\N	\N
20	21	directus_fields	19	{"sort":6,"interface":"input-rich-text-html","special":null,"collection":"recipes","field":"description"}	{"sort":6,"interface":"input-rich-text-html","special":null,"collection":"recipes","field":"description"}	\N	\N
21	22	directus_fields	20	{"sort":7,"interface":"input","special":null,"collection":"recipes","field":"video"}	{"sort":7,"interface":"input","special":null,"collection":"recipes","field":"video"}	\N	\N
22	23	directus_fields	21	{"sort":8,"interface":"select-dropdown","special":null,"options":{"choices":[{"text":"Easy","value":"easy"},{"text":"Medium","value":"medium"},{"text":"Hard","value":"hard"}]},"collection":"recipes","field":"difficulty"}	{"sort":8,"interface":"select-dropdown","special":null,"options":{"choices":[{"text":"Easy","value":"easy"},{"text":"Medium","value":"medium"},{"text":"Hard","value":"hard"}]},"collection":"recipes","field":"difficulty"}	\N	\N
23	24	directus_fields	22	{"sort":9,"interface":"input","special":null,"collection":"recipes","field":"preparation_time"}	{"sort":9,"interface":"input","special":null,"collection":"recipes","field":"preparation_time"}	\N	\N
24	25	directus_fields	23	{"sort":10,"interface":"input","special":null,"collection":"recipes","field":"calories"}	{"sort":10,"interface":"input","special":null,"collection":"recipes","field":"calories"}	\N	\N
25	26	directus_fields	24	{"sort":11,"interface":"input","special":null,"collection":"recipes","field":"cooking_time"}	{"sort":11,"interface":"input","special":null,"collection":"recipes","field":"cooking_time"}	\N	\N
26	27	directus_fields	25	{"sort":12,"interface":"input","special":null,"collection":"recipes","field":"portion_numbers"}	{"sort":12,"interface":"input","special":null,"collection":"recipes","field":"portion_numbers"}	\N	\N
27	28	directus_fields	26	{"sort":13,"interface":"boolean","special":["cast-boolean"],"required":true,"collection":"recipes","field":"api_inserted"}	{"sort":13,"interface":"boolean","special":["cast-boolean"],"required":true,"collection":"recipes","field":"api_inserted"}	\N	\N
28	29	directus_fields	27	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"categories"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"categories"}	\N	\N
29	30	directus_collections	categories	{"singleton":false,"collection":"categories"}	{"singleton":false,"collection":"categories"}	\N	\N
30	31	directus_fields	28	{"sort":2,"interface":"input","special":null,"collection":"categories","field":"name"}	{"sort":2,"interface":"input","special":null,"collection":"categories","field":"name"}	\N	\N
31	32	directus_fields	29	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"images"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"images"}	\N	\N
32	33	directus_fields	30	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"images"}	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"images"}	\N	\N
33	34	directus_fields	31	{"sort":3,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"images"}	{"sort":3,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"images"}	\N	\N
34	35	directus_collections	images	{"singleton":false,"collection":"images"}	{"singleton":false,"collection":"images"}	\N	\N
35	36	directus_fields	32	{"sort":4,"interface":"input","special":null,"collection":"images","field":"image"}	{"sort":4,"interface":"input","special":null,"collection":"images","field":"image"}	\N	\N
36	37	directus_fields	33	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"steps"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"steps"}	\N	\N
37	38	directus_collections	steps	{"singleton":false,"collection":"steps"}	{"singleton":false,"collection":"steps"}	\N	\N
38	39	directus_fields	34	{"sort":2,"interface":"input-rich-text-html","special":null,"collection":"steps","field":"instructions"}	{"sort":2,"interface":"input-rich-text-html","special":null,"collection":"steps","field":"instructions"}	\N	\N
39	40	directus_fields	35	{"sort":3,"interface":"input","special":null,"collection":"steps","field":"order"}	{"sort":3,"interface":"input","special":null,"collection":"steps","field":"order"}	\N	\N
40	41	directus_fields	36	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"ingredients"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"ingredients"}	\N	\N
41	42	directus_collections	ingredients	{"singleton":false,"collection":"ingredients"}	{"singleton":false,"collection":"ingredients"}	\N	\N
42	43	directus_fields	37	{"sort":2,"interface":"input","special":null,"collection":"ingredients","field":"name"}	{"sort":2,"interface":"input","special":null,"collection":"ingredients","field":"name"}	\N	\N
43	44	directus_fields	37	{"id":37,"collection":"ingredients","field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"ingredients","field":"name","required":true}	\N	\N
44	45	directus_fields	38	{"sort":3,"interface":"input","special":null,"collection":"ingredients","field":"macronutrients"}	{"sort":3,"interface":"input","special":null,"collection":"ingredients","field":"macronutrients"}	\N	\N
45	46	directus_fields	39	{"sort":4,"interface":"input","special":null,"collection":"ingredients","field":"micronutrients"}	{"sort":4,"interface":"input","special":null,"collection":"ingredients","field":"micronutrients"}	\N	\N
46	47	directus_fields	40	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"rating_comments"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"rating_comments"}	\N	\N
47	48	directus_fields	41	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"rating_comments"}	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"rating_comments"}	\N	\N
48	49	directus_collections	rating_comments	{"singleton":false,"collection":"rating_comments"}	{"singleton":false,"collection":"rating_comments"}	\N	\N
49	50	directus_fields	42	{"sort":3,"interface":"input-rich-text-html","special":null,"collection":"rating_comments","field":"valuation"}	{"sort":3,"interface":"input-rich-text-html","special":null,"collection":"rating_comments","field":"valuation"}	\N	\N
50	51	directus_fields	43	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"rating_recipes"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"rating_recipes"}	\N	\N
51	52	directus_fields	44	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"rating_recipes"}	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"rating_recipes"}	\N	\N
52	53	directus_collections	rating_recipes	{"singleton":false,"collection":"rating_recipes"}	{"singleton":false,"collection":"rating_recipes"}	\N	\N
53	54	directus_fields	45	{"sort":2,"interface":"input","special":null,"collection":"rating_recipes","field":"valuation"}	{"sort":2,"interface":"input","special":null,"collection":"rating_recipes","field":"valuation"}	\N	\N
54	55	directus_fields	46	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"comments"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"comments"}	\N	\N
55	56	directus_fields	47	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"comments"}	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"comments"}	\N	\N
524	549	directus_fields	115	{"sort":6,"interface":"input","special":["user-created"],"collection":"reports","field":"user_id"}	{"sort":6,"interface":"input","special":["user-created"],"collection":"reports","field":"user_id"}	\N	\N
56	57	directus_fields	48	{"sort":3,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"comments"}	{"sort":3,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated","collection":"comments"}	\N	\N
57	58	directus_collections	comments	{"singleton":false,"collection":"comments"}	{"singleton":false,"collection":"comments"}	\N	\N
58	59	directus_fields	49	{"sort":4,"interface":"input-rich-text-html","special":null,"collection":"comments","field":"comment"}	{"sort":4,"interface":"input-rich-text-html","special":null,"collection":"comments","field":"comment"}	\N	\N
59	60	directus_fields	50	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"reports"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"reports"}	\N	\N
60	61	directus_fields	51	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"reports"}	{"sort":2,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created","collection":"reports"}	\N	\N
61	62	directus_collections	reports	{"singleton":false,"collection":"reports"}	{"singleton":false,"collection":"reports"}	\N	\N
62	63	directus_fields	52	{"sort":3,"interface":"input-rich-text-html","special":null,"collection":"reports","field":"report"}	{"sort":3,"interface":"input-rich-text-html","special":null,"collection":"reports","field":"report"}	\N	\N
63	64	directus_fields	53	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"users_followed"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"users_followed"}	\N	\N
64	65	directus_collections	users_followed	{"singleton":false,"collection":"users_followed"}	{"singleton":false,"collection":"users_followed"}	\N	\N
65	66	directus_fields	54	{"sort":2,"interface":"input","special":null,"required":true,"collection":"users_followed","field":"follower_id"}	{"sort":2,"interface":"input","special":null,"required":true,"collection":"users_followed","field":"follower_id"}	\N	\N
66	67	directus_fields	55	{"sort":14,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"directus_users","field":"follower_id"}	{"sort":14,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"directus_users","field":"follower_id"}	\N	\N
67	68	directus_fields	56	{"sort":3,"interface":"input","special":["user-created"],"collection":"users_followed","field":"user_id"}	{"sort":3,"interface":"input","special":["user-created"],"collection":"users_followed","field":"user_id"}	\N	\N
68	69	directus_fields	53	{"id":53,"collection":"users_followed","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"users_followed","field":"id","sort":1,"group":null}	\N	\N
69	70	directus_fields	56	{"id":56,"collection":"users_followed","field":"user_id","special":["user-created"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"users_followed","field":"user_id","sort":2,"group":null}	\N	\N
70	71	directus_fields	54	{"id":54,"collection":"users_followed","field":"follower_id","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"users_followed","field":"follower_id","sort":3,"group":null}	\N	\N
71	72	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
72	73	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"rating_recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"rating_recipes"}	\N	\N
73	74	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
74	75	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
75	76	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
76	77	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
330	339	recipes_files	1	{"recipes_id":"56c32335-6624-4f24-908a-4091faf5a0d5","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}	{"recipes_id":"56c32335-6624-4f24-908a-4091faf5a0d5","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}	332	\N
77	78	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
78	79	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
79	80	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
80	81	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
81	82	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
82	83	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
83	84	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
84	85	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
85	86	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
86	87	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
87	88	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
88	89	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
89	90	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
90	91	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":10,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":10,"group":null}	\N	\N
91	92	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
92	93	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
331	340	recipes_files	2	{"recipes_id":"56c32335-6624-4f24-908a-4091faf5a0d5","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}}	{"recipes_id":"56c32335-6624-4f24-908a-4091faf5a0d5","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}}	332	\N
93	94	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
94	95	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
95	96	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
96	97	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
97	98	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
98	99	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
99	100	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
100	101	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":10,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":10,"group":null}	\N	\N
101	103	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"rating_recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"rating_recipes"}	\N	\N
102	102	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
103	104	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
104	105	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
105	106	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
106	107	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
107	108	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
108	109	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
109	110	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
110	111	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
111	112	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
112	113	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
113	114	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
114	115	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
115	116	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
116	117	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
117	118	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
338	348	directus_fields	81	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"macronutrients"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id","collection":"macronutrients"}	\N	\N
118	119	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
119	120	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
120	121	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":10,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":10,"group":null}	\N	\N
121	122	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
122	123	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
123	124	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
124	125	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
125	126	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
126	127	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
127	128	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
128	129	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
129	130	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
130	131	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
131	132	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
132	133	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"categories","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"categories"}	\N	\N
133	134	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
339	349	directus_collections	macronutrients	{"singleton":false,"collection":"macronutrients"}	{"singleton":false,"collection":"macronutrients"}	\N	\N
134	135	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
135	136	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
136	137	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
137	138	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
138	139	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
139	140	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
144	145	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
146	147	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
148	149	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":"recipes"}	\N	\N
154	155	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
156	157	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
159	159	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":"recipes"}	\N	\N
160	162	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":"recipes"}	\N	\N
174	175	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
175	176	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
176	177	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":"recipes"}	\N	\N
340	350	directus_fields	82	{"sort":2,"interface":"input","special":null,"collection":"macronutrients","field":"name"}	{"sort":2,"interface":"input","special":null,"collection":"macronutrients","field":"name"}	\N	\N
140	141	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
141	142	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
142	143	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
143	144	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
145	146	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
147	148	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
149	150	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
150	151	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
151	152	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
152	153	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
153	154	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
155	156	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
157	158	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
158	160	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
161	161	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
162	163	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
341	351	directus_fields	83	{"sort":3,"interface":"input","special":null,"required":true,"collection":"macronutrients","field":"quantity"}	{"sort":3,"interface":"input","special":null,"required":true,"collection":"macronutrients","field":"quantity"}	\N	\N
163	164	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
165	166	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
166	167	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
168	169	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":"recipes"}	\N	\N
170	171	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":"recipes"}	\N	\N
172	173	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":"recipes"}	\N	\N
164	165	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
167	168	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
169	170	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
171	172	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
173	174	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
177	178	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":"recipes"}	\N	\N
178	179	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":"recipes"}	\N	\N
179	180	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
180	181	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"comments","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"comments"}	\N	\N
181	182	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
182	183	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
183	184	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
184	186	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
185	185	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"comments","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"comments"}	\N	\N
186	188	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"comments","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"comments"}	\N	\N
187	187	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
188	189	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
189	190	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
190	191	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
191	192	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
192	193	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
193	194	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":"recipes"}	\N	\N
194	195	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":"recipes"}	\N	\N
195	196	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":"recipes"}	\N	\N
196	197	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":"recipes"}	\N	\N
197	198	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
199	200	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
198	199	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
200	201	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
201	202	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
202	203	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":"recipes"}	\N	\N
203	204	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":"recipes"}	\N	\N
204	205	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":"recipes"}	\N	\N
205	206	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
206	207	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"images","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"images"}	\N	\N
207	208	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
208	209	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":"recipes"}	\N	\N
209	210	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":"recipes"}	\N	\N
210	211	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
211	212	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
212	213	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
213	214	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
214	215	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
215	216	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
216	217	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
217	218	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
218	219	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
219	220	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
220	221	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
221	222	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":"recipes"}	\N	\N
222	223	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
224	225	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
223	224	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
225	226	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
226	227	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":"recipes"}	\N	\N
227	228	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
228	229	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
229	230	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
230	231	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
231	232	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"recipes","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"recipes"}	\N	\N
232	233	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
233	234	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
234	235	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
235	236	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
236	237	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
237	238	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
238	240	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":"comments","collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":"comments"}	\N	\N
239	239	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
240	241	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
241	242	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
242	243	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
243	244	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
244	245	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
245	246	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
246	247	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
247	248	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
248	249	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
249	250	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
250	251	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
251	252	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
252	253	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
253	254	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
254	255	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
342	352	directus_fields	82	{"id":82,"collection":"macronutrients","field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"name","required":true}	\N	\N
255	256	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
256	257	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
257	258	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
258	259	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
259	260	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
260	261	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
261	262	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
262	263	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
263	264	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
264	265	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
265	266	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":10,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":10,"group":null}	\N	\N
266	267	directus_collections	recipes	{"collection":"recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":1,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":1,"group":null}	\N	\N
267	268	directus_collections	rating_recipes	{"collection":"rating_recipes","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":2,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":2,"group":null}	\N	\N
268	269	directus_collections	reports	{"collection":"reports","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":3,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":3,"group":null}	\N	\N
269	270	directus_collections	rating_comments	{"collection":"rating_comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":4,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":4,"group":null}	\N	\N
270	271	directus_collections	comments	{"collection":"comments","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":5,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":5,"group":null}	\N	\N
343	353	directus_fields	84	{"sort":4,"interface":"input","special":["uuid"],"collection":"macronutrients","field":"macronutrient_id"}	{"sort":4,"interface":"input","special":["uuid"],"collection":"macronutrients","field":"macronutrient_id"}	\N	\N
271	272	directus_collections	steps	{"collection":"steps","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":6,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":6,"group":null}	\N	\N
272	273	directus_collections	ingredients	{"collection":"ingredients","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":7,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":7,"group":null}	\N	\N
273	274	directus_collections	categories	{"collection":"categories","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":8,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":8,"group":null}	\N	\N
274	275	directus_collections	images	{"collection":"images","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":9,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":9,"group":null}	\N	\N
275	276	directus_collections	users_followed	{"collection":"users_followed","icon":null,"note":null,"display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":null,"archive_app_filter":true,"archive_value":null,"unarchive_value":null,"sort_field":null,"accountability":"all","color":null,"item_duplication_fields":null,"sort":10,"group":null,"collapse":"open","preview_url":null,"versioning":false}	{"sort":10,"group":null}	\N	\N
276	277	recipes	dbb73b63-b531-476b-9069-124ad96707d5	{"title":"Titulo de prueba","description":"<p>Descripcion de prueba</p>","video":"http://videoprueba.com","difficulty":"medium","preparation_time":30,"portion_numbers":3,"cooking_time":40,"calories":555}	{"title":"Titulo de prueba","description":"<p>Descripcion de prueba</p>","video":"http://videoprueba.com","difficulty":"medium","preparation_time":30,"portion_numbers":3,"cooking_time":40,"calories":555}	\N	\N
277	279	categories	c2a859e7-cf51-4295-afed-197c3d4a5e8e	{"name":"Entrantes"}	{"name":"Entrantes"}	\N	\N
278	280	categories	3804069d-68e8-4d7a-be43-f30d0faba482	{"name":"Platos principales"}	{"name":"Platos principales"}	\N	\N
279	281	categories	14174f77-7e4b-4e93-b899-4e2edc7c1c34	{"name":"Guarniciones"}	{"name":"Guarniciones"}	\N	\N
280	282	categories	e061a50f-b291-4393-ae24-2ad93591fe2c	{"name":"Postres"}	{"name":"Postres"}	\N	\N
281	283	directus_fields	57	{"sort":3,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"collection":"users_followed","field":"follower_id"}	{"sort":3,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"collection":"users_followed","field":"follower_id"}	\N	\N
282	284	directus_users	01d5b8e7-3081-4dc7-8db5-4e3cb1585d9b	{"first_name":"Test Name","last_name":"Test Last Name","email":"test@example.com","password":"**********","description":"Test description...","username":"test1","birth_date":"2024-04-24","phone_number":"631182588","town":"Murcia","municipality":"Murcia","street":"Calle test 123","zip_code":"30006"}	{"first_name":"Test Name","last_name":"Test Last Name","email":"test@example.com","password":"**********","description":"Test description...","username":"test1","birth_date":"2024-04-24","phone_number":"631182588","town":"Murcia","municipality":"Murcia","street":"Calle test 123","zip_code":"30006"}	\N	\N
283	285	users_followed	191af4d4-8949-4050-b5f1-1ba7dfe717ec	{"follower_id":"01d5b8e7-3081-4dc7-8db5-4e3cb1585d9b"}	{"follower_id":"01d5b8e7-3081-4dc7-8db5-4e3cb1585d9b"}	\N	\N
284	287	directus_fields	58	{"sort":3,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"users_followed","field":"follower_id"}	{"sort":3,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"users_followed","field":"follower_id"}	\N	\N
285	288	directus_fields	59	{"sort":3,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"collection":"users_followed","field":"follower_id"}	{"sort":3,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"collection":"users_followed","field":"follower_id"}	\N	\N
286	289	directus_fields	60	{"sort":14,"interface":"input","special":["user-created"],"collection":"directus_users","field":"user_id"}	{"sort":14,"interface":"input","special":["user-created"],"collection":"directus_users","field":"user_id"}	\N	\N
287	290	directus_fields	61	{"sort":3,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"users_followed","field":"follower_id"}	{"sort":3,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"users_followed","field":"follower_id"}	\N	\N
293	296	users_followed	94d6a66e-95ff-4834-a9a2-0a355a2cef7c	{"follower_id":{"create":[],"update":[{"user_id":"+","id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}],"delete":[]},"user_id":"3453453453"}	{"follower_id":{"create":[],"update":[{"user_id":"+","id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}],"delete":[]},"user_id":"3453453453"}	\N	\N
292	295	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	{"id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","first_name":"Admin","last_name":"User","email":"admin@example.com","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"525a4819-e516-42c3-82bb-33558d3e82b4","token":null,"last_access":"2024-04-24T10:16:15.103Z","last_page":"/content/users_followed/+","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"username":null,"birth_date":null,"phone_number":null,"town":null,"municipality":null,"street":null,"zip_code":null,"twitter":null,"facebook":null,"youtube":null,"instagram":null,"tiktok":null,"reputation":0,"user_id":"94d6a66e-95ff-4834-a9a2-0a355a2cef7c"}	{"user_id":"94d6a66e-95ff-4834-a9a2-0a355a2cef7c"}	293	\N
294	297	directus_fields	56	{"id":56,"collection":"users_followed","field":"user_id","special":["user-created","user-updated"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"users_followed","field":"user_id","special":["user-created","user-updated"]}	\N	\N
295	298	directus_fields	62	{"sort":3,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"collection":"users_followed","field":"follower_id"}	{"sort":3,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"collection":"users_followed","field":"follower_id"}	\N	\N
296	300	users_followed	79a070ce-8be1-4de8-9eb1-caaeb4da08b1	{"follower_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}	{"follower_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}	\N	\N
297	301	users_followed	0516b6cb-cd98-4f80-843a-d04a033c44ac	{"follower_id":"01d5b8e7-3081-4dc7-8db5-4e3cb1585d9b"}	{"follower_id":"01d5b8e7-3081-4dc7-8db5-4e3cb1585d9b"}	\N	\N
298	302	directus_fields	60	{"id":60,"collection":"directus_users","field":"user_id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"directus_users","field":"user_id","special":["uuid"]}	\N	\N
299	305	directus_users	df91c1bb-8443-41c2-aa02-566f08631e04	{"first_name":"Test2","last_name":"Test2","email":"test2@example.com","password":"**********","description":"Test2 description...","username":"test2","birth_date":"2024-04-24","phone_number":"666555444"}	{"first_name":"Test2","last_name":"Test2","email":"test2@example.com","password":"**********","description":"Test2 description...","username":"test2","birth_date":"2024-04-24","phone_number":"666555444"}	\N	\N
300	306	directus_fields	63	{"sort":14,"interface":"input","special":["uuid"],"collection":"directus_users","field":"user_id"}	{"sort":14,"interface":"input","special":["uuid"],"collection":"directus_users","field":"user_id"}	\N	\N
301	307	directus_users	b7f3a7af-4407-429a-9e25-03412b8b6515	{"first_name":"Test3","last_name":"Test3","email":"test3@example.com","password":"**********","description":"Test3 description..","username":"test3","birth_date":"2024-04-24","phone_number":"654789568"}	{"first_name":"Test3","last_name":"Test3","email":"test3@example.com","password":"**********","description":"Test3 description..","username":"test3","birth_date":"2024-04-24","phone_number":"654789568"}	\N	\N
302	310	users_followed	5d2311ba-e16d-41c9-aba6-35b214248bd5	{"follower_id":"b7f3a7af-4407-429a-9e25-03412b8b6515"}	{"follower_id":"b7f3a7af-4407-429a-9e25-03412b8b6515"}	\N	\N
303	311	users_followed	826e0729-ccee-4247-8e28-e7775fe11550	{"follower_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}	{"follower_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}	\N	\N
304	312	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	{"first_name":"Sergio","last_name":"Sáez","email":"sergio@example.com","password":"**********","description":"Descripción de Sergio...","username":"sergio97","birth_date":"1997-03-27","phone_number":"631182588","town":"Murcia","municipality":"Murcia","street":"Calle Claveles 12","zip_code":"30006"}	{"first_name":"Sergio","last_name":"Sáez","email":"sergio@example.com","password":"**********","description":"Descripción de Sergio...","username":"sergio97","birth_date":"1997-03-27","phone_number":"631182588","town":"Murcia","municipality":"Murcia","street":"Calle Claveles 12","zip_code":"30006"}	\N	\N
305	313	users_followed	625df489-026b-4dee-addd-94748e14c81a	{"follower_id":"ff289b86-09b5-4f1e-b31b-df77c3a0d7b8"}	{"follower_id":"ff289b86-09b5-4f1e-b31b-df77c3a0d7b8"}	\N	\N
306	314	directus_fields	64	{"sort":14,"interface":"list-m2m","special":["m2m"],"required":true,"collection":"recipes","field":"categories"}	{"sort":14,"interface":"list-m2m","special":["m2m"],"required":true,"collection":"recipes","field":"categories"}	\N	\N
307	315	directus_fields	65	{"sort":1,"hidden":true,"field":"id","collection":"recipes_categories"}	{"sort":1,"hidden":true,"field":"id","collection":"recipes_categories"}	\N	\N
308	316	directus_collections	recipes_categories	{"hidden":true,"icon":"import_export","collection":"recipes_categories"}	{"hidden":true,"icon":"import_export","collection":"recipes_categories"}	\N	\N
309	317	directus_fields	66	{"sort":2,"hidden":true,"collection":"recipes_categories","field":"recipes_id"}	{"sort":2,"hidden":true,"collection":"recipes_categories","field":"recipes_id"}	\N	\N
310	318	directus_fields	67	{"sort":3,"hidden":true,"collection":"recipes_categories","field":"categories_id"}	{"sort":3,"hidden":true,"collection":"recipes_categories","field":"categories_id"}	\N	\N
311	319	recipes_categories	1	{"recipes_id":"9e96d043-77b8-492f-aaa2-ed3e362e465c","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	{"recipes_id":"9e96d043-77b8-492f-aaa2-ed3e362e465c","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	314	\N
344	354	directus_fields	85	{"sort":3,"interface":"list-o2m","special":["o2m"],"collection":"ingredients","field":"macronutrients"}	{"sort":3,"interface":"list-o2m","special":["o2m"],"collection":"ingredients","field":"macronutrients"}	\N	\N
314	322	recipes	9e96d043-77b8-492f-aaa2-ed3e362e465c	{"title":"test1","description":"<p>test1</p>","video":"VIDEO_URL","difficulty":"easy","preparation_time":30,"calories":560,"cooking_time":60,"portion_numbers":4,"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}},{"recipes_id":"+","categories_id":{"id":"c2a859e7-cf51-4295-afed-197c3d4a5e8e"}}],"update":[],"delete":[]}}	{"title":"test1","description":"<p>test1</p>","video":"VIDEO_URL","difficulty":"easy","preparation_time":30,"calories":560,"cooking_time":60,"portion_numbers":4,"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}},{"recipes_id":"+","categories_id":{"id":"c2a859e7-cf51-4295-afed-197c3d4a5e8e"}}],"update":[],"delete":[]}}	\N	\N
312	320	recipes_categories	2	{"recipes_id":"9e96d043-77b8-492f-aaa2-ed3e362e465c","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	{"recipes_id":"9e96d043-77b8-492f-aaa2-ed3e362e465c","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	314	\N
313	321	recipes_categories	3	{"recipes_id":"9e96d043-77b8-492f-aaa2-ed3e362e465c","categories_id":{"id":"c2a859e7-cf51-4295-afed-197c3d4a5e8e"}}	{"recipes_id":"9e96d043-77b8-492f-aaa2-ed3e362e465c","categories_id":{"id":"c2a859e7-cf51-4295-afed-197c3d4a5e8e"}}	314	\N
315	324	directus_fields	68	{"sort":4,"interface":"file-image","special":["file"],"required":true,"collection":"images","field":"image"}	{"sort":4,"interface":"file-image","special":["file"],"required":true,"collection":"images","field":"image"}	\N	\N
316	325	directus_fields	69	{"sort":15,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"images"}	{"sort":15,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"images"}	\N	\N
317	326	directus_fields	70	{"sort":15,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"recipes","field":"image_id"}	{"sort":15,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"recipes","field":"image_id"}	\N	\N
318	327	directus_fields	29	{"id":29,"collection":"images","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":false,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"images","field":"id","hidden":false}	\N	\N
319	328	directus_fields	71	{"sort":5,"interface":"input","special":["uuid"],"collection":"images","field":"image_id"}	{"sort":5,"interface":"input","special":["uuid"],"collection":"images","field":"image_id"}	\N	\N
320	329	directus_fields	72	{"sort":15,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"images"}	{"sort":15,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"images"}	\N	\N
321	330	directus_fields	73	{"sort":15,"interface":"files","special":["files"],"display":null,"collection":"recipes","field":"images"}	{"sort":15,"interface":"files","special":["files"],"display":null,"collection":"recipes","field":"images"}	\N	\N
322	331	directus_fields	74	{"sort":1,"hidden":true,"field":"id","collection":"recipes_files"}	{"sort":1,"hidden":true,"field":"id","collection":"recipes_files"}	\N	\N
323	332	directus_collections	recipes_files	{"hidden":true,"icon":"import_export","collection":"recipes_files"}	{"hidden":true,"icon":"import_export","collection":"recipes_files"}	\N	\N
324	333	directus_fields	75	{"sort":2,"hidden":true,"collection":"recipes_files","field":"recipes_id"}	{"sort":2,"hidden":true,"collection":"recipes_files","field":"recipes_id"}	\N	\N
325	334	directus_fields	76	{"sort":3,"hidden":true,"collection":"recipes_files","field":"directus_files_id"}	{"sort":3,"hidden":true,"collection":"recipes_files","field":"directus_files_id"}	\N	\N
326	335	directus_files	5448e639-7980-49fe-b191-fb2b8871fcec	{"title":"Macarrones Con Queso","filename_download":"macarrones-con-queso.jpeg","type":"image/jpeg","storage":"local"}	{"title":"Macarrones Con Queso","filename_download":"macarrones-con-queso.jpeg","type":"image/jpeg","storage":"local"}	\N	\N
327	336	directus_files	1ed25831-f0b4-4838-ba3d-bfce8b45d748	{"title":"Macarrones Queso 2","filename_download":"macarrones_queso_2.jpg","type":"image/jpeg","storage":"local"}	{"title":"Macarrones Queso 2","filename_download":"macarrones_queso_2.jpg","type":"image/jpeg","storage":"local"}	\N	\N
332	341	recipes	56c32335-6624-4f24-908a-4091faf5a0d5	{"title":"asdasda","description":"<p>dasdasdas</p>","video":"awsdasdas","difficulty":"easy","preparation_time":30,"calories":564,"cooking_time":60,"portion_numbers":3,"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}],"update":[],"delete":[]},"images":{"create":[{"recipes_id":"+","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}},{"recipes_id":"+","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}}],"update":[],"delete":[]}}	{"title":"asdasda","description":"<p>dasdasdas</p>","video":"awsdasdas","difficulty":"easy","preparation_time":30,"calories":564,"cooking_time":60,"portion_numbers":3,"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}],"update":[],"delete":[]},"images":{"create":[{"recipes_id":"+","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}},{"recipes_id":"+","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}}],"update":[],"delete":[]}}	\N	\N
328	337	recipes_categories	4	{"recipes_id":"56c32335-6624-4f24-908a-4091faf5a0d5","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	{"recipes_id":"56c32335-6624-4f24-908a-4091faf5a0d5","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	332	\N
329	338	recipes_categories	5	{"recipes_id":"56c32335-6624-4f24-908a-4091faf5a0d5","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	{"recipes_id":"56c32335-6624-4f24-908a-4091faf5a0d5","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	332	\N
333	343	directus_fields	77	{"sort":16,"interface":"list-m2m","special":["m2m"],"collection":"recipes","field":"ingredients"}	{"sort":16,"interface":"list-m2m","special":["m2m"],"collection":"recipes","field":"ingredients"}	\N	\N
334	344	directus_fields	78	{"sort":1,"hidden":true,"field":"id","collection":"recipes_ingredients"}	{"sort":1,"hidden":true,"field":"id","collection":"recipes_ingredients"}	\N	\N
335	345	directus_collections	recipes_ingredients	{"hidden":true,"icon":"import_export","collection":"recipes_ingredients"}	{"hidden":true,"icon":"import_export","collection":"recipes_ingredients"}	\N	\N
336	346	directus_fields	79	{"sort":2,"hidden":true,"collection":"recipes_ingredients","field":"recipes_id"}	{"sort":2,"hidden":true,"collection":"recipes_ingredients","field":"recipes_id"}	\N	\N
337	347	directus_fields	80	{"sort":3,"hidden":true,"collection":"recipes_ingredients","field":"ingredients_id"}	{"sort":3,"hidden":true,"collection":"recipes_ingredients","field":"ingredients_id"}	\N	\N
357	367	ingredients	c868ba45-670d-432d-ac4b-7d9d7351ed03	{"name":"Patata","macronutrients":{"create":[{"name":"Carbohidratos","quantity":17},{"name":"Proteínas","quantity":2},{"name":"Grasas","quantity":1}],"update":[],"delete":[]}}	{"name":"Patata","macronutrients":{"create":[{"name":"Carbohidratos","quantity":17},{"name":"Proteínas","quantity":2},{"name":"Grasas","quantity":1}],"update":[],"delete":[]}}	\N	\N
354	364	macronutrients	821168c8-b40b-4184-bd00-d067166ca1b9	{"name":"Carbohidratos","quantity":17,"macronutrient_id":"c868ba45-670d-432d-ac4b-7d9d7351ed03"}	{"name":"Carbohidratos","quantity":17,"macronutrient_id":"c868ba45-670d-432d-ac4b-7d9d7351ed03"}	357	\N
355	365	macronutrients	bd3b3a32-b50c-4301-a3dd-804e18b7fede	{"name":"Proteínas","quantity":2,"macronutrient_id":"c868ba45-670d-432d-ac4b-7d9d7351ed03"}	{"name":"Proteínas","quantity":2,"macronutrient_id":"c868ba45-670d-432d-ac4b-7d9d7351ed03"}	357	\N
356	366	macronutrients	2d8b9fbb-22cf-4830-9656-5328dc1e4455	{"name":"Grasas","quantity":1,"macronutrient_id":"c868ba45-670d-432d-ac4b-7d9d7351ed03"}	{"name":"Grasas","quantity":1,"macronutrient_id":"c868ba45-670d-432d-ac4b-7d9d7351ed03"}	357	\N
358	372	directus_fields	86	{"sort":5,"interface":"input","special":null,"required":true,"collection":"macronutrients","field":"quantity"}	{"sort":5,"interface":"input","special":null,"required":true,"collection":"macronutrients","field":"quantity"}	\N	\N
359	373	directus_fields	81	{"id":81,"collection":"macronutrients","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"id","sort":1,"group":null}	\N	\N
360	374	directus_fields	82	{"id":82,"collection":"macronutrients","field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"name","sort":2,"group":null}	\N	\N
361	375	directus_fields	86	{"id":86,"collection":"macronutrients","field":"quantity","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"quantity","sort":3,"group":null}	\N	\N
362	376	directus_fields	84	{"id":84,"collection":"macronutrients","field":"macronutrient_id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"macronutrient_id","sort":4,"group":null}	\N	\N
363	377	ingredients	540b300c-fb17-4363-b233-2ef352f7eb6f	{"name":"Patata"}	{"name":"Patata"}	\N	\N
364	378	macronutrients	4d41d9b7-77ba-41ba-8374-5c423c1d4ab8	{"name":"Grasas","quantity":0.1,"macronutrient_id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}	{"name":"Grasas","quantity":0.1,"macronutrient_id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}	\N	\N
365	379	macronutrients	9f6a8ec3-0473-4d56-9824-88b4d25db08a	{"name":"Carbohidratos","quantity":17,"macronutrient_id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}	{"name":"Carbohidratos","quantity":17,"macronutrient_id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}	\N	\N
366	380	macronutrients	1f85e0fc-0e11-4f77-b86e-84c1d0dc1788	{"name":"Proteínas","quantity":2,"macronutrient_id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}	{"name":"Proteínas","quantity":2,"macronutrient_id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}	\N	\N
367	382	directus_fields	87	{"sort":4,"interface":"input","special":null,"collection":"recipes_ingredients","field":"quantity"}	{"sort":4,"interface":"input","special":null,"collection":"recipes_ingredients","field":"quantity"}	\N	\N
368	383	directus_fields	88	{"sort":5,"interface":"select-dropdown","special":null,"options":{"choices":[{"text":"Gramos","value":"g"},{"text":"Kilogramos","value":"kg"},{"text":"Litros","value":"l"},{"text":"Mililitros","value":"ml"},{"text":"Unidades","value":"unidad"},{"text":"Cucharadas","value":"cucharada"},{"text":"Cucharadita","value":"cucharadita"},{"text":"Tazas","value":"taza"}]},"required":true,"collection":"recipes_ingredients","field":"measure_unit"}	{"sort":5,"interface":"select-dropdown","special":null,"options":{"choices":[{"text":"Gramos","value":"g"},{"text":"Kilogramos","value":"kg"},{"text":"Litros","value":"l"},{"text":"Mililitros","value":"ml"},{"text":"Unidades","value":"unidad"},{"text":"Cucharadas","value":"cucharada"},{"text":"Cucharadita","value":"cucharadita"},{"text":"Tazas","value":"taza"}]},"required":true,"collection":"recipes_ingredients","field":"measure_unit"}	\N	\N
369	384	directus_fields	87	{"id":87,"collection":"recipes_ingredients","field":"quantity","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"recipes_ingredients","field":"quantity","required":true}	\N	\N
375	390	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	{"title":"asdasd","description":"<p>dasdasdasd</p>","ingredients":{"create":[{"recipes_id":"+","ingredients_id":{"id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}}],"update":[],"delete":[]},"video":"asxcascas","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":60,"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}],"update":[],"delete":[]},"images":{"create":[{"recipes_id":"+","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}},{"recipes_id":"+","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}],"update":[],"delete":[]}}	{"title":"asdasd","description":"<p>dasdasdasd</p>","ingredients":{"create":[{"recipes_id":"+","ingredients_id":{"id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}}],"update":[],"delete":[]},"video":"asxcascas","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":60,"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}],"update":[],"delete":[]},"images":{"create":[{"recipes_id":"+","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}},{"recipes_id":"+","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}],"update":[],"delete":[]}}	\N	\N
370	385	recipes_categories	6	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	375	\N
371	386	recipes_categories	7	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	375	\N
372	387	recipes_files	3	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}}	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}}	375	\N
373	388	recipes_files	4	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}	375	\N
374	389	recipes_ingredients	1	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","ingredients_id":{"id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}}	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","ingredients_id":{"id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}}	375	\N
377	392	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	{"id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T11:22:56.788Z","date_updated":"2024-04-24T11:23:11.903Z","title":"asdasd","description":"<p>dasdasdasd</p>","video":"asxcascas","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":60,"portion_numbers":null,"api_inserted":false,"images":[3,4],"categories":[6,7],"ingredients":[1]}	{"date_updated":"2024-04-24T11:23:11.903Z"}	\N	\N
376	391	recipes_ingredients	1	{"id":1,"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","ingredients_id":"540b300c-fb17-4363-b233-2ef352f7eb6f","quantity":22,"measure_unit":"taza"}	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","ingredients_id":"540b300c-fb17-4363-b233-2ef352f7eb6f","quantity":22,"measure_unit":"taza"}	377	\N
379	394	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	{"id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T11:22:56.788Z","date_updated":"2024-04-24T11:23:21.426Z","title":"asdasd","description":"<p>dasdasdasd</p>","video":"asxcascas","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":60,"portion_numbers":null,"api_inserted":false,"images":[3,4],"categories":[6,7],"ingredients":[1]}	{"date_updated":"2024-04-24T11:23:21.426Z"}	\N	\N
378	393	recipes_ingredients	1	{"id":1,"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","ingredients_id":"540b300c-fb17-4363-b233-2ef352f7eb6f","quantity":22,"measure_unit":"g"}	{"recipes_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","ingredients_id":"540b300c-fb17-4363-b233-2ef352f7eb6f","measure_unit":"g"}	379	\N
380	395	directus_fields	89	{"sort":4,"interface":"input","special":["uuid"],"collection":"steps","field":"step_id"}	{"sort":4,"interface":"input","special":["uuid"],"collection":"steps","field":"step_id"}	\N	\N
381	396	directus_fields	90	{"sort":17,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"recipes","field":"steps"}	{"sort":17,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"recipes","field":"steps"}	\N	\N
383	398	recipes	40068538-4e9d-46d7-b9ca-ed6a2c398faa	{"id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T11:22:56.788Z","date_updated":"2024-04-24T11:25:32.751Z","title":"asdasd","description":"<p>dasdasdasd</p>","video":"asxcascas","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":60,"portion_numbers":null,"api_inserted":false,"images":[3,4],"categories":[6,7],"ingredients":[1],"steps":["9eda8226-7339-471c-9511-94de6345f3cb"]}	{"date_updated":"2024-04-24T11:25:32.751Z"}	\N	\N
382	397	steps	9eda8226-7339-471c-9511-94de6345f3cb	{"order":1,"instructions":"<p>Primero saca los macarrones de la bolsa</p>","step_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa"}	{"order":1,"instructions":"<p>Primero saca los macarrones de la bolsa</p>","step_id":"40068538-4e9d-46d7-b9ca-ed6a2c398faa"}	383	\N
384	399	directus_fields	91	{"sort":17,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"recipes","field":"steps"}	{"sort":17,"interface":"list-o2m","special":["o2m"],"required":true,"collection":"recipes","field":"steps"}	\N	\N
385	400	directus_fields	92	{"sort":4,"interface":"input","special":["uuid"],"collection":"steps","field":"steps_id"}	{"sort":4,"interface":"input","special":["uuid"],"collection":"steps","field":"steps_id"}	\N	\N
386	401	directus_fields	93	{"sort":17,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"steps"}	{"sort":17,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"steps"}	\N	\N
388	403	recipes	56c32335-6624-4f24-908a-4091faf5a0d5	{"id":"56c32335-6624-4f24-908a-4091faf5a0d5","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T10:45:59.960Z","date_updated":"2024-04-24T11:29:11.812Z","title":"asdasda","description":"<p>dasdasdas</p>","video":"awsdasdas","difficulty":"easy","preparation_time":30,"calories":564,"cooking_time":60,"portion_numbers":3,"api_inserted":false,"images":[1,2],"categories":[4,5],"ingredients":[],"steps":["9eda8226-7339-471c-9511-94de6345f3cb"]}	{"date_updated":"2024-04-24T11:29:11.812Z"}	\N	\N
387	402	steps	9eda8226-7339-471c-9511-94de6345f3cb	{"id":"9eda8226-7339-471c-9511-94de6345f3cb","instructions":"<p>Primero saca los macarrones de la bolsa</p>","order":1,"steps_id":"56c32335-6624-4f24-908a-4091faf5a0d5"}	{"steps_id":"56c32335-6624-4f24-908a-4091faf5a0d5"}	388	\N
389	405	directus_roles	d442c489-354a-4884-b239-9c9138853f39	{"name":"User","admin_access":false,"app_access":true}	{"name":"User","admin_access":false,"app_access":true}	\N	\N
390	406	directus_permissions	1	{"collection":"directus_files","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_files","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
391	407	directus_permissions	2	{"collection":"directus_files","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_files","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
392	408	directus_permissions	3	{"collection":"directus_files","action":"update","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_files","action":"update","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
393	409	directus_permissions	4	{"collection":"directus_files","action":"delete","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_files","action":"delete","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
394	410	directus_permissions	5	{"collection":"directus_dashboards","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_dashboards","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
395	411	directus_permissions	6	{"collection":"directus_dashboards","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_dashboards","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
396	412	directus_permissions	7	{"collection":"directus_dashboards","action":"update","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_dashboards","action":"update","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
397	413	directus_permissions	8	{"collection":"directus_dashboards","action":"delete","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_dashboards","action":"delete","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
398	414	directus_permissions	9	{"collection":"directus_panels","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_panels","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
399	415	directus_permissions	10	{"collection":"directus_panels","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_panels","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
400	416	directus_permissions	11	{"collection":"directus_panels","action":"update","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_panels","action":"update","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
401	417	directus_permissions	12	{"collection":"directus_panels","action":"delete","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_panels","action":"delete","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
402	418	directus_permissions	13	{"collection":"directus_folders","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_folders","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
403	419	directus_permissions	14	{"collection":"directus_folders","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_folders","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
404	420	directus_permissions	15	{"collection":"directus_folders","action":"update","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_folders","action":"update","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
405	421	directus_permissions	16	{"collection":"directus_folders","action":"delete","permissions":{},"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_folders","action":"delete","permissions":{},"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
406	422	directus_permissions	17	{"collection":"directus_users","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_users","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
407	423	directus_permissions	18	{"collection":"directus_users","action":"update","permissions":{"id":{"_eq":"$CURRENT_USER"}},"fields":["first_name","last_name","email","password","location","title","description","avatar","language","appearance","theme_light","theme_dark","theme_light_overrides","theme_dark_overrides","tfa_secret"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_users","action":"update","permissions":{"id":{"_eq":"$CURRENT_USER"}},"fields":["first_name","last_name","email","password","location","title","description","avatar","language","appearance","theme_light","theme_dark","theme_light_overrides","theme_dark_overrides","tfa_secret"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
408	424	directus_permissions	19	{"collection":"directus_roles","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_roles","action":"read","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
409	425	directus_permissions	20	{"collection":"directus_shares","action":"read","permissions":{"_or":[{"role":{"_eq":"$CURRENT_ROLE"}},{"role":{"_null":true}}]},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_shares","action":"read","permissions":{"_or":[{"role":{"_eq":"$CURRENT_ROLE"}},{"role":{"_null":true}}]},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
410	426	directus_permissions	21	{"collection":"directus_shares","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_shares","action":"create","permissions":{},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
411	427	directus_permissions	22	{"collection":"directus_shares","action":"update","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_shares","action":"update","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
412	428	directus_permissions	23	{"collection":"directus_shares","action":"delete","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_shares","action":"delete","permissions":{"user_created":{"_eq":"$CURRENT_USER"}},"fields":["*"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
413	429	directus_permissions	24	{"collection":"directus_flows","action":"read","permissions":{"trigger":{"_eq":"manual"}},"fields":["id","status","name","icon","color","options","trigger"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	{"collection":"directus_flows","action":"read","permissions":{"trigger":{"_eq":"manual"}},"fields":["id","status","name","icon","color","options","trigger"],"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
414	430	directus_permissions	25	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes","action":"create","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes","action":"create","fields":["*"],"permissions":{},"validation":{}}	\N	\N
415	431	directus_permissions	26	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes","action":"read","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes","action":"read","fields":["*"],"permissions":{},"validation":{}}	\N	\N
416	432	directus_permissions	27	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes","action":"update","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes","action":"update","fields":["*"],"permissions":{},"validation":{}}	\N	\N
417	433	directus_permissions	28	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes","action":"delete","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes","action":"delete","fields":["*"],"permissions":{},"validation":{}}	\N	\N
418	434	directus_permissions	29	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"steps","action":"create","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"steps","action":"create","fields":["*"],"permissions":{},"validation":{}}	\N	\N
419	435	directus_permissions	30	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"steps","action":"read","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"steps","action":"read","fields":["*"],"permissions":{},"validation":{}}	\N	\N
420	436	directus_permissions	31	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"steps","action":"update","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"steps","action":"update","fields":["*"],"permissions":{},"validation":{}}	\N	\N
421	437	directus_permissions	32	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"steps","action":"delete","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"steps","action":"delete","fields":["*"],"permissions":{},"validation":{}}	\N	\N
422	438	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	{"id":"ff289b86-09b5-4f1e-b31b-df77c3a0d7b8","first_name":"Sergio","last_name":"Sáez","email":"sergio@example.com","password":"**********","location":null,"title":null,"description":"Descripción de Sergio...","tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"d442c489-354a-4884-b239-9c9138853f39","token":null,"last_access":"2024-04-24T11:30:11.478Z","last_page":"/content","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"username":"sergio97","birth_date":"1997-03-27","phone_number":"631182588","town":"Murcia","municipality":"Murcia","street":"Calle Claveles 12","zip_code":"30006","twitter":null,"facebook":null,"youtube":null,"instagram":null,"tiktok":null,"reputation":0,"user_id":"bf738e2c-c923-49e3-b5a6-7ce7478e0f11"}	{"role":"d442c489-354a-4884-b239-9c9138853f39"}	\N	\N
423	441	directus_permissions	33	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"categories","action":"create","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"categories","action":"create","fields":["*"],"permissions":{},"validation":{}}	\N	\N
424	442	directus_permissions	34	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"categories","action":"read","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"categories","action":"read","fields":["*"],"permissions":{},"validation":{}}	\N	\N
425	443	directus_permissions	35	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"categories","action":"update","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"categories","action":"update","fields":["*"],"permissions":{},"validation":{}}	\N	\N
426	444	directus_permissions	36	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"categories","action":"delete","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"categories","action":"delete","fields":["*"],"permissions":{},"validation":{}}	\N	\N
427	445	directus_permissions	37	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes_categories","action":"create","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes_categories","action":"create","fields":["*"],"permissions":{},"validation":{}}	\N	\N
428	446	directus_permissions	38	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes_categories","action":"read","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes_categories","action":"read","fields":["*"],"permissions":{},"validation":{}}	\N	\N
429	447	directus_permissions	39	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes_categories","action":"update","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes_categories","action":"update","fields":["*"],"permissions":{},"validation":{}}	\N	\N
430	448	directus_permissions	40	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes_categories","action":"delete","fields":["*"],"permissions":{},"validation":{}}	{"role":"d442c489-354a-4884-b239-9c9138853f39","collection":"recipes_categories","action":"delete","fields":["*"],"permissions":{},"validation":{}}	\N	\N
434	452	recipes	0ae4d4d8-0f66-42aa-bc45-50bde2a963ac	{"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}],"update":[],"delete":[]},"title":"bbbbbbbbbbb","description":"<p>bbbbbbbbbbb</p>","video":"bbbbbbbbbbb","difficulty":"hard","preparation_time":33,"calories":333,"cooking_time":44,"portion_numbers":3,"steps":{"create":[],"update":[{"steps_id":"+","id":"9eda8226-7339-471c-9511-94de6345f3cb"}],"delete":[]}}	{"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}],"update":[],"delete":[]},"title":"bbbbbbbbbbb","description":"<p>bbbbbbbbbbb</p>","video":"bbbbbbbbbbb","difficulty":"hard","preparation_time":33,"calories":333,"cooking_time":44,"portion_numbers":3,"steps":{"create":[],"update":[{"steps_id":"+","id":"9eda8226-7339-471c-9511-94de6345f3cb"}],"delete":[]}}	\N	\N
431	449	recipes_categories	8	{"recipes_id":"0ae4d4d8-0f66-42aa-bc45-50bde2a963ac","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	{"recipes_id":"0ae4d4d8-0f66-42aa-bc45-50bde2a963ac","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	434	\N
432	450	recipes_categories	9	{"recipes_id":"0ae4d4d8-0f66-42aa-bc45-50bde2a963ac","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	{"recipes_id":"0ae4d4d8-0f66-42aa-bc45-50bde2a963ac","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	434	\N
433	451	steps	9eda8226-7339-471c-9511-94de6345f3cb	{"id":"9eda8226-7339-471c-9511-94de6345f3cb","instructions":"<p>Primero saca los macarrones de la bolsa</p>","order":1,"steps_id":"0ae4d4d8-0f66-42aa-bc45-50bde2a963ac"}	{"steps_id":"0ae4d4d8-0f66-42aa-bc45-50bde2a963ac"}	434	\N
435	453	directus_fields	93	{"id":93,"collection":"recipes","field":"steps","special":["o2m"],"interface":"list-o2m","options":{"enableSelect":false},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":17,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"recipes","field":"steps","options":{"enableSelect":false}}	\N	\N
436	454	directus_fields	94	{"sort":5,"interface":"input","special":["uuid"],"collection":"comments","field":"comment_id"}	{"sort":5,"interface":"input","special":["uuid"],"collection":"comments","field":"comment_id"}	\N	\N
437	455	directus_fields	95	{"sort":15,"interface":"list-o2m","special":["o2m"],"collection":"directus_users","field":"comments"}	{"sort":15,"interface":"list-o2m","special":["o2m"],"collection":"directus_users","field":"comments"}	\N	\N
438	456	directus_fields	96	{"sort":6,"interface":"input","special":["user-created"],"collection":"comments","field":"user_id"}	{"sort":6,"interface":"input","special":["user-created"],"collection":"comments","field":"user_id"}	\N	\N
439	457	directus_fields	46	{"id":46,"collection":"comments","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"comments","field":"id","sort":1,"group":null}	\N	\N
440	458	directus_fields	94	{"id":94,"collection":"comments","field":"comment_id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"comments","field":"comment_id","sort":2,"group":null}	\N	\N
441	459	directus_fields	47	{"id":47,"collection":"comments","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"comments","field":"date_created","sort":3,"group":null}	\N	\N
442	460	directus_fields	48	{"id":48,"collection":"comments","field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"comments","field":"date_updated","sort":4,"group":null}	\N	\N
443	461	directus_fields	49	{"id":49,"collection":"comments","field":"comment","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"comments","field":"comment","sort":5,"group":null}	\N	\N
444	462	directus_fields	96	{"id":96,"collection":"comments","field":"user_id","special":["user-created"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"comments","field":"user_id","sort":6,"group":null}	\N	\N
445	463	directus_fields	33	{"id":33,"collection":"steps","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"steps","field":"id","sort":1,"group":null}	\N	\N
446	464	directus_fields	92	{"id":92,"collection":"steps","field":"steps_id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"steps","field":"steps_id","sort":2,"group":null}	\N	\N
447	465	directus_fields	34	{"id":34,"collection":"steps","field":"instructions","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"steps","field":"instructions","sort":3,"group":null}	\N	\N
448	466	directus_fields	35	{"id":35,"collection":"steps","field":"order","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"steps","field":"order","sort":4,"group":null}	\N	\N
449	467	directus_fields	81	{"id":81,"collection":"macronutrients","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"id","sort":1,"group":null}	\N	\N
450	468	directus_fields	84	{"id":84,"collection":"macronutrients","field":"macronutrient_id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"macronutrient_id","sort":2,"group":null}	\N	\N
451	469	directus_fields	82	{"id":82,"collection":"macronutrients","field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"name","sort":3,"group":null}	\N	\N
452	470	directus_fields	86	{"id":86,"collection":"macronutrients","field":"quantity","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"group":null,"validation":null,"validation_message":null}	{"collection":"macronutrients","field":"quantity","sort":4,"group":null}	\N	\N
453	471	directus_fields	97	{"sort":18,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"comments"}	{"sort":18,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"comments"}	\N	\N
454	475	directus_fields	98	{"sort":18,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"comments"}	{"sort":18,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"comments"}	\N	\N
455	476	directus_fields	99	{"sort":6,"interface":"input","special":["user-created"],"collection":"comments","field":"user_id"}	{"sort":6,"interface":"input","special":["user-created"],"collection":"comments","field":"user_id"}	\N	\N
456	477	directus_fields	100	{"sort":7,"interface":"input","special":["uuid"],"collection":"comments","field":"comment_id"}	{"sort":7,"interface":"input","special":["uuid"],"collection":"comments","field":"comment_id"}	\N	\N
457	478	comments	1a5de822-f256-4c90-ba17-e1b035bc42e4	{"comment":"<p>dbdgbgdbgbdgb</p>"}	{"comment":"<p>dbdgbgdbgbdgb</p>"}	\N	\N
458	479	comments	1a5de822-f256-4c90-ba17-e1b035bc42e4	{"id":"1a5de822-f256-4c90-ba17-e1b035bc42e4","date_created":"2024-04-24T12:06:01.776Z","date_updated":"2024-04-24T12:06:16.956Z","comment":"<p>Ejemplo de comentario...</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"adb328c9-2834-4333-ac1c-8c17e08994f5"}	{"comment":"<p>Ejemplo de comentario...</p>","date_updated":"2024-04-24T12:06:16.956Z"}	\N	\N
459	480	directus_fields	101	{"sort":18,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"comments"}	{"sort":18,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"comments"}	\N	\N
460	482	directus_fields	102	{"sort":18,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"comments"}	{"sort":18,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"comments"}	\N	\N
467	489	recipes	13b26b73-441c-4511-8369-d976ce3dc737	{"title":"aaaaaaaaa","description":"<p>aaaaaaaaa</p>","video":"aaaaaaaaa","difficulty":"hard","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}],"update":[],"delete":[]},"images":{"create":[{"recipes_id":"+","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}},{"recipes_id":"+","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}],"update":[],"delete":[]},"ingredients":{"create":[{"recipes_id":"+","ingredients_id":{"id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}}],"update":[],"delete":[]},"steps":{"create":[{"instructions":"<p>zaaaaaa</p>","order":1}],"update":[],"delete":[]}}	{"title":"aaaaaaaaa","description":"<p>aaaaaaaaa</p>","video":"aaaaaaaaa","difficulty":"hard","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"categories":{"create":[{"recipes_id":"+","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}},{"recipes_id":"+","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}],"update":[],"delete":[]},"images":{"create":[{"recipes_id":"+","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}},{"recipes_id":"+","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}],"update":[],"delete":[]},"ingredients":{"create":[{"recipes_id":"+","ingredients_id":{"id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}}],"update":[],"delete":[]},"steps":{"create":[{"instructions":"<p>zaaaaaa</p>","order":1}],"update":[],"delete":[]}}	\N	\N
466	488	steps	c8e80c71-24fd-415a-a288-f21dfb0c0088	{"instructions":"<p>zaaaaaa</p>","order":1,"steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"instructions":"<p>zaaaaaa</p>","order":1,"steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	467	\N
521	546	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:44:30.099Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":[]}	{"date_updated":"2024-04-24T12:44:30.099Z"}	\N	\N
518	543	reports	0610ca37-7dda-4778-9b0d-679a5048c4ca	{"id":"0610ca37-7dda-4778-9b0d-679a5048c4ca","date_created":"2024-04-24T12:44:16.865Z","report_id":null,"user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","report":"spam_content"}	{"report_id":null}	521	\N
519	544	reports	6787df23-2698-4f0d-81db-dbf3641aca2b	{"id":"6787df23-2698-4f0d-81db-dbf3641aca2b","date_created":"2024-04-24T12:41:12.098Z","report_id":null,"user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","report":"violent_content"}	{"report_id":null}	521	\N
461	483	recipes_categories	10	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","categories_id":{"id":"14174f77-7e4b-4e93-b899-4e2edc7c1c34"}}	467	\N
462	484	recipes_categories	11	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","categories_id":{"id":"3804069d-68e8-4d7a-be43-f30d0faba482"}}	467	\N
463	485	recipes_files	5	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}}	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","directus_files_id":{"id":"1ed25831-f0b4-4838-ba3d-bfce8b45d748"}}	467	\N
464	486	recipes_files	6	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","directus_files_id":{"id":"5448e639-7980-49fe-b191-fb2b8871fcec"}}	467	\N
465	487	recipes_ingredients	2	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","ingredients_id":{"id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}}	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","ingredients_id":{"id":"540b300c-fb17-4363-b233-2ef352f7eb6f"}}	467	\N
469	491	recipes	13b26b73-441c-4511-8369-d976ce3dc737	{"id":"13b26b73-441c-4511-8369-d976ce3dc737","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T12:08:01.659Z","date_updated":"2024-04-24T12:08:13.850Z","title":"aaaaaaaaa","description":"<p>aaaaaaaaa</p>","video":"aaaaaaaaa","difficulty":"hard","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"api_inserted":false,"images":[5,6],"categories":[10,11],"ingredients":[2],"steps":["c8e80c71-24fd-415a-a288-f21dfb0c0088"],"comments":["e67a320e-dede-43df-ba28-d5c8efaa4f8f"]}	{"date_updated":"2024-04-24T12:08:13.850Z"}	\N	\N
468	490	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"comment":"<p>esto seria un comentario</p>","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"comment":"<p>esto seria un comentario</p>","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	469	\N
470	492	directus_fields	103	{"sort":4,"interface":"input","special":["user-created"],"collection":"rating_comments","field":"user_id"}	{"sort":4,"interface":"input","special":["user-created"],"collection":"rating_comments","field":"user_id"}	\N	\N
471	493	directus_fields	104	{"sort":5,"special":["cast-boolean"],"collection":"rating_comments","field":"valuation"}	{"sort":5,"special":["cast-boolean"],"collection":"rating_comments","field":"valuation"}	\N	\N
472	494	directus_fields	105	{"sort":6,"interface":"input","special":["uuid"],"collection":"rating_comments","field":"rating_comment_id"}	{"sort":6,"interface":"input","special":["uuid"],"collection":"rating_comments","field":"rating_comment_id"}	\N	\N
473	495	directus_fields	106	{"sort":8,"interface":"list-o2m","special":["o2m"],"collection":"comments","field":"rating_comment"}	{"sort":8,"interface":"list-o2m","special":["o2m"],"collection":"comments","field":"rating_comment"}	\N	\N
475	497	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:27:53.171Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87"]}	{"date_updated":"2024-04-24T12:27:53.171Z"}	\N	\N
474	496	rating_comments	39ebf191-a8e6-481a-9e1e-e12fef666f87	{"valuation":true,"rating_comment_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"valuation":true,"rating_comment_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	475	\N
476	498	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	{"id":"ff289b86-09b5-4f1e-b31b-df77c3a0d7b8","first_name":"Sergio","last_name":"Sáez","email":"sergio@example.com","password":"**********","location":null,"title":null,"description":"Descripción de Sergio...","tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"525a4819-e516-42c3-82bb-33558d3e82b4","token":null,"last_access":"2024-04-24T12:08:51.472Z","last_page":"/content/steps","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"username":"sergio97","birth_date":"1997-03-27","phone_number":"631182588","town":"Murcia","municipality":"Murcia","street":"Calle Claveles 12","zip_code":"30006","twitter":null,"facebook":null,"youtube":null,"instagram":null,"tiktok":null,"reputation":0,"user_id":"bf738e2c-c923-49e3-b5a6-7ce7478e0f11"}	{"role":"525a4819-e516-42c3-82bb-33558d3e82b4"}	\N	\N
478	502	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:28:48.158Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"]}	{"date_updated":"2024-04-24T12:28:48.158Z"}	\N	\N
477	501	rating_comments	890ef304-4733-44c2-88d3-b191fd8fecd5	{"valuation":true,"rating_comment_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"valuation":true,"rating_comment_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	478	\N
479	503	directus_fields	107	{"sort":2,"interface":"input","special":["uuid"],"collection":"rating_recipes","field":"rating_recipes_id"}	{"sort":2,"interface":"input","special":["uuid"],"collection":"rating_recipes","field":"rating_recipes_id"}	\N	\N
480	504	directus_fields	108	{"sort":3,"interface":"input","special":["user-created"],"collection":"rating_recipes","field":"user_id"}	{"sort":3,"interface":"input","special":["user-created"],"collection":"rating_recipes","field":"user_id"}	\N	\N
481	505	directus_fields	109	{"sort":4,"special":["cast-boolean"],"collection":"rating_recipes","field":"valuation"}	{"sort":4,"special":["cast-boolean"],"collection":"rating_recipes","field":"valuation"}	\N	\N
482	506	directus_fields	110	{"sort":19,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"rating_recipes"}	{"sort":19,"interface":"list-o2m","special":["o2m"],"collection":"recipes","field":"rating_recipes"}	\N	\N
485	509	rating_recipes	6b1ede2d-4f11-4fe7-8621-b3c93745d205	{"valuation":true,"rating_recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"valuation":true,"rating_recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	487	\N
520	545	reports	fc6bc99b-dba3-47a8-96ab-6d1d981c410f	{"id":"fc6bc99b-dba3-47a8-96ab-6d1d981c410f","date_created":"2024-04-24T12:44:22.865Z","report_id":null,"user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","report":"violent_content"}	{"report_id":null}	521	\N
487	511	recipes	13b26b73-441c-4511-8369-d976ce3dc737	{"id":"13b26b73-441c-4511-8369-d976ce3dc737","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T12:08:01.659Z","date_updated":"2024-04-24T12:32:11.036Z","title":"aaaaaaaaa","description":"<p>aaaaaaaaa</p>","video":"aaaaaaaaa","difficulty":"hard","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"api_inserted":false,"images":[5,6],"categories":[10,11],"ingredients":[2],"steps":["c8e80c71-24fd-415a-a288-f21dfb0c0088"],"comments":["e67a320e-dede-43df-ba28-d5c8efaa4f8f"],"rating_recipes":["6b1ede2d-4f11-4fe7-8621-b3c93745d205"]}	{"date_updated":"2024-04-24T12:32:11.036Z"}	\N	\N
486	510	steps	c8e80c71-24fd-415a-a288-f21dfb0c0088	{"id":"c8e80c71-24fd-415a-a288-f21dfb0c0088","instructions":"<p>Sacamos los macarrones de la bolsa</p>","order":1,"steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"instructions":"<p>Sacamos los macarrones de la bolsa</p>","steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	487	\N
490	514	recipes	13b26b73-441c-4511-8369-d976ce3dc737	{"id":"13b26b73-441c-4511-8369-d976ce3dc737","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T12:08:01.659Z","date_updated":"2024-04-24T12:34:16.436Z","title":"Macarrones con queso","description":"<p>Descripci&oacute;n de la receta de macarrones con queso</p>","video":"http://youtube.com","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"api_inserted":false,"images":[5,6],"categories":[10,11],"ingredients":[2],"steps":["c8e80c71-24fd-415a-a288-f21dfb0c0088"],"comments":["e67a320e-dede-43df-ba28-d5c8efaa4f8f"],"rating_recipes":["6b1ede2d-4f11-4fe7-8621-b3c93745d205"]}	{"title":"Macarrones con queso","description":"<p>Descripci&oacute;n de la receta de macarrones con queso</p>","video":"http://youtube.com","difficulty":"easy","date_updated":"2024-04-24T12:34:16.436Z"}	\N	\N
488	512	recipes_ingredients	2	{"id":2,"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","ingredients_id":"540b300c-fb17-4363-b233-2ef352f7eb6f","quantity":20,"measure_unit":"g"}	{"recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737","ingredients_id":"540b300c-fb17-4363-b233-2ef352f7eb6f","quantity":20,"measure_unit":"g"}	490	\N
489	513	steps	c8e80c71-24fd-415a-a288-f21dfb0c0088	{"id":"c8e80c71-24fd-415a-a288-f21dfb0c0088","instructions":"<p>Sacamos los macarrones de la bolsa</p>","order":1,"steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	490	\N
492	516	recipes	13b26b73-441c-4511-8369-d976ce3dc737	{"id":"13b26b73-441c-4511-8369-d976ce3dc737","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T12:08:01.659Z","date_updated":"2024-04-24T12:34:28.500Z","title":"Macarrones con queso","description":"<p>Descripci&oacute;n de la receta de macarrones con queso</p>","video":"http://youtube.com","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"api_inserted":false,"images":[5,6],"categories":[10,11],"ingredients":[2],"steps":["c8e80c71-24fd-415a-a288-f21dfb0c0088"],"comments":["e67a320e-dede-43df-ba28-d5c8efaa4f8f"],"rating_recipes":["66243f51-f7e8-4e46-bbc6-885a4bf777a3","6b1ede2d-4f11-4fe7-8621-b3c93745d205"]}	{"date_updated":"2024-04-24T12:34:28.500Z"}	\N	\N
491	515	rating_recipes	66243f51-f7e8-4e46-bbc6-885a4bf777a3	{"valuation":true,"rating_recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"valuation":true,"rating_recipes_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	492	\N
494	518	recipes	13b26b73-441c-4511-8369-d976ce3dc737	{"id":"13b26b73-441c-4511-8369-d976ce3dc737","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T12:08:01.659Z","date_updated":"2024-04-24T12:35:17.065Z","title":"Macarrones con queso","description":"<p>Descripci&oacute;n de la receta de macarrones con queso</p>","video":"http://youtube.com","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"api_inserted":false,"images":[5,6],"categories":[10,11],"ingredients":[2],"steps":["3341a51f-b731-46cc-91cb-922deee173a1","c8e80c71-24fd-415a-a288-f21dfb0c0088"],"comments":["e67a320e-dede-43df-ba28-d5c8efaa4f8f"],"rating_recipes":["66243f51-f7e8-4e46-bbc6-885a4bf777a3","6b1ede2d-4f11-4fe7-8621-b3c93745d205"]}	{"date_updated":"2024-04-24T12:35:17.065Z"}	\N	\N
493	517	steps	3341a51f-b731-46cc-91cb-922deee173a1	{"instructions":"<p>Realizamos el paso 2 de la receta...</p>","steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"instructions":"<p>Realizamos el paso 2 de la receta...</p>","steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	494	\N
496	520	recipes	13b26b73-441c-4511-8369-d976ce3dc737	{"id":"13b26b73-441c-4511-8369-d976ce3dc737","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T12:08:01.659Z","date_updated":"2024-04-24T12:35:33.556Z","title":"Macarrones con queso","description":"<p>Descripci&oacute;n de la receta de macarrones con queso</p>","video":"http://youtube.com","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"api_inserted":false,"images":[5,6],"categories":[10,11],"ingredients":[2],"steps":["3341a51f-b731-46cc-91cb-922deee173a1","c8e80c71-24fd-415a-a288-f21dfb0c0088"],"comments":["e67a320e-dede-43df-ba28-d5c8efaa4f8f"],"rating_recipes":["66243f51-f7e8-4e46-bbc6-885a4bf777a3","6b1ede2d-4f11-4fe7-8621-b3c93745d205"]}	{"date_updated":"2024-04-24T12:35:33.556Z"}	\N	\N
495	519	steps	3341a51f-b731-46cc-91cb-922deee173a1	{"id":"3341a51f-b731-46cc-91cb-922deee173a1","instructions":"<p>Realizamos el paso 2 de la receta...</p>","order":2,"steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"order":2,"steps_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	496	\N
497	521	directus_fields	111	{"sort":4,"interface":"input","special":["uuid"],"collection":"reports","field":"report_id"}	{"sort":4,"interface":"input","special":["uuid"],"collection":"reports","field":"report_id"}	\N	\N
498	522	directus_fields	50	{"id":50,"collection":"reports","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"id","sort":1,"group":null}	\N	\N
499	523	directus_fields	111	{"id":111,"collection":"reports","field":"report_id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"report_id","sort":2,"group":null}	\N	\N
500	524	directus_fields	51	{"id":51,"collection":"reports","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":3,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"date_created","sort":3,"group":null}	\N	\N
501	525	directus_fields	52	{"id":52,"collection":"reports","field":"report","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"report","sort":4,"group":null}	\N	\N
502	526	directus_fields	112	{"sort":5,"interface":"input","special":["user-created"],"collection":"reports","field":"user_id"}	{"sort":5,"interface":"input","special":["user-created"],"collection":"reports","field":"user_id"}	\N	\N
503	527	directus_fields	50	{"id":50,"collection":"reports","field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"id","sort":1,"group":null}	\N	\N
504	528	directus_fields	111	{"id":111,"collection":"reports","field":"report_id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"report_id","sort":2,"group":null}	\N	\N
505	529	directus_fields	112	{"id":112,"collection":"reports","field":"user_id","special":["user-created"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"user_id","sort":3,"group":null}	\N	\N
506	530	directus_fields	51	{"id":51,"collection":"reports","field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"date_created","sort":4,"group":null}	\N	\N
507	531	directus_fields	52	{"id":52,"collection":"reports","field":"report","special":null,"interface":"input-rich-text-html","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"group":null,"validation":null,"validation_message":null}	{"collection":"reports","field":"report","sort":5,"group":null}	\N	\N
508	532	directus_fields	113	{"sort":5,"interface":"select-dropdown","special":null,"options":{"choices":[{"text":"Contenido violento o explícito","value":"violent_content"},{"text":"Contenido irrelevante","value":"irrelevant_content"},{"text":"Spam o engañoso","value":"spam_content"}]},"collection":"reports","field":"report"}	{"sort":5,"interface":"select-dropdown","special":null,"options":{"choices":[{"text":"Contenido violento o explícito","value":"violent_content"},{"text":"Contenido irrelevante","value":"irrelevant_content"},{"text":"Spam o engañoso","value":"spam_content"}]},"collection":"reports","field":"report"}	\N	\N
509	533	directus_fields	114	{"sort":9,"interface":"list-o2m","special":["o2m"],"collection":"comments","field":"reports"}	{"sort":9,"interface":"list-o2m","special":["o2m"],"collection":"comments","field":"reports"}	\N	\N
511	535	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:41:12.094Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":["6787df23-2698-4f0d-81db-dbf3641aca2b"]}	{"date_updated":"2024-04-24T12:41:12.094Z"}	\N	\N
510	534	reports	6787df23-2698-4f0d-81db-dbf3641aca2b	{"report":"violent_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"report":"violent_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	511	\N
513	537	recipes	13b26b73-441c-4511-8369-d976ce3dc737	{"id":"13b26b73-441c-4511-8369-d976ce3dc737","user_created":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","date_created":"2024-04-24T12:08:01.659Z","date_updated":"2024-04-24T12:42:04.038Z","title":"Macarrones con queso","description":"<p>Descripci&oacute;n de la receta de macarrones con queso</p>","video":"http://youtube.com","difficulty":"easy","preparation_time":33,"calories":555,"cooking_time":44,"portion_numbers":4,"api_inserted":false,"images":[5,6],"categories":[10,11],"ingredients":[2],"steps":["3341a51f-b731-46cc-91cb-922deee173a1","c8e80c71-24fd-415a-a288-f21dfb0c0088"],"comments":["e67a320e-dede-43df-ba28-d5c8efaa4f8f","f4979c8a-ad74-411e-954e-67d0f9e12d7c"],"rating_recipes":["66243f51-f7e8-4e46-bbc6-885a4bf777a3","6b1ede2d-4f11-4fe7-8621-b3c93745d205"]}	{"date_updated":"2024-04-24T12:42:04.038Z"}	\N	\N
512	536	comments	f4979c8a-ad74-411e-954e-67d0f9e12d7c	{"comment":"<p>Comentario 2....</p>","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	{"comment":"<p>Comentario 2....</p>","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737"}	513	\N
515	540	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:44:16.863Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":["0610ca37-7dda-4778-9b0d-679a5048c4ca","6787df23-2698-4f0d-81db-dbf3641aca2b"]}	{"date_updated":"2024-04-24T12:44:16.863Z"}	\N	\N
514	539	reports	0610ca37-7dda-4778-9b0d-679a5048c4ca	{"report":"spam_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"report":"spam_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	515	\N
517	542	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:44:22.861Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":["0610ca37-7dda-4778-9b0d-679a5048c4ca","6787df23-2698-4f0d-81db-dbf3641aca2b","fc6bc99b-dba3-47a8-96ab-6d1d981c410f"]}	{"date_updated":"2024-04-24T12:44:22.861Z"}	\N	\N
516	541	reports	fc6bc99b-dba3-47a8-96ab-6d1d981c410f	{"report":"violent_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"report":"violent_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	517	\N
522	547	reports	ef5cdc31-c57c-46b1-9906-da8b8562d6b8	{"report":"violent_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"report":"violent_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	523	\N
523	548	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:45:30.654Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":["ef5cdc31-c57c-46b1-9906-da8b8562d6b8"]}	{"date_updated":"2024-04-24T12:45:30.654Z"}	\N	\N
526	551	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:47:11.167Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":["324ca7c1-19e0-4a4f-8eb7-544e4e78b5bb","ef5cdc31-c57c-46b1-9906-da8b8562d6b8"]}	{"date_updated":"2024-04-24T12:47:11.167Z"}	\N	\N
525	550	reports	324ca7c1-19e0-4a4f-8eb7-544e4e78b5bb	{"report":"spam_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"report":"spam_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	526	\N
529	554	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:47:25.751Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":[]}	{"date_updated":"2024-04-24T12:47:25.751Z"}	\N	\N
527	552	reports	324ca7c1-19e0-4a4f-8eb7-544e4e78b5bb	{"id":"324ca7c1-19e0-4a4f-8eb7-544e4e78b5bb","date_created":"2024-04-24T12:47:11.170Z","report_id":null,"report":"spam_content","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}	{"report_id":null}	529	\N
528	553	reports	ef5cdc31-c57c-46b1-9906-da8b8562d6b8	{"id":"ef5cdc31-c57c-46b1-9906-da8b8562d6b8","date_created":"2024-04-24T12:45:30.657Z","report_id":null,"report":"violent_content","user_id":null}	{"report_id":null}	529	\N
530	555	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:48:21.097Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":[]}	{"date_updated":"2024-04-24T12:48:21.097Z"}	\N	\N
532	562	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:48:59.119Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":["c58fda7f-991c-4db8-84ea-20a9a3909d65"]}	{"date_updated":"2024-04-24T12:48:59.119Z"}	\N	\N
531	561	reports	c58fda7f-991c-4db8-84ea-20a9a3909d65	{"report":"violent_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"report":"violent_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	532	\N
534	564	comments	e67a320e-dede-43df-ba28-d5c8efaa4f8f	{"id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","date_created":"2024-04-24T12:08:13.852Z","date_updated":"2024-04-24T12:49:38.969Z","comment":"<p>esto seria un comentario</p>","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","comment_id":"13b26b73-441c-4511-8369-d976ce3dc737","rating_comment":["39ebf191-a8e6-481a-9e1e-e12fef666f87","890ef304-4733-44c2-88d3-b191fd8fecd5"],"reports":["89d08a07-40b9-48f6-93f2-b96382bd392b","c58fda7f-991c-4db8-84ea-20a9a3909d65"]}	{"date_updated":"2024-04-24T12:49:38.969Z"}	\N	\N
533	563	reports	89d08a07-40b9-48f6-93f2-b96382bd392b	{"report":"irrelevant_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	{"report":"irrelevant_content","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f"}	534	\N
535	569	reports	89d08a07-40b9-48f6-93f2-b96382bd392b	{"id":"89d08a07-40b9-48f6-93f2-b96382bd392b","date_created":"2024-04-24T12:49:38.972Z","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","report":"spam_content","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}	{"report":"spam_content"}	\N	\N
536	570	reports	89d08a07-40b9-48f6-93f2-b96382bd392b	{"id":"89d08a07-40b9-48f6-93f2-b96382bd392b","date_created":"2024-04-24T12:49:38.972Z","report_id":"e67a320e-dede-43df-ba28-d5c8efaa4f8f","report":"irrelevant_content","user_id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b"}	{"report":"irrelevant_content"}	\N	\N
537	724	directus_users	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	{"id":"a1e257cf-9a84-4612-8ee9-f3dd49aa225b","first_name":"Admin","last_name":"User","email":"admin@example.com","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"525a4819-e516-42c3-82bb-33558d3e82b4","token":"**********","last_access":"2024-05-23T15:31:37.632Z","last_page":"/users/a1e257cf-9a84-4612-8ee9-f3dd49aa225b","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"username":"assdas","birth_date":null,"phone_number":null,"town":null,"municipality":null,"street":null,"zip_code":null,"twitter":null,"facebook":null,"youtube":null,"instagram":null,"tiktok":null,"reputation":0,"user_id":null}	{"token":"**********","username":"assdas"}	\N	\N
538	725	directus_permissions	41	{"role":null,"collection":"recipes","action":"read","fields":["*"],"permissions":{},"validation":{}}	{"role":null,"collection":"recipes","action":"read","fields":["*"],"permissions":{},"validation":{}}	\N	\N
539	726	directus_permissions	42	{"role":null,"collection":"recipes","action":"share","fields":["*"],"permissions":{},"validation":{}}	{"role":null,"collection":"recipes","action":"share","fields":["*"],"permissions":{},"validation":{}}	\N	\N
540	727	directus_users	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	{"id":"ff289b86-09b5-4f1e-b31b-df77c3a0d7b8","first_name":"Sergio","last_name":"Sáez","email":"sergio@example.com","password":"**********","location":null,"title":null,"description":"Descripción de Sergio...","tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"525a4819-e516-42c3-82bb-33558d3e82b4","token":"**********","last_access":"2024-04-24T13:04:38.623Z","last_page":"/content/reports","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"username":"sergio97","birth_date":"1997-03-27","phone_number":"631182588","town":"Murcia","municipality":"Murcia","street":"Calle Claveles 12","zip_code":"30006","twitter":null,"facebook":null,"youtube":null,"instagram":null,"tiktok":null,"reputation":0,"user_id":"bf738e2c-c923-49e3-b5a6-7ce7478e0f11"}	{"token":"**********"}	\N	\N
541	743	directus_permissions	43	{"role":null,"collection":"directus_users","action":"create","fields":["*"],"permissions":{},"validation":{}}	{"role":null,"collection":"directus_users","action":"create","fields":["*"],"permissions":{},"validation":{}}	\N	\N
\.


--
-- Data for Name: directus_roles; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_roles (id, name, icon, description, ip_access, enforce_tfa, admin_access, app_access) FROM stdin;
525a4819-e516-42c3-82bb-33558d3e82b4	Administrator	verified	$t:admin_description	\N	f	t	t
d442c489-354a-4884-b239-9c9138853f39	User	supervised_user_circle	\N	\N	f	f	t
\.


--
-- Data for Name: directus_sessions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_sessions (token, "user", expires, ip, user_agent, share, origin) FROM stdin;
hpYFBDnhSWMAzPGQExFBN8XSz-C4o1ZEVF2S7PIbGgYLgwLGH2pnlV94unrM0kgk	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-28 15:31:37.604+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	\N	http://localhost:8055
Bge8_XiecqDmPDDqGsVMD5tnAu2CevhoxReR9t6acdLkFhCOKc0NnTT4iotV7GNN	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-28 16:04:30.865+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	\N	http://localhost:8055
s6GXJcVAjAcTzeHlFvHeUDnqf_3Ftjv7xTVrI4oIh2B_sVSnYAw6jzX25DToWl3o	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-28 16:25:14.557+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	\N	http://localhost:8055
b6fO2Af6jAHJK6q4SHwZinsYz4jlovJjwIPBEM7R7R2hO7ETyMzORRe3LJMGfM-1	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 19:16:30.868+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:8055
4qlXBVijvPfKR7OJmK_nXHEW4c1NaeSGZjVagUL3qEQ_YqpCOB_-j16wCelcWcSz	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-28 15:43:19.11+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	\N	http://localhost:8055
uAQ70w5RBIqetLJ4_5MgZfYOF0T9LikXWYJjSU8i8Jzi1uXhOpy_KFEDLqUjLQNy	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 16:23:59.123+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
mczMK98wKVSsOBA0op74ufNRUYCFo-69FdFXVBL-1BEl1giEZm7QxxxZANpc12Gt	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 16:25:24.762+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
SXep16PSQDgkZEw5wuV9APAC23kbzp_t8jbkq68yiCSPJRttAbIL4SbEMwy7RtKB	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 16:29:43.857+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
xEGKLoj-Ed-U75kKY0H2o4zlvyzFDdKlWc8uFL-pwxWerPI63L9A8cMnwAOs3qK2	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 16:34:15.466+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
6GmRLVjODi6soJtbirDCHwVffj9CSMejmfCI_9zwBdSoCYIk8VwsofvA8xtmKttk	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 16:35:06.004+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
cUKYIO1j4z8LA5-usyG23CC-gDIPN4wtfVP4WDpIqm9jq5wbyJNVpBpzJHj1QW-3	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 16:36:00.23+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
v0QNIDFDvxqyAoVbEhfIILIeHpaVlgTw8OZt3WC663_LYt0yOKBGpkLMJxfxQwgv	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 16:42:45.362+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
Pn5uQMlr2cFB-ELEZdq-HIzxvCT8XmUs0IbziBQFkmFJ60J5rqwZdqtwG13YOrdZ	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 16:44:00.936+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
i4ylzGSdg69F7yoJ6foPm7Gp7LFchduOHVStaDzxDHT1A-GsSvJdeUcGERDMLSpY	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 18:35:30.94+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:8055
ykkVs6DkHyRQnUlu3gY6X8ecJlVfbriMxA-H1PeX2j2-jfNaXvFadyU0IqikX7gc	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-28 15:47:42.289+00	46.6.51.173	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	https://ed8n69ihxbp1.share.zrok.io
3IWfW69e2w248SKZlppbB_ZnMh5FCUHPH0Q_HwXZYwZXRe7uWBTrV4WihJyvkuzh	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-31 18:25:23.974+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36	\N	http://localhost:4200
G1-HnsQ5Art0XhBpFfrSYk6TjnB8sgEABpsw7MOAmy8ZpOC6ICW1tQg5VUooJDqX	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-28 15:51:38.315+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	\N	http://localhost:8055
Bwp3U0sloRsk098gbs8A5dOwZEAGRQaFZOjU9WQTOeUDit_VKXHF2Q81ce2KppZY	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-05-28 15:27:06.675+00	172.29.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	\N	http://localhost:8055
\.


--
-- Data for Name: directus_settings; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_settings (id, project_name, project_url, project_color, project_logo, public_foreground, public_background, public_note, auth_login_attempts, auth_password_policy, storage_asset_transform, storage_asset_presets, custom_css, storage_default_folder, basemaps, mapbox_key, module_bar, project_descriptor, default_language, custom_aspect_ratios, public_favicon, default_appearance, default_theme_light, theme_light_overrides, default_theme_dark, theme_dark_overrides) FROM stdin;
\.


--
-- Data for Name: directus_shares; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_shares (id, name, collection, item, role, password, user_created, date_created, date_start, date_end, times_used, max_uses) FROM stdin;
\.


--
-- Data for Name: directus_translations; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_translations (id, language, key, value) FROM stdin;
\.


--
-- Data for Name: directus_users; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_users (id, first_name, last_name, email, password, location, title, description, tags, avatar, language, tfa_secret, status, role, token, last_access, last_page, provider, external_identifier, auth_data, email_notifications, appearance, theme_dark, theme_light, theme_light_overrides, theme_dark_overrides, username, birth_date, phone_number, town, municipality, street, zip_code, twitter, facebook, youtube, instagram, tiktok, reputation, user_id) FROM stdin;
a1e257cf-9a84-4612-8ee9-f3dd49aa225b	Admin	User	admin@example.com	$argon2id$v=19$m=65536,t=3,p=4$tkVvCUfeROAzTqOxM4t7/w$qz7pWagUDQTR4y8nCjshvzH8PaSRNB0egjAPDIHCPmc	\N	\N	\N	\N	\N	\N	\N	active	525a4819-e516-42c3-82bb-33558d3e82b4	jRltxHc-PeGihd9Vy1xUIZcyFbMOWY9n	2024-05-26 19:16:30.947+00	/content/recipes	default	\N	\N	t	\N	\N	\N	\N	\N	assdas	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N
ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	Sergio	Sáez	sergio@example.com	$argon2id$v=19$m=65536,t=3,p=4$5BiuCey2Aog9atIVVRjrZg$tGcULMHSc0xKA0LsjSC7yLPuwib+FSkB2h1mlwgcs0Y	\N	\N	Descripción de Sergio...	\N	\N	\N	\N	active	525a4819-e516-42c3-82bb-33558d3e82b4	GRLsy5J7PoqErRlQemcctMy4OoiFzIWf	2024-04-24 13:04:38.623+00	/content/reports	default	\N	\N	t	\N	\N	\N	\N	\N	sergio97	1997-03-27	631182588	Murcia	Murcia	Calle Claveles 12	30006	\N	\N	\N	\N	\N	0	bf738e2c-c923-49e3-b5a6-7ce7478e0f11
b7f3a7af-4407-429a-9e25-03412b8b6515	Test3	Test3	test3@example.com	$argon2id$v=19$m=65536,t=3,p=4$T/NtjzhQWItpqeDA00+n0Q$qfxfNW/7YK6pPDj0A+Btwdg6W95vOK0IZep534bKeZY	\N	\N	Test3 description..	\N	\N	\N	\N	active	\N	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	test3	2024-04-24	654789568	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	cbd1d3de-0a9a-4557-8774-d22e2144edf2
\.


--
-- Data for Name: directus_versions; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_versions (id, key, name, collection, item, hash, date_created, date_updated, user_created, user_updated) FROM stdin;
\.


--
-- Data for Name: directus_webhooks; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.directus_webhooks (id, name, method, url, status, data, actions, collections, headers) FROM stdin;
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.ingredients (id, name) FROM stdin;
540b300c-fb17-4363-b233-2ef352f7eb6f	Patata
\.


--
-- Data for Name: macronutrients; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.macronutrients (id, name, macronutrient_id, quantity) FROM stdin;
4d41d9b7-77ba-41ba-8374-5c423c1d4ab8	Grasas	540b300c-fb17-4363-b233-2ef352f7eb6f	0.1
9f6a8ec3-0473-4d56-9824-88b4d25db08a	Carbohidratos	540b300c-fb17-4363-b233-2ef352f7eb6f	17
1f85e0fc-0e11-4f77-b86e-84c1d0dc1788	Proteínas	540b300c-fb17-4363-b233-2ef352f7eb6f	2
\.


--
-- Data for Name: rating_comments; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.rating_comments (id, user_id, valuation, rating_comment_id) FROM stdin;
39ebf191-a8e6-481a-9e1e-e12fef666f87	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	t	e67a320e-dede-43df-ba28-d5c8efaa4f8f
890ef304-4733-44c2-88d3-b191fd8fecd5	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	t	e67a320e-dede-43df-ba28-d5c8efaa4f8f
\.


--
-- Data for Name: rating_recipes; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.rating_recipes (id, rating_recipes_id, user_id, valuation) FROM stdin;
6b1ede2d-4f11-4fe7-8621-b3c93745d205	13b26b73-441c-4511-8369-d976ce3dc737	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8	t
66243f51-f7e8-4e46-bbc6-885a4bf777a3	13b26b73-441c-4511-8369-d976ce3dc737	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	t
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.recipes (id, user_created, date_created, date_updated, title, description, video, difficulty, preparation_time, calories, cooking_time, portion_numbers, api_inserted) FROM stdin;
13b26b73-441c-4511-8369-d976ce3dc737	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	2024-04-24 12:08:01.659+00	2024-04-24 12:42:04.038+00	Macarrones con queso	<p>Descripci&oacute;n de la receta de macarrones con queso</p>	http://youtube.com	easy	33	555	44	4	f
\.


--
-- Data for Name: recipes_categories; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.recipes_categories (id, recipes_id, categories_id) FROM stdin;
1	\N	14174f77-7e4b-4e93-b899-4e2edc7c1c34
2	\N	3804069d-68e8-4d7a-be43-f30d0faba482
3	\N	c2a859e7-cf51-4295-afed-197c3d4a5e8e
6	\N	14174f77-7e4b-4e93-b899-4e2edc7c1c34
7	\N	3804069d-68e8-4d7a-be43-f30d0faba482
4	\N	14174f77-7e4b-4e93-b899-4e2edc7c1c34
5	\N	3804069d-68e8-4d7a-be43-f30d0faba482
8	\N	14174f77-7e4b-4e93-b899-4e2edc7c1c34
9	\N	3804069d-68e8-4d7a-be43-f30d0faba482
10	13b26b73-441c-4511-8369-d976ce3dc737	14174f77-7e4b-4e93-b899-4e2edc7c1c34
11	13b26b73-441c-4511-8369-d976ce3dc737	3804069d-68e8-4d7a-be43-f30d0faba482
\.


--
-- Data for Name: recipes_files; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.recipes_files (id, recipes_id, directus_files_id) FROM stdin;
3	\N	1ed25831-f0b4-4838-ba3d-bfce8b45d748
4	\N	5448e639-7980-49fe-b191-fb2b8871fcec
1	\N	5448e639-7980-49fe-b191-fb2b8871fcec
2	\N	1ed25831-f0b4-4838-ba3d-bfce8b45d748
5	13b26b73-441c-4511-8369-d976ce3dc737	1ed25831-f0b4-4838-ba3d-bfce8b45d748
6	13b26b73-441c-4511-8369-d976ce3dc737	5448e639-7980-49fe-b191-fb2b8871fcec
\.


--
-- Data for Name: recipes_ingredients; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.recipes_ingredients (id, recipes_id, ingredients_id, quantity, measure_unit) FROM stdin;
1	\N	540b300c-fb17-4363-b233-2ef352f7eb6f	22	g
2	13b26b73-441c-4511-8369-d976ce3dc737	540b300c-fb17-4363-b233-2ef352f7eb6f	20	g
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.reports (id, date_created, report_id, report, user_id) FROM stdin;
c58fda7f-991c-4db8-84ea-20a9a3909d65	2024-04-24 12:48:59.122+00	e67a320e-dede-43df-ba28-d5c8efaa4f8f	violent_content	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8
89d08a07-40b9-48f6-93f2-b96382bd392b	2024-04-24 12:49:38.972+00	e67a320e-dede-43df-ba28-d5c8efaa4f8f	irrelevant_content	a1e257cf-9a84-4612-8ee9-f3dd49aa225b
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: steps; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.steps (id, instructions, "order", steps_id) FROM stdin;
9eda8226-7339-471c-9511-94de6345f3cb	<p>Primero saca los macarrones de la bolsa</p>	1	\N
c8e80c71-24fd-415a-a288-f21dfb0c0088	<p>Sacamos los macarrones de la bolsa</p>	1	13b26b73-441c-4511-8369-d976ce3dc737
3341a51f-b731-46cc-91cb-922deee173a1	<p>Realizamos el paso 2 de la receta...</p>	2	13b26b73-441c-4511-8369-d976ce3dc737
\.


--
-- Data for Name: users_followed; Type: TABLE DATA; Schema: public; Owner: directus
--

COPY public.users_followed (id, user_id, follower_id) FROM stdin;
5d2311ba-e16d-41c9-aba6-35b214248bd5	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	b7f3a7af-4407-429a-9e25-03412b8b6515
826e0729-ccee-4247-8e28-e7775fe11550	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	a1e257cf-9a84-4612-8ee9-f3dd49aa225b
625df489-026b-4dee-addd-94748e14c81a	a1e257cf-9a84-4612-8ee9-f3dd49aa225b	ff289b86-09b5-4f1e-b31b-df77c3a0d7b8
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: directus
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: directus
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: directus
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: directus
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: directus
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: directus
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: directus_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_activity_id_seq', 744, true);


--
-- Name: directus_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_fields_id_seq', 115, true);


--
-- Name: directus_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_notifications_id_seq', 1, false);


--
-- Name: directus_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_permissions_id_seq', 43, true);


--
-- Name: directus_presets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_presets_id_seq', 9, true);


--
-- Name: directus_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_relations_id_seq', 21, true);


--
-- Name: directus_revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_revisions_id_seq', 541, true);


--
-- Name: directus_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_settings_id_seq', 1, false);


--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.directus_webhooks_id_seq', 1, false);


--
-- Name: recipes_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.recipes_categories_id_seq', 11, true);


--
-- Name: recipes_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.recipes_files_id_seq', 6, true);


--
-- Name: recipes_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: directus
--

SELECT pg_catalog.setval('public.recipes_ingredients_id_seq', 2, true);


--
-- Name: categories categories_name_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_unique UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- Name: directus_extensions directus_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_extensions
    ADD CONSTRAINT directus_extensions_pkey PRIMARY KEY (name);


--
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- Name: directus_flows directus_flows_operation_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_operation_unique UNIQUE (operation);


--
-- Name: directus_flows directus_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_pkey PRIMARY KEY (id);


--
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_reject_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_unique UNIQUE (reject);


--
-- Name: directus_operations directus_operations_resolve_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_unique UNIQUE (resolve);


--
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- Name: directus_translations directus_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_translations
    ADD CONSTRAINT directus_translations_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- Name: directus_users directus_users_phone_number_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_phone_number_unique UNIQUE (phone_number);


--
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- Name: directus_users directus_users_username_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_username_unique UNIQUE (username);


--
-- Name: directus_versions directus_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_pkey PRIMARY KEY (id);


--
-- Name: directus_webhooks directus_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_pkey PRIMARY KEY (id);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: macronutrients macronutrients_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.macronutrients
    ADD CONSTRAINT macronutrients_pkey PRIMARY KEY (id);


--
-- Name: rating_comments rating_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.rating_comments
    ADD CONSTRAINT rating_comments_pkey PRIMARY KEY (id);


--
-- Name: rating_comments rating_comments_user_id_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.rating_comments
    ADD CONSTRAINT rating_comments_user_id_unique UNIQUE (user_id);


--
-- Name: rating_recipes rating_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.rating_recipes
    ADD CONSTRAINT rating_recipes_pkey PRIMARY KEY (id);


--
-- Name: recipes_categories recipes_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_categories
    ADD CONSTRAINT recipes_categories_pkey PRIMARY KEY (id);


--
-- Name: recipes_files recipes_files_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_files
    ADD CONSTRAINT recipes_files_pkey PRIMARY KEY (id);


--
-- Name: recipes_ingredients recipes_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: reports reports_user_id_unique; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_user_id_unique UNIQUE (user_id);


--
-- Name: steps steps_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (id);


--
-- Name: users_followed users_followed_pkey; Type: CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.users_followed
    ADD CONSTRAINT users_followed_pkey PRIMARY KEY (id);


--
-- Name: comments comments_comment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_comment_id_foreign FOREIGN KEY (comment_id) REFERENCES public.recipes(id) ON DELETE SET NULL;


--
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- Name: directus_flows directus_flows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- Name: directus_operations directus_operations_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_flow_foreign FOREIGN KEY (flow) REFERENCES public.directus_flows(id) ON DELETE CASCADE;


--
-- Name: directus_operations directus_operations_reject_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_foreign FOREIGN KEY (reject) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_resolve_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_foreign FOREIGN KEY (resolve) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_permissions directus_permissions_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- Name: directus_revisions directus_revisions_version_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_version_foreign FOREIGN KEY (version) REFERENCES public.directus_versions(id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_favicon_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_favicon_foreign FOREIGN KEY (public_favicon) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_versions directus_versions_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: macronutrients macronutrients_macronutrient_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.macronutrients
    ADD CONSTRAINT macronutrients_macronutrient_id_foreign FOREIGN KEY (macronutrient_id) REFERENCES public.ingredients(id) ON DELETE SET NULL;


--
-- Name: rating_comments rating_comments_rating_comment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.rating_comments
    ADD CONSTRAINT rating_comments_rating_comment_id_foreign FOREIGN KEY (rating_comment_id) REFERENCES public.comments(id) ON DELETE SET NULL;


--
-- Name: rating_recipes rating_recipes_rating_recipes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.rating_recipes
    ADD CONSTRAINT rating_recipes_rating_recipes_id_foreign FOREIGN KEY (rating_recipes_id) REFERENCES public.recipes(id) ON DELETE SET NULL;


--
-- Name: recipes_categories recipes_categories_categories_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_categories
    ADD CONSTRAINT recipes_categories_categories_id_foreign FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: recipes_categories recipes_categories_recipes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_categories
    ADD CONSTRAINT recipes_categories_recipes_id_foreign FOREIGN KEY (recipes_id) REFERENCES public.recipes(id) ON DELETE SET NULL;


--
-- Name: recipes_files recipes_files_directus_files_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_files
    ADD CONSTRAINT recipes_files_directus_files_id_foreign FOREIGN KEY (directus_files_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: recipes_files recipes_files_recipes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_files
    ADD CONSTRAINT recipes_files_recipes_id_foreign FOREIGN KEY (recipes_id) REFERENCES public.recipes(id) ON DELETE SET NULL;


--
-- Name: recipes_ingredients recipes_ingredients_ingredients_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_ingredients_id_foreign FOREIGN KEY (ingredients_id) REFERENCES public.ingredients(id) ON DELETE SET NULL;


--
-- Name: recipes_ingredients recipes_ingredients_recipes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_recipes_id_foreign FOREIGN KEY (recipes_id) REFERENCES public.recipes(id) ON DELETE SET NULL;


--
-- Name: recipes recipes_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: reports reports_report_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_report_id_foreign FOREIGN KEY (report_id) REFERENCES public.comments(id) ON DELETE SET NULL;


--
-- Name: steps steps_steps_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_steps_id_foreign FOREIGN KEY (steps_id) REFERENCES public.recipes(id) ON DELETE SET NULL;


--
-- Name: users_followed users_followed_follower_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.users_followed
    ADD CONSTRAINT users_followed_follower_id_foreign FOREIGN KEY (follower_id) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

