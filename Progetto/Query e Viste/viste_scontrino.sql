/*CREATE VIEW prezzi_base
AS
SELECT prodotto.barcode, vendita.prezzo_base FROM centro_commerciale.acquisto
INNER JOIN prodotto on prodotto.barcode = acquisto.barcode
INNER JOIN vendita on vendita.barcode = prodotto.barcode
*/

/*
CREATE VIEW prezzi_scontati
AS
SELECT prezzi_base.barcode, promozione.id_campagna,
round(prezzi_base.prezzo_base - ((promozione.sconto*prezzi_base.prezzo_base)/100),2) as prezzo_scontato
FROM prezzi_base
INNER JOIN promozione on promozione.barcode = prezzi_base.barcode
INNER JOIN campagna_promozionale on campagna_promozionale.id_campagna = promozione.id_campagna
*/

/*CREATE VIEW listino
AS
SELECT prezzi_base.barcode, if(prezzo_scontato is null, prezzi_base.prezzo_base, prezzo_scontato) as prezzo_listino
FROM prezzi_base
LEFT OUTER JOIN prezzi_scontati on prezzi_scontati.barcode = prezzi_base.barcode
*/

/*CREATE VIEW scontrino_totale
AS
SELECT cod_scontrino, sum((listino.prezzo_listino * q_ta)) as totale FROM acquisto
INNER JOIN listino on listino.barcode = acquisto.barcode
group by cod_scontrino
*/

/*
CREATE VIEW scontrino_totale_carta
AS
SELECT scontrino_totale.cod_scontrino,
round(scontrino_totale.totale - ((if(carta_fedelta.attivata = 0, 0, carta_fedelta.sconto)*scontrino_totale.totale)/100),2) as prezzo_carta
FROM scontrino_totale
INNER JOIN scontrino ON scontrino.cod_scontrino = scontrino_totale.cod_scontrino
INNER JOIN carta_fedelta ON carta_fedelta.cod_carta = scontrino.cod_carta
*/

/*
CREATE VIEW spendaccione
AS
SELECT scontrino_totale_carta.cod_scontrino FROM scontrino_totale_carta
GROUP BY scontrino_totale_carta.cod_scontrino
HAVING MAX(scontrino_totale_carta.prezzo_carta) = (SELECT MAX(scontrino_totale_carta.prezzo_carta) FROM scontrino_totale_carta)
*/

SELECT cliente.nome, cliente.cognome FROM cliente
INNER JOIN carta_fedelta ON carta_fedelta.CF_c = cliente.CF_c
INNER JOIN scontrino ON scontrino.cod_carta = carta_fedelta.cod_carta
where scontrino.cod_carta = (select * from spendaccione)