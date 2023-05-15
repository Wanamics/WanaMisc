pageextension 87058 "wan Sales & Receivables Setup" extends "Sales & Receivables Setup"
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
