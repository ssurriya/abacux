import 'package:abacux/screens/credit_notes/add_product_in_credit_note_screen.dart';
import 'package:abacux/screens/customer/add_and_edit_customer.dart';
import 'package:abacux/screens/credit_notes/add_or_edit_credit_note_screen.dart';
import 'package:abacux/screens/debit_notes/add_or_edit_debit_note_screen.dart';
import 'package:abacux/screens/debit_notes/add_product_in_debit_note_screen.dart';
import 'package:abacux/screens/debit_notes/debit_note_screen.dart';
import 'package:abacux/screens/estimate/add_estimate_product_screen.dart';

import 'package:abacux/screens/products/product/add_or_edit_product_screen.dart';
import 'package:abacux/screens/products/product/product_screen.dart';
import 'package:abacux/screens/products/products_group/add_or_edit_product_group.dart';
import 'package:abacux/screens/purchase_bill/add_or_edit_purchase_bill_screen.dart';
import 'package:abacux/screens/proforma_invoice/add_or_edit_proforma_invoices.dart';
import 'package:abacux/screens/purchase_bill/add_product_in_purchase_bill_screen.dart';
import 'package:abacux/screens/purchase_order/add_or_edit_adiditional%20_charges.dart';
import 'package:abacux/screens/purchase_order/add_or_edit_product_purchase_order.dart';
import 'package:abacux/screens/purchase_order/add_or_edit_purchase_order_screen.dart';
import 'package:abacux/screens/proforma_invoice/add_product_proforma_invoices.dart';
import 'package:abacux/screens/credit_notes/credit_note_screen.dart';
import 'package:abacux/screens/customer/customer_screen.dart';
import 'package:abacux/screens/dashboard_screen.dart';
import 'package:abacux/screens/estimate/estimates_screen.dart';
import 'package:abacux/screens/income_receipts.dart';
import 'package:abacux/screens/launcherScreen.dart';
import 'package:abacux/screens/login_screen.dart';
import 'package:abacux/screens/sales_invoice/sales_invoice_additional_charge.dart';
import 'package:abacux/screens/sales_receipt/sales_receipt_screen.dart';
import 'package:abacux/screens/splash.dart';

import 'package:abacux/screens/proforma_invoice/proforma_invoices_screen.dart';
import 'package:abacux/screens/purchase_bill/purchase_bill_screen.dart';
import 'package:abacux/screens/purchase_payments/purchase_payment_screen.dart';
import 'package:abacux/screens/sales_receipt/sales_receipt.dart';
import 'package:abacux/screens/vendors/add_and_edit_vendors.dart';
import 'package:abacux/screens/vendors/vendor_screen.dart';
import 'package:abacux/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/estimate/add_or_edit_additional_charges.dart';
import 'screens/estimate_settings/add_or_edit_estimate_settings.dart';
import 'screens/estimate_settings/estimate_settings_screen.dart';

import 'screens/master/Invoice_groups/add_or_edit_invoice_groups.dart';
import 'screens/master/Invoice_groups/invoice_groups_screen.dart';
import 'screens/master/additional_charges/add_or_edit_additionalCharges.dart';
import 'screens/master/additional_charges/additionalCharges_screen.dart';
import 'screens/master/financial_year/add_or_edit_financial_screen.dart';
import 'screens/master/financial_year/financial_year_screen.dart';
import 'screens/master/payment_attributes/add_or_edit_payment_attributes.dart';
import 'screens/master/payment_attributes/payment_attributes_screen.dart';
import 'screens/master/payment_modes/add_or_edit_paymentMode_screen.dart';
import 'screens/master/payment_modes/paymentMode_screen.dart';
import 'screens/master/product_attribute/add_or_edit_product_attribute.dart';
import 'screens/master/product_attribute/product_attribute_screen.dart';
import 'screens/master/product_uoms/add_or_edit_productUoms.dart';
import 'screens/master/product_uoms/productUoms_screen.dart';
import 'screens/master/referral/add_or_edit_refferal.dart';
import 'screens/master/referral/refferal_screen.dart';
import 'screens/master/tax/add_or_edit_tax.dart';
import 'screens/master/tax/tax_screen.dart';
import 'screens/master/tax_class_tax/add_or_edit_taxclasses.dart';
import 'screens/master/tax_class_tax/taxclasses_screen.dart';
import 'screens/master/tax_classes/add_or_edit_taxclasses.dart';
import 'screens/master/tax_classes/taxclasses_screen.dart';
import 'screens/products/products_group/products_group_screen.dart';
import 'screens/proforma_invoice/additional_charge_proforma_invoice.dart';

import 'screens/customer/customer_detail_screen.dart';
import 'screens/estimate/add_or_edit_estimates_screen.dart';
import 'screens/purchase_bill/purchase_bill_additional_charge.dart';
import 'screens/purchase_order/purchase_order_screen.dart';

import 'screens/purchase_payments/add_or_edit_purchase_payment.dart';
import 'screens/quotations_settings/add_or_edit_quotation_setting.dart';
import 'screens/quotations_settings/quotation_setting_screen.dart';

import 'screens/sales_invoice/add_or_edit_sales_invoices_screen.dart';
import 'screens/sales_invoice/add_product_sales_invoices.dart';
import 'screens/sales_invoice/sales_invoices_screen.dart';
import 'screens/sales_invoice_settings/add_or_edit_sale_invoice_setting.dart';
import 'screens/sales_invoice_settings/sale_invoice_settings_screen.dart';
import 'screens/splash_screen.dart';

import 'screens/warehouse/warehousebins/add_or_edit_warehouse_bin.dart';
import 'screens/warehouse/warehousebins/ware_house_bin_screen.dart';
import 'screens/warehouse/warehouses/add_or_edit_warehouse.dart';
import 'screens/warehouse/warehouses/warehouse_screen.dart';

class Routes {
  Routes() {
    runApp(const Abacux());
  }
}

class Abacux extends StatelessWidget {
  const Abacux({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      initialData: null,
      create: (_) => ConnectivityService().connectionStatusController.stream,
      child: MaterialApp(
        title: 'Flutter Demo',

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.blue,
        ),
        home: Splash(),
        onGenerateRoute: (RouteSettings settings) {
          CustomRoute customRoute;
          switch (settings.name) {
            case '/':
            case '/splash':
              customRoute = CustomRoute(
                builder: (_) => Splash(),
                settings: settings,
              );
              break;
            case '/splash1':
              customRoute = CustomRoute(
                builder: (_) => const SplashScreen(),
                settings: settings,
              );
              break;
            case '/login':
              customRoute = CustomRoute(
                builder: (_) => const LoginScreen(),
                settings: settings,
              );
              break;
            case '/launcherScreen':
              customRoute = CustomRoute(
                builder: (_) => const LauncherScreen(),
                settings: settings,
              );
              break;
            case '/dashboard':
              customRoute = CustomRoute(
                builder: (_) => const DashboardScreem(),
                settings: settings,
              );
              break;
            case '/estimates':
              customRoute = CustomRoute(
                builder: (_) => const EstimatesScreen(),
                settings: settings,
              );
              break;
            case '/add_estimate_screen':
              customRoute = CustomRoute(
                builder: (_) => AddOrEditEstimatesScreen(),
                settings: settings,
              );
              break;
            case '/add_estimate_product_screen':
              customRoute = CustomRoute(
                builder: (_) => AddEstimateProductScreen(),
                settings: settings,
              );
              break;
            case '/add_estimate_additional_charge_screen':
              customRoute = CustomRoute(
                builder: (_) => EstimateAdditionalCharges(),
                settings: settings,
              );
              break;

            case '/proforma_invoices_screen':
              customRoute = CustomRoute(
                builder: (_) => const ProformaInvoicesScreen(),
                settings: settings,
              );
              break;
            case '/add_proforma_invoices':
              customRoute = CustomRoute(
                builder: (_) => AddOrEditproformaInvoicesScreen(),
                settings: settings,
              );
              break;
            case '/add_product_proforma_invoices':
              customRoute = CustomRoute(
                builder: (_) => const AddProductproformaInvoices(),
                settings: settings,
              );
              break;
            case '/additional_charge_proforma_invoice':
              customRoute = CustomRoute(
                builder: (_) => AdditionalChargeProformaInvoice(),
                settings: settings,
              );
              break;
            case '/sales_invoices_screen':
              customRoute = CustomRoute(
                builder: (_) => SalesInvoicesScreen(),
                settings: settings,
              );
              break;
            case '/add_sales_invoices_screen':
              customRoute = CustomRoute(
                builder: (_) => AddOrEditSalesInvoicesScreen(),
                settings: settings,
              );
              break;
            case AddProductSalesInvoices.route:
              customRoute = CustomRoute(
                builder: (_) => AddProductSalesInvoices(),
                settings: settings,
              );
              break;
            case SalesInvoiceAdditionalCharge.route:
              customRoute = CustomRoute(
                builder: (_) => SalesInvoiceAdditionalCharge(),
                settings: settings,
              );
              break;
            case '/new_customer':
              customRoute = CustomRoute(
                builder: (_) => const CustomerScreen(),
                settings: settings,
              );
              break;
            case '/customer_edit':
              customRoute = CustomRoute(
                builder: (_) => CustomerDetailScreen(),
                settings: settings,
              );
              break;
            case '/add_customer':
              customRoute = CustomRoute(
                builder: (_) => AddAndEditCustomerScreen(),
                settings: settings,
              );
              break;
            case '/new_vendors':
              customRoute = CustomRoute(
                builder: (_) => VendorScreen(),
                settings: settings,
              );
              break;
            case '/add_vendor':
              customRoute = CustomRoute(
                builder: (_) => AddAndEditVendorScreen(),
                settings: settings,
              );
              break;
            case '/purchase_order_screen':
              customRoute = CustomRoute(
                builder: (_) => const PurchaseOrderScreen(),
                settings: settings,
              );
              break;
            case '/add_purchase_order_screen':
              customRoute = CustomRoute(
                builder: (_) => AddOrEditPurchaseOrderScreen(),
                settings: settings,
              );
              break;
            case '/add_purchase_order_product_screen':
              customRoute = CustomRoute(
                builder: (_) => AddOrEditProductPurchaseOrder(),
                settings: settings,
              );
              break;
            case '/add_additional_charge_screen':
              customRoute = CustomRoute(
                builder: (_) => AddOrEditAdditionalCharges(),
                settings: settings,
              );
              break;
            case PurchaseBillScreen.route:
              customRoute = CustomRoute(
                builder: (_) => const PurchaseBillScreen(),
                settings: settings,
              );
              break;
            case AddOrEditPurchaseBillScreen.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditPurchaseBillScreen(),
                settings: settings,
              );
              break;
            case AddProductPurchaseBill.route:
              customRoute = CustomRoute(
                builder: (_) => const AddProductPurchaseBill(),
                settings: settings,
              );
              break;
            case PurchaseBillAdditionalCharges.route:
              customRoute = CustomRoute(
                builder: (_) => const PurchaseBillAdditionalCharges(),
                settings: settings,
              );
              break;
            case SalesReceiptScreen.route:
              customRoute = CustomRoute(
                builder: (_) => const SalesReceiptScreen(),
                settings: settings,
              );
              break;
            case SalesReceiptListScreen.route:
              customRoute = CustomRoute(
                builder: (_) => SalesReceiptListScreen(),
                settings: settings,
              );
              break;
            case '/purchase_payment':
              customRoute = CustomRoute(
                builder: (_) => const PurchasePaymentScreen(),
                settings: settings,
              );
              break;
            case '/income_receipts':
              customRoute = CustomRoute(
                builder: (_) => const IncomeReceiptsScreen(),
                settings: settings,
              );
              break;
            case CreditNoteScreen.route:
              customRoute = CustomRoute(
                builder: (_) => const CreditNoteScreen(),
                settings: settings,
              );
              break;
            case AddOrEditCreditNoteScreen.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditCreditNoteScreen(),
                settings: settings,
              );
              break;
            case AddProductInCreditNote.route:
              customRoute = CustomRoute(
                builder: (_) => const AddProductInCreditNote(),
                settings: settings,
              );
              break;
            case DebitNoteScreen.route:
              customRoute = CustomRoute(
                builder: (_) => const DebitNoteScreen(),
                settings: settings,
              );
              break;
            case AddOrEditDebitNoteScreen.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditDebitNoteScreen(),
                settings: settings,
              );
              break;
            case AddProductInDebitNote.route:
              customRoute = CustomRoute(
                builder: (_) => const AddProductInDebitNote(),
                settings: settings,
              );
              break;
            case '/product_list':
              customRoute = CustomRoute(
                builder: (_) => ProductScreen(),
                settings: settings,
              );
              break;
            case '/add_product':
              customRoute = CustomRoute(
                builder: (_) => AddAndEditProductScreen(),
                settings: settings,
              );
              break;
            case ProductsGroupScreen.route:
              customRoute = CustomRoute(
                builder: (_) => ProductsGroupScreen(),
                settings: settings,
              );
              break;
            case AddOrEditProductGroup.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditProductGroup(),
                settings: settings,
              );
              break;
            case PurchasePaymentScreen.route:
              customRoute = CustomRoute(
                builder: (_) => PurchasePaymentScreen(),
                settings: settings,
              );
              break;
            case AddOrEditPurchasePayment.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditPurchasePayment(),
                settings: settings,
              );
              break;
            case WarehousesScreen.route:
              customRoute = CustomRoute(
                builder: (_) => WarehousesScreen(),
                settings: settings,
              );
              break;
            case AddOrEditWarehouse.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditWarehouse(),
                settings: settings,
              );
              break;
            case WarehousesBinScreen.route:
              customRoute = CustomRoute(
                builder: (_) => WarehousesBinScreen(),
                settings: settings,
              );
              break;
            case AddOrEditWarehouseBin.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditWarehouseBin(),
                settings: settings,
              );
              break;
            case EstimatesSettingsScreen.route:
              customRoute = CustomRoute(
                builder: (_) => EstimatesSettingsScreen(),
                settings: settings,
              );
              break;
            case AddOrEditEstimateSettings.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditEstimateSettings(),
                settings: settings,
              );
              break;
            case QuotationSettingsScreen.route:
              customRoute = CustomRoute(
                builder: (_) => QuotationSettingsScreen(),
                settings: settings,
              );
              break;
            case AddOrEditQuotationSettings.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditQuotationSettings(),
                settings: settings,
              );
              break;
            case SaleInvoiceSettingsScreen.route:
              customRoute = CustomRoute(
                builder: (_) => SaleInvoiceSettingsScreen(),
                settings: settings,
              );
              break;
            case AddOrEditSaleInvoiceSettings.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditSaleInvoiceSettings(),
                settings: settings,
              );
              break;

            // < Master ------------- Start
            case FinancialYearScreen.route:
              customRoute = CustomRoute(
                builder: (_) => FinancialYearScreen(),
                settings: settings,
              );
              break;
            case AddOrEditFinancialYear.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditFinancialYear(),
                settings: settings,
              );
              break;
            case ProductAttributeScreen.route:
              customRoute = CustomRoute(
                builder: (_) => ProductAttributeScreen(),
                settings: settings,
              );
              break;
            case AddOrEditProductAttribute.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditProductAttribute(),
                settings: settings,
              );
              break;
            case PaymentAttributesScreen.route:
              customRoute = CustomRoute(
                builder: (_) => PaymentAttributesScreen(),
                settings: settings,
              );
              break;
            case AddOrEditPaymentAttributes.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditPaymentAttributes(),
                settings: settings,
              );
              break;
            case ProductUomsScreen.route:
              customRoute = CustomRoute(
                builder: (_) => ProductUomsScreen(),
                settings: settings,
              );
              break;
            case AddOrEditProductUoms.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditProductUoms(),
                settings: settings,
              );
              break;
            case TaxClassesScreen.route:
              customRoute = CustomRoute(
                builder: (_) => TaxClassesScreen(),
                settings: settings,
              );
              break;
            case AddOrEditTaxClasses.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditTaxClasses(),
                settings: settings,
              );
              break;
            case TaxScreen.route:
              customRoute = CustomRoute(
                builder: (_) => TaxScreen(),
                settings: settings,
              );
              break;
            case AddOrEditTax.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditTax(),
                settings: settings,
              );
              break;
            case TaxClassTaxScreen.route:
              customRoute = CustomRoute(
                builder: (_) => TaxClassTaxScreen(),
                settings: settings,
              );
              break;
            case AddOrEditTaxClassTax.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditTaxClassTax(),
                settings: settings,
              );
              break;
            case RefferalScreen.route:
              customRoute = CustomRoute(
                builder: (_) => RefferalScreen(),
                settings: settings,
              );
              break;
            case AddOrEditRefferalScreen.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditRefferalScreen(),
                settings: settings,
              );
              break;
            case AdditionalChargeScreen.route:
              customRoute = CustomRoute(
                builder: (_) => AdditionalChargeScreen(),
                settings: settings,
              );
              break;
            case AddOrEditAdditionalChargeScreen.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditAdditionalChargeScreen(),
                settings: settings,
              );
              break;
            case InvoiceGroupScreen.route:
              customRoute = CustomRoute(
                builder: (_) => InvoiceGroupScreen(),
                settings: settings,
              );
              break;
            case AddOrEditInvoiceGroupScreen.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditInvoiceGroupScreen(),
                settings: settings,
              );
              break;
            case PaymentModeScreen.route:
              customRoute = CustomRoute(
                builder: (_) => PaymentModeScreen(),
                settings: settings,
              );
              break;
            case AddOrEditPaymentMode.route:
              customRoute = CustomRoute(
                builder: (_) => AddOrEditPaymentMode(),
                settings: settings,
              );
              break;
            // Master --------- End >
          }
          return customRoute;
        },
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);
}
