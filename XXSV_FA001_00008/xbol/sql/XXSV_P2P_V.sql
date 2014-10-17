--CREATE OR REPLACE FORCE VIEW bolinf.xxsv_p2p_v as 


   SELECT  ph.org_id,  ph.po_header_id,  pl.po_line_id, pd.PO_DISTRIBUTION_ID, ph.vendor_id, aia.invoice_id  ,fai.date_effective  /* HiPr */, 
                   fa.asset_type /* HiPr */,
                   fab.date_placed_in_service /* HiPr */, 
                   h.NAME operating_unit,
                   REPLACE (p.full_name, CHR (50065), 'N') comprador,
                   xxsv_po_report_utl.solicitante
                                          (pd.req_distribution_id)
                                                                  solicitante,
                   ph.attribute5 tipo_compra, 
                   io.organization_name,
                   pd.destination_subinventory, /*ph.attribute4 car, */
                   k.segment9 car, k.concatenated_segments flexfield_contable,
                   REPLACE (s.vendor_name, CHR (50065), 'N') vendor_name,
                   /* Estatus de aprobacion*/
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                1) approver_1,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             1
                                            ) approved_date_1,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                2) approver_2,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             2
                                            ) approved_date_2,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                3) approver_3,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             3
                                            ) approved_date_3,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                4) approver_4,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             4
                                            ) approved_date_4,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                5) approver_5,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             5
                                            ) approved_date_5,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                6) approver_6,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             6
                                            ) approved_date_6,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                7) approver_7,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             7
                                            ) approved_date_7,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                8) approver_8,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             8
                                            ) approved_date_8,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                9) approver_9,
                   xxsv_po_report_utl.approved_date
                                            (ph.po_header_id,
                                             9
                                            ) approved_date_9,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                10
                                               ) approver_10,
                   xxsv_po_report_utl.approved_date
                                           (ph.po_header_id,
                                            10
                                           ) approved_date_10,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                11
                                               ) approver_11,
                   xxsv_po_report_utl.approved_date
                                           (ph.po_header_id,
                                            11
                                           ) approved_date_11,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                12
                                               ) approver_12,
                   xxsv_po_report_utl.approved_date
                                           (ph.po_header_id,
                                            12
                                           ) approved_date_12,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                13
                                               ) approver_13,
                   xxsv_po_report_utl.approved_date
                                           (ph.po_header_id,
                                            13
                                           ) approved_date_13,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                14
                                               ) approver_14,
                   xxsv_po_report_utl.approved_date
                                           (ph.po_header_id,
                                            14
                                           ) approved_date_14,
                   xxsv_po_report_utl.approver (ph.po_header_id,
                                                15
                                               ) approver_15,
                   xxsv_po_report_utl.approved_date
                                           (ph.po_header_id,
                                            15
                                           ) approved_date_15,
                   xxsv_po_report_utl.numero_solicitud
                                     (pd.req_distribution_id)
                                                             numero_solicitud,
                   xxsv_po_report_utl.fecha_solicitud
                                      (pd.req_distribution_id)
                                                              fecha_solicitud,
                   NVL (ph.authorization_status,
                        'INCOMPLETE'
                       ) authorization_status,
                   ph.creation_date fecha_orden, ph.segment1 numero_po,
                   ph.comments po_description, ph.approved_date, pl.line_num,
                   si.segment1 codigo_item,
                   REPLACE (si.description,
                            '%',
                            'POR CIENTO'
                           ) description_item,
                   xxsv_po_report_utl.category_segment
                                     (si.inventory_item_id,
                                      1
                                     ) category_segment1,
                   xxsv_po_report_utl.category_segment
                                     (si.inventory_item_id,
                                      4
                                     ) category_segment4,
                   si.inventory_item_id, pd.quantity_ordered cantidad,
                   pl.unit_price, (pd.quantity_ordered * pl.unit_price
                                  ) monto,
                   (  pd.quantity_ordered
                    - xxsv_po_report_utl.quantity_received (pl.po_line_id)
                   ) cantidad_pendiente,
                   (  xxsv_po_report_utl.quantity_received (pl.po_line_id)
                    * pl.unit_price
                   ) monto_recibido,
                     (  pd.quantity_ordered
                      - xxsv_po_report_utl.quantity_received (pl.po_line_id)
                     )
                   * pl.unit_price monto_pendiente,
                   xxsv_po_report_utl.total_net_received
                                          (ph.po_header_id)
                                                           total_net_received,
                   /* fecha de recepcion */
                   xxsv_po_report_utl.last_date_received
                                     (pl.po_line_id)
                                                    ultima_fecha_de_recepcion,
                   xxsv_po_report_utl.invoice_date
                                          (pd.po_distribution_id)
                                                                 invoice_date,
                   xxsv_po_report_utl.payment_date
                                          (pd.po_distribution_id)
                                                                 payment_date,
                   xxsv_po_report_utl.monto_pagado
                                          (pd.po_distribution_id)
                                                                 monto_pagado
              FROM apps.fa_additions fa,
                   apps.fa_asset_invoices fai,
                   apps.fa_books_v fab,
                   apps.ap_invoices_all aia,
                   apps.ap_invoice_lines_all aila,
                   apps.ap_invoice_distributions_all aida,
                   apps.po_headers_all ph,
                   apps.po_lines_all pl,
                   apps.po_line_types lt,
                   apps.po_line_locations_all pll,
                   apps.po_distributions_all pd,
                   apps.invfv_inventory_organizations io,
                   apps.ap_suppliers s,
                   apps.ap_supplier_sites_all ss,
                   apps.per_people_f p,
                   apps.hr_operating_units h,
                   apps.ap_terms t,
                   apps.mtl_system_items si,
                   apps.gl_code_combinations_kfv k
             WHERE ph.org_id IN (345, 347)
               AND ph.attribute_category = 'SV'
               AND io.organization_name LIKE 'SV%'
               AND fai.invoice_id = aia.invoice_id
               AND aia.invoice_id = aila.invoice_id
               AND aia.invoice_id = aida.invoice_id
               AND aila.line_number = aida.invoice_line_number
               AND fai.invoice_line_number = aila.line_number
               AND fai.invoice_distribution_id = aida.invoice_distribution_id
               AND fai.asset_id = fa.asset_id
               AND fai.asset_id = fab.asset_id
               AND ph.vendor_id = s.vendor_id
               AND ph.vendor_site_id = ss.vendor_site_id
               AND s.vendor_id = ss.vendor_id
               AND ph.agent_id = p.person_id
               AND ph.org_id = h.organization_id
               AND ph.terms_id = t.term_id
               AND ph.po_header_id = pl.po_header_id
               AND pl.item_id = si.inventory_item_id
               AND pl.line_type_id = lt.line_type_id
               AND si.organization_id = 85
               AND pl.po_line_id = pll.po_line_id
               AND pll.line_location_id = pd.line_location_id
               AND pd.destination_organization_id = io.organization_id
               AND pd.code_combination_id = k.code_combination_id
               AND aila.po_header_id = ph.po_header_id
     /*AND ph.segment1 between '2996' and '3100'*/
    AND ph.segment1 ='3015'
    ;
      
/
exit
/
