namespace Wanamics.WanaMisc.FixedAsset;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.FixedAssets.FixedAsset;
using System.IO;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.FixedAssets.Setup;
using Microsoft.FixedAssets.Depreciation;
using Microsoft.Finance.Dimension;
report 87062 "wan Reclass to Fixed Asset"
{
    Caption = 'Reclass to Fixed Asset';
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = m;
    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.");
            trigger OnPreDataItem()
            var
                SelectFixedAssetOrTemplateErr: Label 'You must select fixed asset OR Template Code.';
                ConfirmLbl: Label 'Do you want to reclassify %1 "%2" to %3 %4?';
            begin
                if not ((FixedAsset."No." = '') xor (ConfigTemplateHeader.Code = '')) then
                    Error(SelectFixedAssetOrTemplateErr);
                if not Confirm(ConfirmLbl, false, Count, TableCaption, FixedAsset.TableCaption, FixedAsset."No.") then
                    CurrReport.Quit();
                if ConfigTemplateHeader.Code <> '' then
                    CreateFixedAssetFromTemplate(ConfigTemplateHeader, FromGLEntry, FixedAsset);
            end;

            trigger OnAfterGetRecord()
            var
                GenJournalLine: Record "Gen. Journal Line";
                NewGLEntry: Record "G/L Entry";
            begin
                TestField(Reversed, false);
                Reversed := true;
                Modify(true);

                GenJournalLine.Validate("Source Code", "Source Code");
                if NewPostingDate <> 0D then
                    GenJournalLine.Validate("Posting Date", NewPostingDate)
                else
                    GenJournalLine.Validate("Posting Date", "Posting Date");
                GenJournalLine.Validate("Document No.", "Document No.");
                GenJournalLine.Validate("Document Date", "Document Date");
                GenJournalLine.Validate("Account No.", "G/L Account No.");
                GenJournalLine.Validate("Gen. Posting Type", GenJournalLine."Gen. Posting Type"::" ");
                GenJournalLine.Validate("Gen. Bus. Posting Group", '');
                GenJournalLine.Validate("Gen. Prod. Posting Group", '');
                GenJournalLine.Validate("VAT Bus. Posting Group", '');
                GenJournalLine.Validate("VAT Prod. Posting Group", '');
                GenJournalLine.Validate(Description, Description);
                GenJournalLine.Validate(Amount, -Amount);
                GenJournalLine.Validate(Correction, true);
                GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Account Type"::"Fixed Asset");
                GenJournalLine.Validate("Bal. Account No.", FixedAsset."No.");
                GenJournalLine.Validate("FA Posting Type", GenJournalLine."FA Posting Type"::"Acquisition Cost");
                NewGLEntry.Get(GenJnlPostLine.RunWithCheck(GenJournalLine));

                NewGLEntry.Reversed := true;
                NewGLEntry.Modify();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("FA No."; FixedAsset."No.")
                    {
                        Caption = 'Fixed Asset No.';
                        ApplicationArea = All;
                        TableRelation = "Fixed Asset";
                    }
                    field("Template"; ConfigTemplateHeader.Code)
                    {
                        Caption = 'Fixed Asset Template';
                        ApplicationArea = All;
                        TableRelation = "Config. Template Header".Code where("Table ID" = const(Database::"Fixed Asset"));
                    }
                    field(PostingDate; NewPostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    var
        FixedAsset: Record "Fixed Asset";
        ConfigTemplateHeader: Record "Config. Template Header";
        FromGLEntry: Record "G/L Entry";
        NewPostingDate: Date;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";

    procedure SetFromGLEntry(pGLEntry: Record "G/L Entry")
    begin
        FromGLEntry := pGLEntry;
    end;

    local procedure CreateFixedAssetFromTemplate(pConfigTemplateHeader: Record "Config. Template Header"; pGLEntry: Record "G/L Entry"; var pFixedAsset: Record "Fixed Asset");
    var
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        RecRef: RecordRef;
        FASetup: Record "FA Setup";
        FADepreciationBook: Record "FA Depreciation Book";
        //FASubclass: Record "FA Subclass";
        DimMgt: Codeunit DimensionManagement;
        DimensionSetEntry: Record "Dimension Set Entry" temporary;
        DefaultDimension: Record "Default Dimension";
    begin
        RecRef.Open(Database::"Fixed Asset");
        ConfigTemplateManagement.UpdateRecord(pConfigTemplateHeader, RecRef);
        RecRef.SetTable(pFixedAsset);
        pFixedAsset.Validate(Description, pGLEntry.Description);
        pFixedAsset.Modify();

        DimMgt.GetDimensionSet(DimensionSetEntry, pGLEntry."Dimension Set ID");
        if DimensionSetEntry.FindSet() then
            repeat
                DefaultDimension."Table ID" := RecRef.Number;
                DefaultDimension."No." := pFixedAsset."No.";
                DefaultDimension."Dimension Code" := DimensionSetEntry."Dimension Code";
                DefaultDimension."Dimension Value Code" := DimensionSetEntry."Dimension Value Code";
                DefaultDimension.Insert(true);
            until DimensionSetEntry.Next() = 0;

        FASetup.Get();
        FASetup.TestField("Default Depr. Book");
        FADepreciationBook.Validate("FA No.", pFixedAsset."No.");
        FADepreciationBook.Validate("Depreciation Book Code", FASetup."Default Depr. Book");
        FADepreciationBook.Validate("FA Posting Group", pFixedAsset."FA Posting Group");
        //FADepreciationBook.Validate("Depreciation Method", FASubclass."wan Def. Depreciation Method");
        FADepreciationBook.Validate("Acquisition Date", pGLEntry."Posting Date");
        FADepreciationBook.Validate("G/L Acquisition Date", pGLEntry."Posting Date");
        FADepreciationBook.Validate("Depreciation Starting Date", pGLEntry."Posting Date");
        /*
        FASubclass.Get(FixedAsset."FA Subclass Code");
        if FASubclass."wan Def. No. of Deprec. Years" <> 0 then
            FADepreciationBook.Validate("No. of Depreciation Years", FASubclass."wan Def. No. of Deprec. Years");
        if FASubclass."wan Def. No. of Deprec. Months" <> 0 then
            FADepreciationBook.Validate("No. of Depreciation Months", FASubclass."wan Def. No. of Deprec. Months");
        if FASubclass."wan Def. Declining-Balance %" <> 0 then
            FADepreciationBook.Validate("Declining-Balance %", FASubclass."wan Def. Declining-Balance %");
        */
        FADepreciationBook.Insert(true);
    end;
}
