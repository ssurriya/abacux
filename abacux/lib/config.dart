class Config {
  // final apiUrl = 'http://demo.abacux.io/';
  final apiUrl = "http://sp.abacux.io/";

  String apiLogin,
      apiLogout,
      apiPermission,
      apiGetCustomer,
      apiAddCustomer,
      apiEditCustomer,
      apiAccountHolderTypeList,
      apiCustomerDelete,
      apiGetVendor,
      apiAddVendor,
      apiEditVendor,
      apiVendorDelete,
      apiGetGstTreatment,

      //PurchaseOrderApi
      apiGetOrders,
      apiGetPurchaseOrderList,
      apiGetPurchaseOrderUsingId,
      apiDeletePurchaseOrderProduct,
      apiGetPurchaseOrderNo,
      apiGetPurchaseOrderSettings,
      apiGetPurchaseOrderProducts,
      apiGetAdditionalCharges,
      apiPurchaseOrderStore,
      apiUpdatePurchaseOrderStore,
      apiPurchaseorderDeleteAdditionalChargeUsingId,
      apiDeletePurchaseOrder,

      //AddProductApi
      apiGetPurchaseProductList,
      apiGetBin,
      apiGetTaxType,

      //Product
      apiGetProduct,
      apiAddProduct,
      apiEditProduct,
      apiProductDelete,
      apiIncomeAccounts,
      apiExpenseAccounts,
      apiInventoryAccount,
      apiWarehouseBin,
      apiGetAdditionalChargeList,

      //Product Group
      apiProductGroups,
      apiAddProductGroups,
      apiEditProductGroups,
      apiDeleteProductGroups,

      //tax
      apiGetTaxclass,
      apiGetTaxclassTaxType,
      apiProductUoms,
      apiProductAttribute,

      //Tds/Tcs
      apiGetTds,
      apiGetTcs,

      //ProformaInvoice
      apiGetProformaInvoiceNo,
      apiGetProfromaInvoiceList,
      apiGetProformaInvoiceUsingId,
      apiDeleteProformaInvoiceProduct,
      apiProformaInvoiceStore,
      apiGetProformaInvoiceSettings,
      apiUpdateProformaInvoiceStore,
      apiProformaInvoiceDeleteAdditionalChargeUsingId,
      apiDeleteProformaInvoice,

      //Estimate
      apiGetEstimate,
      apiGetEstimateUsingId,
      apiDeleteEstimateProduct,
      apiGetEstimateNo,
      apiEstimateSettings,
      apiEstimateStore,
      apiUpdateEstimateStore,
      apiEstimateDeleteAdditionalChargeUsingId,
      apiDeleteEstimate,

      //SalesInvoice
      apiGetSalesInvoiceList,
      apiGetSalesInvoiceDetailsList,

      //Purchase Payment List
      apiPurchasePaymentList,

      //Warehouse
      apiWarehouseList,
      apiAddWareHouse,
      apiEditWareHouse,
      apiDeleteWareHouse,

      //Ware Houses Bin
      apiWarehouseBinList,
      apiAddWareHouseBin,
      apiEditWareHouseBin,
      apiDeleteWareHouseBin,

      //Estimate Settings
      apiGetEstimateSettingsList,
      apiAddEstimateSettings,
      apiEditEstimateSettings,
      apiDeleteEstimateSettings,

      //Quotation Settings
      apiGetQuotationSettings,
      apiAddQuotationSettings,
      apiEditQuotationSettings,
      apiDeleteQuotationSettings,

      //Sale Invoice
      apiGetSaleInvoiceSettings,
      apiAddSaleInvoiceSettings,
      apiEditSaleInvoiceSettings,
      apiDeleteSaleInvoiceSettings,

      // Financial Year
      apiGetFinancialYearList,
      apiAddFinancialYear,
      apiEditFinancialYear,
      apiDeleteFinancialYear,

      // Product Attributes
      apiGetProductAttributesList,
      apiAddProductAttributes,
      apiEditProductAttributes,
      apiDeleteProductAttributes,

      // Product Unoms
      apiGetProductUnomsList,
      apiAddProductUnoms,
      apiEditProductUnoms,
      apiDeleteProductUnoms,

      //Payment Attributes
      apiGetPaymentAttributeList,
      apiAddPaymentAttributes,
      apiEditPaymentAttributes,
      apiDeletePaymentAttributes,

      //Tax classes
      apiTaxclasses,
      apiAddTaxclasses,
      apiEditTaxclasses,
      apiDeleteTaxclasses,

      //Payment Mode
      apiGetPaymentModeList,

      //tax
      apiTax,
      apiAddTax,
      apiEditTax,
      apiDeleteTax,

      //amountType
      apiAmountType,

      //sales person
      apiEmployeeList,
      apiEmployeeAdd,
      apiEmployeeEdit,
      apiEmployeeDelete,

      //AdditionalCharge
      apiAdditionalChargeList,
      apiAdditionalChargeAdd,
      apiAdditionalChargeEdit,
      apiAdditionalChargeDelete,

      //taxclasstax
      apiTaxClassTax,
      apiAddTaxClassTax,
      apiEditTaxClassTax,
      apiDeleteTaxClassTax,

      //Invoicegroups
      apiInvoiceGroupList,
      apiInvoiceGroupAdd,
      apiInvoiceGroupEdit,
      apiInvoiceGroupDelete;

  Config() {
    this.apiLogin = apiUrl + "api/login";
    this.apiLogout = apiUrl + "api/logout_api";
    this.apiPermission = apiUrl + "api/permissions";
    this.apiGetCustomer = apiUrl + "api/customers_list_api";
    this.apiAddCustomer = apiUrl + "api/customers_add_api";
    this.apiEditCustomer = apiUrl + "api/customers_edit_api";
    this.apiAccountHolderTypeList = apiUrl + "api/account_holder_type_list";
    this.apiCustomerDelete = apiUrl + "api/customers_delete_api";
    this.apiGetVendor = apiUrl + "api/vendor_list_api";
    this.apiAddVendor = apiUrl + "api/vendor_insert_api";
    this.apiEditVendor = apiUrl + "api/vendor_update_api";
    this.apiVendorDelete = apiUrl + "api/vendor_delete_api";
    this.apiGetEstimate = apiUrl + "api/estimates_list_api";
    this.apiGetGstTreatment = apiUrl + "api/get_gst_treatment";

    //PurchaseOrderApi
    this.apiGetOrders = apiUrl + "api/get_orders_api";
    this.apiGetPurchaseOrderList = apiUrl + "api/purchase_order_list_api";
    this.apiGetPurchaseOrderUsingId = apiUrl + "api/purchase_order_edit_api";
    this.apiDeletePurchaseOrderProduct =
        apiUrl + "api/purchase_products_delete_api";
    this.apiGetPurchaseOrderNo = apiUrl + "api/get_purchase_order_no_api";
    this.apiGetPurchaseOrderSettings =
        apiUrl + "api/get_purchase_order_settings_api";
    this.apiGetPurchaseOrderProducts =
        apiUrl + "api/get_purchase_order_products_api";
    this.apiGetAdditionalCharges = apiUrl + "api/get_additional_charges_api";
    this.apiPurchaseOrderStore = apiUrl + "api/purchase_order_store";
    this.apiUpdatePurchaseOrderStore = apiUrl + "api/purchase_order_update_api";
    this.apiPurchaseorderDeleteAdditionalChargeUsingId =
        apiUrl + "api/purchase_order_edit_additional_charge_delete_api";
    this.apiDeletePurchaseOrder = apiUrl + "api/purchase_order_delete_api";

    //AddProductApi
    this.apiGetPurchaseProductList = apiUrl + "api/product_list_api";
    this.apiGetBin = apiUrl + "api/get_bin_name_api";
    this.apiGetTaxType = apiUrl + "api/taxtype_list_api";
    //Product
    this.apiGetProduct = apiUrl + "api/product_list_api";
    this.apiAddProduct = apiUrl + "api/product_insert_api";
    this.apiEditProduct = apiUrl + "api/product_update_api";
    this.apiProductDelete = apiUrl + "api/product_delete_api";
    this.apiIncomeAccounts = apiUrl + "api/income_account_api";
    this.apiExpenseAccounts = apiUrl + "api/expense_account_api";
    this.apiInventoryAccount = apiUrl + "api/inventory_account_api";
    this.apiWarehouseBin = apiUrl + "api/warehouse_bin_api";
    // this.apiGetAdditionalChargeList = apiUrl + "api/get_additional_charge_api";

    // Product Group
    this.apiProductGroups = apiUrl + "api/product_group_api";
    this.apiAddProductGroups = apiUrl + "api/product_group_add_api";
    this.apiEditProductGroups = apiUrl + "api/product_group_edit_api";
    this.apiDeleteProductGroups = apiUrl + "api/product_group_delete_api";

    //tax
    this.apiGetTaxclassTaxType = apiUrl + "api/taxclasstaxtype_list_api";
    this.apiGetTaxclass = apiUrl + "api/taxclasses_list_api";
    this.apiProductUoms = apiUrl + "api/product_uoms_api";
    this.apiProductAttribute = apiUrl + "api/product_attributes_api";

    //Tcs/Tds
    this.apiGetTds = apiUrl + "api/tdsTaxType_list_api";
    this.apiGetTcs = apiUrl + "api/tcsTaxType_list_api";

    //Proforma Invoice
    this.apiGetProformaInvoiceSettings = apiUrl + "api/quotation_settings_api";
    this.apiGetProformaInvoiceNo = apiUrl + "api/get_proforma_inv_no_api";
    this.apiGetProfromaInvoiceList = apiUrl + "api/proforma_invoice_list_api";
    this.apiGetProformaInvoiceUsingId = apiUrl + "api/proforma_edit_api";
    this.apiDeleteProformaInvoiceProduct =
        apiUrl + "api/proforma_edit_deleted_api";
    this.apiProformaInvoiceStore = apiUrl + "api/proforma_store_api";
    this.apiUpdateProformaInvoiceStore = apiUrl + "api/proforma_update_api";
    this.apiProformaInvoiceDeleteAdditionalChargeUsingId =
        apiUrl + "api/proforma_edit_additional_charge_delete_api";
    this.apiDeleteProformaInvoice = apiUrl + "api/proforma_delete_api";

    //Estimate
    this.apiGetEstimateUsingId = apiUrl + "api/estimates_edit_api";
    this.apiDeleteEstimateProduct = apiUrl + "api/estimates_edit_deleted_api";
    this.apiGetEstimateNo = apiUrl + "api/get_estimate_number_api";
    this.apiEstimateSettings = apiUrl + "api/estimatesettings_api";
    this.apiEstimateStore = apiUrl + "api/estimates_store_api";
    this.apiUpdateEstimateStore = apiUrl + "api/estimates_update_api";
    this.apiEstimateDeleteAdditionalChargeUsingId =
        apiUrl + "api/estimate_edit_additional_charge_delete_api";
    this.apiDeleteEstimate = apiUrl + "api/estimates_delete_api";

    //Sales Invoice
    this.apiGetSalesInvoiceList = apiUrl + "api/salesinvoicelist";
    this.apiGetSalesInvoiceDetailsList = apiUrl + "api/salesinvoicedetailslist";

    //Purchase Payment List
    this.apiPurchasePaymentList = apiUrl + "api/purchase_invoices_list";

    //Warehouse
    this.apiWarehouseList = apiUrl + "api/Warehouses_list_api";
    this.apiAddWareHouse = apiUrl + "api/warehouses_add_api";
    this.apiEditWareHouse = apiUrl + "api/warehouses_edit_api";
    this.apiDeleteWareHouse = apiUrl + "api/warehouses_delete_api";

    //Ware Houses Bin
    this.apiWarehouseBinList = apiUrl + "api/warehousesBin_list_api";
    this.apiAddWareHouseBin = apiUrl + "api/warehousesBin_add_api";
    this.apiEditWareHouseBin = apiUrl + "api/warehousesBin_edit_api";
    this.apiDeleteWareHouseBin = apiUrl + "api/warehousesBin_delete_api";

    //Estimate Settings
    this.apiGetEstimateSettingsList = apiUrl + "api/estimatesettings_api";
    this.apiAddEstimateSettings = apiUrl + "api/estimateSettings_add_api";
    this.apiEditEstimateSettings = apiUrl + "api/estimateSettings_edit_api";
    this.apiDeleteEstimateSettings = apiUrl + "api/estimateSettings_delete_api";

    // Quotation Settings
    this.apiGetQuotationSettings = apiUrl + "api/quotationSettings_list_api";
    this.apiAddQuotationSettings = apiUrl + "api/quotationSettings_add_api";
    this.apiEditQuotationSettings = apiUrl + "api/quotationSettings_edit_api";
    this.apiDeleteQuotationSettings =
        apiUrl + "api/quotationSettings_delete_api";

    //Sale Invoice Settings
    this.apiGetSaleInvoiceSettings =
        apiUrl + "api/salesinvoiceSettings_list_api";
    this.apiAddSaleInvoiceSettings =
        apiUrl + "api/salesinvoiceSettings_add_api";
    this.apiEditSaleInvoiceSettings =
        apiUrl + "api/salesinvoiceSettings_edit_api";
    this.apiDeleteSaleInvoiceSettings =
        apiUrl + "api/salesinvoiceSettings_delete_api";

    // Financial Year
    this.apiGetFinancialYearList = apiUrl + "api/financialyear_list_api";
    this.apiAddFinancialYear = apiUrl + "api/financialyear_add_api";
    this.apiEditFinancialYear = apiUrl + "api/financialyear_edit_api";
    this.apiDeleteFinancialYear = apiUrl + "api/financialyear_delete_api";

    // Product Attributes
    this.apiGetProductAttributesList =
        apiUrl + "api/product_attributes_list_api";
    this.apiAddProductAttributes = apiUrl + "api/product_attributes_add_api";
    this.apiEditProductAttributes = apiUrl + "api/product_attributes_edit_api";
    this.apiDeleteProductAttributes =
        apiUrl + "api/product_attributes_delete_api";

    // Product Unoms
    this.apiGetProductUnomsList = apiUrl + "api/product_uoms_list_api";
    this.apiAddProductUnoms = apiUrl + "api/product_uoms_add_api";
    this.apiEditProductUnoms = apiUrl + "api/product_uoms_edit_api";
    this.apiDeleteProductUnoms = apiUrl + "api/product_uoms_delete_api";

    //Payment Attributes
    this.apiGetPaymentAttributeList =
        apiUrl + "api/PaymentModeAttributes_list_api";
    this.apiAddPaymentAttributes = apiUrl + "api/PaymentModeAttributes_add_api";
    this.apiEditPaymentAttributes =
        apiUrl + "api/PaymentModeAttributes_edit_api";
    this.apiDeletePaymentAttributes =
        apiUrl + "api/PaymentModeAttributes_delete_api";

    //Tax classes
    this.apiTaxclasses = apiUrl + "api/taxclassesname_list_api";
    this.apiAddTaxclasses = apiUrl + "api/taxclasses_add_api";
    this.apiEditTaxclasses = apiUrl + "api/taxclasses_edit_api";
    this.apiDeleteTaxclasses = apiUrl + "api/taxclasses_delete_api";

    //tax
    this.apiTax = apiUrl + "api/taxtypes_list_api";
    this.apiAddTax = apiUrl + "api/taxtype_add_api";
    this.apiEditTax = apiUrl + "api/taxtype_edit_api";
    this.apiDeleteTax = apiUrl + "api/taxtype_delete_api";

    // Payment Mode
    this.apiGetPaymentModeList = apiUrl + "api/paymentmode_list_api";

    //amountType
    this.apiAmountType = apiUrl + "api/amount_type_api";

    //TaxClassTax
    this.apiTaxClassTax = apiUrl + "api/taxclasstax_list_api";
    this.apiAddTaxClassTax = apiUrl + "api/taxclasstax_add_api";
    this.apiEditTaxClassTax = apiUrl + "api/taxclasstax_edit_api";
    this.apiDeleteTaxClassTax = apiUrl + "api/taxclasstax_delete_api";

    //salesperson
    this.apiEmployeeList = apiUrl + "api/employee_list_api";
    this.apiEmployeeAdd = apiUrl + "api/employee_add_api";
    this.apiEmployeeEdit = apiUrl + "api/employee_edit_api";
    this.apiEmployeeDelete = apiUrl + "api/employee_delete_api";

    //AdditionalCharge
    this.apiAdditionalChargeList = apiUrl + "api/additional_charge_list_api";
    this.apiAdditionalChargeAdd = apiUrl + "api/additional_charge_add_api";
    this.apiAdditionalChargeEdit = apiUrl + "api/additional_charge_edit_api";
    this.apiAdditionalChargeDelete =
        apiUrl + "api/additional_charge_delete_api";

    //Invoicegroups
    this.apiInvoiceGroupList = apiUrl + "api/invoicegroups_list_api";
    this.apiInvoiceGroupAdd = apiUrl + "api/invoicegroups_add_api";
    this.apiInvoiceGroupEdit = apiUrl + "api/invoicegroups_edit_api";
    this.apiInvoiceGroupDelete = apiUrl + "api/invoicegroups_delete_api";
  }
}
