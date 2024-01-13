tableextension 87061 "WanaMisc Vendor" extends Vendor
{
    fields
    {
        modify("VAT Registration No.")
        {
            trigger OnBeforeValidate()
            var
                CountryRegion: Record "Country/Region";
            begin
                if (Rec."VAT Registration No." = '') or (Rec."Country/Region Code" <> '') then
                    exit;
                CountryRegion.SetCurrentKey("Intrastat Code");
                CountryRegion.SetRange("EU Country/Region Code", CopyStr(Rec."VAT Registration No.", 1, 2));
                if CountryRegion.FindFirst then
                    Rec.Validate("Country/Region Code", CountryRegion.Code);
            end;
        }
    }
}
