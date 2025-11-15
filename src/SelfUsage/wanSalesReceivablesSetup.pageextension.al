namespace Wanamics.WanaMisc.SelfUsage;

using Microsoft.Sales.Setup;
pageextension 87063 "wan Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Calc. Inv. Discount")
        {
            field("wan Self Usage Customer No."; Rec."wan Self Usage Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Self Usage Customer No. field.';
                Visible = false;
            }
        }
    }
}
