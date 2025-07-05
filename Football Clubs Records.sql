/*==============================================================*/
/* DBMS name:      ORACLE Version 10g                           */
/* Created on:     03.01.2024 10:26:33                          */
/*==============================================================*/


alter table FOTBALOVY_KLUB
   drop constraint FK_FOTBALOV_VLASTNI_STADION;

alter table PRACOVNIK_KLUB
   drop constraint "FK_PRACOVNI_MA CLENY_FOTBALOV";

alter table PRACOVNIK_KLUB
   drop constraint FK_PRACOVNI_PRACUJE_ORG_JEDN;

alter table VLASTNEN
   drop constraint FK_VLASTNEN_VLASTNEN_FOTBALOV;

alter table VLASTNEN
   drop constraint FK_VLASTNEN_VLASTNEN2_VLASTNIK;

drop view FOTBALISTA;

drop index VLASTNI_FK;

drop index "MA CLENY_FK";

drop index PRACUJE_FK;

drop index VLASTNEN2_FK;

drop index VLASTNEN_FK;

drop table FOTBALOVY_KLUB cascade constraints;

drop table ORG_JEDNOTKA cascade constraints;

drop table PRACOVNIK_KLUB cascade constraints;

drop table STADION cascade constraints;

drop table VLASTNEN cascade constraints;

drop table VLASTNIK cascade constraints;

/*==============================================================*/
/* Table: FOTBALOVY_KLUB                                        */
/*==============================================================*/
create table FOTBALOVY_KLUB  (
   CIS_KLUB             INTEGER                         not null,
   CIS_STADION          INTEGER,
   NAZEV_KLUB           VARCHAR2(100)                   not null,
   MESTO                VARCHAR2(100)                   not null,
   ZEME                 VARCHAR2(100)                   not null,
   ROK_ZALOZENI         NUMBER(4)                       not null
      constraint CKC_ROK_ZALOZENI_FOTBALOV check (ROK_ZALOZENI >= 1857),
   ROK_LIKVIDACE        NUMBER(4)                      
      constraint CKC_ROK_LIKVIDACE_FOTBALOV check (ROK_LIKVIDACE is null or (ROK_LIKVIDACE >= 1857)),
   ASOCIACE             VARCHAR2(250)                   not null,
   BARVY                VARCHAR2(250)                   not null,
   constraint PK_FOTBALOVY_KLUB primary key (CIS_KLUB)
);

/*==============================================================*/
/* Index: VLASTNI_FK                                            */
/*==============================================================*/
create index VLASTNI_FK on FOTBALOVY_KLUB (
   CIS_STADION ASC
);

/*==============================================================*/
/* Table: ORG_JEDNOTKA                                          */
/*==============================================================*/
create table ORG_JEDNOTKA  (
   CIS_OJ               INTEGER                         not null,
   NAZEV_OJ             VARCHAR2(50)                    not null,
   constraint PK_ORG_JEDNOTKA primary key (CIS_OJ)
);

/*==============================================================*/
/* Table: PRACOVNIK_KLUB                                        */
/*==============================================================*/
create table PRACOVNIK_KLUB  (
   OS_CIS               INTEGER                         not null,
   CIS_KLUB             INTEGER                         not null,
   CIS_OJ               INTEGER                         not null,
   JMENO                VARCHAR2(250)                   not null,
   PRIJMENI             VARCHAR2(250)                   not null,
   DATUM_NAROZENI       DATE,
   NARODNOST            VARCHAR2(50)                    not null,
   DAT_NAST_KLUB        DATE                            not null,
   DAT_VYST_KLUB        DATE,
   FUNKCE               VARCHAR2(250)                   not null
      constraint CKC_FUNKCE_PRACOVNI check (FUNKCE in ('Predseda','Mistopredseda','Generalni reditel','Sportovni reditel','Hlavni skaut','Skaut mladeze','Hlavni trener','Asistent hlavniho trenera','Fotbalista','Seftrener mladeze','Financni reditel','Manazer akademie','Trener brankaru','Kondicni trener','Vedouci tymu','Fyzioterapeut','Maser','Kustod','Lekar','Analytik','Clen predstavenstva','Manazer mladeze')),
   DATUM_NAST_FUNKCE    DATE                            not null,
   DATUM_REZ            DATE,
   CIS_DRES             NUMBER(2)                      
      constraint CKC_CIS_DRES_PRACOVNI check (CIS_DRES is null or (CIS_DRES between 1 and 99)),
   POZICE               VARCHAR2(10)                   
      constraint CKC_POZICE_PRACOVNI check (POZICE is null or (POZICE in ('Brankar','Obrance','Zaloznik','Utocnik'))),
   VYSKA                NUMBER(3)                      
      constraint CKC_VYSKA_PRACOVNI check (VYSKA is null or (VYSKA between 140 and 240)),
   VAHA                 NUMBER(3)                      
      constraint CKC_VAHA_PRACOVNI check (VAHA is null or (VAHA between 50 and 150)),
   TRZNI_CENA           NUMBER(9),
   PLAT                 NUMBER(7),
   constraint PK_PRACOVNIK_KLUB primary key (OS_CIS)
);

/*==============================================================*/
/* Index: "MA CLENY_FK"                                         */
/*==============================================================*/
create index "MA CLENY_FK" on PRACOVNIK_KLUB (
   CIS_KLUB ASC
);

/*==============================================================*/
/* Index: PRACUJE_FK                                            */
/*==============================================================*/
create index PRACUJE_FK on PRACOVNIK_KLUB (
   CIS_OJ ASC
);

/*==============================================================*/
/* Table: STADION                                               */
/*==============================================================*/
create table STADION  (
   CIS_STADION          INTEGER                         not null,
   NAZEV_STADION        VARCHAR2(250)                   not null,
   KAPACITA             NUMBER(6)                       not null,
   MESTSKA_CAST         VARCHAR2(100)                   not null,
   ULICE                VARCHAR2(150)                   not null,
   CIS_POPIS            NUMBER(5)                      
      constraint CKC_CIS_POPIS_STADION check (CIS_POPIS is null or (CIS_POPIS >= 0)),
   CIS_ORIENT           VARCHAR2(4)                     not null,
   ROK_OTEVRENI         NUMBER(4)                       not null
      constraint CKC_ROK_OTEVRENI_STADION check (ROK_OTEVRENI >= 1857),
   ROK_UZAVRENI         NUMBER(4)                      
      constraint CKC_ROK_UZAVRENI_STADION check (ROK_UZAVRENI is null or (ROK_UZAVRENI >= 1857)),
   constraint PK_STADION primary key (CIS_STADION)
);

/*==============================================================*/
/* Table: VLASTNEN                                              */
/*==============================================================*/
create table VLASTNEN  (
   CIS_KLUB             INTEGER                         not null,
   CIS_VLASTNIK         INTEGER                         not null,
   constraint PK_VLASTNEN primary key (CIS_KLUB, CIS_VLASTNIK)
);

/*==============================================================*/
/* Index: VLASTNEN_FK                                           */
/*==============================================================*/
create index VLASTNEN_FK on VLASTNEN (
   CIS_KLUB ASC
);

/*==============================================================*/
/* Index: VLASTNEN2_FK                                          */
/*==============================================================*/
create index VLASTNEN2_FK on VLASTNEN (
   CIS_VLASTNIK ASC
);

/*==============================================================*/
/* Table: VLASTNIK                                              */
/*==============================================================*/
create table VLASTNIK  (
   CIS_VLASTNIK         INTEGER                         not null,
   JMENO_PO             VARCHAR2(250)                   not null,
   PODIL_AKCII          NUMBER(3)                      
      constraint CKC_PODIL_AKCII_VLASTNIK check (PODIL_AKCII is null or (PODIL_AKCII between 0 and 100)),
   constraint PK_VLASTNIK primary key (CIS_VLASTNIK)
);

/*==============================================================*/
/* View: FOTBALISTA                                             */
/*==============================================================*/
create or replace view FOTBALISTA as
select OS_CIS, CIS_KLUB, JMENO, PRIJMENI, DATUM_NAROZENI, NARODNOST, DAT_NAST_KLUB, DAT_VYST_KLUB, CIS_DRES, POZICE, VYSKA, VAHA, TRZNI_CENA, PLAT
from PRACOVNIK_KLUB
where FUNKCE like 'Fotbalista';

alter table FOTBALOVY_KLUB
   add constraint FK_FOTBALOV_VLASTNI_STADION foreign key (CIS_STADION)
      references STADION (CIS_STADION);

alter table PRACOVNIK_KLUB
   add constraint "FK_PRACOVNI_MA CLENY_FOTBALOV" foreign key (CIS_KLUB)
      references FOTBALOVY_KLUB (CIS_KLUB);

alter table PRACOVNIK_KLUB
   add constraint FK_PRACOVNI_PRACUJE_ORG_JEDN foreign key (CIS_OJ)
      references ORG_JEDNOTKA (CIS_OJ);

alter table VLASTNEN
   add constraint FK_VLASTNEN_VLASTNEN_FOTBALOV foreign key (CIS_KLUB)
      references FOTBALOVY_KLUB (CIS_KLUB);

alter table VLASTNEN
   add constraint FK_VLASTNEN_VLASTNEN2_VLASTNIK foreign key (CIS_VLASTNIK)
      references VLASTNIK (CIS_VLASTNIK);

