pageextension 87063 "WanaMisc VAT Statement" extends "VAT Statement"
{
    actions
    {
        addlast("F&unctions")
        {
            action(wanAddMissingVATLines)
            {
                Caption = 'Add Missing VAT Lines';
                ApplicationArea = All;
                Ellipsis = true;
                Image = Add;
                trigger OnAction()
                var
                    // VATStatementDistinctPosting: Query "wan VAT Statement Distinct";
                    ConfirmLbl: Label 'Do you want to add missing lines?';
                begin
                    if not Confirm(ConfirmLbl, false) then
                        exit;
                    AddMissingLine("General Posting Type"::Purchase, "VAT Statement Line Amount Type"::Base);
                    AddMissingLine("General Posting Type"::Purchase, "VAT Statement Line Amount Type"::Amount);
                    AddMissingLine("General Posting Type"::Sale, "VAT Statement Line Amount Type"::Base);
                    AddMissingLine("General Posting Type"::Sale, "VAT Statement Line Amount Type"::Amount);
                end;
            }
        }
    }

    local procedure AddMissingLine(pGeneralPostingType: Enum "General Posting Type"; pAmountType: Enum "VAT Statement Line Amount Type")
    var
        VATEntryQuery: Query "wan VAT Statement Distinct";
        VATStatementLine: Record "VAT Statement Line";
    begin
        VATEntryQuery.SetRange(Type, pGeneralPostingType, VATEntryQuery.Type::Sale);
        if VATEntryQuery.Open() then
            while VATEntryQuery.Read() do begin
                VATStatementLine.Copy(Rec);
                VATStatementLine.Init();
                VATStatementLine.SetRange("VAT Bus. Posting Group", VATEntryQuery.VATBusPostingGroup);
                VATStatementLine.SetRange("VAT Bus. Posting Group", VATEntryQuery.VATProdPostingGroup);
                VATStatementLine.SetRange(Type, VATEntryQuery.Type);
                VATStatementLine.SetRange("Amount Type", pAmountType);
                if VATStatementLine.IsEmpty then
                    AppendVATStatementLine(VATEntryQuery, pAmountType);
            end;
    end;

    local procedure AppendVATStatementLine(var pQuery: Query "wan VAT Statement Distinct"; pAmountType: Enum "VAT Statement Line Amount Type")
    var
        VATStatementLine: Record "VAT Statement Line";
    begin
        VATStatementLine.Copy(Rec);
        VATStatementLine.Init();
        if VATStatementLine.FindLast() then;
        VATStatementLine."Line No." += 10000;
        VATStatementLine."VAT Bus. Posting Group" := pQuery.VATBusPostingGroup;
        VATStatementLine."VAT Prod. Posting Group" := pQuery.VATProdPostingGroup;
        VATStatementLine."Gen. Posting Type" := pQuery.Type;
        VATStatementLine."Amount Type" := pAmountType;
        VATStatementLine.Insert(true);
    end;
}
