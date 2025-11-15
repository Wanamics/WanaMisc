#if FALSE
namespace Wanamics.WanaMisc.Logos;

using Microsoft.Sales.Customer;

pageextension 87066 "wan Customer List" extends "Customer List"
{
    actions
    {
        addlast(Processing)
        {
            action(wanAddLogos)
            {
                ApplicationArea = All;
                Caption = 'Add Logos';
                Image = Picture;
                ToolTip = 'Add logos to customers based on their home page or email address.';
                trigger OnAction()
                begin
                    wanAddLogos();
                end;
            }
        }
    }
    procedure wanAddLogos()
    var
        Customer: Record Customer;
        Domain: Text;
        Emails: List of [Text];
        // HttpClient: HttpClient;
        // HttpRequest: HttpRequestMessage;
        // HttpResponse: HttpResponseMessage;
        InStream: InStream;
        // OutStream: OutStream;
        LogoHelper: Codeunit "wan Logo Helper";

    begin
        if Customer.FindSet() then
            repeat
                Customer.Validate("Home Page");
                // if Customer."E-Mail" <> '' then begin
                //     if not Customer.Image.HasValue() then
                Customer.Validate("E-Mail");
            // if not Customer.Image.HasValue() then begin
            //     // Clear(HttpRequest);
            //     Domain := '';
            //     if Customer."Home Page" <> '' then
            //         Domain := Customer."Home Page"
            //     else if Customer."E-Mail" <> '' then begin
            //         Emails := Customer."E-Mail".Split(';');
            //         Domain := Emails.Get(1).Split('@').Get(2);
            //     end;
            // if Domain <> '' then begin
            //     HttpRequest.SetRequestUri('https://logo.clearbit.com/' + Domain);
            //     HttpRequest.Method('GET');
            //     if not HttpClient.Send(HttpRequest, HttpResponse) then
            //         Error(GetLastErrorText)
            //     else if HttpResponse.IsSuccessStatusCode() then begin
            //         HttpResponse.Content.ReadAs(InStream);
            //         Customer.Image.ImportStream(InStream, 'logo.png', 'image/apng');
            //         Customer.Modify(true);
            //     end;
            // end;
            //     if LogoHelper.SetLogo(InStream, Domain) then begin
            //         Customer.Image.ImportStream(InStream, 'logo.png', 'image/apng');
            //         Customer.Modify(true);
            //     end;;
            // end;
            until Customer.Next() = 0;
    end;
}
#endif
