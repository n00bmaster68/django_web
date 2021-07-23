--
-- PostgreSQL database dump
--

-- Dumped from database version 12.7
-- Dumped by pg_dump version 12.7

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
-- Name: addtostock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.addtostock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     i integer;
     counter integer := 0 ; 
 BEGIN
     i := (select count(*) from app_for_user_size);
     loop 
         exit when counter = i; 
         counter := counter + 1 ; 
         insert into app_for_user_stock(product_id, size_id, quantity) values (NEW.id, counter, 0);
     end loop; 
     return NEW;
 END;
 $$;


ALTER FUNCTION public.addtostock() OWNER TO postgres;

--
-- Name: receivetostock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.receivetostock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 update app_for_user_stock 
 set quantity = quantity + NEW.quantity
 where app_for_user_stock.size_id = NEW.size_id and app_for_user_stock.product_id = NEW.product_id;
     return NEW;
 END;
 $$;


ALTER FUNCTION public.receivetostock() OWNER TO postgres;

--
-- Name: settt1(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.settt1() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     price integer;
 BEGIN
    update app_for_user_bill
    set total_price = total_price - OLD.unit_price*OLD.quantity
    where app_for_user_bill.id = OLD.bill_id;
	
	update app_for_user_stock
	set quantity = quantity + OLD.quantity
	where app_for_user_stock.id = OLD.product_id;
     return OLD;
 END;
 $$;


ALTER FUNCTION public.settt1() OWNER TO postgres;

--
-- Name: settt2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.settt2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
 BEGIN
    update app_for_user_bill
    set total_price = total_price - OLD.unit_price*OLD.quantity + NEW.unit_price*NEW.quantity
    where app_for_user_bill.id = NEW.bill_id;
	
	update app_for_user_stock
	set quantity = quantity + OLD.quantity - NEW.quantity
	where app_for_user_stock.id = NEW.product_id;
     return new;
 END;
 $$;


ALTER FUNCTION public.settt2() OWNER TO postgres;

--
-- Name: settt3(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.settt3() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
 BEGIN
	update app_for_user_stock
	set quantity = quantity - NEW.quantity
	where app_for_user_stock.id = NEW.product_id;
     return new;
 END;
 $$;


ALTER FUNCTION public.settt3() OWNER TO postgres;

--
-- Name: setunitpriceforbill(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.setunitpriceforbill() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     price integer;
 BEGIN
    price = (select app_for_user_product.price 
                      from app_for_user_product 
                      where app_for_user_product.id = (select product_id
                                                       from app_for_user_stock, app_for_user_product
                                                       where app_for_user_stock.product_id = app_for_user_product.id
                                                             and app_for_user_stock.id = NEW.product_id));
    update app_for_user_billdetail
    set unit_price = price
    where NEW.id = app_for_user_billdetail.id;
    
--     update app_for_user_bill
--     set total_price = total_price + price*NEW.quantity
--     where app_for_user_bill.id = NEW.bill_id;
     return NEW;
 END;
 $$;


ALTER FUNCTION public.setunitpriceforbill() OWNER TO postgres;

--
-- Name: totalprice(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.totalprice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 update app_for_user_goodsreceipt 
 set total_price = total_price + NEW.quantity*NEW.unit_price
 where app_for_user_goodsreceipt.id = NEW.goods_receipt_id;
     return NEW;
 END;
 $$;


ALTER FUNCTION public.totalprice() OWNER TO postgres;

--
-- Name: totalprice1(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.totalprice1() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 update app_for_user_goodsreceipt 
 set total_price = total_price + NEW.quantity*NEW.unit_price - OLD.quantity*OLD.unit_price
 where app_for_user_goodsreceipt.id = NEW.goods_receipt_id;
     return NEW;
 END;
 $$;


ALTER FUNCTION public.totalprice1() OWNER TO postgres;

--
-- Name: totalprice2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.totalprice2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 update app_for_user_goodsreceipt 
 set total_price = total_price - OLD.quantity*OLD.unit_price
 where app_for_user_goodsreceipt.id = OLD.goods_receipt_id;
     return OLD;
 END;
 $$;


ALTER FUNCTION public.totalprice2() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Users_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users_account" (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    email character varying(255) NOT NULL,
    username character varying(50) NOT NULL,
    sex character varying(10) NOT NULL,
    phone_num character varying(10),
    date_joined timestamp with time zone NOT NULL,
    last_login timestamp with time zone NOT NULL,
    is_active boolean NOT NULL,
    is_admin boolean NOT NULL,
    is_staff boolean NOT NULL,
    is_superuser boolean NOT NULL,
    address character varying(150) NOT NULL
);


ALTER TABLE public."Users_account" OWNER TO postgres;

--
-- Name: Users_account_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users_account_groups" (
    id integer NOT NULL,
    account_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public."Users_account_groups" OWNER TO postgres;

--
-- Name: Users_account_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_account_groups_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Users_account_groups_id_seq" OWNER TO postgres;

--
-- Name: Users_account_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_account_groups_id_seq" OWNED BY public."Users_account_groups".id;


--
-- Name: Users_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_account_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Users_account_id_seq" OWNER TO postgres;

--
-- Name: Users_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_account_id_seq" OWNED BY public."Users_account".id;


--
-- Name: Users_account_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users_account_user_permissions" (
    id integer NOT NULL,
    account_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public."Users_account_user_permissions" OWNER TO postgres;

--
-- Name: Users_account_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_account_user_permissions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Users_account_user_permissions_id_seq" OWNER TO postgres;

--
-- Name: Users_account_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_account_user_permissions_id_seq" OWNED BY public."Users_account_user_permissions".id;


--
-- Name: app_for_user_bill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_bill (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    state character varying(20) NOT NULL,
    total_price integer NOT NULL,
    customer_id integer NOT NULL,
    address character varying(150) NOT NULL
);


ALTER TABLE public.app_for_user_bill OWNER TO postgres;

--
-- Name: app_for_user_bill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_bill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_bill_id_seq OWNER TO postgres;

--
-- Name: app_for_user_bill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_bill_id_seq OWNED BY public.app_for_user_bill.id;


--
-- Name: app_for_user_billdetail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_billdetail (
    id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price integer NOT NULL,
    bill_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.app_for_user_billdetail OWNER TO postgres;

--
-- Name: app_for_user_billdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_billdetail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_billdetail_id_seq OWNER TO postgres;

--
-- Name: app_for_user_billdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_billdetail_id_seq OWNED BY public.app_for_user_billdetail.id;


--
-- Name: app_for_user_goodsreceipt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_goodsreceipt (
    id integer NOT NULL,
    deliverer character varying(100) NOT NULL,
    total_price integer NOT NULL,
    date timestamp with time zone NOT NULL,
    vendor_id integer NOT NULL
);


ALTER TABLE public.app_for_user_goodsreceipt OWNER TO postgres;

--
-- Name: app_for_user_goodsreceipt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_goodsreceipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_goodsreceipt_id_seq OWNER TO postgres;

--
-- Name: app_for_user_goodsreceipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_goodsreceipt_id_seq OWNED BY public.app_for_user_goodsreceipt.id;


--
-- Name: app_for_user_goodsreceiptdetail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_goodsreceiptdetail (
    id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price integer NOT NULL,
    goods_receipt_id integer NOT NULL,
    product_id integer NOT NULL,
    size_id integer NOT NULL
);


ALTER TABLE public.app_for_user_goodsreceiptdetail OWNER TO postgres;

--
-- Name: app_for_user_goodsreceiptdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_goodsreceiptdetail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_goodsreceiptdetail_id_seq OWNER TO postgres;

--
-- Name: app_for_user_goodsreceiptdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_goodsreceiptdetail_id_seq OWNED BY public.app_for_user_goodsreceiptdetail.id;


--
-- Name: app_for_user_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_product (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    price integer NOT NULL,
    img character varying(100) NOT NULL,
    type_id integer NOT NULL
);


ALTER TABLE public.app_for_user_product OWNER TO postgres;

--
-- Name: app_for_user_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_product_id_seq OWNER TO postgres;

--
-- Name: app_for_user_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_product_id_seq OWNED BY public.app_for_user_product.id;


--
-- Name: app_for_user_producttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_producttype (
    id integer NOT NULL,
    type_name character varying(20) NOT NULL
);


ALTER TABLE public.app_for_user_producttype OWNER TO postgres;

--
-- Name: app_for_user_producttype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_producttype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_producttype_id_seq OWNER TO postgres;

--
-- Name: app_for_user_producttype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_producttype_id_seq OWNED BY public.app_for_user_producttype.id;


--
-- Name: app_for_user_size; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_size (
    id integer NOT NULL,
    size character varying(10) NOT NULL
);


ALTER TABLE public.app_for_user_size OWNER TO postgres;

--
-- Name: app_for_user_size_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_size_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_size_id_seq OWNER TO postgres;

--
-- Name: app_for_user_size_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_size_id_seq OWNED BY public.app_for_user_size.id;


--
-- Name: app_for_user_stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_stock (
    id integer NOT NULL,
    quantity integer NOT NULL,
    product_id integer NOT NULL,
    size_id integer NOT NULL
);


ALTER TABLE public.app_for_user_stock OWNER TO postgres;

--
-- Name: app_for_user_stock_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_stock_id_seq OWNER TO postgres;

--
-- Name: app_for_user_stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_stock_id_seq OWNED BY public.app_for_user_stock.id;


--
-- Name: app_for_user_vendor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_vendor (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    phone_num character varying(10),
    address character varying(100) NOT NULL
);


ALTER TABLE public.app_for_user_vendor OWNER TO postgres;

--
-- Name: app_for_user_vendor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_vendor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_vendor_id_seq OWNER TO postgres;

--
-- Name: app_for_user_vendor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_vendor_id_seq OWNED BY public.app_for_user_vendor.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test (
    value integer
);


ALTER TABLE public.test OWNER TO postgres;

--
-- Name: Users_account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account" ALTER COLUMN id SET DEFAULT nextval('public."Users_account_id_seq"'::regclass);


--
-- Name: Users_account_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_groups" ALTER COLUMN id SET DEFAULT nextval('public."Users_account_groups_id_seq"'::regclass);


--
-- Name: Users_account_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_user_permissions" ALTER COLUMN id SET DEFAULT nextval('public."Users_account_user_permissions_id_seq"'::regclass);


--
-- Name: app_for_user_bill id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_bill ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_bill_id_seq'::regclass);


--
-- Name: app_for_user_billdetail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_billdetail ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_billdetail_id_seq'::regclass);


--
-- Name: app_for_user_goodsreceipt id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceipt ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_goodsreceipt_id_seq'::regclass);


--
-- Name: app_for_user_goodsreceiptdetail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceiptdetail ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_goodsreceiptdetail_id_seq'::regclass);


--
-- Name: app_for_user_product id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_product ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_product_id_seq'::regclass);


--
-- Name: app_for_user_producttype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_producttype ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_producttype_id_seq'::regclass);


--
-- Name: app_for_user_size id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_size ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_size_id_seq'::regclass);


--
-- Name: app_for_user_stock id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_stock ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_stock_id_seq'::regclass);


--
-- Name: app_for_user_vendor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_vendor ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_vendor_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Data for Name: Users_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users_account" (id, password, email, username, sex, phone_num, date_joined, last_login, is_active, is_admin, is_staff, is_superuser, address) FROM stdin;
27	pbkdf2_sha256$216000$OlqtnP3NKQc7$ONBk7sEkCjdJLJxAlg5iC/tlc8YF7G9133SxiSn7Jn0=	nhat1509@gmail.com	NhatBa	Female	0125846932	2021-07-16 11:46:17.07588+07	2021-07-16 11:46:31.24569+07	t	f	f	f	13 Van Cao
4	pbkdf2_sha256$216000$LxT6ThAgYWgl$NH/+SXuj64iAF/ykieeVrEYgaGoEr/ZP8ybh/uq4bhc=	nhat@gmail.com	Nhat	Female	0123569845	2021-07-15 13:57:43.671534+07	2021-07-16 10:08:08.164053+07	t	f	f	f	13 Van Cao
3	pbkdf2_sha256$216000$Oy0QlpXe8eyD$rLxvnUNDBcz5t865BOfLEzMGKqpeTkrBR/39HJmWEyM=	vy123@gmail.com	Ngô Vy	Female	0234521356	2021-07-15 12:09:56.458931+07	2021-07-15 13:54:41.691125+07	t	f	f	f	456 Văn Cao
26	pbkdf2_sha256$216000$0kNmGJbuLIkZ$tzOWMRtNaGZ6blvNf42tg2M98xGfwteXlbd1Hzc8fik=	nhat1508@gmail.com	Lưu Bị	Male	0125874693	2021-07-16 11:44:28.894692+07	2021-07-17 15:30:25.801827+07	t	f	f	f	15 Van Cao
1	pbkdf2_sha256$216000$Lw5fS3vy65ng$C6mFobysnI00JmFhtyVOJVzDAY2H3bYuXhmrCh9Lk/M=	thang@gmail.com	Thang	Female	0901407894	2021-07-13 08:02:34.754396+07	2021-07-21 10:31:06.8609+07	t	t	t	t	
28	pbkdf2_sha256$216000$CjMJ7qvJrsyL$z7z+oH2bAbvFYXrYRPgr/x1SbyZxx464Bb2VfQisDjE=	tu@gmail.com	Huỳnh Tú	Female	0925897456	2021-07-21 15:00:36.306431+07	2021-07-21 15:01:01.624879+07	t	f	f	f	13 Van Cao
\.


--
-- Data for Name: Users_account_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users_account_groups" (id, account_id, group_id) FROM stdin;
\.


--
-- Data for Name: Users_account_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users_account_user_permissions" (id, account_id, permission_id) FROM stdin;
\.


--
-- Data for Name: app_for_user_bill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_bill (id, date, state, total_price, customer_id, address) FROM stdin;
12	2021-07-21 18:11:56.603508+07	1	1920000	28	13 Van Cao
13	2021-07-21 19:02:39.105386+07	1	38000000	28	13 Van Cao
14	2021-07-22 10:22:02.181033+07	1	4500000	28	13 Van Cao
1	2021-07-13 08:20:41.412203+07	1	1800000	1	
2	2021-07-17 21:07:56.071759+07	1	800000	26	
3	2021-07-17 21:12:23.76607+07	1	4800000	26	
15	2021-07-22 21:05:00.45369+07	1	106560000	28	13 Van Cao
4	2021-07-17 21:13:21.28636+07	1	25200000	26	13 Van Cao
5	2021-07-18 16:47:54.994334+07	1	1280000	26	13 Van Cao
6	2021-07-21 10:31:25.08866+07	1	4500000	26	13 Van Cao
7	2021-07-21 15:01:11.855464+07	1	3600000	28	13 Van Cao
9	2020-07-21 15:01:11.855464+07	1	1	1	16 vam cao
8	2021-06-21 15:01:11.855464+07	1	1	1	16 van cao
10	2021-07-21 18:09:54.825542+07	1	640000	28	13 Van Cao
11	2021-07-21 18:10:41.514213+07	1	1920000	28	13 Van Cao
\.


--
-- Data for Name: app_for_user_billdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_billdetail (id, quantity, unit_price, bill_id, product_id) FROM stdin;
6	2	900000	1	3
7	1	800000	2	245
8	6	800000	3	245
37	12	1800000	4	40
42	6	600000	4	21
44	2	640000	5	41
45	5	900000	6	9
46	3	600000	7	13
47	3	600000	7	15
48	1	640000	10	41
49	3	640000	11	41
51	3	640000	12	41
53	6	900000	13	1
54	7	800000	13	45
55	5	600000	13	297
56	20	1200000	13	305
57	5	900000	14	3
59	12	1300000	15	149
60	4	840000	15	185
61	22	1600000	15	181
62	19	600000	15	241
63	23	600000	15	249
58	34	800000	15	265
\.


--
-- Data for Name: app_for_user_goodsreceipt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_goodsreceipt (id, deliverer, total_price, date, vendor_id) FROM stdin;
1	Thang	1900000	2021-07-13 08:12:30.334837+07	1
\.


--
-- Data for Name: app_for_user_goodsreceiptdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_goodsreceiptdetail (id, quantity, unit_price, goods_receipt_id, product_id, size_id) FROM stdin;
1	15	80000	1	2	1
2	10	70000	1	2	3
\.


--
-- Data for Name: app_for_user_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_product (id, name, price, img, type_id) FROM stdin;
1	3-Stripes Pants	900000	productImg/product_46.jpg	2
2	Arsenal Third Jersey	1800000	productImg/product_14.jpg	1
3	Chile 20 Tee	900000	productImg/product_15.jpg	1
4	3D Trefoil Graphic Tee	600000	productImg/product_16.jpg	1
5	Trefoil Tee	600000	productImg/product_17.jpg	1
6	Pride Trefoil Flag Fill Tee	600000	productImg/product_32.jpg	1
7	Big Badge of Sport Boxy Tee	600000	productImg/product_33.jpg	1
8	Lil Stripe Splash Tee	500000	productImg/product_34.jpg	1
9	Adiprene Tee	700000	productImg/product_35.jpg	1
10	Juventus 20/21 Third Jersey	1800000	productImg/product_36.jpg	1
11	adidas Z.N.E. Pants	640000	productImg/product_47.jpg	2
12	Tiro 19 Training Pants	800000	productImg/product_48.jpg	2
13	Aeroready Knit Pants	860000	productImg/product_55.jpg	2
14	Outline Sweat Pants	1240000	productImg/product_56.jpg	2
15	3-Stripes Pants	780000	productImg/product_57.jpg	2
16	3-Stripes Tee	700000	productImg/product_18.jpg	1
17	Adiprene Tee	560000	productImg/product_19.jpg	1
18	Chile 20 Tee	800000	productImg/product_20.jpg	1
19	M.U Long Sleeve Tee	1400000	productImg/product_21.jpg	1
20	Tiro 19 Training Pants	1100000	productImg/product_58.jpg	2
21	Essentials Wind Pants	1200000	productImg/product_59.jpg	2
22	Tiro 19 Training Pants	1200000	productImg/product_60.jpg	2
23	French Terry Pants	1600000	productImg/product_61.jpg	2
24	Alphaskin 2.0 Sport Tights	1120000	productImg/product_62.jpg	2
25	Firebird Track Pants	1400000	productImg/product_63.jpg	2
26	Essentials Fleece Jogger Pants	640000	productImg/product_64.jpg	2
27	Adicolor SST Track Pants	800000	productImg/product_65.jpg	2
28	Must Haves Primeblue Pants	900000	productImg/product_66.jpg	2
29	Classics Track Pants	640000	productImg/product_67.jpg	2
30	ID Pants	900000	productImg/product_68.jpg	2
31	Cross Up 365 Pants	900000	productImg/product_69.jpg	2
32	Bouclette Pants	1000000	productImg/product_70.jpg	2
33	Own the Run Astro Pants	640000	productImg/product_71.jpg	2
34	R.Y.V. Sweat Pants	900000	productImg/product_72.jpg	2
35	O Shape Pants	1120000	productImg/product_73.jpg	2
36	Must Haves Stadium Pants	1400000	productImg/product_74.jpg	2
37	3-Stripes Pants	900000	productImg/product_75.jpg	2
38	Essentials Tapered Pants	1300000	productImg/product_76.jpg	2
39	Brilliant Basics Pants	840000	productImg/product_77.jpg	2
40	adidas Z.N.E. Woven Pants	1200000	productImg/product_78.jpg	2
41	3-Stripes Tapered Pants	1120000	productImg/product_79.jpg	2
42	Camouflage Pants	1400000	productImg/product_80.jpg	2
43	Essentials Colorblock Pants	840000	productImg/product_81.jpg	2
44	Adventure Track Pants	1200000	productImg/product_82.jpg	2
45	Essentials 3-Stripes Pants	1200000	productImg/product_83.jpg	2
46	Adi Primeblue Track Pants	1600000	productImg/product_84.jpg	2
47	Tiro 19 Training Pants	840000	productImg/product_85.jpg	2
48	3D Trefoil Graphic Sweat Pants	1200000	productImg/product_86.jpg	2
49	Trefoil Tee	600000	productImg/product_0.jpg	1
50	Short Sleeve Shmoo Tee	700000	productImg/product_1.jpg	1
51	Must Haves Stadium Tee	560000	productImg/product_2.jpg	1
52	Run It 3-Stripes PB Tee	700000	productImg/product_3.jpg	1
53	Own Long Sleeve Tee	700000	productImg/product_4.jpg	1
54	Own the Run Tee	700000	productImg/product_5.jpg	1
55	3-Stripes Tee	700000	productImg/product_6.jpg	1
56	Chile 20 Tee	800000	productImg/product_7.jpg	1
57	Trefoil Tee	600000	productImg/product_8.jpg	1
58	Real Madrid Third Jersey	1800000	productImg/product_9.jpg	1
59	25/7 Primeblue Tee	900000	productImg/product_10.jpg	1
60	3-Stripes Tee	800000	productImg/product_11.jpg	1
61	NY Pigeon Tee	600000	productImg/product_12.jpg	1
62	R.Y.V. Graphic Tee	800000	productImg/product_22.jpg	1
63	New Stacked LA Trefoil Tee	600000	productImg/product_23.jpg	1
64	M.U Third Jersey	1800000	productImg/product_24.jpg	1
65	Badge of Sport Tee	500000	productImg/product_26.jpg	1
66	Own the Run Tee	700000	productImg/product_27.jpg	1
67	TAN Logo Tee	800000	productImg/product_29.jpg	1
68	Torsion Tee	700000	productImg/product_30.jpg	1
69	Big Trefoil Outline Tee	600000	productImg/product_31.jpg	1
70	Real Madrid DNA Graphic Tee	500000	productImg/product_37.jpg	1
71	Captain Tsubasa Tee	800000	productImg/product_38.jpg	1
72	USA Volleyball 1/4 Zip Tee	1100000	productImg/product_39.jpg	1
73	Unity Tee	800000	productImg/product_40.jpg	1
74	R.Y.V. Tee	600000	productImg/product_41.jpg	1
75	Badge of Sport Tee	600000	productImg/product_42.jpg	1
76	New Stacked Trefoil Tee	600000	productImg/product_43.jpg	1
77	Essentials 3-Stripes Wind Pants	1200000	productImg/product_49.jpg	1
78	Sport French Terry Pants	1700000	productImg/product_50.jpg	2
79	Woven Tape Pants	900000	productImg/product_51.jpg	2
80	Trefoil Essentials Pants	640000	productImg/product_52.jpg	2
81	3-Stripes Pants	900000	productImg/product_53.jpg	2
82	Run It 3-Stripes Astro Pants	1000000	productImg/product_54.jpg	2
\.


--
-- Data for Name: app_for_user_producttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_producttype (id, type_name) FROM stdin;
1	T-Shirt
2	Pant
\.


--
-- Data for Name: app_for_user_size; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_size (id, size) FROM stdin;
1	L
2	XL
3	S
4	M
\.


--
-- Data for Name: app_for_user_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_stock (id, quantity, product_id, size_id) FROM stdin;
1	1012	1	1
45	993	12	1
144	990	36	4
21	994	6	1
9	995	3	1
13	997	4	1
15	997	4	3
41	991	11	1
3	995	1	3
38	992	10	2
37	995	10	1
2	1002	1	2
40	1000	10	4
4	1000	1	4
6	1000	2	2
8	1000	2	4
10	1000	3	2
11	1000	3	3
12	1000	3	4
14	1000	4	2
16	1000	4	4
17	1000	5	1
18	1000	5	2
19	1000	5	3
20	1000	5	4
22	1000	6	2
23	1000	6	3
24	1000	6	4
25	1000	7	1
26	1000	7	2
27	1000	7	3
28	1000	7	4
29	1000	8	1
30	1000	8	2
31	1000	8	3
32	1000	8	4
33	1000	9	1
34	1000	9	2
35	1000	9	3
36	1000	9	4
39	1000	10	3
42	1000	11	2
43	1000	11	3
44	1000	11	4
46	1000	12	2
47	1000	12	3
48	1000	12	4
49	1000	13	1
50	1000	13	2
51	1000	13	3
52	1000	13	4
53	1000	14	1
54	1000	14	2
55	1000	14	3
56	1000	14	4
57	1000	15	1
58	1000	15	2
59	1000	15	3
60	1000	15	4
61	1000	16	1
62	1000	16	2
63	1000	16	3
64	1000	16	4
65	1000	17	1
66	1000	17	2
67	1000	17	3
68	1000	17	4
69	1000	18	1
70	1000	18	2
71	1000	18	3
72	1000	18	4
73	1000	19	1
74	1000	19	2
75	1000	19	3
76	1000	19	4
77	1000	20	1
78	1000	20	2
79	1000	20	3
80	1000	20	4
81	1000	21	1
82	1000	21	2
83	1000	21	3
84	1000	21	4
85	1000	22	1
86	1000	22	2
87	1000	22	3
88	1000	22	4
89	1000	23	1
90	1000	23	2
91	1000	23	3
92	1000	23	4
93	1000	24	1
94	1000	24	2
95	1000	24	3
96	1000	24	4
97	1000	25	1
98	1000	25	2
99	1000	25	3
100	1000	25	4
101	1000	26	1
102	1000	26	2
103	1000	26	3
104	1000	26	4
105	1000	27	1
106	1000	27	2
107	1000	27	3
108	1000	27	4
109	1000	28	1
110	1000	28	2
111	1000	28	3
112	1000	28	4
113	1000	29	1
114	1000	29	2
115	1000	29	3
116	1000	29	4
117	1000	30	1
118	1000	30	2
119	1000	30	3
120	1000	30	4
121	1000	31	1
122	1000	31	2
123	1000	31	3
124	1000	31	4
125	1000	32	1
126	1000	32	2
127	1000	32	3
128	1000	32	4
129	1000	33	1
130	1000	33	2
131	1000	33	3
132	1000	33	4
133	1000	34	1
134	1000	34	2
135	1000	34	3
136	1000	34	4
137	1000	35	1
138	1000	35	2
139	1000	35	3
140	1000	35	4
145	1000	37	1
146	1000	37	2
147	1000	37	3
148	1000	37	4
150	1000	38	2
151	1000	38	3
152	1000	38	4
153	1000	39	1
154	1000	39	2
155	1000	39	3
156	1000	39	4
157	1000	40	1
158	1000	40	2
159	1000	40	3
160	1000	40	4
161	1000	41	1
162	1000	41	2
163	1000	41	3
164	1000	41	4
165	1000	42	1
166	1000	42	2
167	1000	42	3
168	1000	42	4
169	1000	43	1
170	1000	43	2
171	1000	43	3
172	1000	43	4
173	1000	44	1
174	1000	44	2
175	1000	44	3
176	1000	44	4
177	1000	45	1
178	1000	45	2
179	1000	45	3
180	1000	45	4
182	1000	46	2
183	1000	46	3
184	1000	46	4
7	1000	2	3
186	1000	47	2
187	1000	47	3
188	1000	47	4
189	1000	48	1
190	1000	48	2
191	1000	48	3
192	1000	48	4
193	1000	49	1
194	1000	49	2
195	1000	49	3
196	1000	49	4
197	1000	50	1
198	1000	50	2
199	1000	50	3
200	1000	50	4
201	1000	51	1
202	1000	51	2
203	1000	51	3
204	1000	51	4
205	1000	52	1
206	1000	52	2
207	1000	52	3
208	1000	52	4
209	1000	53	1
210	1000	53	2
211	1000	53	3
212	1000	53	4
213	1000	54	1
214	1000	54	2
215	1000	54	3
216	1000	54	4
217	1000	55	1
218	1000	55	2
219	1000	55	3
220	1000	55	4
221	1000	56	1
222	1000	56	2
223	1000	56	3
224	1000	56	4
225	1000	57	1
226	1000	57	2
227	1000	57	3
228	1000	57	4
149	988	38	1
142	900	36	2
141	998	36	1
143	998	36	3
185	996	47	1
181	978	46	1
229	1000	58	1
230	1000	58	2
231	1000	58	3
232	1000	58	4
233	1000	59	1
234	1000	59	2
235	1000	59	3
236	1000	59	4
237	1000	60	1
238	1000	60	2
239	1000	60	3
240	1000	60	4
242	1000	61	2
243	1000	61	3
244	1000	61	4
245	1000	62	1
246	1000	62	2
247	1000	62	3
248	1000	62	4
250	1000	63	2
251	1000	63	3
252	1000	63	4
253	1000	64	1
254	1000	64	2
255	1000	64	3
256	1000	64	4
257	1000	65	1
258	1000	65	2
259	1000	65	3
260	1000	65	4
263	1000	66	3
266	1000	67	2
267	1000	67	3
268	1000	67	4
269	1000	68	1
270	1000	68	2
271	1000	68	3
272	1000	68	4
273	1000	69	1
274	1000	69	2
275	1000	69	3
276	1000	69	4
277	1000	70	1
278	1000	70	2
279	1000	70	3
280	1000	70	4
281	1000	71	1
282	1000	71	2
283	1000	71	3
284	1000	71	4
285	1000	72	1
286	1000	72	2
287	1000	72	3
288	1000	72	4
289	1000	73	1
290	1000	73	2
291	1000	73	3
292	1000	73	4
293	1000	74	1
294	1000	74	2
295	1000	74	3
296	1000	74	4
298	1000	75	2
299	1000	75	3
300	1000	75	4
301	1000	76	1
302	1000	76	2
303	1000	76	3
304	1000	76	4
306	1000	77	2
307	1000	77	3
308	1000	77	4
309	1000	78	1
310	1000	78	2
311	1000	78	3
312	1000	78	4
313	1000	79	1
314	1000	79	2
315	1000	79	3
316	1000	79	4
317	1000	80	1
318	1000	80	2
319	1000	80	3
320	1000	80	4
321	1000	81	1
322	1000	81	2
323	1000	81	3
324	1000	81	4
325	1000	82	1
326	1000	82	2
327	1000	82	3
328	1000	82	4
297	995	75	1
262	996	66	2
305	980	77	1
264	998	66	4
261	994	66	1
241	981	61	1
249	977	63	1
265	966	67	1
5	991	2	1
\.


--
-- Data for Name: app_for_user_vendor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_vendor (id, name, email, phone_num, address) FROM stdin;
1	Cty TNHH MOT MINH TOI	toicodon@gmail.com	0111111111	13 Bùi Thị Xuân
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add account	1	add_account
2	Can change account	1	change_account
3	Can delete account	1	delete_account
4	Can view account	1	view_account
5	Can add bill	2	add_bill
6	Can change bill	2	change_bill
7	Can delete bill	2	delete_bill
8	Can view bill	2	view_bill
9	Can add product	3	add_product
10	Can change product	3	change_product
11	Can delete product	3	delete_product
12	Can view product	3	view_product
13	Can add Product type	4	add_producttype
14	Can change Product type	4	change_producttype
15	Can delete Product type	4	delete_producttype
16	Can view Product type	4	view_producttype
17	Can add size	5	add_size
18	Can change size	5	change_size
19	Can delete size	5	delete_size
20	Can view size	5	view_size
21	Can add vendor	6	add_vendor
22	Can change vendor	6	change_vendor
23	Can delete vendor	6	delete_vendor
24	Can view vendor	6	view_vendor
25	Can add stock	7	add_stock
26	Can change stock	7	change_stock
27	Can delete stock	7	delete_stock
28	Can view stock	7	view_stock
29	Can add Goods receipt	8	add_goodsreceipt
30	Can change Goods receipt	8	change_goodsreceipt
31	Can delete Goods receipt	8	delete_goodsreceipt
32	Can view Goods receipt	8	view_goodsreceipt
33	Can add Goods receipt detail	9	add_goodsreceiptdetail
34	Can change Goods receipt detail	9	change_goodsreceiptdetail
35	Can delete Goods receipt detail	9	delete_goodsreceiptdetail
36	Can view Goods receipt detail	9	view_goodsreceiptdetail
37	Can add bill detail	10	add_billdetail
38	Can change bill detail	10	change_billdetail
39	Can delete bill detail	10	delete_billdetail
40	Can view bill detail	10	view_billdetail
41	Can add log entry	11	add_logentry
42	Can change log entry	11	change_logentry
43	Can delete log entry	11	delete_logentry
44	Can view log entry	11	view_logentry
45	Can add permission	12	add_permission
46	Can change permission	12	change_permission
47	Can delete permission	12	delete_permission
48	Can view permission	12	view_permission
49	Can add group	13	add_group
50	Can change group	13	change_group
51	Can delete group	13	delete_group
52	Can view group	13	view_group
53	Can add content type	14	add_contenttype
54	Can change content type	14	change_contenttype
55	Can delete content type	14	delete_contenttype
56	Can view content type	14	view_contenttype
57	Can add session	15	add_session
58	Can change session	15	change_session
59	Can delete session	15	delete_session
60	Can view session	15	view_session
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2021-07-13 08:03:13.2795+07	1	L	1	[{"added": {}}]	5	1
2	2021-07-13 08:03:16.892374+07	2	XL	1	[{"added": {}}]	5	1
3	2021-07-13 08:03:19.414207+07	3	S	1	[{"added": {}}]	5	1
4	2021-07-13 08:03:20.827236+07	4	M	1	[{"added": {}}]	5	1
5	2021-07-13 08:03:44.496562+07	1	T	1	[{"added": {}}]	4	1
6	2021-07-13 08:03:51.766576+07	1	T-Shirt	2	[{"changed": {"fields": ["Type name"]}}]	4	1
7	2021-07-13 08:03:58.221251+07	1	T-Shirt	2	[]	4	1
8	2021-07-13 08:04:02.843562+07	2	Pant	1	[{"added": {}}]	4	1
9	2021-07-13 08:11:40.426684+07	1	Cty TNHH MOT MINH TOI	1	[{"added": {}}]	6	1
10	2021-07-13 08:12:30.340837+07	1	GoodsReceipt object (1)	1	[{"added": {}}, {"added": {"name": "Goods receipt detail", "object": "GoodsReceiptDetail object (1)"}}]	8	1
11	2021-07-13 08:14:01.422392+07	1	GoodsReceipt object (1)	2	[{"added": {"name": "Goods receipt detail", "object": "GoodsReceiptDetail object (2)"}}, {"changed": {"name": "Goods receipt detail", "object": "GoodsReceiptDetail object (1)", "fields": ["Quantity"]}}]	8	1
12	2021-07-13 08:14:41.049963+07	1	GoodsReceipt object (1)	2	[{"changed": {"name": "Goods receipt detail", "object": "GoodsReceiptDetail object (2)", "fields": ["Quantity"]}}]	8	1
13	2021-07-13 08:20:41.421203+07	1	1	1	[{"added": {}}, {"added": {"name": "bill detail", "object": "BillDetail object (1)"}}]	2	1
14	2021-07-13 08:21:01.980709+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
15	2021-07-13 08:21:12.810517+07	1	1	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
16	2021-07-13 08:22:23.714559+07	1	1	2	[{"added": {"name": "bill detail", "object": "BillDetail object (2)"}}]	2	1
17	2021-07-13 08:22:36.502664+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (2)", "fields": ["Quantity"]}}]	2	1
18	2021-07-13 08:22:46.604525+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (2)", "fields": ["Quantity"]}}]	2	1
19	2021-07-13 08:22:59.37275+07	1	1	2	[{"added": {"name": "bill detail", "object": "BillDetail object (3)"}}]	2	1
20	2021-07-13 08:23:07.422094+07	1	1	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
21	2021-07-13 08:25:07.475857+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (2)", "fields": ["Quantity"]}}]	2	1
22	2021-07-13 08:25:24.088844+07	1	1	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
23	2021-07-13 08:28:48.507086+07	1	1	2	[{"added": {"name": "bill detail", "object": "BillDetail object (4)"}}]	2	1
24	2021-07-13 08:30:00.505204+07	1	1	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
25	2021-07-13 08:32:07.36846+07	1	1	2	[{"added": {"name": "bill detail", "object": "BillDetail object (5)"}}]	2	1
26	2021-07-13 08:32:19.355146+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (5)", "fields": ["Quantity"]}}]	2	1
27	2021-07-13 08:32:40.164336+07	1	1	2	[{"added": {"name": "bill detail", "object": "BillDetail object (6)"}}]	2	1
28	2021-07-13 08:32:47.616762+07	1	1	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
29	2021-07-14 17:52:27.117642+07	1	thang@gmail.com	2	[{"changed": {"fields": ["Phone number"]}}]	1	1
30	2021-07-15 13:50:36.157081+07	3	vy123@gmail.com	2	[{"changed": {"fields": ["password"]}}]	1	1
31	2021-07-15 13:51:23.16277+07	3	vy123@gmail.com	2	[{"changed": {"fields": ["password"]}}]	1	1
32	2021-07-15 13:56:26.791136+07	3	vy123@gmail.com	2	[]	1	1
33	2021-07-15 13:56:29.935316+07	3	vy123@gmail.com	2	[]	1	1
34	2021-07-15 13:57:43.672534+07	4	nhat@gmail.com	1	[{"added": {}}]	1	1
35	2021-07-15 14:19:42.633598+07	4	nhat@gmail.com	2	[{"changed": {"fields": ["password"]}}]	1	1
36	2021-07-16 10:22:53.385685+07	5	vy12@gmail.com	3		1	1
37	2021-07-16 10:22:53.559695+07	7	nhat1508@gmail.com	3		1	1
38	2021-07-16 10:22:53.562695+07	8	nhat1509@gmail.com	3		1	1
39	2021-07-16 10:22:53.564695+07	6	nhat123@gmail.com	3		1	1
40	2021-07-16 10:22:53.566695+07	2	vyngu@gmail.com	3		1	1
41	2021-07-16 10:27:53.089827+07	9	nhat1508@gmail.com	3		1	1
42	2021-07-16 10:33:20.861575+07	10	nhat1508@gmail.com	3		1	1
43	2021-07-16 10:35:59.87767+07	12	vy3@gmail.com	1	[{"added": {}}]	1	1
44	2021-07-16 10:37:31.967937+07	11	nhat1508@gmail.com	3		1	1
45	2021-07-16 10:38:34.055488+07	13	nhat1508@gmail.com	3		1	1
46	2021-07-16 10:42:19.151363+07	14	nhat1508@gmail.com	3		1	1
47	2021-07-16 10:42:19.157363+07	15	nhat1509@gmail.com	3		1	1
48	2021-07-16 10:56:56.573549+07	16	nhat1509@gmail.com	3		1	1
49	2021-07-16 11:02:27.919501+07	17	nhat1509@gmail.com	3		1	1
50	2021-07-16 11:04:54.115862+07	19	nhat1501@gmail.com	1	[{"added": {}}]	1	1
51	2021-07-16 11:05:36.882309+07	18	nhat1509@gmail.com	2	[{"changed": {"fields": ["password"]}}]	1	1
52	2021-07-16 11:26:34.392234+07	19	nhat1501@gmail.com	3		1	1
53	2021-07-16 11:26:34.432236+07	18	nhat1509@gmail.com	3		1	1
54	2021-07-16 11:26:34.433236+07	20	xuanmailoton@gmail.com	3		1	1
55	2021-07-16 11:34:22.590013+07	21	xuanmailoton@gmail.com	3		1	1
56	2021-07-16 11:38:33.031338+07	24	nhat1508@gmail.com	2	[{"changed": {"fields": ["Phone number", "Address", "Is staff"]}}]	1	1
57	2021-07-16 11:39:50.789785+07	24	nhat1508@gmail.com	2	[{"changed": {"fields": ["password"]}}]	1	1
58	2021-07-16 11:43:30.46635+07	24	nhat1508@gmail.com	3		1	1
59	2021-07-16 11:43:30.46835+07	25	nhat1509@gmail.com	3		1	1
60	2021-07-16 11:43:30.46935+07	12	vy3@gmail.com	3		1	1
61	2021-07-16 11:43:30.47035+07	23	xuanmailoton@gmail.com	3		1	1
62	2021-07-16 19:11:36.482042+07	26	nhat1508@gmail.com	2	[{"changed": {"fields": ["Phone number", "Address"]}}]	1	1
63	2021-07-16 19:12:16.327322+07	26	nhat1508@gmail.com	2	[{"changed": {"fields": ["Sex"]}}]	1	1
64	2021-07-17 21:12:01.279784+07	2	2	2	[{"changed": {"fields": ["State"]}}]	2	1
65	2021-07-17 21:12:14.280528+07	2	2	2	[{"changed": {"fields": ["State"]}}]	2	1
66	2021-07-17 21:13:11.168781+07	3	3	2	[{"changed": {"fields": ["State"]}}]	2	1
67	2021-07-18 08:13:04.636444+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (11)", "fields": ["Quantity"]}}]	2	1
68	2021-07-18 08:14:53.48067+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (11)", "fields": ["Quantity"]}}]	2	1
69	2021-07-18 13:43:17.790032+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
70	2021-07-18 13:44:47.38054+07	4	4	2	[{"added": {"name": "bill detail", "object": "BillDetail object (13)"}}]	2	1
71	2021-07-18 14:12:29.114868+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (22)", "fields": ["Quantity"]}}]	2	1
72	2021-07-18 14:12:39.15783+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (22)", "fields": ["Quantity"]}}]	2	1
73	2021-07-18 14:34:51.539463+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
74	2021-07-18 14:45:18.597641+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
75	2021-07-18 14:45:58.695322+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (29)", "fields": ["Quantity"]}}]	2	1
76	2021-07-18 14:46:19.268463+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (29)", "fields": ["Quantity"]}}]	2	1
77	2021-07-18 14:46:25.487314+07	4	4	2	[]	2	1
78	2021-07-18 14:58:48.676312+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (29)", "fields": ["Quantity"]}}]	2	1
79	2021-07-18 14:59:33.662449+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (29)", "fields": ["Quantity"]}}]	2	1
80	2021-07-18 14:59:49.509112+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (29)", "fields": ["Quantity"]}}]	2	1
81	2021-07-18 15:01:06.34379+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (29)", "fields": ["Quantity"]}}]	2	1
82	2021-07-18 15:02:13.620786+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (29)", "fields": ["Quantity"]}}]	2	1
83	2021-07-18 15:04:59.050721+07	37	Juventus 20/21 Third Jersey - L	2	[{"changed": {"fields": ["Quantity"]}}]	7	1
84	2021-07-18 15:05:20.018648+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
85	2021-07-18 15:10:37.965383+07	4	4	2	[{"added": {"name": "bill detail", "object": "BillDetail object (32)"}}]	2	1
86	2021-07-18 15:11:40.207439+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
87	2021-07-18 15:12:45.099527+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
88	2021-07-18 15:14:24.642823+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
89	2021-07-18 15:15:18.08194+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
90	2021-07-18 15:15:48.160947+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
91	2021-07-18 15:16:23.017994+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
92	2021-07-18 15:16:36.413456+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}, {"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
93	2021-07-18 15:17:54.353619+07	4	4	2	[{"changed": {"fields": ["Total"]}}]	2	1
94	2021-07-18 15:19:06.495503+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
95	2021-07-18 15:21:19.658708+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (37)", "fields": ["Quantity"]}}]	2	1
96	2021-07-18 15:24:48.844412+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (37)", "fields": ["Quantity"]}}]	2	1
97	2021-07-18 15:25:53.426866+07	40	Juventus 20/21 Third Jersey - M	2	[{"changed": {"fields": ["Quantity"]}}]	7	1
98	2021-07-18 15:26:00.825306+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (37)", "fields": ["Quantity"]}}]	2	1
99	2021-07-18 15:26:59.990456+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (37)", "fields": ["Quantity"]}}]	2	1
100	2021-07-18 15:28:03.445028+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (37)", "fields": ["Quantity"]}}]	2	1
101	2021-07-18 15:31:44.091419+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (37)", "fields": ["Quantity"]}}]	2	1
102	2021-07-18 15:33:04.068161+07	4	4	2	[{"added": {"name": "bill detail", "object": "BillDetail object (39)"}}]	2	1
103	2021-07-18 15:33:29.695321+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
104	2021-07-18 15:34:22.018902+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (37)", "fields": ["Quantity"]}}]	2	1
105	2021-07-18 15:34:36.059721+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (37)", "fields": ["Quantity"]}}]	2	1
106	2021-07-18 15:36:07.802067+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (40)", "fields": ["Quantity"]}}]	2	1
107	2021-07-18 15:37:38.037163+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
108	2021-07-18 15:37:49.705791+07	21	Pride Trefoil Flag Fill Tee - L	2	[{"changed": {"fields": ["Quantity"]}}]	7	1
109	2021-07-18 15:39:28.761459+07	4	4	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (41)", "fields": ["Quantity"]}}]	2	1
110	2021-07-18 15:40:31.906141+07	4	4	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
111	2021-07-18 15:40:45.00491+07	21	Pride Trefoil Flag Fill Tee - L	2	[{"changed": {"fields": ["Quantity"]}}]	7	1
112	2021-07-18 16:44:42.619441+07	4	4	2	[{"changed": {"fields": ["State"]}}]	2	1
113	2021-07-18 16:48:25.503735+07	4	4	2	[{"changed": {"fields": ["State"]}}]	2	1
114	2021-07-18 16:49:24.960354+07	5	5	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (44)", "fields": ["Quantity"]}}]	2	1
115	2021-07-18 16:54:01.970559+07	4	4	2	[{"changed": {"fields": ["State"]}}]	2	1
116	2021-07-21 17:52:56.258284+07	8	8	2	[{"changed": {"fields": ["State"]}}]	2	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	Users	account
2	app_for_user	bill
3	app_for_user	product
4	app_for_user	producttype
5	app_for_user	size
6	app_for_user	vendor
7	app_for_user	stock
8	app_for_user	goodsreceipt
9	app_for_user	goodsreceiptdetail
10	app_for_user	billdetail
11	admin	logentry
12	auth	permission
13	auth	group
14	contenttypes	contenttype
15	sessions	session
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2021-07-13 08:02:06.223933+07
2	contenttypes	0002_remove_content_type_name	2021-07-13 08:02:06.256133+07
3	auth	0001_initial	2021-07-13 08:02:06.42494+07
4	auth	0002_alter_permission_name_max_length	2021-07-13 08:02:06.635741+07
5	auth	0003_alter_user_email_max_length	2021-07-13 08:02:06.653341+07
6	auth	0004_alter_user_username_opts	2021-07-13 08:02:06.653341+07
7	auth	0005_alter_user_last_login_null	2021-07-13 08:02:06.653341+07
8	auth	0006_require_contenttypes_0002	2021-07-13 08:02:06.668941+07
9	auth	0007_alter_validators_add_error_messages	2021-07-13 08:02:06.668941+07
10	auth	0008_alter_user_username_max_length	2021-07-13 08:02:06.668941+07
11	auth	0009_alter_user_last_name_max_length	2021-07-13 08:02:06.685541+07
12	auth	0010_alter_group_name_max_length	2021-07-13 08:02:06.696542+07
13	auth	0011_update_proxy_permissions	2021-07-13 08:02:06.702542+07
14	auth	0012_alter_user_first_name_max_length	2021-07-13 08:02:06.708543+07
15	Users	0001_initial	2021-07-13 08:02:06.87535+07
16	admin	0001_initial	2021-07-13 08:02:07.308154+07
17	admin	0002_logentry_remove_auto_add	2021-07-13 08:02:07.432955+07
18	admin	0003_logentry_add_action_flag_choices	2021-07-13 08:02:07.448555+07
19	app_for_user	0001_initial	2021-07-13 08:02:08.064361+07
20	sessions	0001_initial	2021-07-13 08:02:08.84357+07
21	app_for_user	0002_auto_20210713_0837	2021-07-13 08:37:19.690324+07
22	Users	0002_account_address	2021-07-15 10:23:40.005598+07
23	app_for_user	0003_auto_20210717_1958	2021-07-17 19:58:34.278495+07
24	app_for_user	0004_auto_20210717_1959	2021-07-17 19:59:32.913848+07
25	app_for_user	0005_auto_20210717_2107	2021-07-17 21:07:33.860488+07
26	app_for_user	0006_auto_20210718_1243	2021-07-18 12:44:01.131808+07
27	app_for_user	0007_bill_address	2021-07-18 16:40:19.407416+07
28	app_for_user	0008_auto_20210718_1649	2021-07-18 16:49:18.251118+07
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
a53z1r5qise5tvl9zyfwb7jo0t8m2xve	.eJxVjMsOwiAQRf-FtSEMpTxcuvcbyPAYqRpISrsy_ruSdKHbe849L-Zx34rfe179ktiZATv9bgHjI9cB0h3rrfHY6rYugQ-FH7Tza0v5eTncv0DBXkaWTFITWEFaRyVtDo5QABGZKaqJLKJQDqQ1kO0sZIZZaUoWvycHUbD3B9hWN0E:1m36p9:0KeF-ik9qWgJwqtILNSV0Ql9Eq7m8l8qHnYUtKWNDLk	2021-07-27 08:02:59.04789+07
2fjaa19x75eqxamfor5e2a5i0lq4g0r5	.eJxVjMsOwiAQRf-FtSEMpTxcuvcbyPAYqRpISrsy_ruSdKHbe849L-Zx34rfe179ktiZATv9bgHjI9cB0h3rrfHY6rYugQ-FH7Tza0v5eTncv0DBXkaWTFITWEFaRyVtDo5QABGZKaqJLKJQDqQ1kO0sZIZZaUoWvycHUbD3B9hWN0E:1m3Thv:ypHOQXZWgteSKfYxFPrhQkvWSf1CUXsaZSV04I8OVb8	2021-07-28 08:29:03.618899+07
ethm5vrszq9syaph54sup5e14dag6e6d	.eJxVjTEPwiAUhP8LsyE8oC11s7ujM3kFnq2SkpQ2Dsb_LiQddLnh7r67N7O4b5Pdc1jt7NmZATv9eiO6Z1hq4B-43BN3adnWeeS1wo8080uM6VXkVph8TT7E4QD_1ibMU_2gzmsFRlDbOi1NGHtCAUTUKacVGUShe5Cmg2AaIQM0uiVvsEA9OME-X0xGPGs:1m4Fde:z_Kmdqo3IpUIs0SvM3UIH5OlayM2G5pzE_IhaUCOheU	2021-07-30 11:39:50.851789+07
rx1k1iqkkqkjv0lr7xtom7emdwr1jjep	.eJxVjLEOwiAYhN-F2RCgFMRNd0dnAj8_UiWQlDYOxneXJh00l9xw3929iXXrkuzacLZTICciFDn8ht7BE8tGwsOVe6VQyzJPnm4VutNGzznXV7db37RrDZgv-_DvLbmW-pXmR9AIY0SMPggYBBu4MkxKMEwZAQw51z5wZEoKjl3emTiGKLRSDMnnC4L2PSQ:1m4Opf:VIdrq7qdZ4gPSq9g7c6L2EJbKyzir5vfGJeRD--ECTQ	2021-07-30 21:28:51.711337+07
va7tb907eh5uuvo71enutoefd7z372kq	.eJxVjTEPwiAUhP8LsyE8oC11s7ujM3kFnq2SkpQ2Dsb_LiQddLnh7r67N7O4b5Pdc1jt7NmZATv9eiO6Z1hq4B-43BN3adnWeeS1wo8080uM6VXkVph8TT7E4QD_1ibMU_2gzmsFRlDbOi1NGHtCAUTUKacVGUShe5Cmg2AaIQM0uiVvsEA9OME-X0xGPGs:1m4zrx:0I5pUoHceAj1Ky-ADLqpV95GRgv_q5zXSO_3kWCdlcg	2021-08-01 13:01:41.303241+07
ltxgbuem8l5hc6gixyn53tk6xvocqgf1	.eJxVjTEPwiAUhP8LsyE8oC11s7ujM3kFnq2SkpQ2Dsb_LiQddLnh7r67N7O4b5Pdc1jt7NmZATv9eiO6Z1hq4B-43BN3adnWeeS1wo8080uM6VXkVph8TT7E4QD_1ibMU_2gzmsFRlDbOi1NGHtCAUTUKacVGUShe5Cmg2AaIQM0uiVvsEA9OME-X0xGPGs:1m62ws:8aborJdvkmqxpCY-DPi1wjhLSHBXDRX_xiHphElsJnU	2021-08-04 10:31:06.932904+07
8k59lo15ky0jsgx7r6juujraqz18shbt	.eJxVjbkOwjAQRP_FNbJ8JMahg56S2lrvrkkgsqU4EQXi30mkFNBMMW-OtwiwzH1YKk9hIHESxovDrxkBn5w3Qg_I9yKx5HkaotwicqdVnsexvFa5rZ16LcTjZS_-rfVQ--2EHFrHHcGRo1Zgk8KkDTpouWkiMiZvUScLakVsfNdqmygxK1Iusvh8Aa6hPp0:1m67A5:1oiyxy2hGnDAI2d57yF0FX1McPMuEzyFn-J4dHB6rfI	2021-08-04 15:01:01.626879+07
\.


--
-- Data for Name: test; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test (value) FROM stdin;
\.


--
-- Name: Users_account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_account_groups_id_seq"', 1, false);


--
-- Name: Users_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_account_id_seq"', 28, true);


--
-- Name: Users_account_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_account_user_permissions_id_seq"', 1, false);


--
-- Name: app_for_user_bill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_bill_id_seq', 15, true);


--
-- Name: app_for_user_billdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_billdetail_id_seq', 63, true);


--
-- Name: app_for_user_goodsreceipt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_goodsreceipt_id_seq', 1, true);


--
-- Name: app_for_user_goodsreceiptdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_goodsreceiptdetail_id_seq', 2, true);


--
-- Name: app_for_user_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_product_id_seq', 1, false);


--
-- Name: app_for_user_producttype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_producttype_id_seq', 2, true);


--
-- Name: app_for_user_size_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_size_id_seq', 4, true);


--
-- Name: app_for_user_stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_stock_id_seq', 328, true);


--
-- Name: app_for_user_vendor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_vendor_id_seq', 1, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 60, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 116, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 15, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 28, true);


--
-- Name: Users_account Users_account_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account"
    ADD CONSTRAINT "Users_account_email_key" UNIQUE (email);


--
-- Name: Users_account_groups Users_account_groups_account_id_group_id_794359f1_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_groups"
    ADD CONSTRAINT "Users_account_groups_account_id_group_id_794359f1_uniq" UNIQUE (account_id, group_id);


--
-- Name: Users_account_groups Users_account_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_groups"
    ADD CONSTRAINT "Users_account_groups_pkey" PRIMARY KEY (id);


--
-- Name: Users_account Users_account_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account"
    ADD CONSTRAINT "Users_account_phone_num_key" UNIQUE (phone_num);


--
-- Name: Users_account Users_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account"
    ADD CONSTRAINT "Users_account_pkey" PRIMARY KEY (id);


--
-- Name: Users_account_user_permissions Users_account_user_permi_account_id_permission_id_9495fe70_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_user_permissions"
    ADD CONSTRAINT "Users_account_user_permi_account_id_permission_id_9495fe70_uniq" UNIQUE (account_id, permission_id);


--
-- Name: Users_account_user_permissions Users_account_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_user_permissions"
    ADD CONSTRAINT "Users_account_user_permissions_pkey" PRIMARY KEY (id);


--
-- Name: app_for_user_bill app_for_user_bill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_bill
    ADD CONSTRAINT app_for_user_bill_pkey PRIMARY KEY (id);


--
-- Name: app_for_user_billdetail app_for_user_billdetail_bill_id_product_id_5601dabd_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_billdetail
    ADD CONSTRAINT app_for_user_billdetail_bill_id_product_id_5601dabd_uniq UNIQUE (bill_id, product_id);


--
-- Name: app_for_user_billdetail app_for_user_billdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_billdetail
    ADD CONSTRAINT app_for_user_billdetail_pkey PRIMARY KEY (id);


--
-- Name: app_for_user_goodsreceiptdetail app_for_user_goodsreceip_goods_receipt_id_product_3e2ab171_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceiptdetail
    ADD CONSTRAINT app_for_user_goodsreceip_goods_receipt_id_product_3e2ab171_uniq UNIQUE (goods_receipt_id, product_id, size_id);


--
-- Name: app_for_user_goodsreceipt app_for_user_goodsreceipt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceipt
    ADD CONSTRAINT app_for_user_goodsreceipt_pkey PRIMARY KEY (id);


--
-- Name: app_for_user_goodsreceiptdetail app_for_user_goodsreceiptdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceiptdetail
    ADD CONSTRAINT app_for_user_goodsreceiptdetail_pkey PRIMARY KEY (id);


--
-- Name: app_for_user_product app_for_user_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_product
    ADD CONSTRAINT app_for_user_product_pkey PRIMARY KEY (id);


--
-- Name: app_for_user_producttype app_for_user_producttype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_producttype
    ADD CONSTRAINT app_for_user_producttype_pkey PRIMARY KEY (id);


--
-- Name: app_for_user_producttype app_for_user_producttype_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_producttype
    ADD CONSTRAINT app_for_user_producttype_type_name_key UNIQUE (type_name);


--
-- Name: app_for_user_size app_for_user_size_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_size
    ADD CONSTRAINT app_for_user_size_pkey PRIMARY KEY (id);


--
-- Name: app_for_user_size app_for_user_size_size_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_size
    ADD CONSTRAINT app_for_user_size_size_key UNIQUE (size);


--
-- Name: app_for_user_stock app_for_user_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_stock
    ADD CONSTRAINT app_for_user_stock_pkey PRIMARY KEY (id);


--
-- Name: app_for_user_stock app_for_user_stock_product_id_size_id_a0cdbed4_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_stock
    ADD CONSTRAINT app_for_user_stock_product_id_size_id_a0cdbed4_uniq UNIQUE (product_id, size_id);


--
-- Name: app_for_user_vendor app_for_user_vendor_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_vendor
    ADD CONSTRAINT app_for_user_vendor_address_key UNIQUE (address);


--
-- Name: app_for_user_vendor app_for_user_vendor_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_vendor
    ADD CONSTRAINT app_for_user_vendor_email_key UNIQUE (email);


--
-- Name: app_for_user_vendor app_for_user_vendor_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_vendor
    ADD CONSTRAINT app_for_user_vendor_name_key UNIQUE (name);


--
-- Name: app_for_user_vendor app_for_user_vendor_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_vendor
    ADD CONSTRAINT app_for_user_vendor_phone_num_key UNIQUE (phone_num);


--
-- Name: app_for_user_vendor app_for_user_vendor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_vendor
    ADD CONSTRAINT app_for_user_vendor_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: Users_account_email_2c89fa30_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Users_account_email_2c89fa30_like" ON public."Users_account" USING btree (email varchar_pattern_ops);


--
-- Name: Users_account_groups_account_id_ae3963e8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Users_account_groups_account_id_ae3963e8" ON public."Users_account_groups" USING btree (account_id);


--
-- Name: Users_account_groups_group_id_2967e8a0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Users_account_groups_group_id_2967e8a0" ON public."Users_account_groups" USING btree (group_id);


--
-- Name: Users_account_phone_num_6f578f0c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Users_account_phone_num_6f578f0c_like" ON public."Users_account" USING btree (phone_num varchar_pattern_ops);


--
-- Name: Users_account_user_permissions_account_id_b74ad768; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Users_account_user_permissions_account_id_b74ad768" ON public."Users_account_user_permissions" USING btree (account_id);


--
-- Name: Users_account_user_permissions_permission_id_dc4c6d1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Users_account_user_permissions_permission_id_dc4c6d1b" ON public."Users_account_user_permissions" USING btree (permission_id);


--
-- Name: app_for_user_bill_customer_id_a1087260; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_bill_customer_id_a1087260 ON public.app_for_user_bill USING btree (customer_id);


--
-- Name: app_for_user_billdetail_bill_id_913aa310; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_billdetail_bill_id_913aa310 ON public.app_for_user_billdetail USING btree (bill_id);


--
-- Name: app_for_user_billdetail_product_id_ab34b459; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_billdetail_product_id_ab34b459 ON public.app_for_user_billdetail USING btree (product_id);


--
-- Name: app_for_user_goodsreceipt_vendor_id_aec5aca2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_goodsreceipt_vendor_id_aec5aca2 ON public.app_for_user_goodsreceipt USING btree (vendor_id);


--
-- Name: app_for_user_goodsreceiptdetail_goods_receipt_id_f179140c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_goodsreceiptdetail_goods_receipt_id_f179140c ON public.app_for_user_goodsreceiptdetail USING btree (goods_receipt_id);


--
-- Name: app_for_user_goodsreceiptdetail_product_id_d428680e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_goodsreceiptdetail_product_id_d428680e ON public.app_for_user_goodsreceiptdetail USING btree (product_id);


--
-- Name: app_for_user_goodsreceiptdetail_size_id_d99874b9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_goodsreceiptdetail_size_id_d99874b9 ON public.app_for_user_goodsreceiptdetail USING btree (size_id);


--
-- Name: app_for_user_product_type_id_61ad19ce; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_product_type_id_61ad19ce ON public.app_for_user_product USING btree (type_id);


--
-- Name: app_for_user_producttype_type_name_744c65b3_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_producttype_type_name_744c65b3_like ON public.app_for_user_producttype USING btree (type_name varchar_pattern_ops);


--
-- Name: app_for_user_size_size_21371c29_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_size_size_21371c29_like ON public.app_for_user_size USING btree (size varchar_pattern_ops);


--
-- Name: app_for_user_stock_product_id_1e15c23c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_stock_product_id_1e15c23c ON public.app_for_user_stock USING btree (product_id);


--
-- Name: app_for_user_stock_size_id_38097d7f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_stock_size_id_38097d7f ON public.app_for_user_stock USING btree (size_id);


--
-- Name: app_for_user_vendor_address_62c6e790_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_vendor_address_62c6e790_like ON public.app_for_user_vendor USING btree (address varchar_pattern_ops);


--
-- Name: app_for_user_vendor_email_ffb230d2_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_vendor_email_ffb230d2_like ON public.app_for_user_vendor USING btree (email varchar_pattern_ops);


--
-- Name: app_for_user_vendor_name_54e120db_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_vendor_name_54e120db_like ON public.app_for_user_vendor USING btree (name varchar_pattern_ops);


--
-- Name: app_for_user_vendor_phone_num_29c53dc9_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_vendor_phone_num_29c53dc9_like ON public.app_for_user_vendor USING btree (phone_num varchar_pattern_ops);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: app_for_user_product addnewproducttostock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER addnewproducttostock AFTER INSERT ON public.app_for_user_product FOR EACH ROW EXECUTE FUNCTION public.addtostock();


--
-- Name: app_for_user_billdetail settt1; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER settt1 AFTER DELETE ON public.app_for_user_billdetail FOR EACH ROW EXECUTE FUNCTION public.settt1();


--
-- Name: app_for_user_billdetail settt2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER settt2 AFTER UPDATE ON public.app_for_user_billdetail FOR EACH ROW EXECUTE FUNCTION public.settt2();


--
-- Name: app_for_user_billdetail settt3; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER settt3 AFTER INSERT ON public.app_for_user_billdetail FOR EACH ROW EXECUTE FUNCTION public.settt3();


--
-- Name: app_for_user_billdetail setunitpriceforbill; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER setunitpriceforbill AFTER INSERT ON public.app_for_user_billdetail FOR EACH ROW EXECUTE FUNCTION public.setunitpriceforbill();


--
-- Name: app_for_user_goodsreceiptdetail updatequantityinstock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updatequantityinstock AFTER INSERT ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.receivetostock();


--
-- Name: app_for_user_goodsreceiptdetail updatetotalprice; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updatetotalprice AFTER INSERT ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.totalprice();


--
-- Name: app_for_user_goodsreceiptdetail updatetotalprice1; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updatetotalprice1 BEFORE UPDATE ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.totalprice1();


--
-- Name: app_for_user_goodsreceiptdetail updatetotalprice2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updatetotalprice2 BEFORE DELETE ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.totalprice2();


--
-- Name: Users_account_groups Users_account_groups_account_id_ae3963e8_fk_Users_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_groups"
    ADD CONSTRAINT "Users_account_groups_account_id_ae3963e8_fk_Users_account_id" FOREIGN KEY (account_id) REFERENCES public."Users_account"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Users_account_groups Users_account_groups_group_id_2967e8a0_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_groups"
    ADD CONSTRAINT "Users_account_groups_group_id_2967e8a0_fk_auth_group_id" FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Users_account_user_permissions Users_account_user_p_account_id_b74ad768_fk_Users_acc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_user_permissions"
    ADD CONSTRAINT "Users_account_user_p_account_id_b74ad768_fk_Users_acc" FOREIGN KEY (account_id) REFERENCES public."Users_account"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Users_account_user_permissions Users_account_user_p_permission_id_dc4c6d1b_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_user_permissions"
    ADD CONSTRAINT "Users_account_user_p_permission_id_dc4c6d1b_fk_auth_perm" FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_bill app_for_user_bill_customer_id_a1087260_fk_Users_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_bill
    ADD CONSTRAINT "app_for_user_bill_customer_id_a1087260_fk_Users_account_id" FOREIGN KEY (customer_id) REFERENCES public."Users_account"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_billdetail app_for_user_billdet_bill_id_913aa310_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_billdetail
    ADD CONSTRAINT app_for_user_billdet_bill_id_913aa310_fk_app_for_u FOREIGN KEY (bill_id) REFERENCES public.app_for_user_bill(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_billdetail app_for_user_billdet_product_id_ab34b459_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_billdetail
    ADD CONSTRAINT app_for_user_billdet_product_id_ab34b459_fk_app_for_u FOREIGN KEY (product_id) REFERENCES public.app_for_user_stock(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_goodsreceiptdetail app_for_user_goodsre_goods_receipt_id_f179140c_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceiptdetail
    ADD CONSTRAINT app_for_user_goodsre_goods_receipt_id_f179140c_fk_app_for_u FOREIGN KEY (goods_receipt_id) REFERENCES public.app_for_user_goodsreceipt(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_goodsreceiptdetail app_for_user_goodsre_product_id_d428680e_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceiptdetail
    ADD CONSTRAINT app_for_user_goodsre_product_id_d428680e_fk_app_for_u FOREIGN KEY (product_id) REFERENCES public.app_for_user_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_goodsreceiptdetail app_for_user_goodsre_size_id_d99874b9_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceiptdetail
    ADD CONSTRAINT app_for_user_goodsre_size_id_d99874b9_fk_app_for_u FOREIGN KEY (size_id) REFERENCES public.app_for_user_size(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_goodsreceipt app_for_user_goodsre_vendor_id_aec5aca2_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceipt
    ADD CONSTRAINT app_for_user_goodsre_vendor_id_aec5aca2_fk_app_for_u FOREIGN KEY (vendor_id) REFERENCES public.app_for_user_vendor(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_product app_for_user_product_type_id_61ad19ce_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_product
    ADD CONSTRAINT app_for_user_product_type_id_61ad19ce_fk_app_for_u FOREIGN KEY (type_id) REFERENCES public.app_for_user_producttype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_stock app_for_user_stock_product_id_1e15c23c_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_stock
    ADD CONSTRAINT app_for_user_stock_product_id_1e15c23c_fk_app_for_u FOREIGN KEY (product_id) REFERENCES public.app_for_user_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_stock app_for_user_stock_size_id_38097d7f_fk_app_for_user_size_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_stock
    ADD CONSTRAINT app_for_user_stock_size_id_38097d7f_fk_app_for_user_size_id FOREIGN KEY (size_id) REFERENCES public.app_for_user_size(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_Users_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT "django_admin_log_user_id_c564eba6_fk_Users_account_id" FOREIGN KEY (user_id) REFERENCES public."Users_account"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

