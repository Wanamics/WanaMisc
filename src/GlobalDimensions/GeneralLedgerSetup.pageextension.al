namespace Wanamics.WanaDim.GlobalDimensions;

using Microsoft.Finance.GeneralLedger.Setup;
pageextension 87050 "General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Global Dimension 1 Code")
        {
            field("wan Income Glob. Dim. 1 Mand."; GlobDimSetup."Income Glob. Dim. 1 Mand.")
            {
                Caption = 'Income Glob. Dim. 1 Mandatory';
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    GlobDimSetup.Validate("Income Glob. Dim. 1 Mand.");
                    GlobDimSetup.Modify(true);
                end;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field("wan Income Glob. Dim. 2 Mand."; GlobDimSetup."Income Glob. Dim. 2 Mand.")
            {
                Caption = 'Income Glob. Dim. 2 Mandatory';
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    GlobDimSetup.Validate("Income Glob. Dim. 2 Mand.");
                    GlobDimSetup.Modify(true);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if not GlobDimSetup.Get() then
            GlobDimSetup.Insert()
    end;

    var
        GlobDimSetup: Record "wan Global Dimension Setup";
}