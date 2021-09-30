/*visualizza i negozi che utilizzano un solo locale*/
select * from negozio
where negozio.P_IVA_neg in (select P_IVA_neg from locale
						    group by P_IVA_neg
						    having count(locale.id_locale) = 1)

