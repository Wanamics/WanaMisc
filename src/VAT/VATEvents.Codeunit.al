codeunit 87056 "wan VAT Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertVAT', '', false, false)]
    local procedure OnBeforeInsertVAT(var GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry"; var UnrealizedVAT: Boolean; var AddCurrencyCode: Code[10]; var VATPostingSetup: Record "VAT Posting Setup"; var GLEntryAmount: Decimal; var GLEntryVATAmount: Decimal; var GLEntryBaseAmount: Decimal; var SrcCurrCode: Code[10]; var SrcCurrGLEntryAmt: Decimal; var SrcCurrGLEntryVATAmt: Decimal; var SrcCurrGLEntryBaseAmt: Decimal)
    var
        MustBeCustomerOrVendorForUnrealizedVAT: Label 'must be Customer or Vendor for unrealized VAT';
    begin
        if (VATEntry."Unrealized Base" <> 0) and (VATEntry."Bill-to/Pay-to No." = '') then
            GenJournalLine.FieldError("Source Type", MustBeCustomerOrVendorForUnrealizedVAT);
    end;
}