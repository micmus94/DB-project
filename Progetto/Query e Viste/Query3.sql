/*elenco dei prodotti acquistati da un certo cliente in un dato negozio nel corso del tempo*/
use `centro_commerciale`;

SELECT prodotto.barcode, prodotto.nome, marca, prodotto.descrizione, numero, materiale, taglia, eta_minima, id_categoria, id_micro_categoria
FROM prodotto
INNER JOIN acquisto on acquisto.barcode = prodotto.barcode
INNER JOIN scontrino on scontrino.cod_scontrino = acquisto.cod_scontrino
INNER JOIN carta_fedelta on carta_fedelta.cod_carta = scontrino.cod_carta
INNER JOIN cliente on cliente.CF_c = carta_fedelta.CF_c
INNER JOIN vendita on vendita.barcode = prodotto.barcode
INNER JOIN negozio on negozio.P_IVA_neg = vendita.P_IVA_neg
WHERE cliente.nome = 'emilio' AND cliente.cognome = 'lapietra' AND negozio.nome = 'sony shop'
ORDER BY scontrino.emesso