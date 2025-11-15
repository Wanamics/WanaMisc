namespace Wanamics.WanaDim.GlobalDimensions;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.Dimension;
using System.Diagnostics;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Journal;
using Microsoft.Projects.Project.Journal;
using System.Automation;
using Microsoft.Inventory.Posting;
using Microsoft.Projects.Project.Posting;
codeunit 87050 "Global Dimension Events"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Account", OnAfterInsertEvent, '', False, False)]
    local procedure OnAfterInsertGLAccount(var Rec: Record "G/L Account")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if Rec.IsTemporary then
            exit;
        if Rec."Income/Balance" = Rec."Income/Balance"::"Income Statement" then
            Rec.Validate("Income/Balance");
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Account", OnAfterValidateEvent, "Income/Balance", False, False)]
    local procedure OnAfterValidateIncomeBalance(var Rec: Record "G/L Account"; var xRec: Record "G/L Account"; CurrFieldNo: Integer)
    var
        GLSetup: Record "General Ledger Setup";
        Setup: Record "wan Global Dimension Setup";
    begin
        if Rec."Income/Balance" = Rec."Income/Balance"::"Income Statement" then begin
            GLSetup.GetRecordOnce();
            if not Setup.Get() then
                exit;
            if Setup."Income Glob. Dim. 1 Mand." then
                SetDefaultDimMandatory(Database::"G/L Account", Rec."No.", GLSetup."Global Dimension 1 Code");
            if Setup."Income Glob. Dim. 2 Mand." then
                SetDefaultDimMandatory(Database::"G/L Account", Rec."No.", GLSetup."Global Dimension 2 Code");
        end;
    end;

    local procedure SetDefaultDimMandatory(pTableID: Integer; pNo: Code[20]; pDimCode: Code[20]);
    var
        DefaultDim: Record "Default Dimension";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        ChangeLogMgt: Codeunit "Change Log Management";
    begin
        if not DefaultDim.Get(pTableID, pNo, pDimCode) then begin
            DefaultDim.Init;
            DefaultDim.Validate("Table ID", pTableID);
            DefaultDim."No." := pNo;
            DefaultDim.Validate("Dimension Code", pDimCode);
            DefaultDim.Validate("Value Posting", DefaultDim."Value Posting"::"Code Mandatory");
            DefaultDim.Insert();
            RecRef.GetTable(DefaultDim);
            ChangeLogMgt.LogInsertion(RecRef);
        end else
            if (DefaultDim."Value Posting" = DefaultDim."Value Posting"::"Same Code") and (DefaultDim."Dimension Value Code" <> '') then begin
            end else
                if DefaultDim."Value Posting" <> DefaultDim."Value Posting"::"Code Mandatory" then begin
                    xRecRef.GetTable(DefaultDim);
                    DefaultDim.Validate("Value Posting", DefaultDim."Value Posting"::"Code Mandatory");
                    RecRef.GetTable(DefaultDim);
                    ChangeLogMgt.LogModification(RecRef);
                    DefaultDim.Modify();
                end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnAfterReleaseSalesDoc, '', False, False)]
    local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    begin
        CheckSalesLinesDim(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnAfterCheckSalesApprovalPossible, '', false, false)]
    local procedure OnAfterCheckSalesApprovalPossible(var SalesHeader: Record "Sales Header")
    begin
        CheckSalesLinesDim(SalesHeader);
    end;

    local procedure CheckSalesLinesDim(SalesHeader: Record "Sales Header")
    var
        Setup: Record "wan Global Dimension Setup";
        Line: Record "Sales Line";
    begin
        if not Setup.Get() then
            exit;
        Line.SetRange("Document Type", SalesHeader."Document Type");
        Line.SetRange("Document No.", SalesHeader."No.");
        Line.SetFilter(Quantity, '<>0');
        if Setup."Income Glob. Dim. 1 Mand." then begin
            Line.SetRange("Shortcut Dimension 1 Code", '');
            if Line.FindFirst() then
                Line.TestField("Shortcut Dimension 1 Code");
            Line.SetRange("Shortcut Dimension 1 Code");
        end;
        if Setup."Income Glob. Dim. 2 Mand." then begin
            Line.SetRange("Shortcut Dimension 2 Code", '');
            if Line.FindFirst() then
                Line.TestField("Shortcut Dimension 2 Code");
            Line.SetRange("Shortcut Dimension 2 Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnAfterReleasePurchaseDoc, '', False, False)]
    local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    begin
        CheckPurchaseLinesDim(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnAfterCheckPurchaseApprovalPossible, '', false, false)]
    local procedure OnAfterCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header")
    begin
        CheckPurchaseLinesDim(PurchaseHeader);
    end;

    local procedure CheckPurchaseLinesDim(pPurchaseHeader: Record "Purchase Header")
    var
        Setup: Record "wan Global Dimension Setup";
        Line: Record "Purchase Line";
    begin
        if not Setup.Get() then
            exit;
        Line.SetRange("Document Type", pPurchaseHeader."Document Type");
        Line.SetRange("Document No.", pPurchaseHeader."No.");
        Line.SetFilter(Quantity, '<>0');
        if Setup."Income Glob. Dim. 1 Mand." then begin
            Line.SetRange("Shortcut Dimension 1 Code", '');
            if Line.FindFirst() then
                Line.TestField("Shortcut Dimension 1 Code");
            Line.SetRange("Shortcut Dimension 1 Code");
        end;
        if Setup."Income Glob. Dim. 2 Mand." then begin
            Line.SetRange("Shortcut Dimension 2 Code", '');
            if Line.FindFirst() then
                Line.TestField("Shortcut Dimension 2 Code");
            Line.SetRange("Shortcut Dimension 2 Code");
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforePostItemJnlLine, '', False, False)]
    local procedure OnBeforePostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean)
    var
        Setup: Record "wan Global Dimension Setup";
    begin
        if ItemJournalLine."Journal Template Name" = '' then
            exit;
        if not Setup.Get() then
            exit;
        if Setup."Income Glob. Dim. 1 Mand." then
            ItemJournalLine.TestField("Shortcut Dimension 1 Code");
        if Setup."Income Glob. Dim. 2 Mand." then
            ItemJournalLine.TestField("Shortcut Dimension 2 Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Check Line", OnBeforeRunCheck, '', False, False)]
    local procedure OnBeforeRunCheck(var JobJnlLine: Record "Job Journal Line")
    var
        Setup: Record "wan Global Dimension Setup";
    begin
        if JobJnlLine."Journal Template Name" = '' then
            exit;
        if not Setup.Get() then
            exit;
        if Setup."Income Glob. Dim. 1 Mand." then
            JobJnlLine.TestField("Shortcut Dimension 1 Code");
        if Setup."Income Glob. Dim. 2 Mand." then
            JobJnlLine.TestField("Shortcut Dimension 2 Code");
    end;
}