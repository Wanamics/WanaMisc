pageextension 87061 "WanaMisc Vendor Card" extends "Vendor Card"
{
    layout
    {
        moveafter("No."; "VAT Registration No.")
        modify("VAT Registration No.")
        {
            trigger OnBeforeValidate()
            var
                CountryRegion: Record "Country/Region";
            begin
                if (Rec."VAT Registration No." = '') or (rec."Country/Region Code" <> '') then
                    exit;
                if CountryRegion.Get(CopyStr(Rec."VAT Registration No.", 1, 2)) then
                    Rec.Validate("Country/Region Code", CountryRegion.Code);
            end;
        }
    }
}
