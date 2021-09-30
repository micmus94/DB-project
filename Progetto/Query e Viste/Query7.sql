/*visualizza il capireparto che ha lavorato in più reparti*/
                               
select * from dipendente
where CF_d = (select CF_cr from caporeparto
			  group by CF_cr
			  having count(id_reparto)>= all(select count(id_reparto)
											 from caporeparto
											 group by CF_cr))