#if FALSE // moved to WanApply

using Microsoft.Purchases.Payables;
pageextension 87065 "wan Vendor Ledger Entries" extends "Vendor Ledger Entries"
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
