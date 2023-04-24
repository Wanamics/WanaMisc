codeunit 87059 "wan Self Usage Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnFillInvoicePostingBufferOnBeforeSetInvDiscAccount', '', false, false)]
    local procedure OnFillInvoicePostingBufferOnBeforeSetInvDiscAccount(SalesLine: Record "Sales Line"; GenPostingSetup: Record "General Posting Setup"; var InvDiscAccount: Code[20]; var IsHandled: Boolean)
    var
        SelfUsageAccount: Record "wan Self Usage Account";
    begin
        if not SelfUsageAccount.Get(SalesLine."Gen. Bus. Posting Group", SalesLine."Item Category Code") then
            exit;
        InvDiscAccount := SelfUsageAccount."Invoice Disc. Account No.";
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Category", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteItemCategory(var Rec: Record "Item Category")
    var
        SelfUsageAccount: Record "wan Self Usage Account";
    begin
        SelfUsageAccount.SetRange("Item Category Code", Rec.Code);
        SelfUsageAccount.DeleteAll(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Product Posting Group", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteGenProdPostingGroup(var Rec: Record "Gen. Product Posting Group")
    var
        SelfUsageAccount: Record "wan Self Usage Account";
    begin
        SelfUsageAccount.SetRange("Item Category Code", Rec.Code);
        SelfUsageAccount.DeleteAll(true);
    end;
}
