/*visualizzare, per ogni negozio e per ogni mese, quanti e quali prodotti sono stati richiesti ai fornitori*/
use `centro_commerciale`;

SELECT month(ordine.data_ordine) as mese, negozio.nome as negozio, prodotto.marca, prodotto.nome as prodotto, sum(q_ta) as q_ta_tot from ordine_prodotto
INNER JOIN prodotto on ordine_prodotto.barcode = prodotto.barcode
INNER JOIN ordine on ordine_prodotto.id_ordine = ordine.id_ordine
INNER JOIN negozio on ordine.p_iva_neg = negozio.P_IVA_neg
GROUP BY prodotto, prodotto.marca, negozio, mese