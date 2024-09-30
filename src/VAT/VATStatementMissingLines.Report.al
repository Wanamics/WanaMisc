report 87052 "wan VATStatement Missing Lines"
{
    Caption = 'VAT Statement Missing Lines';
    ProcessingOnly = true;
    dataset
    {
        dataitem(VATSTatementLine; "VAT Statement Line")
        {


        }
        dataitem(VATEntry; "VAT Entry")
        {
            DataItemTableView = sorting(Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date", "G/L Acc. No.", "VAT Reporting Date");
            // Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Tax Jurisdiction Code", "Use Tax", "Posting Date", "G/L Acc. No."
            //  "Posting Date", Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", Reversed, "G/L Acc. No.", "VAT Reporting Date");

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
