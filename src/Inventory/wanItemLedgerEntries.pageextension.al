namespace Wanamics.WanaMisc.Inventory;

using Microsoft.Inventory.Ledger;
pageextension 87061 "wan Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        modify("Document No.")
        {
            trigger OnDrillDown()
            begin
                Rec.ShowDoc();
            end;
        }
    }
}
