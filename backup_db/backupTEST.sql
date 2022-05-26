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
-- Name: checkdup(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.checkdup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     i integer := (SELECT MAX(id) FROM app_for_user_product) + 1;
 BEGIN
     IF EXISTS (SELECT 1 FROM app_for_user_product WHERE id = NEW.id) THEN
-- 	 	INSERT INTO app_for_user_product(id, name, price, img, type_id) VALUES (i, NEW.name, NEW.price, NEW.img, NEW.type_id);
		NEW.id = i;
		raise notice 'Value: %', NEW.id;
		RETURN NEW;
	 ELSE
     	RETURN NEW;
	END IF;
 END;
 $$;


ALTER FUNCTION public.checkdup() OWNER TO postgres;

--
-- Name: checkdup1(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.checkdup1() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     i integer := (SELECT MAX(id) FROM app_for_user_producttype) + 1;
 BEGIN
     IF EXISTS (SELECT 1 FROM app_for_user_producttype WHERE id = NEW.id) THEN
		NEW.id = i;
		raise notice 'Value: %', NEW.id;
		RETURN NEW;
	 ELSE
     	RETURN NEW;
	END IF;
 END;
 $$;


ALTER FUNCTION public.checkdup1() OWNER TO postgres;

--
-- Name: checkdup2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.checkdup2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     i integer := (SELECT MAX(id) FROM app_for_user_goodsreceipt) + 1;
 BEGIN
     IF EXISTS (SELECT 1 FROM app_for_user_goodsreceipt WHERE id = NEW.id) THEN
		NEW.id = i;
		raise notice 'Value: %', NEW.id;
		RETURN NEW;
	 ELSE
     	RETURN NEW;
	END IF;
 END;
 $$;


ALTER FUNCTION public.checkdup2() OWNER TO postgres;

--
-- Name: checkdup3(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.checkdup3() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     i integer := (SELECT MAX(id) FROM app_for_user_goodsreceiptdetail) + 1;
 BEGIN
     IF EXISTS (SELECT 1 FROM app_for_user_goodsreceiptdetail WHERE id = NEW.id) THEN
		NEW.id = i;
		raise notice 'Value: %', NEW.id;
		RETURN NEW;
	 ELSE
     	RETURN NEW;
	END IF;
 END;
 $$;


ALTER FUNCTION public.checkdup3() OWNER TO postgres;

--
-- Name: checkdup4(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.checkdup4() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     i integer := (SELECT MAX(id) FROM app_for_user_stock) + 1;
 BEGIN
     IF EXISTS (SELECT 1 FROM app_for_user_stock WHERE id = NEW.id) THEN
		NEW.id = i;
		raise notice 'Value: %', NEW.id;
		RETURN NEW;
	 ELSE
     	RETURN NEW;
	END IF;
 END;
 $$;


ALTER FUNCTION public.checkdup4() OWNER TO postgres;

--
-- Name: checkdup5(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.checkdup5() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
     i integer := (SELECT MAX(id) FROM app_for_user_size) + 1;
 BEGIN
     IF EXISTS (SELECT 1 FROM app_for_user_size WHERE id = NEW.id) THEN
		NEW.id = i;
		raise notice 'Value: %', NEW.id;
		RETURN NEW;
	 ELSE
     	RETURN NEW;
	END IF;
 END;
 $$;


ALTER FUNCTION public.checkdup5() OWNER TO postgres;

--
-- Name: decreasestock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decreasestock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE app_for_user_stock
	SET quantity = quantity - NEW.quantity
	WHERE id = NEW.stock_id;
  	return NEW;
END;
$$;


ALTER FUNCTION public.decreasestock() OWNER TO postgres;

--
-- Name: decreasetotal(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decreasetotal() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	update app_for_user_goodsreceipt 
	set total_price = total_price - OLD.quantity*OLD.unit_price
	where app_for_user_goodsreceipt.id = OLD.goods_receipt_id;
    return OLD;
END;
$$;


ALTER FUNCTION public.decreasetotal() OWNER TO postgres;

--
-- Name: dltbilldetailtostock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dltbilldetailtostock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE app_for_user_bill
	SET total_price = total_price - OLD.quantity*OLD.unit_price
	WHERE app_for_user_bill.id = OLD.bill_id;
	
	UPDATE app_for_user_stock
	SET quantity = quantity + OLD.quantity
	WHERE id = OLD.stock_id;
	
	RETURN OLD;
END;
$$;


ALTER FUNCTION public.dltbilldetailtostock() OWNER TO postgres;

--
-- Name: dltreceipttostock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.dltreceipttostock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM app_for_user_stock
	WHERE OLD.id = receipt_detail_id;
  	return OLD;
END;
$$;


ALTER FUNCTION public.dltreceipttostock() OWNER TO postgres;

--
-- Name: increasetotal(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increasetotal() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE app_for_user_goodsreceipt
	SET total_price = total_price + NEW.quantity*NEW.unit_price
	WHERE app_for_user_goodsreceipt.id = NEW.goods_receipt_id;
  	return NEW;
END;
$$;


ALTER FUNCTION public.increasetotal() OWNER TO postgres;

--
-- Name: increasetotalanddecreasestock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increasetotalanddecreasestock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE app_for_user_bill
	SET total_price = total_price + NEW.unit_price*NEW.quantity
	WHERE app_for_user_bill.id = NEW.bill_id;
	
  	return NEW;
END;
$$;


ALTER FUNCTION public.increasetotalanddecreasestock() OWNER TO postgres;

--
-- Name: receipttostock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.receipttostock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT into app_for_user_stock(product_id, size_id, receipt_detail_id, quantity) 
	VALUES (NEW.product_id, NEW.size_id, NEW.id, NEW.quantity);
  	return NEW;
END;
$$;


ALTER FUNCTION public.receipttostock() OWNER TO postgres;

--
-- Name: updatetotal(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.updatetotal() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 	update app_for_user_goodsreceipt 
 	set total_price = total_price + NEW.quantity*NEW.unit_price - OLD.quantity*OLD.unit_price
 	where app_for_user_goodsreceipt.id = NEW.goods_receipt_id;
    return NEW;
END;
$$;


ALTER FUNCTION public.updatetotal() OWNER TO postgres;

--
-- Name: updatetotalandstock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.updatetotalandstock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE app_for_user_bill
	SET total_price = total_price + NEW.quantity*NEW.unit_price - OLD.quantity*OLD.unit_price
	WHERE app_for_user_bill.id = NEW.bill_id;
	
	UPDATE app_for_user_stock
	SET quantity = quantity + OLD.quantity - NEW.quantity 
	WHERE id = NEW.stock_id;
	
  	return NEW;
END;
$$;


ALTER FUNCTION public.updatetotalandstock() OWNER TO postgres;

--
-- Name: updreceipttostock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.updreceipttostock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE app_for_user_stock
	SET quantity = NEW.quantity
	WHERE NEW.id = receipt_detail_id;
  	return NEW;
END;
$$;


ALTER FUNCTION public.updreceipttostock() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Users_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users_account" (
    id bigint NOT NULL,
    password character varying(128) NOT NULL,
    email character varying(255) NOT NULL,
    username character varying(50) NOT NULL,
    address character varying(150) NOT NULL,
    sex character varying(10) NOT NULL,
    phone_num character varying(500),
    date_joined timestamp with time zone NOT NULL,
    last_login timestamp with time zone NOT NULL,
    is_active boolean NOT NULL,
    is_admin boolean NOT NULL,
    is_staff boolean NOT NULL,
    is_superuser boolean NOT NULL
);


ALTER TABLE public."Users_account" OWNER TO postgres;

--
-- Name: Users_account_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users_account_groups" (
    id integer NOT NULL,
    account_id bigint NOT NULL,
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
    account_id bigint NOT NULL,
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
    address character varying(150) NOT NULL,
    total_price integer NOT NULL,
    customer_id bigint NOT NULL
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
    stock_id integer NOT NULL
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
    total_price bigint NOT NULL,
    date timestamp with time zone NOT NULL,
    vendor_id integer NOT NULL,
    warehouse_id integer NOT NULL
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
    receipt_detail_id integer NOT NULL,
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
-- Name: app_for_user_warehouse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_for_user_warehouse (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    region character varying(50) NOT NULL,
    address character varying(100) NOT NULL,
    phone_num character varying(10)
);


ALTER TABLE public.app_for_user_warehouse OWNER TO postgres;

--
-- Name: app_for_user_warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_for_user_warehouse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_for_user_warehouse_id_seq OWNER TO postgres;

--
-- Name: app_for_user_warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_for_user_warehouse_id_seq OWNED BY public.app_for_user_warehouse.id;


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
    user_id bigint NOT NULL,
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
-- Name: app_for_user_warehouse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_warehouse ALTER COLUMN id SET DEFAULT nextval('public.app_for_user_warehouse_id_seq'::regclass);


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

COPY public."Users_account" (id, password, email, username, address, sex, phone_num, date_joined, last_login, is_active, is_admin, is_staff, is_superuser) FROM stdin;
1	pbkdf2_sha256$216000$OBAIkFwHQAFa$mhdq++Pn9L2ZCwCM5Gd9yUgrHsQIa9pLB70LCdzXenA=	nguyenlehuythang@gmail.com	Thang	77 Qtnpfq Zxq	Female	0797764179	2021-11-03 19:36:14.618625+07	2021-11-27 15:29:40.563253+07	t	t	t	t
2	pbkdf2_sha256$216000$nba2t6behJ6x$gq+GNXg9mbFliQeEJ2c/xn7W4ncYd6AUXP2qHvsNW1Q=	hang@gmail.com	Thắng Lê	185/02 Ean Gax Axd	Female	0147852369	2021-11-14 11:20:52.154628+07	2021-11-27 15:25:49.283025+07	t	f	t	f
22	pbkdf2_sha256$260000$rHMVvmfDk0QnTwKmtt8RdA$2qAMEP6LWIHNFv2kq/iC97sZH+/GfBWoirVpqeSFX0Q=	dung@gmail.com	Dung Viet	456 Văn Cao	Female	0852147963	2022-05-17 13:21:13.573823+07	2022-05-17 13:21:36.012708+07	t	f	f	f
6	pbkdf2_sha256$260000$ptwFsJ3GVLamAqRT308RB7$XH33QYCbLsbdsRzfz8hiEUjlgWaZY4mWLa9i61Y8k0s=	le@gmail.com	Thang	456 Phú Thọ Hoà	Female	0258741369	2022-05-08 09:43:26.965783+07	2022-05-23 14:38:25.329789+07	t	t	t	t
3	pbkdf2_sha256$216000$GS6QuPK0NxIi$I22UyhYy37fRPQSYfihKfTWXbjig5g4BhFXldnGf1K8=	abc@gmail.com	Con Mèo	31 Văn Cao	Female	0222222222	2021-11-26 09:29:17.952015+07	2021-11-26 09:29:39.797264+07	t	f	t	f
\.


--
-- Data for Name: Users_account_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users_account_groups" (id, account_id, group_id) FROM stdin;
7	2	1
\.


--
-- Data for Name: Users_account_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users_account_user_permissions" (id, account_id, permission_id) FROM stdin;
\.


--
-- Data for Name: app_for_user_bill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_bill (id, date, state, address, total_price, customer_id) FROM stdin;
6	2021-11-14 12:46:49.964638+07	2	456/17 ABC XYZ	2400000	2
5	2021-11-14 11:51:10.452628+07	2	456/17 ABC XYZ	1800000	2
4	2021-11-14 11:35:25.405575+07	2	456/17 ABC XYZ	1800000	2
7	2021-11-15 09:22:29.038575+07	2	456/17 Phú Thọ Hoà	6300000	2
15	2021-11-26 09:43:26.784565+07	0		900000	2
13	2021-11-26 09:34:50.341026+07	1	456/17 Phú Thọ Hoà	6900000	3
3	2001-12-12 00:00:00+07	1	AAAA	0	1
17	2022-05-17 13:22:36.783844+07	2	185/1 Trần Hưng Đạo	900000	22
16	2022-05-10 14:27:52.793484+07	1	456 Phú Thọ Hoà	21600000	6
18	2022-05-17 17:01:14.231406+07	0	31 Văn Cao	900000	6
\.


--
-- Data for Name: app_for_user_billdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_billdetail (id, quantity, unit_price, bill_id, stock_id) FROM stdin;
2	3	600000	4	242
3	3	600000	5	241
16	7	900000	7	530
4	2	600000	6	244
5	2	600000	6	242
17	5	900000	13	531
18	1	900000	15	529
19	2	1200000	13	373
25	4	900000	16	529
27	1	900000	17	219
28	18	1000000	16	541
29	1	900000	18	217
\.


--
-- Data for Name: app_for_user_goodsreceipt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_goodsreceipt (id, deliverer, total_price, date, vendor_id, warehouse_id) FROM stdin;
3	Khỉ	3280000000	2021-11-03 19:55:43.720493+07	1	1
2	Cas	12000000	2021-11-10 10:28:21.068866+07	1	1
4	Mèo	105000000	2021-11-21 20:28:25.600598+07	1	1
5	Thắng	150000000	2021-11-27 15:30:45.277955+07	1	1
\.


--
-- Data for Name: app_for_user_goodsreceiptdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_goodsreceiptdetail (id, quantity, unit_price, goods_receipt_id, product_id, size_id) FROM stdin;
220	100	100000	3	1	1
221	100	100000	3	1	2
222	100	100000	3	1	3
223	100	100000	3	1	4
224	100	100000	3	2	1
225	100	100000	3	2	2
226	100	100000	3	2	3
227	100	100000	3	2	4
228	100	100000	3	3	1
229	100	100000	3	3	2
230	100	100000	3	3	3
231	100	100000	3	3	4
232	100	100000	3	4	1
233	100	100000	3	4	2
234	100	100000	3	4	3
235	100	100000	3	4	4
236	100	100000	3	5	1
237	100	100000	3	5	2
238	100	100000	3	5	3
239	100	100000	3	5	4
240	100	100000	3	6	1
241	100	100000	3	6	2
242	100	100000	3	6	3
243	100	100000	3	6	4
244	100	100000	3	7	1
245	100	100000	3	7	2
246	100	100000	3	7	3
247	100	100000	3	7	4
248	100	100000	3	8	1
249	100	100000	3	8	2
250	100	100000	3	8	3
251	100	100000	3	8	4
252	100	100000	3	9	1
253	100	100000	3	9	2
254	100	100000	3	9	3
255	100	100000	3	9	4
256	100	100000	3	10	1
257	100	100000	3	10	2
258	100	100000	3	10	3
259	100	100000	3	10	4
260	100	100000	3	11	1
261	100	100000	3	11	2
262	100	100000	3	11	3
263	100	100000	3	11	4
264	100	100000	3	12	1
265	100	100000	3	12	2
266	100	100000	3	12	3
267	100	100000	3	12	4
268	100	100000	3	13	1
269	100	100000	3	13	2
270	100	100000	3	13	3
271	100	100000	3	13	4
272	100	100000	3	14	1
273	100	100000	3	14	2
274	100	100000	3	14	3
275	100	100000	3	14	4
276	100	100000	3	15	1
277	100	100000	3	15	2
278	100	100000	3	15	3
279	100	100000	3	15	4
280	100	100000	3	16	1
281	100	100000	3	16	2
282	100	100000	3	16	3
283	100	100000	3	16	4
284	100	100000	3	17	1
285	100	100000	3	17	2
286	100	100000	3	17	3
287	100	100000	3	17	4
288	100	100000	3	18	1
289	100	100000	3	18	2
290	100	100000	3	18	3
291	100	100000	3	18	4
292	100	100000	3	19	1
293	100	100000	3	19	2
294	100	100000	3	19	3
295	100	100000	3	19	4
296	100	100000	3	20	1
297	100	100000	3	20	2
298	100	100000	3	20	3
299	100	100000	3	20	4
300	100	100000	3	21	1
301	100	100000	3	21	2
302	100	100000	3	21	3
303	100	100000	3	21	4
304	100	100000	3	22	1
305	100	100000	3	22	2
306	100	100000	3	22	3
307	100	100000	3	22	4
308	100	100000	3	23	1
309	100	100000	3	23	2
310	100	100000	3	23	3
311	100	100000	3	23	4
312	100	100000	3	24	1
313	100	100000	3	24	2
314	100	100000	3	24	3
315	100	100000	3	24	4
316	100	100000	3	25	1
317	100	100000	3	25	2
318	100	100000	3	25	3
319	100	100000	3	25	4
320	100	100000	3	26	1
321	100	100000	3	26	2
322	100	100000	3	26	3
323	100	100000	3	26	4
324	100	100000	3	27	1
325	100	100000	3	27	2
326	100	100000	3	27	3
327	100	100000	3	27	4
328	100	100000	3	28	1
329	100	100000	3	28	2
330	100	100000	3	28	3
331	100	100000	3	28	4
332	100	100000	3	29	1
333	100	100000	3	29	2
334	100	100000	3	29	3
335	100	100000	3	29	4
336	100	100000	3	30	1
337	100	100000	3	30	2
338	100	100000	3	30	3
339	100	100000	3	30	4
340	100	100000	3	31	1
341	100	100000	3	31	2
342	100	100000	3	31	3
343	100	100000	3	31	4
344	100	100000	3	32	1
345	100	100000	3	32	2
346	100	100000	3	32	3
347	100	100000	3	32	4
348	100	100000	3	33	1
349	100	100000	3	33	2
350	100	100000	3	33	3
351	100	100000	3	33	4
352	100	100000	3	34	1
353	100	100000	3	34	2
354	100	100000	3	34	3
355	100	100000	3	34	4
356	100	100000	3	35	1
357	100	100000	3	35	2
358	100	100000	3	35	3
359	100	100000	3	35	4
360	100	100000	3	36	1
361	100	100000	3	36	2
362	100	100000	3	36	3
363	100	100000	3	36	4
364	100	100000	3	37	1
365	100	100000	3	37	2
366	100	100000	3	37	3
367	100	100000	3	37	4
368	100	100000	3	38	1
369	100	100000	3	38	2
370	100	100000	3	38	3
371	100	100000	3	38	4
372	100	100000	3	39	1
373	100	100000	3	39	2
374	100	100000	3	39	3
375	100	100000	3	39	4
376	100	100000	3	40	1
377	100	100000	3	40	2
378	100	100000	3	40	3
379	100	100000	3	40	4
380	100	100000	3	41	1
381	100	100000	3	41	2
382	100	100000	3	41	3
383	100	100000	3	41	4
384	100	100000	3	42	1
385	100	100000	3	42	2
386	100	100000	3	42	3
387	100	100000	3	42	4
388	100	100000	3	43	1
389	100	100000	3	43	2
390	100	100000	3	43	3
391	100	100000	3	43	4
392	100	100000	3	44	1
393	100	100000	3	44	2
394	100	100000	3	44	3
395	100	100000	3	44	4
396	100	100000	3	45	1
397	100	100000	3	45	2
398	100	100000	3	45	3
399	100	100000	3	45	4
400	100	100000	3	46	1
401	100	100000	3	46	2
402	100	100000	3	46	3
403	100	100000	3	46	4
404	100	100000	3	47	1
405	100	100000	3	47	2
406	100	100000	3	47	3
407	100	100000	3	47	4
408	100	100000	3	48	1
409	100	100000	3	48	2
410	100	100000	3	48	3
411	100	100000	3	48	4
412	100	100000	3	49	1
413	100	100000	3	49	2
414	100	100000	3	49	3
415	100	100000	3	49	4
416	100	100000	3	50	1
417	100	100000	3	50	2
418	100	100000	3	50	3
419	100	100000	3	50	4
420	100	100000	3	51	1
421	100	100000	3	51	2
422	100	100000	3	51	3
423	100	100000	3	51	4
424	100	100000	3	52	1
425	100	100000	3	52	2
426	100	100000	3	52	3
427	100	100000	3	52	4
428	100	100000	3	53	1
429	100	100000	3	53	2
430	100	100000	3	53	3
431	100	100000	3	53	4
432	100	100000	3	54	1
433	100	100000	3	54	2
434	100	100000	3	54	3
435	100	100000	3	54	4
436	100	100000	3	55	1
437	100	100000	3	55	2
438	100	100000	3	55	3
439	100	100000	3	55	4
440	100	100000	3	56	1
441	100	100000	3	56	2
442	100	100000	3	56	3
443	100	100000	3	56	4
444	100	100000	3	57	1
445	100	100000	3	57	2
446	100	100000	3	57	3
447	100	100000	3	57	4
448	100	100000	3	58	1
449	100	100000	3	58	2
450	100	100000	3	58	3
451	100	100000	3	58	4
452	100	100000	3	59	1
453	100	100000	3	59	2
454	100	100000	3	59	3
455	100	100000	3	59	4
456	100	100000	3	60	1
457	100	100000	3	60	2
458	100	100000	3	60	3
459	100	100000	3	60	4
460	100	100000	3	61	1
461	100	100000	3	61	2
462	100	100000	3	61	3
463	100	100000	3	61	4
464	100	100000	3	62	1
465	100	100000	3	62	2
466	100	100000	3	62	3
467	100	100000	3	62	4
468	100	100000	3	63	1
469	100	100000	3	63	2
470	100	100000	3	63	3
471	100	100000	3	63	4
472	100	100000	3	64	1
473	100	100000	3	64	2
474	100	100000	3	64	3
475	100	100000	3	64	4
476	100	100000	3	65	1
477	100	100000	3	65	2
478	100	100000	3	65	3
479	100	100000	3	65	4
480	100	100000	3	66	1
481	100	100000	3	66	2
482	100	100000	3	66	3
483	100	100000	3	66	4
484	100	100000	3	67	1
485	100	100000	3	67	2
486	100	100000	3	67	3
487	100	100000	3	67	4
488	100	100000	3	68	1
489	100	100000	3	68	2
490	100	100000	3	68	3
491	100	100000	3	68	4
492	100	100000	3	69	1
493	100	100000	3	69	2
494	100	100000	3	69	3
495	100	100000	3	69	4
496	100	100000	3	70	1
497	100	100000	3	70	2
498	100	100000	3	70	3
499	100	100000	3	70	4
500	100	100000	3	71	1
501	100	100000	3	71	2
502	100	100000	3	71	3
503	100	100000	3	71	4
504	100	100000	3	72	1
505	100	100000	3	72	2
506	100	100000	3	72	3
507	100	100000	3	72	4
508	100	100000	3	73	1
509	100	100000	3	73	2
510	100	100000	3	73	3
511	100	100000	3	73	4
512	100	100000	3	74	1
513	100	100000	3	74	2
514	100	100000	3	74	3
515	100	100000	3	74	4
516	100	100000	3	75	1
517	100	100000	3	75	2
518	100	100000	3	75	3
519	100	100000	3	75	4
520	100	100000	3	76	1
521	100	100000	3	76	2
522	100	100000	3	76	3
523	100	100000	3	76	4
524	100	100000	3	77	1
525	100	100000	3	77	2
526	100	100000	3	77	3
527	100	100000	3	77	4
528	100	100000	3	78	1
529	100	100000	3	78	2
530	100	100000	3	78	3
531	100	100000	3	78	4
532	100	100000	3	79	1
533	100	100000	3	79	2
534	100	100000	3	79	3
535	100	100000	3	79	4
536	100	100000	3	80	1
537	100	100000	3	80	2
538	100	100000	3	80	3
539	100	100000	3	80	4
540	100	100000	3	81	1
541	100	100000	3	81	2
542	100	100000	3	81	3
543	100	100000	3	81	4
544	100	100000	3	82	1
545	100	100000	3	82	2
546	100	100000	3	82	3
547	100	100000	3	82	4
2	100	120000	2	82	1
3	100	150000	4	19	1
4	100	900000	4	74	1
5	1500	100000	5	20	1
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
83	test	15	productImg/d_edbOCHQ.png	1
\.


--
-- Data for Name: app_for_user_producttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_producttype (id, type_name) FROM stdin;
1	T-Shirt
2	Pant
3	test
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

COPY public.app_for_user_stock (id, quantity, product_id, receipt_detail_id, size_id) FROM stdin;
218	100	1	221	2
220	100	1	223	4
221	100	2	224	1
222	100	2	225	2
223	100	2	226	3
224	100	2	227	4
226	100	3	229	2
227	100	3	230	3
228	100	3	231	4
229	100	4	232	1
230	100	4	233	2
231	100	4	234	3
232	100	4	235	4
233	100	5	236	1
234	100	5	237	2
235	100	5	238	3
236	100	5	239	4
237	100	6	240	1
238	100	6	241	2
239	100	6	242	3
240	100	6	243	4
243	100	7	246	3
245	100	8	248	1
246	100	8	249	2
247	100	8	250	3
248	100	8	251	4
249	100	9	252	1
250	100	9	253	2
251	100	9	254	3
252	100	9	255	4
253	100	10	256	1
254	100	10	257	2
255	100	10	258	3
256	100	10	259	4
257	100	11	260	1
258	100	11	261	2
259	100	11	262	3
260	100	11	263	4
261	100	12	264	1
262	100	12	265	2
263	100	12	266	3
264	100	12	267	4
265	100	13	268	1
266	100	13	269	2
267	100	13	270	3
268	100	13	271	4
269	100	14	272	1
270	100	14	273	2
271	100	14	274	3
272	100	14	275	4
273	100	15	276	1
274	100	15	277	2
275	100	15	278	3
276	100	15	279	4
277	100	16	280	1
278	100	16	281	2
279	100	16	282	3
280	100	16	283	4
281	100	17	284	1
282	100	17	285	2
283	100	17	286	3
284	100	17	287	4
285	100	18	288	1
286	100	18	289	2
287	100	18	290	3
288	100	18	291	4
289	100	19	292	1
290	100	19	293	2
291	100	19	294	3
292	100	19	295	4
293	100	20	296	1
294	100	20	297	2
295	100	20	298	3
296	100	20	299	4
297	100	21	300	1
298	100	21	301	2
299	100	21	302	3
300	100	21	303	4
301	100	22	304	1
302	100	22	305	2
303	100	22	306	3
304	100	22	307	4
305	100	23	308	1
306	100	23	309	2
307	100	23	310	3
308	100	23	311	4
309	100	24	312	1
310	100	24	313	2
311	100	24	314	3
312	100	24	315	4
313	100	25	316	1
314	100	25	317	2
315	100	25	318	3
316	100	25	319	4
317	100	26	320	1
318	100	26	321	2
319	100	26	322	3
320	100	26	323	4
321	100	27	324	1
322	100	27	325	2
323	100	27	326	3
324	100	27	327	4
325	100	28	328	1
326	100	28	329	2
327	100	28	330	3
328	100	28	331	4
329	100	29	332	1
330	100	29	333	2
331	100	29	334	3
332	100	29	335	4
333	100	30	336	1
334	100	30	337	2
335	100	30	338	3
336	100	30	339	4
337	100	31	340	1
338	100	31	341	2
339	100	31	342	3
340	100	31	343	4
341	100	32	344	1
342	100	32	345	2
343	100	32	346	3
344	100	32	347	4
345	100	33	348	1
346	100	33	349	2
347	100	33	350	3
348	100	33	351	4
349	100	34	352	1
350	100	34	353	2
351	100	34	354	3
352	100	34	355	4
353	100	35	356	1
354	100	35	357	2
355	100	35	358	3
356	100	35	359	4
357	100	36	360	1
358	100	36	361	2
359	100	36	362	3
360	100	36	363	4
361	100	37	364	1
362	100	37	365	2
363	100	37	366	3
364	100	37	367	4
365	100	38	368	1
366	100	38	369	2
367	100	38	370	3
368	100	38	371	4
369	100	39	372	1
370	100	39	373	2
371	100	39	374	3
372	100	39	375	4
374	100	40	377	2
244	98	7	247	4
373	98	40	376	1
219	99	1	222	3
225	100	3	228	1
375	100	40	378	3
376	100	40	379	4
377	100	41	380	1
378	100	41	381	2
379	100	41	382	3
380	100	41	383	4
381	100	42	384	1
382	100	42	385	2
383	100	42	386	3
384	100	42	387	4
385	100	43	388	1
386	100	43	389	2
387	100	43	390	3
388	100	43	391	4
389	100	44	392	1
390	100	44	393	2
391	100	44	394	3
392	100	44	395	4
393	100	45	396	1
394	100	45	397	2
395	100	45	398	3
396	100	45	399	4
397	100	46	400	1
398	100	46	401	2
399	100	46	402	3
400	100	46	403	4
401	100	47	404	1
402	100	47	405	2
403	100	47	406	3
404	100	47	407	4
405	100	48	408	1
406	100	48	409	2
407	100	48	410	3
408	100	48	411	4
409	100	49	412	1
410	100	49	413	2
411	100	49	414	3
412	100	49	415	4
413	100	50	416	1
414	100	50	417	2
415	100	50	418	3
416	100	50	419	4
417	100	51	420	1
418	100	51	421	2
419	100	51	422	3
420	100	51	423	4
421	100	52	424	1
422	100	52	425	2
423	100	52	426	3
424	100	52	427	4
425	100	53	428	1
426	100	53	429	2
427	100	53	430	3
428	100	53	431	4
429	100	54	432	1
430	100	54	433	2
431	100	54	434	3
432	100	54	435	4
433	100	55	436	1
434	100	55	437	2
435	100	55	438	3
436	100	55	439	4
437	100	56	440	1
438	100	56	441	2
439	100	56	442	3
440	100	56	443	4
441	100	57	444	1
442	100	57	445	2
443	100	57	446	3
444	100	57	447	4
445	100	58	448	1
446	100	58	449	2
447	100	58	450	3
448	100	58	451	4
449	100	59	452	1
450	100	59	453	2
451	100	59	454	3
452	100	59	455	4
453	100	60	456	1
454	100	60	457	2
455	100	60	458	3
456	100	60	459	4
457	100	61	460	1
458	100	61	461	2
459	100	61	462	3
460	100	61	463	4
461	100	62	464	1
462	100	62	465	2
463	100	62	466	3
464	100	62	467	4
465	100	63	468	1
466	100	63	469	2
467	100	63	470	3
468	100	63	471	4
469	100	64	472	1
470	100	64	473	2
471	100	64	474	3
472	100	64	475	4
473	100	65	476	1
474	100	65	477	2
475	100	65	478	3
476	100	65	479	4
477	100	66	480	1
478	100	66	481	2
479	100	66	482	3
480	100	66	483	4
481	100	67	484	1
482	100	67	485	2
483	100	67	486	3
484	100	67	487	4
485	100	68	488	1
486	100	68	489	2
487	100	68	490	3
488	100	68	491	4
489	100	69	492	1
490	100	69	493	2
491	100	69	494	3
492	100	69	495	4
493	100	70	496	1
494	100	70	497	2
495	100	70	498	3
496	100	70	499	4
497	100	71	500	1
498	100	71	501	2
499	100	71	502	3
500	100	71	503	4
501	100	72	504	1
502	100	72	505	2
503	100	72	506	3
504	100	72	507	4
505	100	73	508	1
506	100	73	509	2
507	100	73	510	3
508	100	73	511	4
509	100	74	512	1
510	100	74	513	2
511	100	74	514	3
512	100	74	515	4
513	100	75	516	1
514	100	75	517	2
515	100	75	518	3
516	100	75	519	4
517	100	76	520	1
518	100	76	521	2
519	100	76	522	3
520	100	76	523	4
521	100	77	524	1
522	100	77	525	2
523	100	77	526	3
525	100	78	528	1
526	100	78	529	2
527	100	78	530	3
528	100	78	531	4
524	90	77	527	4
530	93	79	533	2
532	100	79	535	4
534	100	80	537	2
535	100	80	538	3
537	100	81	540	1
538	100	81	541	2
539	100	81	542	3
544	90	82	547	4
540	90	81	543	4
536	90	80	539	4
543	60	82	546	3
542	80	82	545	2
2	100	82	2	1
242	95	7	245	2
3	100	19	3	1
4	100	74	4	1
531	85	79	534	3
5	1500	20	5	1
241	97	7	244	1
533	100	80	536	1
529	96	79	532	1
541	32	82	544	1
217	99	1	220	1
\.


--
-- Data for Name: app_for_user_vendor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_vendor (id, name, email, phone_num, address) FROM stdin;
1	Adidas Trần Hưng Đạo	adidasthd@outlook.com	0223344444	185/1 Trần Hưng Đạo
\.


--
-- Data for Name: app_for_user_warehouse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_for_user_warehouse (id, name, region, address, phone_num) FROM stdin;
1	Kho HCM 1	TPHCM	456 Hung Vuong, quan 5	0999999999
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
1	Sale employee
3	Accounting employee
2	Warehouse employee
4	Manager
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
169	2	32
170	2	33
171	2	34
172	2	35
5	1	41
6	1	42
7	1	43
8	1	44
173	2	36
174	2	37
175	2	38
176	2	39
177	2	40
178	2	17
15	1	40
16	1	20
17	1	24
18	1	28
19	2	9
20	2	10
21	2	11
22	2	12
23	2	13
24	2	14
25	2	15
26	2	16
179	2	18
180	2	19
181	2	20
182	2	29
183	2	30
184	2	31
185	4	64
186	4	57
187	4	58
188	4	59
189	4	60
190	4	61
191	4	62
192	4	63
57	3	8
58	3	40
59	3	44
60	3	45
61	3	46
62	3	47
63	3	48
64	3	12
65	3	16
66	3	20
67	3	24
69	4	1
70	4	2
71	4	3
72	4	4
73	4	5
74	4	6
75	4	7
76	4	8
77	4	9
78	4	10
79	4	11
80	4	12
81	4	13
82	4	14
83	4	15
84	4	16
85	4	17
86	4	18
87	4	19
88	4	20
89	4	21
90	4	22
91	4	23
92	4	24
93	4	25
94	4	26
95	4	27
96	4	28
97	4	29
98	4	30
99	4	31
100	4	32
101	4	33
102	4	34
103	4	35
104	4	36
105	4	37
106	4	38
107	4	39
108	4	40
109	4	41
110	4	42
111	4	43
112	4	44
113	4	45
114	4	46
115	4	47
116	4	48
117	4	49
118	4	50
119	4	51
120	4	52
121	4	53
122	4	54
123	4	55
124	4	56
125	1	5
126	1	6
127	1	7
128	1	8
129	1	45
130	1	46
131	1	47
132	1	48
161	2	21
162	2	22
163	2	23
164	2	24
165	2	25
166	2	26
167	2	27
168	2	28
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
9	Can add Goods receipt	3	add_goodsreceipt
10	Can change Goods receipt	3	change_goodsreceipt
11	Can delete Goods receipt	3	delete_goodsreceipt
12	Can view Goods receipt	3	view_goodsreceipt
13	Can add Goods receipt detail	4	add_goodsreceiptdetail
14	Can change Goods receipt detail	4	change_goodsreceiptdetail
15	Can delete Goods receipt detail	4	delete_goodsreceiptdetail
16	Can view Goods receipt detail	4	view_goodsreceiptdetail
17	Can add product	5	add_product
18	Can change product	5	change_product
19	Can delete product	5	delete_product
20	Can view product	5	view_product
21	Can add Product type	6	add_producttype
22	Can change Product type	6	change_producttype
23	Can delete Product type	6	delete_producttype
24	Can view Product type	6	view_producttype
25	Can add size	7	add_size
26	Can change size	7	change_size
27	Can delete size	7	delete_size
28	Can view size	7	view_size
29	Can add vendor	8	add_vendor
30	Can change vendor	8	change_vendor
31	Can delete vendor	8	delete_vendor
32	Can view vendor	8	view_vendor
33	Can add warehouse	9	add_warehouse
34	Can change warehouse	9	change_warehouse
35	Can delete warehouse	9	delete_warehouse
36	Can view warehouse	9	view_warehouse
37	Can add stock	10	add_stock
38	Can change stock	10	change_stock
39	Can delete stock	10	delete_stock
40	Can view stock	10	view_stock
41	Can add bill detail	11	add_billdetail
42	Can change bill detail	11	change_billdetail
43	Can delete bill detail	11	delete_billdetail
44	Can view bill detail	11	view_billdetail
45	Can add log entry	12	add_logentry
46	Can change log entry	12	change_logentry
47	Can delete log entry	12	delete_logentry
48	Can view log entry	12	view_logentry
49	Can add permission	13	add_permission
50	Can change permission	13	change_permission
51	Can delete permission	13	delete_permission
52	Can view permission	13	view_permission
53	Can add group	14	add_group
54	Can change group	14	change_group
55	Can delete group	14	delete_group
56	Can view group	14	view_group
57	Can add content type	15	add_contenttype
58	Can change content type	15	change_contenttype
59	Can delete content type	15	delete_contenttype
60	Can view content type	15	view_contenttype
61	Can add session	16	add_session
62	Can change session	16	change_session
63	Can delete session	16	delete_session
64	Can view session	16	view_session
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2021-11-08 16:14:01.857359+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
2	2021-11-08 16:15:26.513201+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
3	2021-11-08 16:16:17.241103+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
4	2021-11-08 16:16:37.280249+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
5	2021-11-08 16:16:49.341939+07	217	3-Stripes Pants - L	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
6	2021-11-08 16:16:58.040437+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
7	2021-11-08 16:17:12.668273+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
8	2021-11-08 16:17:25.862028+07	1	1	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
9	2021-11-10 09:35:50.883794+07	1	1	3		2	1
10	2021-11-10 09:36:19.857451+07	217	3-Stripes Pants - L	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
11	2021-11-10 09:39:40.969844+07	3	3	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
12	2021-11-10 09:40:39.957218+07	3	3	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
13	2021-11-10 09:40:58.111257+07	3	3	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (1)", "fields": ["Quantity"]}}]	2	1
14	2021-11-10 09:41:14.713206+07	3	3	2	[{"deleted": {"name": "bill detail", "object": "BillDetail object (None)"}}]	2	1
15	2021-11-10 09:59:52.779156+07	544	Run It 3-Stripes Astro Pants - M	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
16	2021-11-10 10:00:07.311987+07	540	3-Stripes Pants - M	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
17	2021-11-10 10:00:11.370219+07	536	Trefoil Essentials Pants - M	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
18	2021-11-10 10:00:17.097547+07	531	Woven Tape Pants - S	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
19	2021-11-10 10:00:22.414851+07	524	Essentials 3-Stripes Wind Pants - M	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
20	2021-11-10 10:01:10.700613+07	543	Run It 3-Stripes Astro Pants - S	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
21	2021-11-10 10:01:14.67284+07	542	Run It 3-Stripes Astro Pants - XL	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
22	2021-11-10 10:01:19.291104+07	541	Run It 3-Stripes Astro Pants - L	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
23	2021-11-10 10:28:21.087867+07	2	GoodsReceipt object (2)	1	[{"added": {}}, {"added": {"name": "Goods receipt detail", "object": "Receipt note 2"}}]	3	1
24	2021-11-15 08:29:44.319564+07	6	6	2	[{"changed": {"fields": ["State"]}}]	2	1
25	2021-11-15 08:30:00.152469+07	5	5	2	[{"changed": {"fields": ["State"]}}]	2	1
26	2021-11-15 08:30:21.861711+07	4	4	2	[{"changed": {"fields": ["State"]}}]	2	1
27	2021-11-15 09:18:08.08665+07	6	6	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (4)", "fields": ["Quantity"]}}, {"changed": {"name": "bill detail", "object": "BillDetail object (5)", "fields": ["Quantity"]}}]	2	1
28	2021-11-15 09:18:20.918384+07	6	6	2	[{"changed": {"fields": ["Total"]}}]	2	1
29	2021-11-15 10:08:18.713146+07	7	7	2	[{"changed": {"fields": ["Total"]}}]	2	1
30	2021-11-15 10:10:24.205324+07	7	7	2	[{"changed": {"fields": ["Total"]}}]	2	1
31	2021-11-15 10:12:43.161271+07	7	7	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (15)", "fields": ["Quantity"]}}]	2	1
32	2021-11-15 10:14:44.577216+07	7	7	2	[{"changed": {"fields": ["Total"]}}]	2	1
33	2021-11-15 10:16:31.935356+07	7	7	2	[{"changed": {"fields": ["Total"]}}]	2	1
34	2021-11-15 10:19:36.015885+07	6	6	2	[{"changed": {"name": "bill detail", "object": "BillDetail object (4)", "fields": ["Quantity"]}}, {"changed": {"name": "bill detail", "object": "BillDetail object (5)", "fields": ["Quantity"]}}]	2	1
35	2021-11-15 10:20:09.892823+07	5	5	2	[{"changed": {"fields": ["Total"]}}]	2	1
36	2021-11-15 10:20:24.147638+07	4	4	2	[{"changed": {"fields": ["Total"]}}]	2	1
37	2021-11-15 10:34:17.96333+07	7	7	2	[{"changed": {"fields": ["State", "Address"]}}]	2	1
38	2021-11-15 11:30:54.021573+07	8	8	1	[{"added": {}}]	2	1
39	2021-11-15 17:16:32.86333+07	8	8	3		2	1
40	2021-11-16 16:35:19.188132+07	1	Sale	1	[{"added": {}}]	14	1
41	2021-11-16 16:36:04.737296+07	2	Warehouse	1	[{"added": {}}]	14	1
42	2021-11-16 16:37:25.562071+07	3	Accounting	1	[{"added": {}}]	14	1
43	2021-11-16 16:38:15.379536+07	4	Managing	1	[{"added": {}}]	14	1
44	2021-11-16 16:38:25.691405+07	3	Accounting employee	2	[{"changed": {"fields": ["Name"]}}]	14	1
45	2021-11-16 16:38:34.227289+07	4	Manager	2	[{"changed": {"fields": ["Name"]}}]	14	1
46	2021-11-16 16:38:44.940534+07	1	Sale employee	2	[{"changed": {"fields": ["Name"]}}]	14	1
47	2021-11-16 16:38:54.072387+07	2	Warehouse employee	2	[{"changed": {"fields": ["Name"]}}]	14	1
48	2021-11-16 16:40:54.069289+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Username", "Groups"]}}]	1	1
49	2021-11-16 16:42:30.854893+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Is staff"]}}]	1	1
50	2021-11-17 09:54:13.294819+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Is staff"]}}]	1	1
51	2021-11-17 12:40:40.794647+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Is staff"]}}]	1	1
52	2021-11-17 12:43:28.808257+07	1	Sale employee	2	[{"changed": {"fields": ["Permissions"]}}]	14	1
53	2021-11-17 12:45:20.719658+07	1	Sale employee	2	[{"changed": {"fields": ["Permissions"]}}]	14	1
54	2021-11-17 12:47:43.200807+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Groups"]}}]	1	1
55	2021-11-17 12:50:55.123785+07	2	Warehouse employee	2	[{"changed": {"fields": ["Permissions"]}}]	14	1
56	2021-11-17 12:52:53.025528+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Is admin"]}}]	1	1
57	2021-11-17 12:54:14.666198+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Is admin"]}}]	1	1
58	2021-11-17 12:55:28.687432+07	2	Warehouse employee	2	[{"changed": {"fields": ["Permissions"]}}]	14	1
59	2021-11-17 13:03:31.581052+07	2	Warehouse employee	2	[{"changed": {"fields": ["Permissions"]}}]	14	1
60	2021-11-17 13:32:16.620718+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Groups"]}}]	1	1
61	2021-11-17 13:34:56.503863+07	9	9	1	[{"added": {}}]	2	2
62	2021-11-17 13:53:13.284595+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Groups"]}}]	1	1
63	2021-11-17 14:00:30.568607+07	3	Accounting employee	2	[{"changed": {"fields": ["Permissions"]}}]	14	1
64	2021-11-17 14:22:25.598326+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Groups"]}}]	1	1
65	2021-11-17 14:23:31.658105+07	2	Warehouse employee	2	[{"changed": {"fields": ["Permissions"]}}]	14	1
66	2021-11-17 14:43:17.394767+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Groups"]}}]	1	1
67	2021-11-17 14:44:29.037865+07	2	hang@gmail.com	2	[]	1	1
68	2021-11-17 14:45:39.522896+07	4	Manager	2	[{"changed": {"fields": ["Permissions"]}}]	14	1
69	2021-11-17 14:46:15.620961+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Is admin"]}}]	1	1
70	2021-11-17 14:46:30.626819+07	2	hang@gmail.com	2	[]	1	1
71	2021-11-21 20:19:02.048592+07	83	Test	3		5	1
72	2021-11-21 20:19:23.270806+07	83	Test	1	[{"added": {}}]	5	1
73	2021-11-21 20:21:40.630662+07	3	test	1	[{"added": {}}]	6	1
74	2021-11-21 20:28:25.767607+07	4	GoodsReceipt object (4)	1	[{"added": {}}, {"added": {"name": "Goods receipt detail", "object": "Receipt note 4"}}]	3	1
75	2021-11-21 20:31:22.61859+07	4	GoodsReceipt object (4)	2	[{"added": {"name": "Goods receipt detail", "object": "Receipt note 4"}}]	3	1
76	2021-11-26 09:30:59.306812+07	531	Woven Tape Pants - S	2	[{"changed": {"fields": ["Quantity"]}}]	10	2
77	2021-11-26 09:31:24.251239+07	531	Woven Tape Pants - S	2	[{"changed": {"fields": ["Quantity"]}}]	10	2
78	2021-11-26 09:34:41.784537+07	9	9	3		2	2
79	2021-11-27 15:22:02.390047+07	373	Adidas Z.N.E. Woven Pants - L	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
80	2021-11-27 15:22:19.557029+07	373	Adidas Z.N.E. Woven Pants - L	2	[{"changed": {"fields": ["Quantity"]}}]	10	1
81	2021-11-27 15:24:26.064265+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Groups"]}}]	1	1
82	2021-11-27 15:25:35.20822+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Is admin"]}}]	1	1
83	2021-11-27 15:30:45.477966+07	5	GoodsReceipt object (5)	1	[{"added": {}}, {"added": {"name": "Goods receipt detail", "object": "Receipt note 5"}}]	3	1
84	2021-11-27 15:31:10.285385+07	5	GoodsReceipt object (5)	2	[{"changed": {"name": "Goods receipt detail", "object": "Receipt note 5", "fields": ["Quantity"]}}]	3	1
85	2022-05-08 19:48:23.469577+07	11	tuandip2@gmail.com	3		1	6
86	2022-05-08 19:48:23.501578+07	10	tuandip1@gmail.com	3		1	6
87	2022-05-08 19:49:29.607603+07	12	tuandip2@gmail.com	3		1	6
88	2022-05-08 21:06:57.374749+07	13	tuandip2@gmail.com	3		1	6
89	2022-05-08 21:32:47.553376+07	14	tuandip2@gmail.com	2	[{"changed": {"fields": ["Phone number"]}}]	1	6
90	2022-05-13 09:09:54.258552+07	7	dungviet@gmail.com	3		1	6
91	2022-05-13 09:10:41.397761+07	16	ydg0@tjdhc.rxj	3		1	6
92	2022-05-13 09:10:41.402761+07	18	ydg7@tjdhc.rxj	3		1	6
93	2022-05-13 09:10:54.619193+07	8	tuandip@gmail.com	3		1	6
94	2022-05-13 09:10:54.624193+07	14	tuandip2@gmail.com	3		1	6
95	2022-05-13 09:11:05.248348+07	5	thinhthongminh@gmail.com	3		1	6
96	2022-05-13 09:11:13.037215+07	15	thang89@gmail.com	3		1	6
97	2022-05-13 09:13:24.104185+07	20	ydg8@tjdhc.rxj	3		1	6
98	2022-05-13 09:13:39.557356+07	4	than123g@gmail.com	3		1	6
99	2022-05-13 09:15:06.012738+07	21	dat5@gmail.com	3		1	6
100	2022-05-13 09:15:38.114929+07	19	dat3@gmail.com	3		1	6
101	2022-05-13 09:16:02.770164+07	3	abc@gmail.com	2	[{"changed": {"fields": ["Username", "Is staff"]}}]	1	6
102	2022-05-13 09:35:46.324156+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Address"]}}]	1	6
103	2022-05-13 09:37:31.101182+07	6	le@gmail.com	2	[{"changed": {"fields": ["Phone number", "Address"]}}]	1	6
104	2022-05-13 09:37:55.359907+07	1	nguyenlehuythang@gmail.com	2	[{"changed": {"fields": ["Phone number", "Address"]}}]	1	6
105	2022-05-13 09:48:11.684701+07	1	Dyhydz Anqt Unxqt	2	[{"changed": {"fields": ["Address"]}}]	8	6
106	2022-05-14 08:30:54.673311+07	3	abc@gmail.com	2	[{"changed": {"fields": ["Phone number"]}}]	1	6
107	2022-05-17 13:14:27.055422+07	3	abc@gmail.com	2	[{"changed": {"fields": ["Phone number", "Address"]}}]	1	6
108	2022-05-17 13:14:55.537013+07	6	le@gmail.com	2	[{"changed": {"fields": ["Phone number", "Address"]}}]	1	6
109	2022-05-17 13:16:04.866093+07	1	nguyenlehuythang@gmail.com	2	[{"changed": {"fields": ["Phone number"]}}]	1	6
110	2022-05-17 13:16:18.745321+07	2	hang@gmail.com	2	[{"changed": {"fields": ["Phone number"]}}]	1	6
111	2022-05-17 13:17:41.656443+07	1	Adidas Trần Hưng Đạo	2	[{"changed": {"fields": ["Name", "Email address", "Phone number", "Address"]}}]	8	6
112	2022-05-17 13:24:23.787519+07	17	17	2	[{"changed": {"fields": ["State"]}}]	2	6
113	2022-05-17 17:57:41.063856+07	18	18	2	[{"changed": {"fields": ["Address"]}}]	2	6
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	Users	account
2	app_for_user	bill
3	app_for_user	goodsreceipt
4	app_for_user	goodsreceiptdetail
5	app_for_user	product
6	app_for_user	producttype
7	app_for_user	size
8	app_for_user	vendor
9	app_for_user	warehouse
10	app_for_user	stock
11	app_for_user	billdetail
12	admin	logentry
13	auth	permission
14	auth	group
15	contenttypes	contenttype
16	sessions	session
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2021-11-08 15:23:15.321108+07
2	contenttypes	0002_remove_content_type_name	2021-11-08 15:23:15.330108+07
3	auth	0001_initial	2021-11-08 15:23:15.948143+07
4	auth	0002_alter_permission_name_max_length	2021-11-08 15:23:17.10621+07
5	auth	0003_alter_user_email_max_length	2021-11-08 15:23:17.11221+07
6	auth	0004_alter_user_username_opts	2021-11-08 15:23:17.11821+07
7	auth	0005_alter_user_last_login_null	2021-11-08 15:23:17.123211+07
8	auth	0006_require_contenttypes_0002	2021-11-08 15:23:17.125211+07
9	auth	0007_alter_validators_add_error_messages	2021-11-08 15:23:17.131211+07
10	auth	0008_alter_user_username_max_length	2021-11-08 15:23:17.240217+07
11	auth	0009_alter_user_last_name_max_length	2021-11-08 15:23:17.254218+07
12	auth	0010_alter_group_name_max_length	2021-11-08 15:23:17.499232+07
13	auth	0011_update_proxy_permissions	2021-11-08 15:23:17.506232+07
14	auth	0012_alter_user_first_name_max_length	2021-11-08 15:23:17.512233+07
15	Users	0001_initial	2021-11-08 15:23:19.019319+07
16	admin	0001_initial	2021-11-08 15:23:19.825365+07
17	admin	0002_logentry_remove_auto_add	2021-11-08 15:23:20.233388+07
18	admin	0003_logentry_add_action_flag_choices	2021-11-08 15:23:20.241389+07
19	app_for_user	0001_initial	2021-11-08 15:23:23.434572+07
20	app_for_user	0002_auto_20211103_1958	2021-11-08 15:23:27.415799+07
21	app_for_user	0003_auto_20211103_2009	2021-11-08 15:23:27.440801+07
22	app_for_user	0004_auto_20211108_1503	2021-11-08 15:23:27.568808+07
23	sessions	0001_initial	2021-11-08 15:23:27.808822+07
24	app_for_user	0005_auto_20211110_1027	2021-11-10 10:27:16.519944+07
25	Users	0002_alter_account_id	2022-05-08 18:57:26.665538+07
26	Users	0003_alter_account_phone_num	2022-05-08 19:43:55.488374+07
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
m91pqcp70kfr20dk88b8w3uwi5yohre0	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqqcd:LwFuP_8vALuGFnNgpY4I7cSfgeMlFu6CZTzAPZ-JKJw	2022-05-31 13:23:55.210611+07
ec3r7fdt2ey4ostzsjl4xvtgod09ue7l	.eJxVjLEOwiAURf-F2ZDyqFTc7O7oTB68V6mSkpQ2DsZ_lyYddLnDPffct3C4LtGthWc3kjgLJQ6_ncfw5GkD9MDpnmXI0zKPXm4TudMiLynlV41bdco1E6d-F__eIpZYr7jToQETGmVJU0vM4DUiWOtBWW6JtDr60NYBAYPt2CgcwskMoLTXJD5fY9Q9cw:1mm7A8:S5YQiCArAn067LVjnmlKzDECsTuEYyma8NwmzrDJIpo	2021-11-28 11:30:40.388273+07
t6xoo2uyghl7djpf6wj3x27k0uhvvlgs	.eJxVjLEOwiAURf-F2ZDyqFTc7O7oTB68V6mSkpQ2DsZ_lyYddLnDPffct3C4LtGthWc3kjgLJQ6_ncfw5GkD9MDpnmXI0zKPXm4TudMiLynlV41bdco1E6d-F__eIpZYr7jToQETGmVJU0vM4DUiWOtBWW6JtDr60NYBAYPt2CgcwskMoLTXJD5fY9Q9cw:1mmQl6:bLFdT46bpcMIwJY3IFQ1erXwq9bmj7FOqwVXt9Gb5ZU	2021-11-29 08:26:08.394213+07
vajk4hxxg1cfyb8it6al7p4nl30ytdti	.eJxVjLEOwiAURf-F2ZDyqFTc7O7oTB68V6mSkpQ2DsZ_lyYddLnDPffct3C4LtGthWc3kjgLJQ6_ncfw5GkD9MDpnmXI0zKPXm4TudMiLynlV41bdco1E6d-F__eIpZYr7jToQETGmVJU0vM4DUiWOtBWW6JtDr60NYBAYPt2CgcwskMoLTXJD5fY9Q9cw:1mnDfx:u1p3x8k9HgHeNxmT2sYdGa0xmrDk11ttA_gQUIBNTBs	2021-12-01 12:40:05.292617+07
m9lxe96re3lkuvtc3amvdq7sxqwum9gs	.eJxVjLEOgkAQRP_lanNZbvcQ7LS3tCbL7SIouUs4iIXx34WEQpspZua9t2l4mftmyTo1g5iTQXP47VoOT43bIA-O92RDivM0tHa72H3N9jyO6bXGbWXyNYmOlx38s_Wc-1VVglTkjqyE4Em8QyHXeSzb0CGWWjnVADUgBCJgENGOa1f4oghMtTefLz3KPII:1mqQzb:6uot6-CmszrflQd1B4b2dCIXgEzw_6xk1kyhB_9Rc98	2021-12-10 09:29:39.827266+07
kk8ffaaimg3d8vygh3e6db28qyc3a3qs	.eJxVjLEOwiAURf-F2ZDyqFTc7O7oTB68V6mSkpQ2DsZ_lyYddLnDPffct3C4LtGthWc3kjgLJQ6_ncfw5GkD9MDpnmXI0zKPXm4TudMiLynlV41bdco1E6d-F__eIpZYr7jToQETGmVJU0vM4DUiWOtBWW6JtDr60NYBAYPt2CgcwskMoLTXJD5fY9Q9cw:1mqt5Y:47Q-sEri3jEZ7oy19XxnMF6DgajaKOxrYZOu3h3bpeo	2021-12-11 15:29:40.567254+07
jd3069m0fu96sytvuxb330qxo4fr0c8y	.eJxVjD0PgjAURf9LZ9MAtkDddHd0Ju-jz6JNm1CIg_G_CwmDLne4957zVgMscxiW4qdhZHVSVh1-OwR6-rQN_IB0z5pymqcR9XbR-1r0Ocb8WuO2MuWa2cfLDv7ZApSwqYwFsATYGSu9Mx0bbkGQsGlc5wQq43tmb4HA1b2tCEXaWpwcvbBD9fkCivk-xA:1nRPpn:EvFKMeuS0SGK-lzJl0xVEw-D0atH4f6NhYEbj1miL7U	2022-03-22 09:44:23.060269+07
a2jy2vgibipuktm3vfxojc3ghvsmq12f	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1npKib:Iy328Oi4lbDabdbY9sQwVpj6nb0hm0YpJMlEUS-Qg1M	2022-05-27 09:07:49.445611+07
iymhtib2vmxtir0h1x32msacwqdga7ni	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqPMR:qTZscEwsxJZFui4rlEVOLHsgqTh74QrLQGH5m9ja-dg	2022-05-30 08:17:23.347107+07
ceanymazgd2tqniaa4he26a2i90wlc0t	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqPQ9:qaJtB0Gilnhq3d6j6EJguvXmVr5HjwZgQLrCWz-zsdc	2022-05-30 08:21:13.366263+07
rpqzgbwmuuloyyl49vslpgwzz2oklbcf	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqPWG:kQDIqK6DdCBxONTKaAh9meRSe5iNLfKfKLBoSnyOPj0	2022-05-30 08:27:32.080984+07
0l2zsnfnn6fgoem0brzyry2s5yn0ndhy	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqkg2:3KmVd9QnCkoUovzurpqVn4CvDicGELCZ8EY9KY0qZ1I	2022-05-31 07:03:02.704341+07
vq1sbpam686mjc3f53panmkrgzkewsc3	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqkid:SWYoBG8VCK22Lw3NQx2NqLUrYew9D8jbS2OjEsVzVLw	2022-05-31 07:05:43.160394+07
4q1y8zsylbimjkbopqsnpuzg91ivj99k	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqkoA:8xhvdimpod8I-5nienwt6gagnqofl0oBAhb3svX8MTQ	2022-05-31 07:11:26.296993+07
vfoxotpd4em12o5xql3svxhujj893802	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqku2:GD242h-Ez0tpC5xga5WOCXqDYRB4bKQFRmE916LPRFk	2022-05-31 07:17:30.820125+07
idyw2l1cjptcdz3y1q35cuwwonrabwo8	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqkvn:_8LYCWrdBkD_LBsPPv-Tza5GB3cYErb8XOH0TTjXe-o	2022-05-31 07:19:19.547311+07
m28ixkhdggyqlqy83ltafd00mcu0cehm	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqkyF:T_JqQivBN6NQmItYSWBD2dtc_WUGVfshEkOk7QFhkA4	2022-05-31 07:21:51.421169+07
syhdvg3wer8ft294hy2alps09x47x4lz	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nql9P:B0zwcB8bOHswGzgGNyGzwvaonSITpqfK8-DcD2o6Qik	2022-05-31 07:33:23.896183+07
ywqc5jrxye3h1vgicc2mxiediav3h75r	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nql9g:1H9mFwHS4CvqJslooDByGOOVGJ_kNT0Jj9GBI5mlRHg	2022-05-31 07:33:40.893198+07
y11cejgsnwt8vqoq2tsm8at7be3mchyh	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nql9z:kSOtkh09MtuzIlXaC0CnEiKfgH4T0PePt30zZ2yZ-Io	2022-05-31 07:33:59.541087+07
rgi2ove8c2sdy24zejkknyi2eq5salgy	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqmqO:MPItziA-HPJAsBjgnHQSyVFmXzVoAaFQbxOn0JznN9w	2022-05-31 09:21:52.876624+07
d4l23a9wuzutkwt2x8wc2pe1mfey806d	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqn0W:xrh0ZRLrwcL8-tX1M6meIpqh0CzWjKJ30E5Vu4bVbak	2022-05-31 09:32:20.265449+07
ri40y0ihw66abpdrsjh6b6b55mzq63ni	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqn0o:ecIKC6YD1O4ogNvgAxpayIOPOwNfMLB37YeAH0yMp8s	2022-05-31 09:32:38.334327+07
vxh2jgbe1wpxprvo3s91m07f9xbvasia	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqn15:L3kKBSrKo_L2iRXG8VShty6kyptTguMXCwnYhLrmkbU	2022-05-31 09:32:55.49914+07
a1fo7x1wg2rdwsxl59v0npqgk0njbc6d	.eJxVjLEOwiAURf-F2RBKkb7nprujc_OAh602kJQ2DsZ_lyYddLnDvfect-hpXYZ-LTz3YxAnobU4_JaO_JPTtoQHpXuWPqdlHp3cLnJfizxPU37VuFWmXHPg6bKDf7aBylBVZBlVsMpha7vGdFWjlFdAUbnYOkJtIaKJPrRHZNDgG7SA4BE1BDbi8wV_Az0f:1nqqaN:CGU1Zf5rNh-Xo1RMktM6RVkY3dbvb-UTKQLxwHOhVdA	2022-05-31 13:21:35.896701+07
oj4ie48kzs2zgj8rgx97ra4fzboa77ta	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nqtp6:CNqzQc6NyYoux9362xidrVCpWyTH7Z5oObpLsKnoSpM	2022-05-31 16:49:00.49722+07
zefbsv7fbobgcu3p5mc8q4jyex13brc8	.eJxVjLEOwiAURf-F2RBoEYqb7o7O5PEeSLWBpLRxMP67NOmgyx3uvee8mYN1SW6tYXYjsRPT7PDbecBnyNtAD8j3wrHkZR493y58Xys_T1N5tbg1pl4Lhemyg3-2BDU11SColxaE9EKjkYMGKQIaBB_JKxu1VhEpyh4UemF6eyRBnTYBVCejiezzBWGnPX4:1nt2e1:1bpqeZMUSUas7-dnYXQQ85HA9i7VuzhAgze0PBHokdU	2022-06-06 14:38:25.400793+07
\.


--
-- Name: Users_account_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_account_groups_id_seq"', 7, true);


--
-- Name: Users_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_account_id_seq"', 22, true);


--
-- Name: Users_account_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_account_user_permissions_id_seq"', 1, false);


--
-- Name: app_for_user_bill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_bill_id_seq', 18, true);


--
-- Name: app_for_user_billdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_billdetail_id_seq', 29, true);


--
-- Name: app_for_user_goodsreceipt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_goodsreceipt_id_seq', 5, true);


--
-- Name: app_for_user_goodsreceiptdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_goodsreceiptdetail_id_seq', 5, true);


--
-- Name: app_for_user_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_product_id_seq', 11, true);


--
-- Name: app_for_user_producttype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_producttype_id_seq', 2, true);


--
-- Name: app_for_user_size_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_size_id_seq', 1, false);


--
-- Name: app_for_user_stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_stock_id_seq', 5, true);


--
-- Name: app_for_user_vendor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_vendor_id_seq', 1, false);


--
-- Name: app_for_user_warehouse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_for_user_warehouse_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 4, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 192, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 64, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 113, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 16, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 26, true);


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
-- Name: app_for_user_billdetail app_for_user_billdetail_bill_id_stock_id_8f181109_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_billdetail
    ADD CONSTRAINT app_for_user_billdetail_bill_id_stock_id_8f181109_uniq UNIQUE (bill_id, stock_id);


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
-- Name: app_for_user_warehouse app_for_user_warehouse_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_warehouse
    ADD CONSTRAINT app_for_user_warehouse_address_key UNIQUE (address);


--
-- Name: app_for_user_warehouse app_for_user_warehouse_phone_num_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_warehouse
    ADD CONSTRAINT app_for_user_warehouse_phone_num_key UNIQUE (phone_num);


--
-- Name: app_for_user_warehouse app_for_user_warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_warehouse
    ADD CONSTRAINT app_for_user_warehouse_pkey PRIMARY KEY (id);


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
-- Name: app_for_user_billdetail_stock_id_da47d11f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_billdetail_stock_id_da47d11f ON public.app_for_user_billdetail USING btree (stock_id);


--
-- Name: app_for_user_goodsreceipt_vendor_id_aec5aca2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_goodsreceipt_vendor_id_aec5aca2 ON public.app_for_user_goodsreceipt USING btree (vendor_id);


--
-- Name: app_for_user_goodsreceipt_warehouse_id_1b0be046; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_goodsreceipt_warehouse_id_1b0be046 ON public.app_for_user_goodsreceipt USING btree (warehouse_id);


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
-- Name: app_for_user_stock_receiptDetail_id_2af1cefe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "app_for_user_stock_receiptDetail_id_2af1cefe" ON public.app_for_user_stock USING btree (receipt_detail_id);


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
-- Name: app_for_user_warehouse_address_6b1a0a60_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_warehouse_address_6b1a0a60_like ON public.app_for_user_warehouse USING btree (address varchar_pattern_ops);


--
-- Name: app_for_user_warehouse_phone_num_682460da_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX app_for_user_warehouse_phone_num_682460da_like ON public.app_for_user_warehouse USING btree (phone_num varchar_pattern_ops);


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
-- Name: billidx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX billidx ON public.app_for_user_bill USING btree (customer_id, state) WHERE ((state)::text = '0'::text);


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
-- Name: app_for_user_billdetail addnewdetail; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER addnewdetail AFTER INSERT ON public.app_for_user_billdetail FOR EACH ROW EXECUTE FUNCTION public.increasetotalanddecreasestock();


--
-- Name: app_for_user_billdetail decreasestock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER decreasestock AFTER INSERT ON public.app_for_user_billdetail FOR EACH ROW EXECUTE FUNCTION public.decreasestock();


--
-- Name: app_for_user_goodsreceiptdetail decreasetotalvalue; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER decreasetotalvalue BEFORE DELETE ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.decreasetotal();


--
-- Name: app_for_user_billdetail dltbdtostock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER dltbdtostock BEFORE DELETE ON public.app_for_user_billdetail FOR EACH ROW EXECUTE FUNCTION public.dltbilldetailtostock();


--
-- Name: app_for_user_goodsreceiptdetail dltreceiptnotetostock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER dltreceiptnotetostock BEFORE DELETE ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.dltreceipttostock();


--
-- Name: app_for_user_goodsreceiptdetail increasetotalvalue; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER increasetotalvalue AFTER INSERT ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.increasetotal();


--
-- Name: app_for_user_goodsreceiptdetail receiptnotetostock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER receiptnotetostock AFTER INSERT ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.receipttostock();


--
-- Name: app_for_user_goodsreceipt set_check_dublicate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_check_dublicate BEFORE INSERT ON public.app_for_user_goodsreceipt FOR EACH ROW EXECUTE FUNCTION public.checkdup2();


--
-- Name: app_for_user_goodsreceiptdetail set_check_dublicate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_check_dublicate BEFORE INSERT ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.checkdup3();


--
-- Name: app_for_user_product set_check_dublicate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_check_dublicate BEFORE INSERT ON public.app_for_user_product FOR EACH ROW EXECUTE FUNCTION public.checkdup();


--
-- Name: app_for_user_producttype set_check_dublicate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_check_dublicate BEFORE INSERT ON public.app_for_user_producttype FOR EACH ROW EXECUTE FUNCTION public.checkdup1();


--
-- Name: app_for_user_size set_check_dublicate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_check_dublicate BEFORE INSERT ON public.app_for_user_size FOR EACH ROW EXECUTE FUNCTION public.checkdup5();


--
-- Name: app_for_user_stock set_check_dublicate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_check_dublicate BEFORE INSERT ON public.app_for_user_stock FOR EACH ROW EXECUTE FUNCTION public.checkdup4();


--
-- Name: app_for_user_billdetail updatedetail; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updatedetail BEFORE UPDATE ON public.app_for_user_billdetail FOR EACH ROW EXECUTE FUNCTION public.updatetotalandstock();


--
-- Name: app_for_user_goodsreceiptdetail updatetotalvalue; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updatetotalvalue AFTER UPDATE ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.updatetotal();


--
-- Name: app_for_user_goodsreceiptdetail updreceiptnotetostock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updreceiptnotetostock AFTER UPDATE ON public.app_for_user_goodsreceiptdetail FOR EACH ROW EXECUTE FUNCTION public.updreceipttostock();


--
-- Name: Users_account_groups Users_account_groups_group_id_2967e8a0_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_groups"
    ADD CONSTRAINT "Users_account_groups_group_id_2967e8a0_fk_auth_group_id" FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: Users_account_user_permissions Users_account_user_p_permission_id_dc4c6d1b_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users_account_user_permissions"
    ADD CONSTRAINT "Users_account_user_p_permission_id_dc4c6d1b_fk_auth_perm" FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_bill app_for_user_bill_customer_id_a1087260_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_bill
    ADD CONSTRAINT app_for_user_bill_customer_id_a1087260_fk FOREIGN KEY (customer_id) REFERENCES public."Users_account"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_billdetail app_for_user_billdet_bill_id_913aa310_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_billdetail
    ADD CONSTRAINT app_for_user_billdet_bill_id_913aa310_fk_app_for_u FOREIGN KEY (bill_id) REFERENCES public.app_for_user_bill(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: app_for_user_billdetail app_for_user_billdet_stock_id_da47d11f_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_billdetail
    ADD CONSTRAINT app_for_user_billdet_stock_id_da47d11f_fk_app_for_u FOREIGN KEY (stock_id) REFERENCES public.app_for_user_stock(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: app_for_user_goodsreceipt app_for_user_goodsre_warehouse_id_1b0be046_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_goodsreceipt
    ADD CONSTRAINT app_for_user_goodsre_warehouse_id_1b0be046_fk_app_for_u FOREIGN KEY (warehouse_id) REFERENCES public.app_for_user_warehouse(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: app_for_user_stock app_for_user_stock_receipt_detail_id_2d3f3dab_fk_app_for_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_for_user_stock
    ADD CONSTRAINT app_for_user_stock_receipt_detail_id_2d3f3dab_fk_app_for_u FOREIGN KEY (receipt_detail_id) REFERENCES public.app_for_user_goodsreceiptdetail(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk FOREIGN KEY (user_id) REFERENCES public."Users_account"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

