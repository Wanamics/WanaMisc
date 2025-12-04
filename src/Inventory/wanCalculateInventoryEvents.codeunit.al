codeunit 87060 "wan CalculateInventory Events"
{
    [EventSubscriber(ObjectType::Report, Report::"Calculate Inventory", OnItemLedgerEntryOnAfterPreDataItem, '', false, false)]
    local procedure OnItemLedgerEntryOnAfterPreDataItem(var ItemLedgerEntry: Record "Item Ledger Entry"; var Item: Record Item)
    begin
        if Item.GetFilter("Date Filter") <> '' then
            ItemLedgerEntry.SetRange("Posting Date", 0D, Item.GetRangeMax("Date Filter"));
    end;
}
