*&---------------------------------------------------------------------*
*& Report ZYT_FATURA_BAZCIKTI_ADOBEFORM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zyt_fatura_bazcikti_adobeform.

INCLUDE zyt_fatura_bazcikti_af_top.

INCLUDE zyt_fatura_bazcikti_af_pbo.

INCLUDE zyt_fatura_bazcikti_af_pai.

INCLUDE zyt_fatura_bazcikti_af_frm.

START-OF-SELECTION.

  PERFORM get_alv_data.

  PERFORM set_layout.

  PERFORM call_fieldcat_merge.

  PERFORM call_alv_grid.
