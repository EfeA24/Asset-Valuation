REPORT Z_VARLIK_KATKISI_DEGERI_HESAPLAMA.

TABLES: ANLC. "Durum Değerleme Tablosu

TYPES: BEGIN OF ty_anlc,
         anln1 TYPE ANLC-ANLN1, "Varlık Numarası
         gjahr TYPE ANLC-GJAHR, "Muhasebe Yılı
         afabg TYPE ANLC-AFABG, "Amortisman Grubu
         slbnm TYPE ANLC-SLBNM, "Sermaye Bölgesi
         nbuch TYPE ANLC-NBUCH, "Defter Değeri
         nverm TYPE ANLC-NVERM, "Değerleme
         nreav TYPE ANLC-NREAV, "Değerleme Sonrası Defter Değeri
       END OF ty_anlc.

DATA: lt_anlc TYPE TABLE OF ty_anlc,
      ls_anlc TYPE ty_anlc,
      lv_toplam_varlik_degeri TYPE ANLC-NBUCH,
      lv_toplam_katkı TYPE ANLC-NBUCH,
      lv_toplam_amortisman TYPE ANLC-NVERM.

PARAMETERS: p_muhasebe_yili TYPE ANLC-GJAHR DEFAULT sy-datum,
            p_amortisman_grubu TYPE ANLC-AFABG DEFAULT '',
            p_sermaye_bolgesi TYPE ANLC-SLBNM DEFAULT ''.
START-OF-SELECTION.
  SELECT anln1 gjahr afabg slbnm nbuch nverm nreav
    FROM anlc
    INTO TABLE lt_anlc
    WHERE gjahr = p_muhasebe_yili
      AND afabg = p_amortisman_grubu
      AND slbnm = p_sermaye_bolgesi.

  IF lt_anlc IS NOT INITIAL.
    LOOP AT lt_anlc INTO ls_anlc.
      lv_toplam_varlik_degeri = lv_toplam_varlik_degeri + ls_anlc-nbuch.
      lv_toplam_amortisman = lv_toplam_amortisman + ls_anlc-nverm.

      DATA(lv_varlik_katkisi) = ls_anlc-nbuch - ls_anlc-nverm.

      WRITE: / 'Varlık Numarası:', ls_anlc-anln1,
             'Muhasebe Yılı:', ls_anlc-gjahr,
             'Amortisman Grubu:', ls_anlc-afabg,
             'Sermaye Bölgesi:', ls_anlc-slbnm,
             'Defter Değeri:', ls_anlc-nbuch,
             'Değerleme:', ls_anlc-nverm,
             'Değerleme Sonrası Defter Değeri:', ls_anlc-nreav,
             'Varlıkların Borsa Değerine Katkısı:', lv_varlik_katkisi.
    ENDLOOP.

    lv_toplam_katkı = lv_toplam_varlik_degeri - lv_toplam_amortisman.

    WRITE: / 'Toplam Varlık Değeri:', lv_toplam_varlik_degeri,
           'Toplam Amortisman:', lv_toplam_amortisman,
           'Toplam Varlık Katkısı:', lv_toplam_katkı.
  ELSE.
    WRITE: / 'Varlık bulunamadı.'.
  ENDIF.
