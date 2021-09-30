
select negozio.P_IVA_neg, negozio.ragione_sociale, negozio.nome, negozio.sede_fisica, negozio.sede_legale, negozio.id_franch
from negozio
inner join negozio_fedeli on negozio_fedeli.negozio = negozio.P_IVA_neg
where clienti_fedeli <
				(select avg(clienti_fedeli)
				from negozio_fedeli
				)