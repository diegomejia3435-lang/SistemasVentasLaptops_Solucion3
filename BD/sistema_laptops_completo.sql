CREATE TABLE public.detalle_ventas (
    id_detalle integer NOT NULL,
    id_venta integer,
    id_producto integer,
    cantidad integer,
    precio_unitario numeric(10,2)
);


ALTER TABLE public.detalle_ventas OWNER TO postgres;

--
-- Name: detalle_ventas_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_ventas_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_ventas_id_detalle_seq OWNER TO postgres;

--
-- Name: detalle_ventas_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_ventas_id_detalle_seq OWNED BY public.detalle_ventas.id_detalle;


--
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id_producto integer NOT NULL,
    nombre character varying(150),
    marca character varying(50),
    categoria character varying(50),
    precio numeric(10,2),
    stock integer
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productos_id_producto_seq OWNER TO postgres;

--
-- Name: productos_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_producto_seq OWNED BY public.productos.id_producto;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    nombre character varying(100),
    correo character varying(100),
    password character varying(100),
    rol character varying(20),
    CONSTRAINT usuarios_rol_check CHECK (((rol)::text = ANY ((ARRAY['Administrador'::character varying, 'Empleado'::character varying])::text[])))
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- Name: ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventas (
    id_venta integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total numeric(10,2),
    id_usuario integer
);


ALTER TABLE public.ventas OWNER TO postgres;

--
-- Name: ventas_id_venta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ventas_id_venta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ventas_id_venta_seq OWNER TO postgres;

--
-- Name: ventas_id_venta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ventas_id_venta_seq OWNED BY public.ventas.id_venta;


--
-- Name: detalle_ventas id_detalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_ventas ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalle_ventas_id_detalle_seq'::regclass);


--
-- Name: productos id_producto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id_producto SET DEFAULT nextval('public.productos_id_producto_seq'::regclass);


--
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- Name: ventas id_venta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas ALTER COLUMN id_venta SET DEFAULT nextval('public.ventas_id_venta_seq'::regclass);


--
-- Data for Name: detalle_ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_ventas (id_detalle, id_venta, id_producto, cantidad, precio_unitario) FROM stdin;
1	1	1	1	3500.00
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id_producto, nombre, marca, categoria, precio, stock) FROM stdin;
1	Laptop ZenBook 14	ASUS	Laptop	3500.00	9
3	Laptop VivoBook 15	ASUS	Laptop	2800.00	12
4	Laptop IdeaPad Slim 5	Lenovo	Laptop	2600.00	8
5	Laptop ThinkPad E14	Lenovo	Laptop	4200.00	5
6	Laptop Pavilion 15	HP	Laptop	2400.00	15
7	Laptop Envy x360	HP	Laptop	4800.00	4
8	Laptop MacBook Air M2	Apple	Laptop	7500.00	6
9	Laptop MacBook Pro 14	Apple	Laptop	9800.00	3
10	Laptop Inspiron 15	Dell	Laptop	2900.00	10
11	Laptop XPS 13	Dell	Laptop	5600.00	4
12	Laptop Gram 14	LG	Laptop	5100.00	7
13	Laptop Swift 3	Acer	Laptop	2200.00	18
14	Laptop Predator Helios 300	Acer	Gaming	6300.00	5
15	Laptop ROG Strix G15	ASUS	Gaming	6800.00	4
16	Laptop Legion 5 Pro	Lenovo	Gaming	7200.00	3
17	Laptop OMEN 16	HP	Gaming	6500.00	6
18	Laptop Surface Pro 9	Microsoft	2 en 1	6900.00	4
19	Laptop Yoga 7i	Lenovo	2 en 1	4400.00	7
20	Laptop Chromebook Spin 714	Acer	Chromebook	1800.00	9
21	Mini PC NUC 13 Pro	Intel	Mini PC	3100.00	6
22	Laptop EliteBook 840	HP	Empresarial	5300.00	5
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id_usuario, nombre, correo, password, rol) FROM stdin;
1	Admin Tech	admin@tech.com	admin123	Administrador
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas (id_venta, fecha, total, id_usuario) FROM stdin;
1	2026-04-30 13:19:02.22357	3500.00	1
\.


--
-- Name: detalle_ventas_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_ventas_id_detalle_seq', 1, true);


--
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_producto_seq', 22, true);


--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 1, true);


--
-- Name: ventas_id_venta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ventas_id_venta_seq', 1, true);


--
-- Name: detalle_ventas detalle_ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_pkey PRIMARY KEY (id_detalle);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id_venta);


--
-- Name: detalle_ventas detalle_ventas_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto);


--
-- Name: detalle_ventas detalle_ventas_id_venta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_id_venta_fkey FOREIGN KEY (id_venta) REFERENCES public.ventas(id_venta);


--
-- Name: ventas ventas_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- PostgreSQL database dump complete
--

