*&---------------------------------------------------------------------*
*&  Include           ZYT_FATURA_BAZCIKTI_AF_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS : slis.

TABLES: vbrk,
        vbrp,
        kna1.


DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.


TYPES: BEGIN OF gty_faturabazcikti_alv,
         vbeln    TYPE vbrk-vbeln,
         matnr    TYPE vbrp-matnr,
         arktx    TYPE vbrp-arktx,
         kunrg    TYPE vbrk-kunrg,
         name1    TYPE kna1-name1,
         checkbox TYPE checkbox,
       END OF gty_faturabazcikti_alv.

DATA: gt_faturabazcikti_alv TYPE TABLE OF gty_faturabazcikti_alv,
      gs_faturabazcikti_alv TYPE gty_faturabazcikti_alv.


TYPES: BEGIN OF gty_adobeform,
         vbeln        TYPE  vbrk-vbeln,
         posnr        TYPE  vbrp-posnr,
         matnr        TYPE  vbrp-matnr,
         arktx        TYPE  vbrp-arktx,
         fkdat        TYPE  vbrk-fkdat,
         kunnr        TYPE  kunnr,
         name1        TYPE  kna1-name1,
         name2        TYPE  kna1-name2,
         nametot(100) TYPE c,
         stcd1        TYPE  kna1-stcd1,
         stcd2        TYPE  kna1-stcd2,
         stcdtot(40)  TYPE c,
         fkimg        TYPE  vbrp-fkimg,
         vrkme        TYPE  vbrp-vrkme,
         netwr        TYPE  vbrp-netwr,
       END OF gty_adobeform.

DATA: gt_adobeform TYPE TABLE OF gty_adobeform,
      gs_adobeform TYPE gty_adobeform.

TYPES: BEGIN OF gty_musteri_af,
         kunnr TYPE  kunnr,
       END OF gty_musteri_af.

DATA: gt_musteri TYPE TABLE OF gty_musteri_af,
      gs_musteri TYPE gty_musteri_af.
