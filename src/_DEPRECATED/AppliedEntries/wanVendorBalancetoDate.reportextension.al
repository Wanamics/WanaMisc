#if FALSE // moved to WanApply
namespace Wanamics.WanaMisc.AppliedEntries;

using Microsoft.Purchases.Reports;
reportextension 87065 "wan Vendor - Balance to Date " extends "Vendor - Balance to Date"
{
    dataset
    {
        add(VendLedgEntry3)
        {
            column(ExternalDocumentNo; "External Document No.") { }
            column(AppliedToCode; AppliedHelper.AppliedToCode("Entry No.", Open, "Closed by Entry No.")) { }
        }
    }
    var
        AppliedHelper: Codeunit "wan Applied Entries Helper";
}
#endif
