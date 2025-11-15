#if FALSE // moved to WanApply
namespace Wanamics.WanaMisc.AppliedEntries;

using Microsoft.Sales.Receivables;
pageextension 87064 "wan Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field(AppliedToCode; AppliedHelper.AppliedToCode(Rec."Entry No.", Rec.Open, Rec."Closed by Entry No."))
            {
                Caption = 'Applied-to Code';
                Width = 6;
                Editable = false;
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    var
        AppliedHelper: Codeunit "wan Applied Entries Helper";
}
#endif
