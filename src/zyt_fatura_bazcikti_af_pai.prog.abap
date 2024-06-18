*&---------------------------------------------------------------------*
*&  Include           ZYT_FATURA_BAZCIKTI_AF_PAI
*&---------------------------------------------------------------------*

FORM user_command USING p_ucomm    TYPE sy-ucomm
                        p_selfield TYPE slis_selfield.

  DATA: gs_outputparams TYPE sfpoutputparams,
        gv_form_name    TYPE fpname,
        gv_funcname     TYPE funcname,
        gs_docparams    TYPE sfpdocparams,
        gs_dormoutput   TYPE fpformoutput.


  CASE p_ucomm.

    WHEN '&KISIAFRM'.

      DATA: lt_temp_alv1 TYPE TABLE OF gty_faturabazcikti_alv,
            ls_temp_alv1 TYPE gty_faturabazcikti_alv.

      CLEAR lt_temp_alv1.
      lt_temp_alv1[] = gt_faturabazcikti_alv[].


      DELETE lt_temp_alv1 WHERE checkbox EQ ' '.

      SELECT *
        FROM vbrp AS a
        INNER JOIN vbrk AS b ON a~vbeln = b~vbeln
        INNER JOIN kna1 AS c ON c~kunnr = b~kunrg
        INTO CORRESPONDING FIELDS OF TABLE gt_adobeform.

      DATA: lt_temp_af1 TYPE TABLE OF gty_adobeform,
            ls_temp_af1 TYPE gty_adobeform.

      lt_temp_af1[] = gt_adobeform[].
      CLEAR gt_adobeform.

      LOOP AT lt_temp_af1 INTO ls_temp_af1.
        READ TABLE lt_temp_alv1 INTO ls_temp_alv1 WITH KEY vbeln = ls_temp_af1-vbeln
                                                         matnr = ls_temp_af1-matnr
                                                         arktx = ls_temp_af1-arktx
                                                         kunrg = ls_temp_af1-kunnr.
        IF sy-subrc EQ 0.
          APPEND: ls_temp_af1 TO gt_adobeform.
        ENDIF.
      ENDLOOP.

      SORT gt_adobeform.
      DELETE ADJACENT DUPLICATES FROM gt_adobeform COMPARING vbeln matnr arktx kunnr.

      DATA: lv_nametot1 TYPE char100.
      DATA: lv_stcdtot1(40) TYPE c.
      LOOP AT gt_adobeform INTO gs_adobeform.
        CONCATENATE gs_adobeform-name1 gs_adobeform-name2 INTO lv_nametot1 SEPARATED BY space.
        gs_adobeform-nametot = lv_nametot1.
        CONCATENATE gs_adobeform-stcd1 gs_adobeform-stcd2 INTO lv_stcdtot1 SEPARATED BY ' / '.
        gs_adobeform-stcdtot = lv_stcdtot1.
        IF lv_stcdtot1 = ' / ' .
          gs_adobeform-stcdtot = 'Uygun Değer Bulunamadı !!!'.
        ENDIF.
        MODIFY gt_adobeform FROM gs_adobeform.
      ENDLOOP.

      SORT gt_adobeform BY kunnr ASCENDING.

      gs_outputparams-nodialog = abap_true.
      gs_outputparams-preview  = abap_true.
      gs_outputparams-dest     = 'LP01'.
      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = gs_outputparams
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.

      gv_form_name = 'ZYT_FATURA_BAZCIKTI_KISIB_FORM'.
      " gv_form_name = 'ZYT_FATURA_BAZCIKTI_FORM'.

      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = gv_form_name
        IMPORTING
          e_funcname = gv_funcname.


      CALL FUNCTION gv_funcname
        EXPORTING
          /1bcdwb/docparams = gs_docparams
          gt_adobeform      = gt_adobeform
        EXCEPTIONS
          usage_error       = 1
          system_error      = 2
          internal_error    = 3
          OTHERS            = 4.


      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.


    WHEN '&AFRM'.

**** with marker checkbox

      DATA: lt_temp_alv TYPE TABLE OF gty_faturabazcikti_alv,
            ls_temp_alv TYPE gty_faturabazcikti_alv.

      CLEAR lt_temp_alv.
      lt_temp_alv[] = gt_faturabazcikti_alv[].


      DELETE lt_temp_alv WHERE checkbox EQ ' '.

      SELECT *
        FROM vbrp AS a
        INNER JOIN vbrk AS b ON a~vbeln = b~vbeln
        INNER JOIN kna1 AS c ON c~kunnr = b~kunrg
        INTO CORRESPONDING FIELDS OF TABLE gt_adobeform.

      DATA: lt_temp_af TYPE TABLE OF gty_adobeform,
            ls_temp_af TYPE gty_adobeform.

      lt_temp_af[] = gt_adobeform[].
      CLEAR gt_adobeform.

      LOOP AT lt_temp_af INTO ls_temp_af.
        READ TABLE lt_temp_alv INTO ls_temp_alv WITH KEY vbeln = ls_temp_af-vbeln
                                                         matnr = ls_temp_af-matnr
                                                         arktx = ls_temp_af-arktx
                                                         kunrg = ls_temp_af-kunnr.
        IF sy-subrc EQ 0.
          APPEND: ls_temp_af TO gt_adobeform.
        ENDIF.
      ENDLOOP.

      SORT gt_adobeform.
      DELETE ADJACENT DUPLICATES FROM gt_adobeform COMPARING vbeln matnr arktx kunnr.

      DATA: lv_nametot TYPE char100.
      DATA: lv_stcdtot(40) TYPE c.
      LOOP AT gt_adobeform INTO gs_adobeform.
        CONCATENATE gs_adobeform-name1 gs_adobeform-name2 INTO lv_nametot SEPARATED BY space.
        gs_adobeform-nametot = lv_nametot.
        CONCATENATE gs_adobeform-stcd1 gs_adobeform-stcd2 INTO lv_stcdtot SEPARATED BY ' / '.
        gs_adobeform-stcdtot = lv_stcdtot.
        IF lv_stcdtot = ' / ' .
          gs_adobeform-stcdtot = 'Uygun Değer Bulunamadı !!!'.
        ENDIF.
        MODIFY gt_adobeform FROM gs_adobeform.
        EXIT.
      ENDLOOP.


      gs_outputparams-nodialog = abap_true.
      gs_outputparams-preview  = abap_true.
      gs_outputparams-dest     = 'LP01'.
      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = gs_outputparams
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.

      gv_form_name = 'ZYT_FATURA_BAZCIKTI_FORM'.
      "gv_form_name = 'ZYT_FATURA_BAZCIKTI_KISIB_FORM'.

      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = gv_form_name
        IMPORTING
          e_funcname = gv_funcname.


      CALL FUNCTION gv_funcname
        EXPORTING
          /1bcdwb/docparams = gs_docparams
          gt_adobeform      = gt_adobeform
        EXCEPTIONS
          usage_error       = 1
          system_error      = 2
          internal_error    = 3
          OTHERS            = 4.


      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.


*********************************************************************

*** With Checkbox fieldcatalog '111 - 206'
*
*    WHEN '&AFRM'.
*
*      DATA: ref1 TYPE REF TO cl_gui_alv_grid.
*** alvde seçilen checkboxları internal tabloya yansıtır "checkbox
*      CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
*        IMPORTING
*          e_grid = ref1.
*      CALL METHOD ref1->check_changed_data.
*
*      DATA: lt_temp_alv TYPE TABLE OF gty_faturabazcikti_alv,
*            ls_temp_alv TYPE gty_faturabazcikti_alv.
*
*      CLEAR lt_temp_alv.
*      lt_temp_alv[] = gt_faturabazcikti_alv[].
*
*      DELETE lt_temp_alv WHERE checkbox = space.
*
*      SELECT *
*        FROM vbrp AS a
*        INNER JOIN vbrk AS b ON a~vbeln = b~vbeln
*        INNER JOIN kna1 AS c ON c~kunnr = b~kunrg
*        INTO CORRESPONDING FIELDS OF TABLE gt_adobeform.
*
*      DATA: lt_temp_af TYPE TABLE OF gty_adobeform,
*            ls_temp_af TYPE gty_adobeform.
*
*      lt_temp_af[] = gt_adobeform[].
*      CLEAR gt_adobeform.
*
*      LOOP AT lt_temp_af INTO ls_temp_af.
*        READ TABLE lt_temp_alv INTO ls_temp_alv WITH KEY vbeln = ls_temp_af-vbeln
*                                                         matnr = ls_temp_af-matnr
*                                                         arktx = ls_temp_af-arktx
*                                                         kunrg = ls_temp_af-kunnr.
*        IF sy-subrc EQ 0.
*          APPEND: ls_temp_af TO gt_adobeform.
*        ENDIF.
*      ENDLOOP.
*
*      SORT gt_adobeform.
*      DELETE ADJACENT DUPLICATES FROM gt_adobeform COMPARING vbeln matnr arktx kunnr.
*
*      DATA: lv_nametot TYPE char100.
*      DATA: lv_stcdtot(40) TYPE c.
*      LOOP AT gt_adobeform INTO gs_adobeform.
*        CONCATENATE gs_adobeform-name1 gs_adobeform-name2 INTO lv_nametot SEPARATED BY space.
*        gs_adobeform-nametot = lv_nametot.
*        CONCATENATE gs_adobeform-stcd1 gs_adobeform-stcd2 INTO lv_stcdtot SEPARATED BY ' / '.
*        gs_adobeform-stcdtot = lv_stcdtot.
*        IF lv_stcdtot = ' / ' .
*          gs_adobeform-stcdtot = 'Uygun Değer Bulunamadı !!!'.
*        ENDIF.
*        MODIFY gt_adobeform FROM gs_adobeform.
*        EXIT.
*      ENDLOOP.
*
*
*      gs_outputparams-nodialog = abap_true.
*      gs_outputparams-preview  = abap_true.
*      gs_outputparams-dest     = 'LP01'.
*      CALL FUNCTION 'FP_JOB_OPEN'
*        CHANGING
*          ie_outputparams = gs_outputparams
*        EXCEPTIONS
*          cancel          = 1
*          usage_error     = 2
*          system_error    = 3
*          internal_error  = 4
*          OTHERS          = 5.
*
*      gv_form_name = 'ZYT_FATURA_BAZCIKTI_FORM'.
*
*      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*        EXPORTING
*          i_name     = gv_form_name
*        IMPORTING
*          e_funcname = gv_funcname.
*
*
*      CALL FUNCTION gv_funcname
*        EXPORTING
*          /1bcdwb/docparams = gs_docparams
*          gt_adobeform      = gt_adobeform
*        EXCEPTIONS
*          usage_error       = 1
*          system_error      = 2
*          internal_error    = 3
*          OTHERS            = 4.
*
*
*      CALL FUNCTION 'FP_JOB_CLOSE'
*        EXCEPTIONS
*          usage_error    = 1
*          system_error   = 2
*          internal_error = 3
*          OTHERS         = 4.


    WHEN '&ALL2'.

      LOOP AT gt_faturabazcikti_alv INTO gs_faturabazcikti_alv.

        gs_faturabazcikti_alv-checkbox = 'X'.
        MODIFY gt_faturabazcikti_alv FROM gs_faturabazcikti_alv.
      ENDLOOP.

      p_selfield-refresh = 'X'.

    WHEN '&SAL2'.

      LOOP AT gt_faturabazcikti_alv INTO gs_faturabazcikti_alv.

        gs_faturabazcikti_alv-checkbox = ' '.
        MODIFY gt_faturabazcikti_alv FROM gs_faturabazcikti_alv.
      ENDLOOP.

      p_selfield-refresh = 'X'.

  ENDCASE.

ENDFORM.
