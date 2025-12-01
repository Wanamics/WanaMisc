namespace Wanamics.WanaMisc.CheckDirectPosting;

using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using Microsoft.Projects.Project.Job;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.VAT.Setup;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Inventory.Item;
using Microsoft.Finance.GeneralLedger.Account;
report 87067 "WanaMisc Check Direct Posting"
{
    DefaultRenderingLayout = Default;
    Caption = 'Check Direct Posting';
    ApplicationArea = All;
    UsageCategory = None;
    dataset
    {
        dataitem(Buffer; "WanaMisc Check Direct Posting")
        {
            DataItemTableView = sorting("Table No.");
            column(CompanyName; CompanyName) { }
            column(CurrReportObjectId; CurrReport.ObjectId(false)) { }
            column(CurrReportObjectCaption; CopyStr(CurrReport.ObjectId(true), 8)) { }
            column(TableNoCaption; FieldCaption("Table No.")) { }
            column(TableCaptionCaption; FieldCaption("Table Caption")) { }
            column(TableNo; "Table No.") { }
            column(TableCaption; "Table Caption") { }
            column(PostingGroup; "Posting Group 1") { }
            column(PostingGroup2; "Posting Group 2") { }
            column(FieldNo; "Field No.") { }
            column(FieldCaption; "Field Caption") { }
            column(AccountNo; "Account No.") { }
            column(AccountName; "Account Name") { }

            trigger OnPreDataItem()
            var
                NoProblemLbl: Label 'Direct Posting is correct for posting groups G/L accounts setup';
            begin
                CheckPostingGroup(Database::"Customer Posting Group");
                CheckPostingGroup(Database::"Vendor Posting Group");
                CheckPostingGroup(Database::"Job Posting Group");
                CheckPostingGroup(Database::"General Posting Setup");
                CheckPostingGroup(Database::"Bank Account Posting Group");
                CheckPostingGroup(Database::"VAT Posting Setup");
                CheckPostingGroup(Database::"FA Posting Group");
                CheckPostingGroup(Database::"Inventory Posting Setup");
                if Buffer.IsEmpty then begin
                    Message(NoProblemLbl);
                    CurrReport.Quit();
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field("Reset Direct Posting"; ResetDirectPosting)
                {
                    ApplicationArea = All;
                    Caption = 'Update Direct Posting';
                }
            }
        }
    }

    rendering
    {
        layout(Default)
        {
            Caption = 'Check Direct Posting';
            Type = Excel;
            LayoutFile = './ReportLayouts/CheckDirectPosting.xlsx';
        }
    }
    var
        ResetDirectPosting: Boolean;

    local procedure CheckPostingGroup(pTableID: Integer)
    var
        RRef: RecordRef;
        KRef: KeyRef;
    begin
        RRef.Open(pTableID);
        KRef := RRef.KeyIndex(1);
        if RRef.FindSet() then
            repeat
                CheckAccounts(RRef, KRef)
            until RRef.Next() = 0;
    end;

    local procedure CheckAccounts(pRRef: RecordRef; pKRef: KeyRef)
    var
        FRef: FieldRef;
        i: Integer;
    begin
        for i := 1 to pRRef.FieldCount() do begin
            FRef := pRRef.FieldIndex(i);
            if FRef.Relation = Database::"G/L Account" then
                CheckAccount(pRRef, pKRef, FRef);
        end;
    end;

    local procedure CheckAccount(pRecordRef: RecordRef; pKRef: KeyRef; pFieldRef: FieldRef)
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount."No." := pFieldRef.Value;
        if GLAccount."No." = '' then
            exit;
        if not GLAccount.Find() then
            GLAccount.Name := '??????????'
        else
            if not GLAccount."Direct Posting" or MustBeDirectPosting(pRecordRef, pFieldRef) then
                exit
            else
                if ResetDirectPosting then begin
                    GLAccount."Direct Posting" := not GLAccount."Direct Posting";
                    GLAccount.Modify();
                end;
        InsertBuffer(pRecordRef, pKRef, pFieldRef, GLAccount);
    end;

    local procedure InsertBuffer(pRecordRef: RecordRef; pKRef: KeyRef; pFieldRef: FieldRef; pGLAccount: Record "G/L Account")
    var
        FRef: FieldRef;
    begin
        Buffer."Table No." := pRecordRef.Number;
        FRef := pKRef.FieldIndex(1);
        Buffer."Posting Group 1" := FRef.Value;
        if pKRef.FieldCount = 1 then
            Buffer."Posting Group 2" := ''
        else begin
            FRef := pKRef.FieldIndex(2);
            Buffer."Posting Group 2" := FRef.Value;
        end;
        Buffer."Table Caption" := pRecordRef.Caption;
        Buffer."Field No." := pFieldRef.Number;
        Buffer."Field Caption" := pFieldRef.Caption;
        Buffer."Account No." := pGLAccount."No.";
        Buffer."Account Name" := pGLAccount.Name;
        Buffer.Insert;
    end;

    local procedure MustBeDirectPosting(var pRecordRef: RecordRef; var pFieldRef: FieldRef) returnValue: Boolean
    var
        FAPostingGroup: Record "FA Posting Group";
    begin
        if (pRecordRef.Number = Database::"FA Posting Group") and (pFieldRef.Number = FAPostingGroup.FieldNo("Depreciation Expense Acc.")) then
            exit(true);
    end;
}
