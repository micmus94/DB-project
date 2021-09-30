CREATE DEFINER=`root`@`localhost` TRIGGER `prodotto_ripiano_AFTER_UPDATE` AFTER UPDATE ON `prodotto_ripiano` FOR EACH ROW BEGIN
if(new.scorta_disp < new.scorta_min)
then
insert into ordine(data_ordine, p_iva_forn, p_iva_neg)
values(
data_ordine = curdate(),
p_iva_forn =  (select p_iva_forn
				from fornitore
				inner join prodotto on prodotto.id_categoria = fornitore.id_categoria
				where prodotto.barcode = new.barcode
				order by rand()
				limit 1),
                
p_iva_neg =  (select negozio.P_IVA_neg
				from negozio
				inner join magazzino on magazzino.p_iva_neg = negozio.p_iva_neg
				inner join scaffale on scaffale.cod_magazzino = magazzino.cod_magazzino
				inner join ripiano on ripiano.cod_scaffale = scaffale.cod_scaffale
				inner join prodotto_ripiano on prodotto_ripiano.cod_ripiano = ripiano.cod_ripiano
				where prodotto_ripiano.barcode = new.barcode));
                
insert into ordine_prodotto(id_ordine, barcode, q_ta)
values(
id_ordine = (select count(*) from ordine),
barcode = new.barcode,
q_ta = 10);

update prodotto_ripiano
set
scorta_disp = scorta_disp + 10
where barcode = new.barcode; 
end if;
END