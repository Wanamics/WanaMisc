/*
codeunit 87052 "wan Fixed Asset Events"
{
    /*
    [EventSubscriber(ObjectType::Table, Database::"FA Depreciation Book", 'OnBeforeInsertFADeprBook', '', false, false)]
    local procedure OnBeforeInsertFADeprBook(FADepreciationBook: Record "FA Depreciation Book"; var IsHandled: Boolean)
    begin
        // FADepreciationBook is not by Var...
        SetDefaultValues(FADepreciationBook);
    end;

    [EventSubscriber(ObjectType::Table, Database::"FA Depreciation Book", 'OnBeforeInsertFADeprBook', '', false, false)]
    local procedure OnBeforeModifyDeprFields(FADepreciationBook: Record "FA Depreciation Book"; var IsHandled: Boolean)
    begin
        // FADepreciationBook is not by Var...
        SetDefaultValues(FADepreciationBook);
    end;

    local procedure SetDefaultValues(var FADepreciationBook: Record "FA Depreciation Book")
    var
        FixedAsset: Record "Fixed Asset";
        FASubclass: Record "FA Subclass";
    begin
        FixedAsset.Get(FADepreciationBook."FA No.");
        if FixedAsset."FA Subclass Code" = '' then
            exit;
        FASubclass.Get(FixedAsset."FA Subclass Code");
        FADepreciationBook.Validate("Depreciation Method", FASubclass."wan Def. Depreciation Method");
        FADepreciationBook.Validate("Declining-Balance %", FASubclass."wan Def. Declining-Balance %");
        FADepreciationBook."No. of Depreciation Years" := FASubclass."wan Def. No. of Deprec. Years";
        FADepreciationBook."No. of Depreciation Months" := FASubclass."wan Def. No. of Deprec. Months";
        if FADepreciationBook."Depreciation Starting Date" <> 0D then begin
            FADepreciationBook.Validate("No. of Depreciation Years");
            FADepreciationBook.Validate("No. of Depreciation Months");
        end;
    end;
        [EventSubscriber(ObjectType::Table, Database::"FA Depreciation Book", 'OnAfterModifyEvent', '', false, false)]
        local procedure OnAfterModifyFADepreciationBook(var Rec: Record "FA Depreciation Book"; var xRec: Record "FA Depreciation Book"; RunTrigger: Boolean)
        begin
            SetDefaultValues(Rec);
        end;
    [EventSubscriber(ObjectType::Page, Page::"Fixed Asset Card", 'OnAfterValidateEvent', 'FA Subclass Code', false, false)]
    local procedure OnAfterValidateFASubclassCode(var Rec: Record "Fixed Asset"; var xRec: Record "Fixed Asset")
    var
        FADepreciationBook: Record "FA Depreciation Book";
        FASubclass: Record "FA Subclass";
    begin
        if Rec."FA Subclass Code" = '' then
            exit;
        FADepreciationBook.SetRange("FA No.", Rec."No.");
        if FADepreciationBook.Count <> 1 then
            exit;
        FADepreciationBook.FindFirst();
        FASubclass.Get(Rec."FA Subclass Code");
        FADepreciationBook.Validate("Depreciation Method", FASubclass."wan Def. Depreciation Method");
        FADepreciationBook.Validate("Declining-Balance %", FASubclass."wan Def. Declining-Balance %");
        FADepreciationBook."No. of Depreciation Years" := FASubclass."wan Def. No. of Deprec. Years";
        FADepreciationBook."No. of Depreciation Months" := FASubclass."wan Def. No. of Deprec. Months";
        if FADepreciationBook."Depreciation Starting Date" <> 0D then begin
            FADepreciationBook.Validate("No. of Depreciation Years");
            FADepreciationBook.Validate("No. of Depreciation Months");
        end;
        FADepreciationBook.Modify(true);
    end;
}
*/
