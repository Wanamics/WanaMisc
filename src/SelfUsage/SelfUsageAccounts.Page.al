page 87059 "wan Self Usage Accounts"
{
    Caption = 'Self Usage Accounts';
    PageType = List;
    SourceTable = "wan Self Usage Account";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the value of the Dimension Value field.';
                }
                field("Invoice Disc. Account No."; Rec."Invoice Disc. Account No.")
                {
                    ToolTip = 'Specifies the value of the Invoice Disc. Account No. field.';
                }
            }
        }
    }
}
