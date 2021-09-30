create view negozio_fedeli (negozio, clienti_fedeli)
as
select P_IVA_neg, count(*)
from carta_fedelta
group by P_IVA_neg;


