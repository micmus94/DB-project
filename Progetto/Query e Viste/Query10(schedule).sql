/*CREATE DEFINER=`root`@`localhost` PROCEDURE `verifica`()
BEGIN

update carta_fedelta set abilitata=0 where cod_carta not in
(select scontrino.cod_carta
from scontrino
where datediff(curdate(),emesso)<730 and datediff(curdate(),data_rilascio)>730
);
END*/


delimiter |
create event query_11 
on schedule every 1 day starts '2018-07-18 00:00:00'
do
begin
call verifica();
end |
delimiter ;