pageextension 87069 "WanaWho Users" extends Users
{
    actions
    {
        addlast(processing)
        {
            action(Export)
            {
                ApplicationArea = All;
                Image = Export;
                Caption = 'Export WanaWho';

                trigger OnAction()
                var
                    lRec: Record User;
                    ExcelUsers: Codeunit "WanaWho Users Excel";
                begin
                    CurrPage.SetSelectionFilter(lRec);
                    ExcelUsers.Export(lRec);
                end;
            }
            action(Import)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Import WahaWho';

                trigger OnAction()
                var
                    ExcelUsers: Codeunit "WanaWho Users Excel";
                begin
                    ExcelUsers.Import(Rec);
                end;
            }
        }
    }
}