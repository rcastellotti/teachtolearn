--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

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

DROP DATABASE IF EXISTS ttl;
--
-- Name: ttl; Type: DATABASE; Schema: -; Owner: teachtolearn
--

CREATE DATABASE ttl WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE ttl OWNER TO teachtolearn;

\connect ttl

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: teachtolearn
--

CREATE TABLE public.courses (
    abbreviation character varying(8) NOT NULL,
    name character varying(64) NOT NULL,
    icon character varying(32) NOT NULL,
    color character varying(16) NOT NULL,
    latitude double precision,
    longitude double precision,
    address character varying(256),
    syllabus character varying(1024) NOT NULL,
    "maxStudents" integer NOT NULL,
    "enrolledStudents" integer NOT NULL,
    "teacherId" character varying(16) NOT NULL,
    "isBanned" boolean NOT NULL,
    "isDeleted" boolean NOT NULL
);


ALTER TABLE public.courses OWNER TO teachtolearn;

--
-- Name: lectures; Type: TABLE; Schema: public; Owner: teachtolearn
--

CREATE TABLE public.lectures (
    index integer NOT NULL,
    "courseAbbreviation" character varying(8) NOT NULL,
    summary character varying(1024) NOT NULL,
    date date NOT NULL,
    start time without time zone NOT NULL,
    "end" time without time zone NOT NULL,
    "isBanned" boolean NOT NULL,
    id character varying(16) NOT NULL
);


ALTER TABLE public.lectures OWNER TO teachtolearn;

--
-- Name: reservations; Type: TABLE; Schema: public; Owner: teachtolearn
--

CREATE TABLE public.reservations (
    id character varying(16) NOT NULL,
    "courseAbbreviation" character varying(8) NOT NULL,
    "userId" character varying(16) NOT NULL
);


ALTER TABLE public.reservations OWNER TO teachtolearn;

--
-- Name: reviews; Type: TABLE; Schema: public; Owner: teachtolearn
--

CREATE TABLE public.reviews (
    reviewer character varying(16) NOT NULL,
    reviewee character varying(8) NOT NULL,
    rating integer NOT NULL,
    review character varying(1024) NOT NULL,
    "isBanned" boolean NOT NULL,
    id character varying(16) NOT NULL
);


ALTER TABLE public.reviews OWNER TO teachtolearn;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: teachtolearn
--

CREATE TABLE public.sessions (
    id character varying(16) NOT NULL,
    "userId" character varying(16) NOT NULL,
    "sessionToken" character varying(36) NOT NULL,
    platform character varying(64) NOT NULL,
    ip character varying(64) NOT NULL,
    "lastLoginTime" timestamp without time zone NOT NULL
);


ALTER TABLE public.sessions OWNER TO teachtolearn;

--
-- Name: users; Type: TABLE; Schema: public; Owner: teachtolearn
--

CREATE TABLE public.users (
    id character varying(16) NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(120) NOT NULL,
    "passwordHash" character varying(128),
    bio character varying(1024),
    fullname character varying(64) NOT NULL,
    "isActive" boolean NOT NULL,
    "isAdmin" boolean NOT NULL,
    "isBanned" boolean NOT NULL,
    "isDeleted" boolean NOT NULL
);


ALTER TABLE public.users OWNER TO teachtolearn;

--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: teachtolearn
--

COPY public.courses (abbreviation, name, icon, color, latitude, longitude, address, syllabus, "maxStudents", "enrolledStudents", "teacherId", "isBanned", "isDeleted") FROM stdin;
HHVR	Introduction to the HashiCorp Stack	bi-heart-half	gray	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	60	4	eWPDXgQ3	f	f
VSN5	Operating Systems and Systems Programming	bi-pentagon-half	cyan	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	160	4	eWPDXgQ3	f	f
7OPV	Introduction to Computer Graphics and Imaging	bi-file-x	yellow	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	90	4	eWPDXgQ3	f	f
B6H_	Logic, Automata, and Complexity	bi-bookmark-fill	pink	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	eWPDXgQ3	f	f
AAN0	Introduction to the HashiCorp Stack	bi-upload	stone	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	eWPDXgQ3	f	f
DGZP	Logic, Automata, and Complexity	bi-chevron-compact-left	blue	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	60	4	eWPDXgQ3	f	f
2D7D	Operating Systems and Systems Programming	bi-bag-plus	teal	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	SYjiwdB1	f	f
WBGK	Artificial Intelligence: Principles and Techniques	bi-cloud-upload-fill	pink	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	160	4	SYjiwdB1	f	f
JUKM	Operating Systems and Systems Programming	bi-cloud-download-fill	lime	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	50	4	PgcTBcqM	f	f
ZF_F	Introduction to the HashiCorp Stack	bi-usb-mini	stone	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	160	4	SYjiwdB1	f	f
8NKB	Logic, Automata, and Complexity	bi-usb-c	green	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	20	4	SYjiwdB1	f	f
5KPF	Introduction to Computer Graphics and Imaging	bi-cloud-rain	pink	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	50	4	PgcTBcqM	f	f
L3BV	Artificial Intelligence: Principles and Techniques	bi-journal-bookmark	slate	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	40	4	PgcTBcqM	f	f
SC2M	Operating Systems and Systems Programming	bi-thunderbolt-fill	emerald	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	60	4	PgcTBcqM	f	f
IPTS	Artificial Intelligence: Principles and Techniques	bi-skip-backward-fill	orange	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	10	4	PgcTBcqM	f	f
W6LU	Operating Systems and Systems Programming	bi-optical-audio-fill	red	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	90	4	PgcTBcqM	f	f
-IIG	Introduction to Computer Graphics and Imaging	bi-reception-1	sky	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	160	4	PgcTBcqM	f	f
OHVR	Logic, Automata, and Complexity	bi-dice-4-fill	neutral	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	PgcTBcqM	f	f
42CA	Artificial Intelligence: Principles and Techniques	bi-bookmark-plus-fill	green	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	90	4	PgcTBcqM	f	f
O_MJ	Introduction to the HashiCorp Stack	bi-ticket-detailed-fill	purple	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	90	4	eWPDXgQ3	f	f
GCTL	Introduction to the HashiCorp Stack	bi-envelope-exclamation	blue	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	20	4	eWPDXgQ3	f	f
JOQA	Logic, Automata, and Complexity	bi-router-fill	stone	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	40	4	eWPDXgQ3	f	f
Q7-F	Logic, Automata, and Complexity	bi-filter-circle-fill	teal	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	60	4	SYjiwdB1	f	f
7RFE	Logic, Automata, and Complexity	bi-file-earmark-medical	green	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	90	4	SYjiwdB1	f	f
HK-F	Operating Systems and Systems Programming	bi-lamp	lime	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	20	4	s7MN51Nd	f	f
JRSW	Logic, Automata, and Complexity	bi-wifi-off	teal	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	400	4	wSWBg3yl	f	f
R7PP	Introduction to Computer Graphics and Imaging	bi-cloud-fog2	gray	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	s7MN51Nd	f	f
FCQT	Artificial Intelligence: Principles and Techniques	bi-pause-circle	yellow	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	s7MN51Nd	f	f
FP8D	Operating Systems and Systems Programming	bi-menu-button-wide-fill	orange	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	40	4	s7MN51Nd	f	f
VDZD	Introduction to the HashiCorp Stack	bi-chevron-bar-right	gray	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	40	4	s7MN51Nd	f	f
YUT6	Operating Systems and Systems Programming	bi-exclamation-diamond	green	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	60	4	s7MN51Nd	f	f
IM6R	Logic, Automata, and Complexity	bi-badge-ar-fill	gray	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	60	4	s7MN51Nd	f	f
E7FV	Introduction to the HashiCorp Stack	bi-whatsapp	lime	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	20	4	s7MN51Nd	f	f
RWNJ	Operating Systems and Systems Programming	bi-emoji-dizzy-fill	fuchsia	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	50	4	wSWBg3yl	f	f
MBNX	Artificial Intelligence: Principles and Techniques	bi-hand-thumbs-down-fill	gray	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	40	4	wSWBg3yl	f	f
C1H7	Artificial Intelligence: Principles and Techniques	bi-calendar-event-fill	emerald	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	160	4	wSWBg3yl	f	f
PHDR	Introduction to Computer Graphics and Imaging	bi-pause-btn-fill	amber	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	40	4	wSWBg3yl	f	f
NTQM	Operating Systems and Systems Programming	bi-stop-circle-fill	orange	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	10	4	wSWBg3yl	f	f
VXAT	Operating Systems and Systems Programming	bi-cloud-check-fill	gray	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	400	4	wSWBg3yl	f	f
IYSI	Operating Systems and Systems Programming	bi-truck	gray	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	wSWBg3yl	f	f
IROR	Artificial Intelligence: Principles and Techniques	bi-cloud-plus-fill	violet	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	50	4	wSWBg3yl	f	f
E5ME	Logic, Automata, and Complexity	bi-cloud	violet	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	60	4	wSWBg3yl	f	f
ZLFR	Logic, Automata, and Complexity	bi-reception-3	orange	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	160	4	SYjiwdB1	f	f
GVSE	Logic, Automata, and Complexity	bi-person	indigo	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	SYjiwdB1	f	f
J89G	Artificial Intelligence: Principles and Techniques	bi-eraser	blue	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	s7MN51Nd	f	f
FLVU	Operating Systems and Systems Programming	bi-shield-slash-fill	yellow	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	50	4	SYjiwdB1	f	f
F3Y9	Logic, Automata, and Complexity	bi-file-earmark-music	orange	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	10	4	PgcTBcqM	f	f
GO9A	Introduction to Computer Graphics and Imaging	bi-ui-checks-grid	indigo	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	400	4	eWPDXgQ3	f	f
DFP1	Introduction to the HashiCorp Stack	bi-octagon-half	violet	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	100	4	SYjiwdB1	f	f
1RRV	Artificial Intelligence: Principles and Techniques	bi-arrow-down-square-fill	orange	44.4014427672185	8.96940579031976	Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	40	4	s7MN51Nd	f	f
\.


--
-- Data for Name: lectures; Type: TABLE DATA; Schema: public; Owner: teachtolearn
--

COPY public.lectures (index, "courseAbbreviation", summary, date, start, "end", "isBanned", id) FROM stdin;
1	5KPF	5KPF - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	v9ejjMve
2	5KPF	5KPF - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	Rt3VEaMz
3	5KPF	5KPF - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	DiDjuppj
4	5KPF	5KPF - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	IbLEYWvY
5	5KPF	5KPF - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	lW7DeWnx
6	5KPF	5KPF - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	FAz-poVc
7	5KPF	5KPF - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	mT_kStW2
8	5KPF	5KPF - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	DsDezj48
9	5KPF	5KPF - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	fSf-kjFK
10	5KPF	5KPF - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	r7HkjAD1
11	5KPF	5KPF - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	VW4K5Mez
12	5KPF	5KPF - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	IrcJ_wP1
13	5KPF	5KPF - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	2-A2EvlK
14	5KPF	5KPF - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	6R8vnEGs
1	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	iBtNjTUO
2	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	CzB1U3Ak
3	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	un5y12hK
4	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	64x_qrTH
5	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	KqUyL9Fz
6	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	urqcCqdh
7	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	l2VVYq_9
8	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	z6PDV3p1
9	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	QZMWjroU
10	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	wZMERcz-
11	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	c6E0-AAs
12	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	dXIs01Y2
13	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	n71PZKhn
14	F3Y9	F3y9 - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	_2VrLeYo
1	JUKM	jUkm - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	XEas2_CE
2	JUKM	jUkm - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	po2qUVn1
3	JUKM	jUkm - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	ISlN-RtS
4	JUKM	jUkm - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	0Z75rpCN
5	JUKM	jUkm - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	HoDi_VRm
6	JUKM	jUkm - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	YpKZcyxH
7	JUKM	jUkm - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	b1woUWY7
8	JUKM	jUkm - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	2zBIqScN
9	JUKM	jUkm - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	YhjrWmcv
10	JUKM	jUkm - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	6EIVdK-v
11	JUKM	jUkm - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	cjBLQV36
12	JUKM	jUkm - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	iWc4I74g
13	JUKM	jUkm - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	6V4Eg3R0
14	JUKM	jUkm - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	DtdUL0Qp
1	L3BV	l3BV - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	PAHIx4NL
2	L3BV	l3BV - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	xDLcJaeo
3	L3BV	l3BV - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	Cvx2HXck
4	L3BV	l3BV - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	UNLYXSWw
5	L3BV	l3BV - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	Ll_eKJTx
6	L3BV	l3BV - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	TrbTFi7Q
7	L3BV	l3BV - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	RJmHVNnc
8	L3BV	l3BV - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	AULoCzNQ
9	L3BV	l3BV - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	mKLF99jA
10	L3BV	l3BV - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	HZS1NW4u
11	L3BV	l3BV - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	XKuSPvG3
12	L3BV	l3BV - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	piQB0i5O
13	L3BV	l3BV - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	Jknd1PQY
14	L3BV	l3BV - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	ZHcT5fPh
1	SC2M	SC2m - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	Z1E7jha3
2	SC2M	SC2m - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	l1QAjzbz
3	SC2M	SC2m - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	Wo4-VCij
4	SC2M	SC2m - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	wtaE_VAT
5	SC2M	SC2m - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	Bt6Mb9-8
6	SC2M	SC2m - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	2fFwlmru
7	SC2M	SC2m - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	ksU4JaTK
8	SC2M	SC2m - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	uTsTfVs-
9	SC2M	SC2m - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	WneAVKUA
10	SC2M	SC2m - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	iDYBr8Oi
11	SC2M	SC2m - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	Svb23I5v
12	SC2M	SC2m - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	Z87XuOJg
13	SC2M	SC2m - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	wZetZ8BP
14	SC2M	SC2m - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	fxAFhyov
1	IPTS	iPTs - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	_lnNUrpo
2	IPTS	iPTs - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	TWmc4vKf
3	IPTS	iPTs - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	igf_Ze7h
4	IPTS	iPTs - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	1Xh7MSqH
5	IPTS	iPTs - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	JceSbsAc
6	IPTS	iPTs - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	jyDN3u-F
7	IPTS	iPTs - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	cHwgM4j0
8	IPTS	iPTs - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	-5P0ADKJ
9	IPTS	iPTs - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	Ah1B2i0F
10	IPTS	iPTs - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	2KUEoEAc
11	IPTS	iPTs - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	3MwrCHqj
12	IPTS	iPTs - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	2qUrifsK
13	IPTS	iPTs - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	P89snOuz
14	IPTS	iPTs - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	wohlLuG_
1	W6LU	W6LU - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	l905YusQ
2	W6LU	W6LU - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	QODttlqn
3	W6LU	W6LU - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	pTJxU4Rk
4	W6LU	W6LU - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	8G9U6iez
5	W6LU	W6LU - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	AvI0UFf5
6	W6LU	W6LU - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	94ffWPtV
7	W6LU	W6LU - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	mMDzBwZ-
8	W6LU	W6LU - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	n34peEhF
9	W6LU	W6LU - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	2JVEOXG7
10	W6LU	W6LU - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	MJ7a4NtK
11	W6LU	W6LU - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	het7b6jA
12	W6LU	W6LU - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	Vk_e608v
13	W6LU	W6LU - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	D-nSnPVt
14	W6LU	W6LU - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	5VQ6_TCj
1	-IIG	-Iig - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	hx3QuRbN
2	-IIG	-Iig - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	gwth8IrV
3	-IIG	-Iig - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	s93dfeyS
4	-IIG	-Iig - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	7mWQF-au
5	-IIG	-Iig - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	XIIL2lBD
6	-IIG	-Iig - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	71-BJs9Z
7	-IIG	-Iig - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	fpGtCoMw
8	-IIG	-Iig - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	JbBL3ix9
9	-IIG	-Iig - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	wsLDBlzL
10	-IIG	-Iig - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	ndwm7aja
11	-IIG	-Iig - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	r7q5PRcV
12	-IIG	-Iig - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	016uwLGa
13	-IIG	-Iig - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	dIuPj4ev
14	-IIG	-Iig - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	ZMHb5vMV
1	OHVR	OhvR - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	M3JZg0vb
2	OHVR	OhvR - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	O_c74Isz
3	OHVR	OhvR - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	m_3Gp68V
4	OHVR	OhvR - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	C_v0q4iZ
5	OHVR	OhvR - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	fZtr8wtb
6	OHVR	OhvR - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	X-MX2u9y
7	OHVR	OhvR - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	XBGKu5RG
8	OHVR	OhvR - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	TDjjuVHb
9	OHVR	OhvR - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	a7q07QI8
10	OHVR	OhvR - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	ekCsmmWd
11	OHVR	OhvR - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	QltOkN2F
12	OHVR	OhvR - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	5wA_CubM
13	OHVR	OhvR - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	kD_MmMri
14	OHVR	OhvR - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	Q_twMLqK
1	42CA	42Ca - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	jclZjNZI
2	42CA	42Ca - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	aPi0ODSM
3	42CA	42Ca - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	xYFhMvRO
4	42CA	42Ca - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	QUsv2J-t
5	42CA	42Ca - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	QtUCaM2j
6	42CA	42Ca - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	FQ3zRcPL
7	42CA	42Ca - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	HzC7bb3u
8	42CA	42Ca - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	e54gPQOf
9	42CA	42Ca - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	YeJ1XvNp
10	42CA	42Ca - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	-TekVnnB
11	42CA	42Ca - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	OZDmt6b1
12	42CA	42Ca - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	JEj7nXQR
13	42CA	42Ca - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	iDkIe6c_
14	42CA	42Ca - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	i-1dQrhO
1	GO9A	Go9a - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	lzOlrk05
2	GO9A	Go9a - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	KAUlxS6J
3	GO9A	Go9a - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	7qek2fRw
4	GO9A	Go9a - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	_kH-R8Z2
5	GO9A	Go9a - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	Avd70MgP
6	GO9A	Go9a - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	dyuAKyzH
7	GO9A	Go9a - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	KqgFXN4Q
8	GO9A	Go9a - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	efsrbT2I
9	GO9A	Go9a - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	YJMooBNp
10	GO9A	Go9a - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	rBm8plGB
11	GO9A	Go9a - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	XNPBcODH
12	GO9A	Go9a - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	H0tZLX7h
13	GO9A	Go9a - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	gBf8ZUyj
14	GO9A	Go9a - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	Z0yIGeNw
1	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	ynCmagf9
2	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	G9q5thrj
3	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	2eGx0J4V
4	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	7wuAc3BC
5	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	5IW1nl6u
6	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	9zsm126B
7	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	O0_3SG_b
8	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	RGkT7zAO
9	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	kHkJZRS2
10	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	gcen-vsr
11	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	zfXvjLdN
12	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	IrBXrQ_l
13	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	ZRovWEL8
14	O_MJ	o_Mj - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	kroNemSW
1	GCTL	GCTl - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	MXwbK5zS
2	GCTL	GCTl - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	-TYwEdhz
3	GCTL	GCTl - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	IAelNFJL
4	GCTL	GCTl - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	Fz5BfZ6r
5	GCTL	GCTl - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	sDgbGnlX
6	GCTL	GCTl - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	XzplUBMg
7	GCTL	GCTl - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	y3HOC4Nx
8	GCTL	GCTl - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	5MfNfIrP
9	GCTL	GCTl - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	rxVvr0hi
10	GCTL	GCTl - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	vjLc9_IO
11	GCTL	GCTl - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	jmgTeGPn
12	GCTL	GCTl - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	CDK90Dn6
13	GCTL	GCTl - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	thzDwQQf
14	GCTL	GCTl - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	onzeOB21
1	JOQA	joQA - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	1CTs7Qqs
2	JOQA	joQA - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	s36onsPd
3	JOQA	joQA - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	Uzl77jJW
4	JOQA	joQA - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	uyZsor-I
5	JOQA	joQA - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	nEna239U
6	JOQA	joQA - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	zqRDCGej
7	JOQA	joQA - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	0b7CGd5-
8	JOQA	joQA - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	PL28V3NW
9	JOQA	joQA - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	h2kLD7Ic
10	JOQA	joQA - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	ZyknuYJ1
11	JOQA	joQA - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	BU_FLfxv
12	JOQA	joQA - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	qsXes9TW
13	JOQA	joQA - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	S1AFkyRy
14	JOQA	joQA - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	2stk9mPz
1	HHVR	HhvR - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	ziFA_maS
2	HHVR	HhvR - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	OFiIulEN
3	HHVR	HhvR - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	BH1omTIG
4	HHVR	HhvR - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	ZXsvsU4o
5	HHVR	HhvR - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	OVvv8hWu
6	HHVR	HhvR - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	UWDJn6dL
7	HHVR	HhvR - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	v9VOuYuA
8	HHVR	HhvR - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	8CE3gaWX
9	HHVR	HhvR - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	AOdDTPXz
10	HHVR	HhvR - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	Ef0rE-b8
11	HHVR	HhvR - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	kXL-1_YV
12	HHVR	HhvR - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	pRA5kGbR
13	HHVR	HhvR - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	Lf3O5SDs
14	HHVR	HhvR - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	bfGob-mL
1	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	0tkPONGA
2	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	oowBBrx5
3	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	xVUwf4bT
4	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	DP2ve1JD
5	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	2gGH4B4U
6	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	epgvtLT7
7	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	V7JbrWxT
8	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	Ip-lOD67
9	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	9rZBvGiV
10	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	eqiqqIoH
11	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	_yBd23jZ
12	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	qgDZAUwa
13	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	-lm4SdR6
14	VSN5	vSn5 - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	KbI6cxFB
1	7OPV	7opv - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	r4H0eQaK
2	7OPV	7opv - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	tYEckyrN
3	7OPV	7opv - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	gIuG_LI2
4	7OPV	7opv - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	IpOlVvCr
5	7OPV	7opv - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	ZTN51ZFZ
6	7OPV	7opv - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	NAFURsIz
7	7OPV	7opv - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	CWIFfS9r
8	7OPV	7opv - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	bgTtXDLF
9	7OPV	7opv - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	U1CIZXsr
10	7OPV	7opv - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	KczVtGha
11	7OPV	7opv - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	v4lO91r6
12	7OPV	7opv - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	zAXTnWNx
13	7OPV	7opv - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	56T6OZBj
14	7OPV	7opv - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	FmZq4-m2
1	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	cpBWUwPQ
2	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	N58q-jnV
3	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	quCkV-xO
4	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	7YxKjCvx
5	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	DYYzsS2W
6	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	wBSAMjut
7	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	RLaySvp9
8	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	ujzwDJ4f
9	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	YK6SlrtY
10	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	RSjNYv9q
11	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	XorjquJp
12	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	QXgj8AJj
13	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	f2zYIaec
14	B6H_	B6h_ - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	avUflwAv
1	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	yN_gV8LF
2	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	vff_fcUY
3	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	-sDgwAMr
4	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	mMek-2CS
5	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	nMR_Rnhx
6	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	d0NBnP_0
7	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	tgKkGmNm
8	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	dETs5gPE
9	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	Lx_gJZUT
10	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	-2ntnlUg
11	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	b2WsY0sT
12	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	sZddvdUI
13	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	lK0YqjtV
14	AAN0	aAN0 - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	aRO8uWuZ
1	DGZP	DGzp - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	17SYhEn8
2	DGZP	DGzp - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	P-Wwvjyg
3	DGZP	DGzp - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	fGMs7mkM
4	DGZP	DGzp - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	F-VcZl8b
5	DGZP	DGzp - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	YYydkhIS
6	DGZP	DGzp - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	OcT91ShO
7	DGZP	DGzp - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	LbEykyai
8	DGZP	DGzp - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	IMdPAjlJ
9	DGZP	DGzp - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	7Lm9hQIZ
10	DGZP	DGzp - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	kr2N3I4E
11	DGZP	DGzp - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	JQGO7eSc
12	DGZP	DGzp - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	xPIUw80g
13	DGZP	DGzp - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	HcUXsIV8
14	DGZP	DGzp - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	H2tDOgA9
1	2D7D	2D7d - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	4WtUBob5
2	2D7D	2D7d - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	bK6nYQ8Q
3	2D7D	2D7d - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	wObBXEfu
4	2D7D	2D7d - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	Zc607QZa
5	2D7D	2D7d - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	gabel4D3
6	2D7D	2D7d - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	R-RhmIf1
7	2D7D	2D7d - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	Q9A2loaG
8	2D7D	2D7d - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	_gEaBki1
9	2D7D	2D7d - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	Ys-6KgtZ
10	2D7D	2D7d - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	TEHEfl31
11	2D7D	2D7d - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	3IMZ0N5c
12	2D7D	2D7d - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	Dgvp7kL0
13	2D7D	2D7d - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	ISyVHSIB
14	2D7D	2D7d - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	_Lu5kNOj
1	WBGK	wbgK - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	wrs_UUoz
2	WBGK	wbgK - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	ijIMEbRG
3	WBGK	wbgK - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	FDZU0mHS
4	WBGK	wbgK - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	pPFE1C5i
5	WBGK	wbgK - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	VT3feOHj
6	WBGK	wbgK - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	p-MtqMRg
7	WBGK	wbgK - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	QE5kZky-
8	WBGK	wbgK - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	BnKNmaQK
9	WBGK	wbgK - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	sFh_aeK2
10	WBGK	wbgK - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	GktFeOTF
11	WBGK	wbgK - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	H3ZZDpIF
12	WBGK	wbgK - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	uQ5fnqXs
13	WBGK	wbgK - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	e1FtSVaW
14	WBGK	wbgK - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	w8g7wVws
1	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	znwtg8O4
2	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	glf_8Kn8
3	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	6zSZt4WZ
4	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	ndZpNV9-
5	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	947me0C8
6	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	VF_NmwiK
7	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	wrGnB02W
8	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	c7fsEOgk
9	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	isy1W_Mt
10	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	t21wnk3u
11	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	wjgXiVHy
12	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	AZNd1HMK
13	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	UN1QmQis
14	Q7-F	q7-f - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	Zg6fYR-e
1	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	e_CP-ZqN
2	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	Yun4UppL
3	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	kxRN1M40
4	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	tHeCv2Yw
5	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	YBsFAhiW
6	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	u5jikvet
7	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	nTszyqIZ
8	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	2tsvv2l-
9	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	BRQHFa61
10	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	pTBBn7Ok
11	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	sGJFm7M3
12	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	jOdIso6L
13	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	4zHkj5-l
14	ZF_F	zF_F - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	r6GkW4-W
1	8NKB	8nKb - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	rm7d5zWe
2	8NKB	8nKb - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	emIPsFQo
3	8NKB	8nKb - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	8aWQoXfU
4	8NKB	8nKb - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	8PCcOAeP
5	8NKB	8nKb - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	_R7AHA5i
6	8NKB	8nKb - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	I73TQJ3f
7	8NKB	8nKb - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	kaEHFGR-
8	8NKB	8nKb - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	YGBv-e1N
9	8NKB	8nKb - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	fu7q49ez
10	8NKB	8nKb - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	Jtk8itsB
11	8NKB	8nKb - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	p0Za9UNe
12	8NKB	8nKb - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	2VP0YEDh
13	8NKB	8nKb - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	dxrb9sl5
14	8NKB	8nKb - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	h-u68ati
1	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	thkJ1txp
2	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	PWwsM6W8
3	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	Hv2ifIqZ
4	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	8ZMMLQuD
5	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	rQ8oX09V
6	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	RTsluL49
7	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	_fTmgM95
8	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	l61eFGCM
9	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	G8TJ--EA
10	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	5915xmpa
11	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	Fylohvf2
12	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	Y1m42Yhx
13	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	GskuUDpi
14	DFP1	DFp1 - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	1ApiGcRT
1	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	ICxzr7RA
2	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	MXY_jJOo
3	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	WYJ0GrhC
4	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	KVqnsRKB
5	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	x9EOijmf
6	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	ReOIgYRU
7	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	lO31QhmI
8	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	_K_VsxlJ
9	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	-_ymHqPY
10	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	57p9rmyw
11	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	hz4gKvFd
12	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	MnEvyCOs
13	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	r_UR7jSy
14	ZLFR	ZLFr - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	R8AZpdjl
1	GVSE	GvSe - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	ED-1l271
2	GVSE	GvSe - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	oIZTbFuJ
3	GVSE	GvSe - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	OBm3mGSS
4	GVSE	GvSe - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	wniR_unM
5	GVSE	GvSe - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	7M3P4U1E
6	GVSE	GvSe - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	eU4AKQXW
7	GVSE	GvSe - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	FlmaET0L
8	GVSE	GvSe - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	A-09EgDy
9	GVSE	GvSe - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	SorhsBdl
10	GVSE	GvSe - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	zyqPqrQh
11	GVSE	GvSe - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	Tn6xzuHF
12	GVSE	GvSe - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	RFquPs2m
13	GVSE	GvSe - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	AWQzlGOJ
14	GVSE	GvSe - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	DPNwfkru
1	FLVU	flVU - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	_uP_q38g
2	FLVU	flVU - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	2MyHMoy2
3	FLVU	flVU - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	bAaFl9jF
4	FLVU	flVU - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	IypoM0HV
5	FLVU	flVU - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	aT4_M9iq
6	FLVU	flVU - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	_yJsxTEs
7	FLVU	flVU - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	XlKz3xRM
8	FLVU	flVU - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	55L7jza1
9	FLVU	flVU - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	abWXITsz
10	FLVU	flVU - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	LNlphvO3
11	FLVU	flVU - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	q3J-dcIO
12	FLVU	flVU - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	aMgy2WOO
13	FLVU	flVU - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	i0hmjSE6
14	FLVU	flVU - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	EFjQXGUu
1	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	NFlXWMzw
2	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	Kyhcvez6
3	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	D_FaFW0Z
4	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	r5BSUUuS
5	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	6_SK1gmo
6	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	YQQqwYdP
7	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	54EMD1iI
8	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	eHysCR-e
9	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	yTc9TPwJ
10	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	IOmgft6i
11	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	yxrR91Lj
12	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	ZIfQZgHp
13	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	cWfbLxnK
14	7RFE	7Rfe - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	CDRLksT6
1	HK-F	hK-f - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	BmKaSDnF
2	HK-F	hK-f - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	dbcj0R28
3	HK-F	hK-f - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	EeLx0eGi
4	HK-F	hK-f - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	hERwg7Hh
5	HK-F	hK-f - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	n22mxppa
6	HK-F	hK-f - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	E0m3Etov
7	HK-F	hK-f - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	JczTfdev
8	HK-F	hK-f - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	-tesyyzK
9	HK-F	hK-f - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	6AUcwAVm
10	HK-F	hK-f - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	DH-5LJ-X
11	HK-F	hK-f - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	9Upvx-YF
12	HK-F	hK-f - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	EI2um7aU
13	HK-F	hK-f - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	R3D1pUBZ
14	HK-F	hK-f - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	uYhpP_8V
1	J89G	j89g - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	YGbv7OcN
2	J89G	j89g - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	_gfGAOEt
3	J89G	j89g - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	R4G_yyzn
4	J89G	j89g - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	BgpVvd_o
5	J89G	j89g - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	LMx6u6ld
6	J89G	j89g - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	EiVKD3yc
7	J89G	j89g - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	DY8XAAGc
8	J89G	j89g - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	NINPSzWw
9	J89G	j89g - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	0VQz3zP6
10	J89G	j89g - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	DIXrX-Ty
11	J89G	j89g - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	3YM49MKE
12	J89G	j89g - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	FjxvRh_a
13	J89G	j89g - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	85yzCUbT
14	J89G	j89g - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	bcJ4Dgli
1	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	1u-N5Q6z
2	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	6bQAUB4-
3	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	WLOsOkNr
4	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	MrrNWf5t
5	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	lStSQYy2
6	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	BW7KsnG7
7	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	9Ub87tG9
8	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	FY8sQ8rW
9	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	xqeK9err
10	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	uk6t91AS
11	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	xuQygV4d
12	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	KZ_80XtF
13	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	_1WUDYOW
14	R7PP	R7Pp - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	rWPPJ2ul
1	1RRV	1RRv - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	Y18duA2Y
2	1RRV	1RRv - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	KnCP2puu
3	1RRV	1RRv - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	jshw0LSg
4	1RRV	1RRv - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	D-lLLZcO
5	1RRV	1RRv - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	CiPNlXxT
6	1RRV	1RRv - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	OcVq-iJQ
7	1RRV	1RRv - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	hZBApLgI
8	1RRV	1RRv - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	L2mlExXn
9	1RRV	1RRv - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	n6xl2SoR
10	1RRV	1RRv - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	DikFyl5o
11	1RRV	1RRv - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	OMZbBHYF
12	1RRV	1RRv - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	6jwK64eZ
13	1RRV	1RRv - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	sNkuEVga
14	1RRV	1RRv - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	ZIdc5Gob
1	FCQT	FcQT - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	OLBzs0dC
2	FCQT	FcQT - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	MvJsjWXo
3	FCQT	FcQT - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	BMvTligy
4	FCQT	FcQT - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	jJhRB_tR
5	FCQT	FcQT - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	phPD0m5x
6	FCQT	FcQT - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	MQioyqZg
7	FCQT	FcQT - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	WUh50kIC
8	FCQT	FcQT - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	leGIqmXR
9	FCQT	FcQT - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	FoH__7Bt
10	FCQT	FcQT - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	BiF2h0hP
11	FCQT	FcQT - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	uZULEeLU
12	FCQT	FcQT - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	l_nO1i0b
13	FCQT	FcQT - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	2NyhjIge
14	FCQT	FcQT - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	aRIF4DrO
1	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	4-7nKGn-
2	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	YWQxkmm_
3	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	RRyVMCGV
4	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	UNmhSid2
5	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	qOnodrPI
6	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	mKjhTJlw
7	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	EUOybfHX
8	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	PKL8lCvL
9	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	sgWXgYw1
10	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	l5_jj4_m
11	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	qQwYC86z
12	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	wJuHjhKr
13	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	AzOIzRuX
14	FP8D	Fp8d - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	mTZZJv0u
1	VDZD	vdzD - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	Jy3dbr4V
2	VDZD	vdzD - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	Gesz8kof
3	VDZD	vdzD - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	P5KLFmb_
4	VDZD	vdzD - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	BXb3GnWq
5	VDZD	vdzD - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	x3Q5RydV
6	VDZD	vdzD - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	ARVmKVBu
7	VDZD	vdzD - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	TutxUUnB
8	VDZD	vdzD - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	Q1tcdUhh
9	VDZD	vdzD - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	nKoJYbyp
10	VDZD	vdzD - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	RMYwufuc
11	VDZD	vdzD - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	KiB4_jbo
12	VDZD	vdzD - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	xj1_aBWf
13	VDZD	vdzD - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	tQ9yXkpn
14	VDZD	vdzD - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	Z_p24jBo
1	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	rkTHcgD_
2	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	bbydH6OQ
3	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	wmTODK3a
4	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	_G1VfBmD
5	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	iqaO80oB
6	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	BtvgDIoG
7	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	MSHuSRih
8	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	47-zPsc_
9	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	cFu1681i
10	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	HylLuM6R
11	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	7lLtVbFQ
12	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	cSr0nP8C
13	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	v7YRtvBO
14	YUT6	yuT6 - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	Dj6-6e-s
1	IM6R	Im6R - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	-n7hN9XV
2	IM6R	Im6R - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	suGmlbmv
3	IM6R	Im6R - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	8LGv2-7z
4	IM6R	Im6R - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	06gGNr_L
5	IM6R	Im6R - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	CETWprpP
6	IM6R	Im6R - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	syDyMl9j
7	IM6R	Im6R - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	FngDr_ae
8	IM6R	Im6R - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	ZAiQbANY
9	IM6R	Im6R - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	uMtZ-3nG
10	IM6R	Im6R - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	W45mBdu3
11	IM6R	Im6R - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	x7PSFEqz
12	IM6R	Im6R - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	GFTrDFBp
13	IM6R	Im6R - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	nZtn3w0Y
14	IM6R	Im6R - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	dCSYccmu
1	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	ke0zjceg
2	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	YzOM2BT5
3	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	YSueRBbo
4	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	D2wjZFQ5
5	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	vCnEFLXP
6	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	XDjc6ZQ5
7	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	woUD0duY
8	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	ibd8yq3z
9	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	cQtWOWYY
10	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	sloEuMmE
11	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	4qziMvFt
12	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	kY40_aS0
13	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	YK2rVa3Z
14	E7FV	e7Fv - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	Y16TFv3u
1	JRSW	JrsW - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	M3kZVoBk
2	JRSW	JrsW - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	cJRYWzcj
3	JRSW	JrsW - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	qrh4LVqS
4	JRSW	JrsW - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	H6_3v1g7
5	JRSW	JrsW - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	GPZbjOGc
6	JRSW	JrsW - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	hv0Nc3Gl
7	JRSW	JrsW - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	KsjEzZ7M
8	JRSW	JrsW - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	Y_K3UGlp
9	JRSW	JrsW - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	aaTAtv2w
10	JRSW	JrsW - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	Yf0Rga9x
11	JRSW	JrsW - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	_bpOx_58
12	JRSW	JrsW - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	eyzim6bb
13	JRSW	JrsW - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	Y2eQMuRR
14	JRSW	JrsW - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	7ekYgvUS
1	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	B7f1ut8g
2	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	3MkXhygf
3	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	jzC0bTqG
4	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	xi77LCvl
5	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	V8AjuyJJ
6	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	nVf4dtB_
7	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	dKOPde7v
8	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	4dxFRZJT
9	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	QaKerwm3
10	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	0-C6Tj4O
11	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	0y9r6cuW
12	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	4eyuPO2b
13	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	I-bxOEoB
14	RWNJ	rwnJ - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	KDiBgELY
1	MBNX	MbnX - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	zWT8hO1g
2	MBNX	MbnX - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	wEAvIVXC
3	MBNX	MbnX - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	0m47ln7r
4	MBNX	MbnX - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	YrNh0_aw
5	MBNX	MbnX - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	xmOJHeyy
6	MBNX	MbnX - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	pc9KyUzc
7	MBNX	MbnX - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	t5i-WzEV
8	MBNX	MbnX - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	Qxx7Rt55
9	MBNX	MbnX - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	QsBUcgFG
10	MBNX	MbnX - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	EATjMbEy
11	MBNX	MbnX - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	eNs7Fl52
12	MBNX	MbnX - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	dfqO4cOR
13	MBNX	MbnX - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	ogJTWtdZ
14	MBNX	MbnX - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	f2Duhxj9
1	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	8kYX9ci6
2	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	fd_Y2UwT
3	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	y7OP-gQb
4	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	7ehJSQQL
5	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	hcpqwd2e
6	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	ToL-o0fe
7	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	6YSq38MY
8	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	M6iACPq_
9	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	2hNKGsxU
10	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	MxwdXZqO
11	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	AQH0lqkx
12	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	0OY3ywac
13	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	Oa4WGVPC
14	C1H7	c1H7 - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	ebtSv7sF
1	PHDR	phdr - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	nvBB4NFT
2	PHDR	phdr - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	ov70cPRA
3	PHDR	phdr - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	X8pqADEu
4	PHDR	phdr - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	eAbgo-n-
5	PHDR	phdr - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	rQ6-Eas0
6	PHDR	phdr - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	R7A4Danm
7	PHDR	phdr - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	WI-ajQjP
8	PHDR	phdr - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	iGEQHD0X
9	PHDR	phdr - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	sCs45jD8
10	PHDR	phdr - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	x_TDEsGH
11	PHDR	phdr - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	J9dFXj5J
12	PHDR	phdr - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	I1YZ9f9A
13	PHDR	phdr - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	jJ0yjVnY
14	PHDR	phdr - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	hZ3SkRYR
1	NTQM	nTQm - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	y1mqQLFT
2	NTQM	nTQm - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	eyuD6Mn6
3	NTQM	nTQm - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	wb-b1PXx
4	NTQM	nTQm - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	Kz1WMzVQ
5	NTQM	nTQm - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	Dc6Y_-Xm
6	NTQM	nTQm - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	WPmlkvnc
7	NTQM	nTQm - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	exh3AxhI
8	NTQM	nTQm - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	UZAxcdZ4
9	NTQM	nTQm - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	o1NUl1HW
10	NTQM	nTQm - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	KV_Kf--_
11	NTQM	nTQm - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	tMl_TFN8
12	NTQM	nTQm - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	Yp6LYubt
13	NTQM	nTQm - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	QC5dC_Oh
14	NTQM	nTQm - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	P2-RIDjD
1	VXAT	vxAt - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	P1xhun6N
2	VXAT	vxAt - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	-ht81t9z
3	VXAT	vxAt - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	tCQXT1r8
4	VXAT	vxAt - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	XGDU7eRx
5	VXAT	vxAt - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	37KQucpJ
6	VXAT	vxAt - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	zqa1YVG0
7	VXAT	vxAt - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	O9zAscRj
8	VXAT	vxAt - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	VxReZdY3
9	VXAT	vxAt - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	QaYn0RZ8
10	VXAT	vxAt - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	HUGxslxJ
11	VXAT	vxAt - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	wQwDq-6P
12	VXAT	vxAt - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	4RWrIV_1
13	VXAT	vxAt - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	mD7VyUlO
14	VXAT	vxAt - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	Ap2KvVs5
1	IYSI	iYSI - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	9f2VoYvz
2	IYSI	iYSI - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	j-bPzuSE
3	IYSI	iYSI - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	xol-YAdf
4	IYSI	iYSI - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	zl2rS6Ml
5	IYSI	iYSI - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	vcmUMb9n
6	IYSI	iYSI - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	CVdbxdCR
7	IYSI	iYSI - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	aacZOaHn
8	IYSI	iYSI - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	Fy-h2UM3
9	IYSI	iYSI - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	UvqzkbrD
10	IYSI	iYSI - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	qCoSYfZN
11	IYSI	iYSI - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	ep1MZOtU
12	IYSI	iYSI - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	_59AwgZU
13	IYSI	iYSI - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	h2AoiIQ7
14	IYSI	iYSI - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	YIDZNdtV
1	IROR	IrOR - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	NHx8S6oO
2	IROR	IrOR - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	JwYMv4wT
3	IROR	IrOR - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	UdmsH161
4	IROR	IrOR - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	MzyEwACx
5	IROR	IrOR - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	cE2OEdGK
6	IROR	IrOR - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	bgBq9ZuH
7	IROR	IrOR - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	EpoVHlmg
8	IROR	IrOR - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	-HY3aUUR
9	IROR	IrOR - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	eAVejrPy
10	IROR	IrOR - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	2Z9cLjWE
11	IROR	IrOR - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	Rv1-t-xm
12	IROR	IrOR - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	SFUHZAxn
13	IROR	IrOR - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	18OtYNi1
14	IROR	IrOR - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	YuyOhDe8
1	E5ME	E5ME - lorem ipsum dolor summary	2021-02-01	14:00:00	16:00:00	f	g9BSPRso
2	E5ME	E5ME - lorem ipsum dolor summary	2021-02-03	14:00:00	16:00:00	f	_liFPTKl
3	E5ME	E5ME - lorem ipsum dolor summary	2021-02-05	14:00:00	16:00:00	f	g3Ij3k2b
4	E5ME	E5ME - lorem ipsum dolor summary	2021-02-07	14:00:00	16:00:00	f	XZt3qW2M
5	E5ME	E5ME - lorem ipsum dolor summary	2021-02-09	14:00:00	16:00:00	f	XfV2wDS_
6	E5ME	E5ME - lorem ipsum dolor summary	2021-02-11	14:00:00	16:00:00	f	XZaIDt-b
7	E5ME	E5ME - lorem ipsum dolor summary	2021-02-13	14:00:00	16:00:00	f	Z_tib9W_
8	E5ME	E5ME - lorem ipsum dolor summary	2021-02-15	14:00:00	16:00:00	f	rQO9ks2Y
9	E5ME	E5ME - lorem ipsum dolor summary	2021-02-17	14:00:00	16:00:00	f	0G1uTevJ
10	E5ME	E5ME - lorem ipsum dolor summary	2021-02-19	14:00:00	16:00:00	f	sKnwacPp
11	E5ME	E5ME - lorem ipsum dolor summary	2021-02-21	14:00:00	16:00:00	f	oxa3nS6u
12	E5ME	E5ME - lorem ipsum dolor summary	2021-02-23	14:00:00	16:00:00	f	RuGw1xZv
13	E5ME	E5ME - lorem ipsum dolor summary	2021-02-27	14:00:00	16:00:00	f	usbplTBY
14	E5ME	E5ME - lorem ipsum dolor summary	2021-02-28	14:00:00	16:00:00	f	pQDKJa1O
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: teachtolearn
--

COPY public.reservations (id, "courseAbbreviation", "userId") FROM stdin;
wYSqEyc9	GO9A	PgcTBcqM
f0glaf0-	O_MJ	PgcTBcqM
Fi_sO8Pn	GCTL	PgcTBcqM
P7GtpKb9	JOQA	PgcTBcqM
4fxi7c8z	HHVR	PgcTBcqM
x8vW9cHY	VSN5	PgcTBcqM
D6QiJqFc	7OPV	PgcTBcqM
jfIY2Q5x	B6H_	PgcTBcqM
wjvf_KP4	AAN0	PgcTBcqM
9mtOGvAl	DGZP	PgcTBcqM
U206Pm5m	2D7D	PgcTBcqM
hZxJzoYv	WBGK	PgcTBcqM
63n-Dk32	Q7-F	PgcTBcqM
31io-gK7	ZF_F	PgcTBcqM
uHD4PEJy	8NKB	PgcTBcqM
TNUXfqF9	DFP1	PgcTBcqM
f46bpY91	ZLFR	PgcTBcqM
sRsePit0	GVSE	PgcTBcqM
QshxCveX	FLVU	PgcTBcqM
MbjCzYuT	7RFE	PgcTBcqM
UajI-goz	HK-F	PgcTBcqM
7AvzQBnB	J89G	PgcTBcqM
aolrmQeI	R7PP	PgcTBcqM
K4jrV3Vh	1RRV	PgcTBcqM
7MdZHIQQ	FCQT	PgcTBcqM
i3xTcbEZ	FP8D	PgcTBcqM
tdSk6GTm	VDZD	PgcTBcqM
cjDn4Ekb	YUT6	PgcTBcqM
K1UHx2Wf	IM6R	PgcTBcqM
WjC-sPWi	E7FV	PgcTBcqM
rBZj0_k8	JRSW	PgcTBcqM
EIPD_dIh	RWNJ	PgcTBcqM
lKMjHJup	MBNX	PgcTBcqM
mGsCUx_r	C1H7	PgcTBcqM
zJw0VU7Z	PHDR	PgcTBcqM
C_lnzsuV	NTQM	PgcTBcqM
8tJk33DL	VXAT	PgcTBcqM
7g4Kxfj6	IYSI	PgcTBcqM
vMVE2HlK	IROR	PgcTBcqM
DRMS7sYE	E5ME	PgcTBcqM
BK3S_osO	5KPF	eWPDXgQ3
efjKiRe2	F3Y9	eWPDXgQ3
UEA2np2H	JUKM	eWPDXgQ3
JQl06vF7	L3BV	eWPDXgQ3
hK9OkGzV	SC2M	eWPDXgQ3
XdiyPBC2	IPTS	eWPDXgQ3
TKsbJOTR	W6LU	eWPDXgQ3
982OLF67	-IIG	eWPDXgQ3
9nxUsVL7	OHVR	eWPDXgQ3
f2U3G7JE	42CA	eWPDXgQ3
HkBu0P_F	2D7D	eWPDXgQ3
1KrERKgc	WBGK	eWPDXgQ3
m-YzGgah	Q7-F	eWPDXgQ3
aXQTbBw-	ZF_F	eWPDXgQ3
UqLAnH22	8NKB	eWPDXgQ3
Nyz3v1Vs	DFP1	eWPDXgQ3
W1ijI__T	ZLFR	eWPDXgQ3
4860ZfrP	GVSE	eWPDXgQ3
q_KulDs7	FLVU	eWPDXgQ3
DrbswreN	7RFE	eWPDXgQ3
bhO9tsJP	HK-F	eWPDXgQ3
H9IWAo7Q	J89G	eWPDXgQ3
hMKzfouZ	R7PP	eWPDXgQ3
CSOkA-Ez	1RRV	eWPDXgQ3
deUb_g3k	FCQT	eWPDXgQ3
32mniZP7	FP8D	eWPDXgQ3
Xtbp5U0F	VDZD	eWPDXgQ3
QiEq0Cif	YUT6	eWPDXgQ3
rE0hkSz3	IM6R	eWPDXgQ3
cAZaDgVt	E7FV	eWPDXgQ3
vl6_p0Q-	JRSW	eWPDXgQ3
KywtjuF9	RWNJ	eWPDXgQ3
DB9bSxFy	MBNX	eWPDXgQ3
auwsMg7v	C1H7	eWPDXgQ3
suzew-Yp	PHDR	eWPDXgQ3
vZxFvAiE	NTQM	eWPDXgQ3
UnqkWR9c	VXAT	eWPDXgQ3
Ck6APChj	IYSI	eWPDXgQ3
Oe2BiOif	IROR	eWPDXgQ3
NkW2zNbC	E5ME	eWPDXgQ3
JniIt8hj	5KPF	SYjiwdB1
Ts7kzAdt	F3Y9	SYjiwdB1
dsGtYhiD	JUKM	SYjiwdB1
L7BHU-ug	L3BV	SYjiwdB1
Y54naKqA	SC2M	SYjiwdB1
O1_D1zsb	IPTS	SYjiwdB1
ofYWFNhU	W6LU	SYjiwdB1
8Yab_y0z	-IIG	SYjiwdB1
wGny__Rn	OHVR	SYjiwdB1
wvmzrGF0	42CA	SYjiwdB1
GERhXOR4	GO9A	SYjiwdB1
hGLwi1U-	O_MJ	SYjiwdB1
gADchsAV	GCTL	SYjiwdB1
wnnKYeBJ	JOQA	SYjiwdB1
5GNLtyhT	HHVR	SYjiwdB1
5XrkogBO	VSN5	SYjiwdB1
LyEZjvpb	7OPV	SYjiwdB1
I2hyzYFf	B6H_	SYjiwdB1
Kxx2o9Gu	AAN0	SYjiwdB1
jdUm0fMt	DGZP	SYjiwdB1
kvDzJGSG	HK-F	SYjiwdB1
C6maIRIa	J89G	SYjiwdB1
TMLJFgcg	R7PP	SYjiwdB1
f-FzEmON	1RRV	SYjiwdB1
GLw5svcU	FCQT	SYjiwdB1
tA_F-ruF	FP8D	SYjiwdB1
f8WyC7z0	VDZD	SYjiwdB1
icxbhC2L	YUT6	SYjiwdB1
tJshniaj	IM6R	SYjiwdB1
UUlC4Ycl	E7FV	SYjiwdB1
4LpORFrK	JRSW	SYjiwdB1
2XZAh6_j	RWNJ	SYjiwdB1
p3v287Jb	MBNX	SYjiwdB1
HlSeQgtS	C1H7	SYjiwdB1
VFQ17cOU	PHDR	SYjiwdB1
2vvv3KEJ	NTQM	SYjiwdB1
koKN5RbE	VXAT	SYjiwdB1
4z31pfuT	IYSI	SYjiwdB1
--J74jKK	IROR	SYjiwdB1
EYEepQdy	E5ME	SYjiwdB1
esFjzOvg	5KPF	s7MN51Nd
uSk1RIMn	F3Y9	s7MN51Nd
_n4SScyB	JUKM	s7MN51Nd
FFg7_uhx	L3BV	s7MN51Nd
Yz_8tapL	SC2M	s7MN51Nd
eLhdQzYC	IPTS	s7MN51Nd
Jw4o-FoU	W6LU	s7MN51Nd
B_5n4GjI	-IIG	s7MN51Nd
Os6T0OZN	OHVR	s7MN51Nd
SojHgnPG	42CA	s7MN51Nd
untKWOQA	GO9A	s7MN51Nd
VTcWZ9vS	O_MJ	s7MN51Nd
OGpaZsc8	GCTL	s7MN51Nd
rfNevT38	JOQA	s7MN51Nd
vxQ54pOr	HHVR	s7MN51Nd
f7KR6H8W	VSN5	s7MN51Nd
M3QLEJe9	7OPV	s7MN51Nd
Fs6cuSKT	B6H_	s7MN51Nd
1DeKE_DH	AAN0	s7MN51Nd
GgOZyNEJ	DGZP	s7MN51Nd
iiWqJz7P	2D7D	s7MN51Nd
PPO2tQSM	WBGK	s7MN51Nd
b-D_9QOm	Q7-F	s7MN51Nd
9kKBhRCy	ZF_F	s7MN51Nd
su0WMjJ8	8NKB	s7MN51Nd
koxiEk6U	DFP1	s7MN51Nd
CWaDblJf	ZLFR	s7MN51Nd
hLSo2-fk	GVSE	s7MN51Nd
us8PAID5	FLVU	s7MN51Nd
ijHy2t3V	7RFE	s7MN51Nd
HNn5GT24	JRSW	s7MN51Nd
fbSIIUhk	RWNJ	s7MN51Nd
kiPv_pq3	MBNX	s7MN51Nd
V3QIsfBv	C1H7	s7MN51Nd
ouxo9ENi	PHDR	s7MN51Nd
38ModweU	NTQM	s7MN51Nd
cD45KyIH	VXAT	s7MN51Nd
0XxPIsx2	IYSI	s7MN51Nd
LWlbYMjB	IROR	s7MN51Nd
1_L2Ro9L	E5ME	s7MN51Nd
CtvjHIQc	5KPF	wSWBg3yl
y2-ic2pP	F3Y9	wSWBg3yl
XCzmmqAj	JUKM	wSWBg3yl
hNIAFq9i	L3BV	wSWBg3yl
qwkTF5b3	SC2M	wSWBg3yl
TcCcNnf8	IPTS	wSWBg3yl
KdoTfaWL	W6LU	wSWBg3yl
ELU4zMU9	-IIG	wSWBg3yl
8q5bcSKV	OHVR	wSWBg3yl
IYs3-zbn	42CA	wSWBg3yl
Np48bF8D	GO9A	wSWBg3yl
_A6VSAXQ	O_MJ	wSWBg3yl
e-5UX6JX	GCTL	wSWBg3yl
9iQTfkPB	JOQA	wSWBg3yl
LkahoAA1	HHVR	wSWBg3yl
Q5ZA6mVk	VSN5	wSWBg3yl
XS8BZgWf	7OPV	wSWBg3yl
PjZfSV7x	B6H_	wSWBg3yl
e5eJtfIC	AAN0	wSWBg3yl
tpthI5vt	DGZP	wSWBg3yl
x_bi6iPo	2D7D	wSWBg3yl
7i3eF60M	WBGK	wSWBg3yl
T601jIFz	Q7-F	wSWBg3yl
I5hTYtFY	ZF_F	wSWBg3yl
C5cMiPFq	8NKB	wSWBg3yl
G-Gjpnsx	DFP1	wSWBg3yl
ha4NByTn	ZLFR	wSWBg3yl
WS94MUrK	GVSE	wSWBg3yl
96TcHamZ	FLVU	wSWBg3yl
ZIyfa_iF	7RFE	wSWBg3yl
ptEV06ub	HK-F	wSWBg3yl
kZy9K35N	J89G	wSWBg3yl
DW6l66hr	R7PP	wSWBg3yl
pj0yqW6A	1RRV	wSWBg3yl
LQSNkqAg	FCQT	wSWBg3yl
INgHrj76	FP8D	wSWBg3yl
8oha9wOC	VDZD	wSWBg3yl
5601obyW	YUT6	wSWBg3yl
XDIj0PTq	IM6R	wSWBg3yl
IopTCiua	E7FV	wSWBg3yl
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: teachtolearn
--

COPY public.reviews (reviewer, reviewee, rating, review, "isBanned", id) FROM stdin;
PgcTBcqM	GO9A	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	MZF2voJA
PgcTBcqM	O_MJ	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	-raum-g7
PgcTBcqM	GCTL	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	KLdkcmmj
PgcTBcqM	JOQA	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	HudTZoqs
PgcTBcqM	HHVR	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	CHOWyX8j
PgcTBcqM	VSN5	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	22g0epHZ
PgcTBcqM	7OPV	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	tyOyh6oE
PgcTBcqM	B6H_	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	Db1B-q-H
PgcTBcqM	AAN0	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	UnN92YFD
PgcTBcqM	DGZP	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	gTm7WBUn
PgcTBcqM	2D7D	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	O0pt-Vi8
PgcTBcqM	WBGK	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	hAT-PViV
PgcTBcqM	Q7-F	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	BWsvf-7Q
PgcTBcqM	ZF_F	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	8WRzqtoo
PgcTBcqM	8NKB	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	qsp-GmPQ
PgcTBcqM	DFP1	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	h8JWVUcD
PgcTBcqM	ZLFR	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	dMZH6nP5
PgcTBcqM	GVSE	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	9Q6G23TU
PgcTBcqM	FLVU	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	mAfDwO0s
PgcTBcqM	7RFE	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	885DERhX
PgcTBcqM	HK-F	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	l15UU9Mi
PgcTBcqM	J89G	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	4m4YZq4O
PgcTBcqM	R7PP	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	za__6oOc
PgcTBcqM	1RRV	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	q3SGEj4O
PgcTBcqM	FCQT	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	69M5ghOJ
SYjiwdB1	W6LU	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	hyXW1IhK
PgcTBcqM	FP8D	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	91iMVGQH
PgcTBcqM	VDZD	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	wMiERtEa
PgcTBcqM	YUT6	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	22pYVs0w
PgcTBcqM	IM6R	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	IgYK32lY
PgcTBcqM	E7FV	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	YvwlEeId
PgcTBcqM	JRSW	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	rm94gfEP
PgcTBcqM	RWNJ	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	PgHo1OiF
PgcTBcqM	MBNX	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	Bksitb_4
PgcTBcqM	C1H7	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	tm6O0X7T
PgcTBcqM	PHDR	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	SA8wX5zh
PgcTBcqM	NTQM	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	tK-w07C5
PgcTBcqM	VXAT	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	pq5m9Era
PgcTBcqM	IYSI	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	gumu65kZ
PgcTBcqM	IROR	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	si-E_qp2
PgcTBcqM	E5ME	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	ezwLlv8O
eWPDXgQ3	5KPF	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	JLoT2h5o
eWPDXgQ3	F3Y9	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	DXmxssim
eWPDXgQ3	JUKM	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	sQthFpLK
eWPDXgQ3	L3BV	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	_uOYR0_4
eWPDXgQ3	SC2M	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	KsdqP2oC
eWPDXgQ3	IPTS	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	pW-_cODk
eWPDXgQ3	W6LU	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	_Yj_hEXz
eWPDXgQ3	-IIG	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	PdE3NvQi
eWPDXgQ3	OHVR	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	jHUFlIfi
eWPDXgQ3	42CA	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	TVx6jkWz
eWPDXgQ3	2D7D	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	us7gA7FH
eWPDXgQ3	WBGK	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	Wfrl3bfI
eWPDXgQ3	Q7-F	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	nsTwLY-y
eWPDXgQ3	ZF_F	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	3umJRtpl
eWPDXgQ3	8NKB	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	YtdfCIsO
eWPDXgQ3	DFP1	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	xO-hwnkS
eWPDXgQ3	ZLFR	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	FuwLHupw
eWPDXgQ3	GVSE	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	7Rt-sg4t
eWPDXgQ3	FLVU	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	X20mOvH2
eWPDXgQ3	7RFE	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	d_lWKgb4
eWPDXgQ3	HK-F	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	P6kTOPGA
eWPDXgQ3	J89G	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	kOHD6L-W
eWPDXgQ3	R7PP	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	NqHpA4d-
eWPDXgQ3	1RRV	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	o9JbjPaa
eWPDXgQ3	FCQT	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	vqxBuVZ1
eWPDXgQ3	FP8D	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	HcH6xipg
eWPDXgQ3	VDZD	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	49GO-b4g
eWPDXgQ3	YUT6	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	jAEtoXCK
eWPDXgQ3	IM6R	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	joXyyzYc
eWPDXgQ3	E7FV	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	2GsP4gwu
eWPDXgQ3	JRSW	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	3B0Z9TyI
eWPDXgQ3	RWNJ	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	3clX1IAO
eWPDXgQ3	MBNX	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	i6PFBrQk
eWPDXgQ3	C1H7	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	wDrcUGV5
eWPDXgQ3	PHDR	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	oOxvamvA
eWPDXgQ3	NTQM	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	YSPUE8RE
eWPDXgQ3	VXAT	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	A2sm4eC1
eWPDXgQ3	IYSI	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	bmxqfxPt
eWPDXgQ3	IROR	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	EJRWx6Wt
eWPDXgQ3	E5ME	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	gRcz6VUL
SYjiwdB1	5KPF	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	v73QOTcq
SYjiwdB1	F3Y9	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	g-fxFfmT
SYjiwdB1	JUKM	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	V_ujU2rE
SYjiwdB1	L3BV	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	cUQvn6Kq
SYjiwdB1	SC2M	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	1UtJJMbC
SYjiwdB1	IPTS	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	68QWrXOI
SYjiwdB1	-IIG	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	IJxV6sEc
SYjiwdB1	OHVR	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	mWgKxRmG
SYjiwdB1	42CA	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	_bznbs7k
SYjiwdB1	GO9A	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	8J1xoUrP
SYjiwdB1	O_MJ	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	f7sS_7TD
SYjiwdB1	GCTL	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	opeIfxgX
SYjiwdB1	JOQA	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	4gTAoy14
SYjiwdB1	HHVR	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	Lviom7T9
SYjiwdB1	VSN5	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	klxyFmxT
SYjiwdB1	7OPV	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	TubH6e5l
SYjiwdB1	B6H_	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	DjLqdryA
SYjiwdB1	AAN0	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	rS7IZCQ-
SYjiwdB1	DGZP	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	fr2R-MkQ
SYjiwdB1	HK-F	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	sLRVcHxR
SYjiwdB1	J89G	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	GP013b04
SYjiwdB1	R7PP	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	2sIPOOVc
SYjiwdB1	1RRV	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	Fimfh5PE
SYjiwdB1	FCQT	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	G-6c2Uju
SYjiwdB1	FP8D	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	KgWzGNNy
SYjiwdB1	VDZD	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	F4SBnX4B
SYjiwdB1	YUT6	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	4ZGYeUcI
SYjiwdB1	IM6R	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	yfTyWbRc
SYjiwdB1	E7FV	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	2vFoCJVX
SYjiwdB1	JRSW	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	CYMdxdsB
SYjiwdB1	RWNJ	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	wMLyAISc
s7MN51Nd	AAN0	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	32qT40Fi
SYjiwdB1	MBNX	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	IqEJp9N-
SYjiwdB1	C1H7	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	a-2qk4l0
SYjiwdB1	PHDR	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	ctTq1NL2
SYjiwdB1	NTQM	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	8X5xh272
SYjiwdB1	VXAT	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	rzmtjopa
SYjiwdB1	IYSI	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	_IvICJdb
SYjiwdB1	IROR	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	fD-4Io7y
SYjiwdB1	E5ME	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	fbrlcfFC
s7MN51Nd	5KPF	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	CGeCoipo
s7MN51Nd	F3Y9	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	NO1yCuyE
s7MN51Nd	JUKM	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	QSJmj61y
s7MN51Nd	L3BV	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	ZT7agy_f
s7MN51Nd	SC2M	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	98dEVnII
s7MN51Nd	IPTS	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	PK3enMr8
s7MN51Nd	W6LU	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	kwWyCAe2
s7MN51Nd	-IIG	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	t_rMLhr9
s7MN51Nd	OHVR	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	IEu4Tl9c
s7MN51Nd	42CA	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	AxQQ_8E8
s7MN51Nd	GO9A	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	-Cx3YfI3
s7MN51Nd	O_MJ	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	Nv-zr7QO
s7MN51Nd	GCTL	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	WU5bg64V
s7MN51Nd	JOQA	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	VQwL3uO8
s7MN51Nd	HHVR	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	CdUeGAp_
s7MN51Nd	VSN5	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	nHC_4Tvo
s7MN51Nd	7OPV	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	VSUbCgId
s7MN51Nd	B6H_	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	93nc7uaH
s7MN51Nd	DGZP	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	P-QgKJBO
s7MN51Nd	2D7D	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	S1Zf0Ftg
s7MN51Nd	WBGK	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	PrCUN2d6
s7MN51Nd	Q7-F	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	RyzfZRbw
s7MN51Nd	ZF_F	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	iGukO-QG
s7MN51Nd	8NKB	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	SYRp-16_
s7MN51Nd	DFP1	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	LrIYxXk9
s7MN51Nd	ZLFR	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	uualoI2j
s7MN51Nd	GVSE	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	rgEGY4gs
s7MN51Nd	FLVU	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	a2894UAc
s7MN51Nd	7RFE	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	GSH-HJ5y
s7MN51Nd	JRSW	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	G5w3yqwi
s7MN51Nd	RWNJ	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	gzZv3Fxt
s7MN51Nd	MBNX	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	YmJaf2d5
s7MN51Nd	C1H7	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	yjCJbYLa
s7MN51Nd	PHDR	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	Ar7mmyxJ
s7MN51Nd	NTQM	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	-NvLkyYs
s7MN51Nd	VXAT	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	sNd2GGVX
s7MN51Nd	IYSI	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	dS_F2Fgl
s7MN51Nd	IROR	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	Hv4zqeg3
s7MN51Nd	E5ME	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	4xOG5P53
wSWBg3yl	5KPF	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	jTgdLojj
wSWBg3yl	F3Y9	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	4sa0h1fQ
wSWBg3yl	JUKM	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	yeXDSiFy
wSWBg3yl	L3BV	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	HfI8Kjcq
wSWBg3yl	SC2M	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	74PZC-dv
wSWBg3yl	IPTS	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	mrXMrUJP
wSWBg3yl	W6LU	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	Sc2Ulv5s
wSWBg3yl	-IIG	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	wjxgAi8c
wSWBg3yl	OHVR	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	liDD8_9U
wSWBg3yl	42CA	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	ya-ECksR
wSWBg3yl	GO9A	0	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	qwz9DnpH
wSWBg3yl	O_MJ	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	mCKjy27w
wSWBg3yl	GCTL	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	7kMU3LXH
wSWBg3yl	JOQA	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	-FPxhKri
wSWBg3yl	HHVR	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	6CROsHiR
wSWBg3yl	VSN5	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	WyRvQhwl
wSWBg3yl	7OPV	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	HybLUUR-
wSWBg3yl	B6H_	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	19Dm3CC4
wSWBg3yl	AAN0	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	9aWw0FnM
wSWBg3yl	DGZP	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	_xo_LEC8
wSWBg3yl	2D7D	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	3DTWRqmT
wSWBg3yl	WBGK	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	v1loRcW7
wSWBg3yl	Q7-F	6	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	iMN6HVlh
wSWBg3yl	ZF_F	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	I6WBWOyT
wSWBg3yl	8NKB	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	cjRHfuth
wSWBg3yl	DFP1	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	t7mO439M
wSWBg3yl	ZLFR	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	J-qs5UZv
wSWBg3yl	GVSE	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	tfbt9SBC
wSWBg3yl	FLVU	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	rLPZlP2T
wSWBg3yl	7RFE	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	BggaRrPk
wSWBg3yl	HK-F	9	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	FP_WOBOO
wSWBg3yl	J89G	2	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	f	Zjx_Y_Zj
wSWBg3yl	R7PP	8	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	jpY5vHl5
wSWBg3yl	1RRV	10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	5Dx5TQYY
wSWBg3yl	FCQT	7	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	b9RznJcQ
wSWBg3yl	FP8D	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut	f	3j_37_QH
wSWBg3yl	VDZD	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	Xuqvec8f
wSWBg3yl	YUT6	3	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt	f	MIA4fmUD
wSWBg3yl	IM6R	4	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	47oA5jlO
wSWBg3yl	E7FV	1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.	f	Llzvo0m5
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: teachtolearn
--

COPY public.sessions (id, "userId", "sessionToken", platform, ip, "lastLoginTime") FROM stdin;
_HP3cP1D	PgcTBcqM	5cgDlIPyhYz3LUVHHW-TjLTnsrVGdPkGNG4O	Android	127.0.0.1	2022-01-03 12:37:56
_dgzPhe-	eWPDXgQ3	-X1bc_XwQPVCaJjmZhxT1fGSSCMbuq5mMMtT	Linux	127.0.0.1	2022-01-03 12:37:56
zQBmq0Bm	SYjiwdB1	kKGYZ7JpHU8FOrTMBqzw6d3qnEt18QaGwmu9	Windows	127.0.0.1	2022-01-03 12:37:56
vhifG4mP	s7MN51Nd	SMJVZPQvmg3p4a42IGbDULlYZx4yArIMzr8n	Linux	127.0.0.1	2022-01-03 12:37:56
qMNjyng8	wSWBg3yl	fD_6tvnTP3llxXT89GcIm0jWyzewwqYM3JUQ	Android	127.0.0.1	2022-01-03 12:37:56
s1afwgUM	PgcTBcqM	2f5wuCe453juf0Lzq856z9dBWKFOcu9Wdyra	Android	127.0.0.1	2022-01-03 12:37:56
PUu1n-sF	eWPDXgQ3	Zo6DSzImF23_Pqo5sQfvt8dtpezUnRYgSfxN	Windows	127.0.0.1	2022-01-03 12:37:56
VOTNzwaY	SYjiwdB1	VvpAo2VK6vZ7l_Pq49AYB0Tr4PTB7rXMzN54	Linux	127.0.0.1	2022-01-03 12:37:56
ccp19LmG	s7MN51Nd	Lcxinz9QKlwS7nNVEJi7peYk1cDgd0toJ5pm	Linux	127.0.0.1	2022-01-03 12:37:56
BTzPOIiC	wSWBg3yl	r7oQ_psX3MYZU3RcUSW7c6noQZix1j9M4bDu	Mac OS X	127.0.0.1	2022-01-03 12:37:56
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: teachtolearn
--

COPY public.users (id, username, email, "passwordHash", bio, fullname, "isActive", "isAdmin", "isBanned", "isDeleted") FROM stdin;
PgcTBcqM	fabifont	s4891185@studenti.unige.it	pbkdf2:sha256:260000$MOh4gr7FmMxbjcgX$61c320872db9d56c6b0bc3e25ec8aaf4e65e0bfa5d6195753b3d318541151597	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	Fabio Fontana	t	f	f	f
eWPDXgQ3	rcastellotti	me@rcastellotti.dev	pbkdf2:sha256:260000$oWlHDiEEOHQVIUYN$b426733bd8e79ee822e29f5fba06f15e0b81e9b49364e6981731654d9511aec1	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	Roberto Castellotti	t	f	f	f
SYjiwdB1	federico_fontana	s4835118@studenti.fakeunige.it	pbkdf2:sha256:260000$Jj25o43b7O4fXMwF$f7f794a9a33180f2f298cde4161e06e537f7e5c93476cc528727a10af1e38b17	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	Federico Fontana	t	f	f	f
s7MN51Nd	edsger_dijkstra	edsger_dijkstra@fakeunige.it	pbkdf2:sha256:260000$Io2icIExthnziCAK$a29bd23d1e0da75f042829799bfcf11b497eb9565bcb1bb981f1cc3d7decec3f	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	Edsger Dijkstra	t	f	f	f
wSWBg3yl	armon_dadgar	armon_dadgar@fakeunige.it	pbkdf2:sha256:260000$idHGPoAGntCKnpju$740e9db301cc4dc14d780e3f65e84aaaff175aa496ab20d5ca1c7fa81cdaad10	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.	Armon Dagdar	t	f	f	f
\.


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (abbreviation);


--
-- Name: lectures lectures_id_key; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.lectures
    ADD CONSTRAINT lectures_id_key UNIQUE (id);


--
-- Name: lectures lectures_pkey; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.lectures
    ADD CONSTRAINT lectures_pkey PRIMARY KEY (index, "courseAbbreviation");


--
-- Name: reservations reservations_id_key; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_id_key UNIQUE (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY ("courseAbbreviation", "userId");


--
-- Name: reviews reviews_id_key; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_id_key UNIQUE (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (reviewer, reviewee);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_sessionToken_key; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT "sessions_sessionToken_key" UNIQUE ("sessionToken");


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_courses_abbreviation; Type: INDEX; Schema: public; Owner: teachtolearn
--

CREATE INDEX ix_courses_abbreviation ON public.courses USING btree (abbreviation);


--
-- Name: ix_lectures_courseAbbreviation; Type: INDEX; Schema: public; Owner: teachtolearn
--

CREATE INDEX "ix_lectures_courseAbbreviation" ON public.lectures USING btree ("courseAbbreviation");


--
-- Name: ix_reservations_userId; Type: INDEX; Schema: public; Owner: teachtolearn
--

CREATE INDEX "ix_reservations_userId" ON public.reservations USING btree ("userId");


--
-- Name: ix_reviews_reviewee; Type: INDEX; Schema: public; Owner: teachtolearn
--

CREATE INDEX ix_reviews_reviewee ON public.reviews USING btree (reviewee);


--
-- Name: ix_sessions_userId; Type: INDEX; Schema: public; Owner: teachtolearn
--

CREATE INDEX "ix_sessions_userId" ON public.sessions USING btree ("userId");


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: teachtolearn
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: teachtolearn
--

CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);


--
-- Name: courses courses_teacherId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "courses_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lectures lectures_courseAbbreviation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.lectures
    ADD CONSTRAINT "lectures_courseAbbreviation_fkey" FOREIGN KEY ("courseAbbreviation") REFERENCES public.courses(abbreviation) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reservations reservations_courseAbbreviation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT "reservations_courseAbbreviation_fkey" FOREIGN KEY ("courseAbbreviation") REFERENCES public.courses(abbreviation) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reservations reservations_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT "reservations_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reviews reviews_reviewee_fkey; Type: FK CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_reviewee_fkey FOREIGN KEY (reviewee) REFERENCES public.courses(abbreviation) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reviews reviews_reviewer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_reviewer_fkey FOREIGN KEY (reviewer) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: sessions sessions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: teachtolearn
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

