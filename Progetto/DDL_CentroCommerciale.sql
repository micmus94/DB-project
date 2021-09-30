CREATE SCHEMA `centro_commerciale` ;
USE `centro_commerciale`;


CREATE TABLE franchising (
    id_franch int AUTO_INCREMENT PRIMARY KEY,
    ragione_sociale varchar(20) NOT NULL
);

CREATE TABLE categoria (
	id_categoria int AUTO_INCREMENT PRIMARY KEY,
    descrizione varchar(20) NOT NULL
);

CREATE TABLE micro_categoria (
	id_micro_categoria int AUTO_INCREMENT PRIMARY KEY,
    id_categoria int NOT NULL,
    descrizione varchar(20) NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE dipendente (
	CF_d varchar(16) PRIMARY KEY,
    nome varchar(20) NOT NULL,
    cognome varchar(20) NOT NULL,
    data_nascita date NOT NULL,
    indirizzo varchar(30) NOT NULL,
    telefono int NOT NULL,
    sesso enum('M', 'F') NOT NULL,
    stipendio int NOT NULL
);

CREATE TABLE cliente (
	CF_c varchar(16) PRIMARY KEY,
    nome varchar(20) NOT NULL,
    cognome varchar(20) NOT NULL,
    data_nascita date NOT NULL,
    indirizzo varchar(30) NOT NULL,
    sesso enum('M', 'F') NOT NULL,
    stato_civile varchar(10) NOT NULL,
    n_figli int NOT NULL
);


CREATE TABLE negozio (
    P_IVA_neg int(11) PRIMARY KEY,
    ragione_sociale varchar(30) NOT NULL,
    nome varchar(30) NOT NULL,
    telefono int,
    sede_fisica varchar(20) NOT NULL,
    sede_legale varchar(20) NOT NULL,
    id_franch int NULL DEFAULT NULL,
    FOREIGN KEY (id_franch) REFERENCES franchising(id_franch)
);

CREATE TABLE carta_fedelta (
    cod_carta int AUTO_INCREMENT PRIMARY KEY,
    data_rilascio date NOT NULL,
    sconto int NOT NULL,
    CF_c varchar(16) NOT NULL,
    P_IVA_neg int(11) NOT NULL,
    FOREIGN KEY (CF_c) REFERENCES cliente(CF_c),
    FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg),
    attivata boolean NOT NULL
);

CREATE TABLE magazzino (
	cod_magazzino int AUTO_INCREMENT PRIMARY KEY,
    descrizione varchar(20) NOT NULL,
    P_IVA_neg int(11) NOT NULL,
    FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg)
);

CREATE TABLE manager (
    P_IVA_neg int(11),
    CF_m varchar(16),
    PRIMARY KEY(P_IVA_neg, CF_m),
    data_inizio date NOT NULL,
    data_fine date NULL DEFAULT NULL,
    FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg),
    FOREIGN KEY (CF_m) REFERENCES dipendente(CF_d)
);

CREATE TABLE reparto (
	id_reparto int AUTO_INCREMENT PRIMARY KEY,
    descrizione varchar(20) NOT NULL,
    id_categoria int NOT NULL,
    P_IVA_neg int(11) NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg)
);

CREATE TABLE caporeparto (
    id_reparto int,
    CF_cr varchar(16),
    PRIMARY KEY(id_reparto, CF_c),
    data_inizio date NOT NULL,
    data_fine date NULL,
    FOREIGN KEY (id_reparto) REFERENCES reparto(id_reparto),
    FOREIGN KEY (CF_cr) REFERENCES dipendente(CF_d)
);

CREATE TABLE dipendente_reparto (
    id_reparto int,
    CF_d varchar(16),
    PRIMARY KEY(id_reparto, CF_d),
    data_inizio date NOT NULL,
    data_fine date NULL,
    FOREIGN KEY (id_reparto) REFERENCES reparto(id_reparto),
    FOREIGN KEY (CF_d) REFERENCES dipendente(CF_d)
);

CREATE TABLE scaffale (
	cod_scaffale int AUTO_INCREMENT PRIMARY KEY,
    descrizione varchar(20) NOT NULL,
    cod_magazzino int,
    FOREIGN KEY (cod_magazzino) REFERENCES magazzino(cod_magazzino)
);

CREATE TABLE ripiano (
	cod_ripiano int AUTO_INCREMENT PRIMARY KEY,
    descrizione varchar(20) NOT NULL,
    cod_scaffale int,
    FOREIGN KEY (cod_scaffale) REFERENCES scaffale(cod_scaffale)
);

CREATE TABLE campagna_promozionale (
    id_campagna int AUTO_INCREMENT PRIMARY KEY,
    descrizione varchar(30) NOT NULL,
    data_inizio date NOT NULL,
    data_fine date NULL DEFAULT NULL,
    P_IVA_neg int(11) NOT NULL,
	FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg)
);

CREATE TABLE prodotto (
    barcode int(13) PRIMARY KEY,
    nome varchar(20) NOT NULL,
    marca varchar(20) NOT NULL,
    descrizione varchar(20) NULL DEFAULT NULL,
    numero int(2) NULL DEFAULT NULL,
    materiale varchar(10) NULL DEFAULT NULL,
    taglia int NULL DEFAULT NULL,
    eta_minima int(2) NULL DEFAULT NULL,
    id_categoria int NOT NULL,
    id_micro_categoria int NULL DEFAULT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_micro_categoria) REFERENCES micro_categoria(id_micro_categoria)
);

CREATE TABLE prodotto_ripiano (
    barcode int(13) NOT NULL,
    cod_ripiano int NOT NULL,
    scorta_min int NOT NULL,
    scorta_disp int NOT NULL,
    PRIMARY KEY (barcode, cod_ripiano),
    FOREIGN KEY (barcode) REFERENCES prodotto(barcode),
    FOREIGN KEY (cod_ripiano) REFERENCES ripiano(cod_ripiano)
);

CREATE TABLE promozione (
	barcode int(13) NOT NULL,
    id_campagna int NOT NULL,
    PRIMARY KEY (barcode, id_campagna),
    sconto int NOT NULL,
	FOREIGN KEY (barcode) REFERENCES prodotto(barcode),
    FOREIGN KEY (id_campagna) REFERENCES campagna_promozionale(id_campagna)
);

CREATE TABLE val_nutrizionale (
	id_valore int AUTO_INCREMENT PRIMARY KEY,
    descrizione varchar(20) NOT NULL
);

CREATE TABLE tabella_nutrizionale (
	barcode int(13),
    id_valore int,
    PRIMARY KEY(barcode, id_valore),
    valore int NOT NULL,
    FOREIGN KEY (barcode) REFERENCES prodotto(barcode),
    FOREIGN KEY (id_valore) REFERENCES val_nutrizionale(id_valore)
);

CREATE TABLE locale (
    id_locale int AUTO_INCREMENT PRIMARY KEY,
    superficie int NOT NULL,
    affitto_mensile int NOT NULL,
    P_IVA_neg int(11) NULL DEFAULT NULL,
    FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg)
);

CREATE TABLE scontrino (
    cod_scontrino int AUTO_INCREMENT PRIMARY KEY,
    emesso date NOT NULL,
    cod_carta int NULL DEFAULT NULL,
    P_IVA_neg int(11) NULL DEFAULT NULL,
    FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg),
    FOREIGN KEY (cod_carta) REFERENCES carta_fedelta(cod_carta)
);

CREATE TABLE acquisto (
    cod_scontrino int,
    barcode int(13),
    q_ta int NOT NULL,
    PRIMARY KEY(cod_scontrino, barcode),
    FOREIGN KEY (cod_scontrino) REFERENCES scontrino(cod_scontrino),
    FOREIGN KEY (barcode) REFERENCES prodotto(barcode)
);

CREATE TABLE vendita (
    P_IVA_neg int(11),
    barcode int(13),
    PRIMARY KEY (P_IVA_neg, barcode),
    prezzo_base decimal(5,2) NOT NULL,
    q_ta_esposta int NOT NULL,
    FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg),
    FOREIGN KEY (barcode) REFERENCES prodotto(barcode)
);

CREATE TABLE fornitore (
	P_IVA_forn int(11) PRIMARY KEY,
    ragione_sociale varchar(20) NOT NULL,
    indirizzo varchar(30) NOT NULL,
    id_categoria int NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE ordine (
	id_ordine int AUTO_INCREMENT PRIMARY KEY,
    data_ordine date NOT NULL,
    P_IVA_neg int(11) NOT NULL,
    P_IVA_forn int(11) NOT NULL,
    FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg),
    FOREIGN KEY (P_IVA_forn) REFERENCES fornitore(P_IVA_forn)
);

CREATE TABLE ordine_prodotto (
	id_ordine int,
	barcode int(13),
    PRIMARY KEY (id_ordine, barcode),
    q_ta int NOT NULL,
    FOREIGN KEY (id_ordine) REFERENCES ordine(id_ordine),
    FOREIGN KEY (barcode) REFERENCES prodotto(barcode)
);

CREATE TABLE fornitura (
	id_fornitura int AUTO_INCREMENT PRIMARY KEY,
	P_IVA_forn int(11) NOT NULL,
    P_IVA_neg int(11) NOT NULL,
    id_categoria int NOT NULL,
    FOREIGN KEY (P_IVA_forn) REFERENCES fornitore(P_IVA_forn),
	FOREIGN KEY (P_IVA_neg) REFERENCES negozio(P_IVA_neg),
	FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);
