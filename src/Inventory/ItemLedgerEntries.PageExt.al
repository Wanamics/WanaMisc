pageextension 87056 "wan Item Ledger Entries" extends "Item Ledger Entries"
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
