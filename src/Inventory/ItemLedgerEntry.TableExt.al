tableextension 87051 "wan Item Ledger Entry" extends "Item Ledger Entry"
{
    procedure ShowDoc(): Boolean
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ReturnReceiptHeader: Record "Return Receipt Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnShipmentHeader: Record "Return Shipment Header";
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        PurchaseRcptHeader: Record "Purch. Rcpt. Header";
        PurchaseInvHeader: Record "Purch. Inv. Header";
        PurchaseShipmentHeader: Record "Return Shipment Header";
        PurchaseCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferReceiptHeader: Record "Transfer Receipt Header";
        ServiceShipmentHeader: Record "Service Shipment Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        PostedAssemblyHeader: Record "Posted Assembly Header";
        IsHandled: Boolean;
        IsPageOpened: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowDoc(Rec, IsPageOpened, IsHandled);
        if IsHandled then
            exit(IsPageOpened);

        case "Document Type" of
            "Document Type"::"Sales Shipment":
                if SalesShipmentHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Sales Shipment", SalesShipmentHeader);
                    exit(true);
                end;
            "Document Type"::"Sales Invoice":
                if SalesInvoiceHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
                    exit(true);
                end;
            "Document Type"::"Sales Return Receipt":
                if ReturnReceiptHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Return Shipment", ReturnReceiptHeader);
                    exit(true);
                end;
            "Document Type"::"Sales Credit Memo":
                if SalesCrMemoHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                    exit(true);
                end;

            "Document Type"::"Purchase Receipt":
                if PurchaseShipmentHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Purchase Receipt", PurchaseRcptHeader);
                    exit(true);
                end;
            "Document Type"::"Purchase Invoice":
                if PurchaseInvoiceHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Purchase Invoice", PurchaseInvoiceHeader);
                    exit(true);
                end;
            "Document Type"::"Purchase Return Shipment":
                if ReturnReceiptHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Return Shipment", ReturnShipmentHeader);
                    exit(true);
                end;
            "Document Type"::"Purchase Credit Memo":
                if PurchaseCrMemoHdr.Get("Document No.") then begin
                    Page.Run(Page::"Posted Purchase Credit Memo", PurchaseCrMemoHdr);
                    exit(true);
                end;

            "Document Type"::"Transfer Shipment":
                if TransferShipmentHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Transfer Shipment", TransferShipmentHeader);
                    exit(true);
                end;
            "Document Type"::"Transfer Receipt":
                if TransferReceiptHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Transfer Receipt", TransferReceiptHeader);
                    exit(true);
                end;
            "Document Type"::"Service Shipment":
                if ServiceShipmentHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Service Shipment", ServiceShipmentHeader);
                    exit(true);
                end;
            "Document Type"::"Service Invoice":
                if ServiceInvoiceHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Service Invoice", ServiceInvoiceHeader);
                    exit(true);
                end;
            "Document Type"::"Service Credit Memo":
                if ServiceCrMemoHeader.Get("Document No.") then begin
                    PAGE.Run(PAGE::"Posted Service Credit Memo", ServiceCrMemoHeader);
                    exit(true);
                end;
            "Document Type"::"Posted Assembly":
                if PostedAssemblyHeader.Get("Document No.") then begin
                    Page.Run(Page::"Posted Assembly Order", PostedAssemblyHeader);
                    exit(true);
                end;
        // "Document Type"::"Inventory Receipt":
        //     begin
        //     end;
        // "Document Type"::"Inventory Shipment":
        //     begin
        //     end;
        // "Document Type"::"Direct Transfer":
        //     begin
        //     end;
        end;

        OnAfterShowDoc(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowDoc(ItemLedgerEntry: Record "Item Ledger Entry"; var IsPageOpened: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShowDoc(var ItemLedgerEntry: Record "Item Ledger Entry")
    begin
    end;

}
