*&---------------------------------------------------------------------*
*&  Include           ZYT_FATURA_BAZCIKTI_AF_FRM
*&---------------------------------------------------------------------*

****************************  ALV  ***************************

SELECT-OPTIONS: s_vbeln FOR vbrk-vbeln,
                s_matnr FOR vbrp-matnr,
                s_kunnr FOR kna1-kunnr.

FORM get_alv_data.

  SELECT a~vbeln
         b~matnr
         b~arktx
         a~kunrg
         c~name1
    FROM vbrk AS a
    INNER JOIN vbrp AS b ON a~vbeln = b~vbeln
    INNER JOIN kna1 AS c ON a~kunrg = c~kunnr
    INTO CORRESPONDING FIELDS OF TABLE gt_faturabazcikti_alv
    WHERE a~vbeln IN s_vbeln
    AND b~matnr IN s_matnr
    AND a~kunrg IN s_kunnr.

ENDFORM.

FORM set_layout.

  gs_layout-zebra             = abap_true.
  gs_layout-colwidth_optimize = abap_true.
  gs_layout-box_fieldname = 'CHECKBOX'.

ENDFORM.

FORM: pf_status_set USING extab TYPE slis_t_extab.

  SET PF-STATUS 'STANDARD'.

ENDFORM.

FORM call_fieldcat_merge.
  DATA: ls_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-cprog
      i_structure_name       = 'ZYT_ADOBEFORMS_FAT_BAZ_STRUCT'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  DATA: lv_col_pos TYPE i.
  lv_col_pos = 1.
  LOOP AT gt_fieldcat INTO ls_fieldcat .
    lv_col_pos = lv_col_pos + 1.
    CASE ls_fieldcat-fieldname .
*      WHEN 'CHECKBOX'.
*        ls_fieldcat-col_pos      = 1.
*        ls_fieldcat-checkbox     = 'X'.     "checkbox
*        ls_fieldcat-edit         = 'X'.     "checkbox
*        ls_fieldcat-input        = 'X'.     "checkbox
      WHEN 'VBELN'.
        ls_fieldcat-outputlen    = 20.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'MATNR'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
        ls_fieldcat-edit         = 'X'.
      WHEN 'ARKTX'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'KUNRG'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN 'NAME1'.
        ls_fieldcat-outputlen    = 10.
        ls_fieldcat-col_pos      = lv_col_pos.
      WHEN OTHERS.
        ls_fieldcat-no_out       = 'X'.
    ENDCASE.
    CLEAR ls_fieldcat-key.
    ls_fieldcat-seltext_m    = ls_fieldcat-seltext_l.
    ls_fieldcat-seltext_s    = ls_fieldcat-seltext_l.
    ls_fieldcat-reptext_ddic = ls_fieldcat-seltext_l.
    MODIFY gt_fieldcat FROM ls_fieldcat .
  ENDLOOP.
ENDFORM.


FORM call_alv_grid.

  DATA: lv_lines      TYPE i,
        lv_slines(10) TYPE c,
        lv_title      TYPE lvc_title.
*** Total records
  DESCRIBE TABLE gt_faturabazcikti_alv LINES lv_lines.
  lv_slines = lv_lines.
  CONDENSE lv_slines.
  CONCATENATE 'Toplam' lv_slines 'kayıt mevcut'
         INTO lv_title SEPARATED BY space.

  IF lv_slines = 0.
    lv_title = 'Uygun veri bulunamadı'.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS_SET'
      i_callback_user_command  = 'USER_COMMAND'
      i_grid_title             = lv_title
      is_layout                = gs_layout
      it_fieldcat              = gt_fieldcat[]
      i_default                = 'X'
    TABLES
      t_outtab                 = gt_faturabazcikti_alv[]
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc = 0.
    "do nothing
  ENDIF.

ENDFORM.
