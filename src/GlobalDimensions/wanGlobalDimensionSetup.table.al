namespace Wanamics.WanaDim.GlobalDimensions;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Setup;
table 87050 "wan Global Dimension Setup"
{
    Caption = 'Global Dimension Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(87050; "Primary Key"; Code[10]) { }
        field(87051; "Income Glob. Dim. 1 Mand."; Boolean)
        {
            Caption = 'Income Glob. Dim. 1 Mandatory';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                SetIncomeGLAccGlobDim(1, Rec."Income Glob. Dim. 1 Mand.");
            end;
        }
        field(87052; "Income Glob. Dim. 2 Mand."; Boolean)
        {
            Caption = 'Income Glob. Dim. 2 Mandatory';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                SetIncomeGLAccGlobDim(2, Rec."Income Glob. Dim. 2 Mand.");
            end;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    local procedure SetIncomeGLAccGlobDim(pGlobDim: Integer; pGlobDimMandatory: Boolean);
    var
        GLSetup: Record "General Ledger Setup";
        GlobDimCode: Code[20];
        GLAccount: Record "G/L Account";
        DefaultDim: Record "Default Dimension";
        ConfirmEnable: Label 'Do you want to define %1 dim. as mandatory for each ''Income'' G/L account?';
        ConfirmDisable: Label 'Do-you want to disable value posting of dimension %1 for Income G/L Accounts?';
    begin
        GLSetup.Get();
        case pGlobDim of
            1:
                GlobDimCode := GLSetup."Global Dimension 1 Code";
            2:
                GlobDimCode := GLSetup."Global Dimension 2 Code";
        end;

        GLAccount.SetRange("Income/Balance", GLAccount."Income/Balance"::"Income Statement");
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if pGlobDimMandatory then begin
            if not Confirm(ConfirmEnable, False, GlobDimCode) then
                exit;
            if GLAccount.FindSet then
                repeat
                    DefaultDim."Table ID" := Database::"G/L Account";
                    DefaultDim."No." := GLAccount."No.";
                    DefaultDim."Dimension Code" := GlobDimCode;
                    if not DefaultDim.Find() then begin
                        DefaultDim."Value Posting" := DefaultDim."Value Posting"::"Code Mandatory";
                        DefaultDim.Insert(true);
                    end else
                        if DefaultDim."Value Posting" <> DefaultDim."Value Posting"::"Code Mandatory" then begin
                            DefaultDim."Value Posting" := DefaultDim."Value Posting"::"Code Mandatory";
                            DefaultDim.Modify(true);
                        end;
                until GLAccount.Next() = 0;
        end else begin
            if not Confirm(ConfirmDisable, False, GlobDimCode) then
                exit;
            if GLAccount.FindSet then
                repeat
                    if DefaultDim.Get(Database::"G/L Account", GLAccount."No.", GlobDimCode) and (DefaultDim."Value Posting" <> DefaultDim."Value Posting"::" ") then begin
                        DefaultDim."Value Posting" := DefaultDim."Value Posting"::" ";
                        DefaultDim.Modify(true);
                    end;
                until GLAccount.Next() = 0;
        end;
    end;
}