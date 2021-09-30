/*visualizza i clienti che hanno attivato una carta fedeltà in ogni negozio*/
select * from cliente
where CF_c = (select CF_c from carta_fedelta
			  where attivata = 1
			  group by CF_c
			  having count(P_IVA_neg) = (select count(*) from negozio))
