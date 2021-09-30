/*cliente che ha speso di più = mostra tutti gli acquisti totali di tutti i clienti - il totale max*/
/*totale di uno scontrino*/
SELECT * FROM cliente
INNER JOIN carta_fedelta ON carta_fedelta.CF_c = cliente.CF_c
INNER JOIN scontrino ON scontrino.cod_carta = carta_fedelta.cod_carta
where scontrino.cod_carta = (select * from spendaccione)