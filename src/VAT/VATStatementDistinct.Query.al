query 87050 "wan VAT Statement Distinct"
{
    Caption = 'wan VAT Statement Distinct Posting';
    QueryType = Normal;

    elements
    {
        dataitem(VATEntry; "VAT Entry")
        {
            column(VATBusPostingGroup; "VAT Bus. Posting Group")
            {
            }
            column(VATProdPostingGroup; "VAT Prod. Posting Group")
            {
            }
            column("Type"; "Type")
            {
            }
            column(Count)
            {
                Method = Count;
            }
        }
    }
    trigger OnBeforeOpen()
    begin
    end;
}
