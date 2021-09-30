/*trigger orario inizio e fine*/

CREATE DEFINER=`root`@`localhost` TRIGGER `manager_AFTER_INSERT`
AFTER INSERT ON `manager`
FOR EACH ROW
BEGIN
delete from manager
where manager.ora_inizio < manager.ora_fine;
END

CREATE DEFINER=`root`@`localhost` TRIGGER `caporeparto_AFTER_INSERT`
AFTER INSERT ON `caporeparto`
FOR EACH ROW
BEGIN
delete from caporeparto
where caporeparto.ora_inizio < caporeparto.ora_fine;
END

CREATE DEFINER=`root`@`localhost` TRIGGER `caporeparto_AFTER_INSERT_1`
AFTER INSERT ON `caporeparto`
FOR EACH ROW
BEGIN
delete from dipendente_reparto
where new.CF_cr = dipendente_reparto.CF_d;
delete from manager
where new.CF_cr = manager.CF_m;
END

/*trigger contratto univoco*/

CREATE DEFINER=`root`@`localhost` TRIGGER `dipendente_reparto_AFTER_INSERT_1`
AFTER INSERT ON `dipendente_reparto`
FOR EACH ROW
BEGIN
delete from caporeparto
where new.CF_d = caporeparto.CF_cr;
delete from manager
where new.CF_d = manager.CF_m;
END
   
CREATE DEFINER=`root`@`localhost` TRIGGER `caporeparto_AFTER_INSERT_1`
AFTER INSERT ON `caporeparto`
FOR EACH ROW
BEGIN
delete from dipendente_reparto
where new.CF_cr = dipendente_reparto.CF_d;
delete from manager
where new.CF_cr = manager.CF_m;
END

CREATE DEFINER=`root`@`localhost` TRIGGER `manager_AFTER_INSERT_1`
AFTER INSERT ON `manager`
FOR EACH ROW BEGIN
delete from dipendente_reparto
where new.CF_m = dipendente_reparto.CF_d;
delete from caporeparto
where new.CF_m = caporeparto.CF_cr;
END

/*trigger carta*/

CREATE DEFINER=`root`@`localhost` TRIGGER `scontrino_AFTER_INSERT`
AFTER INSERT ON `scontrino`
FOR EACH ROW
BEGIN
delete from scontrino
where new.cod_carta not in (select * from carta_fedelta
							where new.P_IVA_neg = carta_fedelta.P_IVA_neg);
END

/*trigger prodotto*/

CREATE DEFINER=`root`@`localhost` TRIGGER `prodotto_AFTER_INSERT` AFTER INSERT ON `prodotto` FOR EACH ROW BEGIN
delete from prodotto
where new.id_micro_categoria not in (select * from microcategoria
										where new.id_categoria = microcategoria.id_categoria);
END

CREATE DEFINER=`root`@`localhost` TRIGGER `prodotto_AFTER_INSERT_1` AFTER INSERT ON `prodotto` FOR EACH ROW BEGIN
delete from prodotto
where new.taglia is null
and new.materiale is null
and new.numero is not null
and new.eta_minima is null
and new.id_categoria != 1;
END

CREATE DEFINER=`root`@`localhost` TRIGGER `prodotto_AFTER_INSERT_2` AFTER INSERT ON `prodotto` FOR EACH ROW BEGIN
delete from prodotto
where new.taglia is not null
and new.materiale is not null
and new.numero is null
and new.eta_minima is null
and new.id_categoria != 2;
END

CREATE DEFINER=`root`@`localhost` TRIGGER `prodotto_AFTER_INSERT_3` AFTER INSERT ON `prodotto` FOR EACH ROW BEGIN
delete from prodotto
where new.taglia is null
and new.materiale is null
and new.numero is null
and new.eta_minima is not null
and new.id_categoria != 3;
END

CREATE DEFINER=`root`@`localhost` TRIGGER `prodotto_AFTER_INSERT_4` AFTER INSERT ON `prodotto` FOR EACH ROW BEGIN
delete from prodotto
where new.taglia is null
and new.materiale is null
and new.numero is null
and new.eta_minima is null
and new.barcode not in (select * from tabella_nutrizionale
						where new.barcode = tabella_nutrizionale.barcode)
and new.id_categoria != 4;
END

/*trigger fornitura*/

CREATE DEFINER = CURRENT_USER TRIGGER `centro_commerciale`.`fornitura_AFTER_INSERT` AFTER INSERT ON `fornitura` FOR EACH ROW
BEGIN
if (select count(*)	from fornitura
    where fornitura.id_categoria=NEW.id_categoria
    and fornitura.P_IVA_neg=new.P_IVA_neg)>1
    
    then
    delete from fornitura
    where fornitura.id_categoria=NEW.id_categoria
    and fornitura.P_IVA_neg=new.P_IVA_neg
    and fornitura.P_IVA_forn=new.P_IVA_forn;
    end if;
END