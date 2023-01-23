Report 87056 "wan Remaining VAT"
{
    ApplicationArea = All;
    Caption = 'Remaining VAT';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(RemainingVAT; "VAT Entry")
        {
            RequestFilterFields = Type;

            trigger OnAfterGetRecord()
            begin
                TempVATEntry.TransferFields(RemainingVAT);
                TempVATEntry.Insert;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", 0D, PostingDate);
                SetFilter("Remaining Unrealized Amount", '<>0');
            end;
        }
        dataitem(RealizedAfterPostingDate; "VAT Entry")
        {
            DataItemTableView = sorting("Posting Date", Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", Reversed);

            trigger OnAfterGetRecord()
            begin
                if TempVATEntry.Get("Unrealized VAT Entry No.") then begin
                    TempVATEntry."Remaining Unrealized Amount" -= Amount;
                    TempVATEntry."Remaining Unrealized Base" -= Base;
                    TempVATEntry.Modify;
                end else begin
                    RemainingVAT.Get("Unrealized VAT Entry No.");
                    if RemainingVAT."Posting Date" <= PostingDate then begin
                        TempVATEntry.TransferFields(RemainingVAT);
                        TempVATEntry."Remaining Unrealized Amount" := Amount;
                        TempVATEntry."Remaining Unrealized Base" := Base;
                        TempVATEntry.Insert;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Posting Date", '>%1', PostingDate);
                SetFilter("Unrealized VAT Entry No.", '<>0');
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Export(TempVATEntry);
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        RowNo: Integer;
        ColumnNo: Integer;
        SheetName: label 'Data', Locked = true;
        PostingDate: Date;
        TempVATEntry: Record "VAT Entry" temporary;

    procedure Export(var pRec: Record "VAT Entry")
    var
        ltConfirm: Label 'Do-you want to create an Excel book for %1 %2(s)?';
        lProgressDialog: Codeunit "Progress Dialog";
    begin
        lProgressDialog.OpenCopyCountMax('', pRec.Count);
        RowNo := 1;
        ColumnNo := 1;
        ExportTitles(pRec);
        if pRec.FindSet then
            repeat
                lProgressDialog.UpdateCopyCount();
                RowNo += 1;
                ColumnNo := 1;
                ExportToExcelBuffer(pRec);
            until pRec.Next = 0;
        ExcelBuffer.CreateNewBook(SheetName);
        ExcelBuffer.WriteSheet(Format(PostingDate), CompanyName, UserId);
        ExcelBuffer.CloseBook;
        ExcelBuffer.SetFriendlyFilename(SafeFileName(pRec));
        ExcelBuffer.OpenExcel;
    end;

    local procedure SafeFileName(var pRec: Record "VAT Entry"): Text
    var
        FileManagement: Codeunit "File Management";
    begin
        exit(FileManagement.GetSafeFileName(CompanyName + ' ' + pRec.FieldCaption(pRec."Remaining Unrealized Amount") + ' ' + Format(PostingDate, 0, 9)));
    end;

    local procedure EnterCell(pRowNo: Integer; var pColumnNo: Integer; pCellValue: Text; pBold: Boolean; pUnderLine: Boolean; pNumberFormat: Text; pCellType: Option)
    begin
        ExcelBuffer.Init;
        ExcelBuffer.Validate(ExcelBuffer."Row No.", pRowNo);
        ExcelBuffer.Validate(ExcelBuffer."Column No.", pColumnNo);
        ExcelBuffer."Cell Value as Text" := pCellValue;
        ExcelBuffer.Formula := '';
        ExcelBuffer.Bold := pBold;
        ExcelBuffer.Underline := pUnderLine;
        ExcelBuffer.NumberFormat := pNumberFormat;
        ExcelBuffer."Cell Type" := pCellType;
        ExcelBuffer.Insert;
        pColumnNo += 1;
    end;

    local procedure ExportTitles(var pRec: Record "VAT Entry")
    begin
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec.Type), true, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec."Bill-to/Pay-to No."), true, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec."Posting Date"), true, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec."Document Type"), true, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec."Document No."), true, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec."VAT Bus. Posting Group"), true, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec."VAT Prod. Posting Group"), true, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec."Remaining Unrealized Amount"), true, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec.FieldCaption(pRec."Remaining Unrealized Base"), true, false, '', ExcelBuffer."cell type"::Text);
    end;

    local procedure ExportToExcelBuffer(var pRec: Record "VAT Entry")
    begin
        EnterCell(RowNo, ColumnNo, Format(pRec.Type), false, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec."Bill-to/Pay-to No.", false, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, Format(pRec."Posting Date"), false, false, '', ExcelBuffer."cell type"::Date);
        EnterCell(RowNo, ColumnNo, Format(pRec."Document Type"), false, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec."Document No.", false, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec."VAT Bus. Posting Group", false, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, pRec."VAT Prod. Posting Group", false, false, '', ExcelBuffer."cell type"::Text);
        EnterCell(RowNo, ColumnNo, Format(pRec."Remaining Unrealized Amount"), false, false, '', ExcelBuffer."cell type"::Number);
        EnterCell(RowNo, ColumnNo, Format(pRec."Remaining Unrealized Base"), false, false, '', ExcelBuffer."cell type"::Number);
    end;
}
