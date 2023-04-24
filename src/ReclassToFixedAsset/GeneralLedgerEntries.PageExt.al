pageextension 87057 "wan General Ledger Entries" extends "General Ledger Entries"
{
    actions
    {
        addlast(processing)
        {
            action(wanReclassToFixedAsset)
            {
                ApplicationArea = All;
                Caption = 'Reclass to Fixed Asset';

                trigger OnAction()
                var
                    lRec: Record "G/L Entry";
                    ExpenseToFixedAsset: Report "wan Reclass to Fixed Asset";
                begin
                    CurrPage.SetSelectionFilter(lRec);
                    ExpenseToFixedAsset.SetTableView(lRec);
                    ExpenseToFixedAsset.SetFromGLEntry(Rec);
                    ExpenseToFixedAsset.RunModal();
                end;
            }
        }
    }
}
