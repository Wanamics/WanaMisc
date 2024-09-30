codeunit 87069 "WanaWho Users Excel"
{
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        RowNo: Integer;
        ColumnNo: Integer;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Resource: Record "Resource";
        Employee: Record "Employee";
        // UserGroupMember: Record "User Group Member";
        // Table 'User Group Member' is marked for removal. Reason: [220_UserGroups] Replaced by the Security Group Member Buffer table and Security Group codeunit in the security groups system; by Access Control table in the permission sets system. To learn more, go to https://go.microsoft.com/fwlink/?linkid=2245709.. Tag: 22.0.
        UserGroupMember: Record "Security Group Member Buffer";
        UserSetup: Record "User Setup";
        UserPersonalization: Record "User Personalization";

    procedure Import(var pUser: Record User)
    var
        IStream: InStream;
        FileName: Text;
    begin
        // if UploadIntoStream('', '', '', FileName, IStream) then begin
        if UploadIntoStream('', '', '', FileName, IStream) then begin
            ExcelBuffer.LockTable();
            ExcelBuffer.OpenBookStream(IStream, CompanyName);
            ExcelBuffer.ReadSheet();
            Initialize();
            AnalyzeData(pUser);
            ExcelBuffer.DeleteAll();
        end;
    end;

    local procedure Initialize()
    begin
    end;

    local procedure AnalyzeData(pUser: Record User)
    var
        lRowNo: Integer;
        lNext: Integer;
        lExists: Boolean;
        lCount: Integer;
        lProgress: Integer;
        lDialog: Dialog;
        ltAnalyzing: Label 'Analyzing Data';
    begin
        lDialog.Open(ltAnalyzing + '@1@@@@@@@@@@@@@@@@@@@@@@@@@');
        lDialog.Update(1, 0);
        ExcelBuffer.SetFilter("Row No.", '>1');
        lCount := ExcelBuffer.Count();
        if ExcelBuffer.FindSet() then
            repeat
                InitLine(pUser);
                lRowNo := ExcelBuffer."Row No.";
                repeat
                    lProgress += 1;
                    ImportCell(pUser, ExcelBuffer."Column No.", ExcelBuffer."Cell Value as Text");
                    lNext := ExcelBuffer.Next();
                until (lNext = 0) or (ExcelBuffer."Row No." <> lRowNo);
                InsertLine(pUser);
                lDialog.Update(1, Round(lProgress / lCount * 10000, 1));
            until lNext = 0;
    end;

    local procedure InitLine(var pUser: Record User)
    begin
        Clear(pUser);
        pUser."Change Password" := true;
        Clear(SalespersonPurchaser);
        Clear(Resource);
        Clear(Employee);
        Clear(UserGroupMember);
        Clear(UserSetup);
    end;

    local procedure InsertLine(var pUser: Record User)
    var
        lUser: Record "User";
    begin
        if pUser."User Name" <> '' then
            if lUser.Get(pUser."User Security ID") then begin
                if pUser.Modify(true) then;
            end else
                if pUser.Insert(true) then; // not allowed on SaaS, to be done from AAD
        if SalespersonPurchaser.Code <> '' then
            if not SalespersonPurchaser.Insert(true) then
                SalespersonPurchaser.Modify(true);
        if Resource."No." <> '' then
            if not Resource.Insert(true) then
                Resource.Modify(true);
        if Employee."No." <> '' then
            if not Employee.Insert(true) then
                Employee.Modify(true);
        // if UserGroupMember."User Group Code" <> '' then
        if UserGroupMember."Security Group Code" <> '' then
            if not UserGroupMember.Insert(true) then
                UserGroupMember.Modify(true);
        UserSetup.Validate("User ID");
        UserSetup.Validate("E-Mail", pUser."Contact Email");
        if UserSetup."Salespers./Purch. Code" <> SalespersonPurchaser.Code then
            UserSetup.Validate("Salespers./Purch. Code", SalespersonPurchaser.Code);
        if not UserSetup.Insert(true) then
            UserSetup.Modify(true);

        OnAfterInsert(pUser);
    end;

    local procedure ToDecimal(pCell: Text) ReturnValue: Decimal
    begin
        Evaluate(ReturnValue, ExcelBuffer."Cell Value as Text");
    end;

    local procedure ToDate(pCell: Text) ReturnValue: Date
    begin
        Evaluate(ReturnValue, ExcelBuffer."Cell Value as Text");
    end;

    procedure Export(var pUser: Record User)
    var
        ConfirmLbl: Label 'Do-you want to create an Excel book for %1 %2(s)?';
        ProgressDialog: Codeunit "Excel Buffer Dialog Management";
        FileNameLbl: Label 'WanaWho';
    begin
        if not Confirm(ConfirmLbl, true, pUser.Count, pUser.TableCaption) then
            exit;
        ProgressDialog.Open('');
        ExportTitles(pUser);
        if pUser.FindSet then
            repeat
                ProgressDialog.SetProgress(RowNo);
                ExportLine(pUser);
            until pUser.Next = 0;
        ProgressDialog.Close;

        ExcelBuffer.CreateNewBook(CompanyName);
        ExcelBuffer.WriteSheet(CompanyName, CompanyName, UserId);
        ExcelBuffer.CloseBook;
        ExcelBuffer.SetFriendlyFilename(FileNameLbl);
        ExcelBuffer.OpenExcel;
    end;

    local procedure SafeFileName(pFileName: Text): Text
    var
        FileManagement: Codeunit "File Management";
    begin
        exit(FileManagement.GetSafeFileName(pFileName));
    end;

    local procedure EnterCell(pRowNo: Integer; var pColumnNo: Integer; pCellValue: Text; pBold: Boolean; pUnderLine: Boolean; pNumberFormat: Text; pCellType: Option)
    begin
        ExcelBuffer.init();
        ExcelBuffer.Validate("Row No.", pRowNo);
        ExcelBuffer.Validate("Column No.", pColumnNo);
        ExcelBuffer."Cell Value as Text" := pCellValue;
        ExcelBuffer.Formula := '';
        ExcelBuffer.Bold := pBold;
        ExcelBuffer.Underline := pUnderLine;
        ExcelBuffer.NumberFormat := pNumberFormat;
        ExcelBuffer."Cell Type" := pCellType;
        ExcelBuffer.Insert();
        pColumnNo += 1;
    end;


    local procedure ExportTitles(pUser: Record User)
    var
        Caption: Text;
    begin
        RowNo := 1;
        ColumnNo := 1;
        Caption := pUser.TableCaption;
        EnterCell(RowNo, ColumnNo, Title(Caption, pUser.FieldCaption("User Security ID")), true, false, '', ExcelBuffer."Cell Type"::Text); // 1
        EnterCell(RowNo, ColumnNo, Title(Caption, pUser.FieldCaption("User Name")), true, false, '', ExcelBuffer."Cell Type"::Text); // 2
        Caption := Employee.TableCaption;
        EnterCell(RowNo, ColumnNo, Title(Caption, Employee.FieldCaption("First Name")), true, false, '', ExcelBuffer."Cell Type"::Text); // 3
        EnterCell(RowNo, ColumnNo, Title(Caption, Employee.FieldCaption("Last Name")), true, false, '', ExcelBuffer."Cell Type"::Text); // 4
        Caption := pUser.TableCaption;
        EnterCell(RowNo, ColumnNo, Title(Caption, pUser.FieldCaption("License Type")), true, false, '', ExcelBuffer."Cell Type"::Text); // 5
        EnterCell(RowNo, ColumnNo, Title(Caption, pUser.FieldCaption(State)), true, false, '', ExcelBuffer."Cell Type"::Text); // 6
        EnterCell(RowNo, ColumnNo, Title(Caption, pUser.FieldCaption("Contact Email")), true, false, '', ExcelBuffer."Cell Type"::Text); // 7
        Caption := UserGroupMember.TableCaption;
        // EnterCell(RowNo, ColumnNo, Title(Caption, UserGroupMember.FieldCaption("User Group Code")), true, false, '', ExcelBuffer."Cell Type"::Text); // 8
        EnterCell(RowNo, ColumnNo, Title(Caption, UserGroupMember.FieldCaption("Security Group Code")), true, false, '', ExcelBuffer."Cell Type"::Text); // 8
        Caption := UserPersonalization.TableCaption;
        EnterCell(RowNo, ColumnNo, Title(Caption, UserPersonalization.FieldCaption("Profile ID")), true, false, '', ExcelBuffer."Cell Type"::Text); // 9
        Caption := UserSetup.TableCaption;
        EnterCell(RowNo, ColumnNo, Title(Caption, UserSetup.FieldCaption("Approver ID")), true, false, '', ExcelBuffer."Cell Type"::Text); // 10
        EnterCell(RowNo, ColumnNo, Title(Caption, UserSetup.FieldCaption("Register Time")), true, false, '', ExcelBuffer."Cell Type"::Text); // 11
        Caption := SalespersonPurchaser.TableCaption;
        EnterCell(RowNo, ColumnNo, Title(Caption, SalespersonPurchaser.FieldCaption(Code)), true, false, '', ExcelBuffer."Cell Type"::Text); // 12
        EnterCell(RowNo, ColumnNo, Title(Caption, SalespersonPurchaser.FieldCaption("Job Title")), true, false, '', ExcelBuffer."Cell Type"::Text); // 13
        EnterCell(RowNo, ColumnNo, Title(Caption, SalespersonPurchaser.FieldCaption("Phone No.")), true, false, '', ExcelBuffer."Cell Type"::Text); // 14
        Caption := Employee.TableCaption;
        EnterCell(RowNo, ColumnNo, Title(Caption, Employee.FieldCaption("No.")), true, false, '', ExcelBuffer."Cell Type"::Text); // 15
        EnterCell(RowNo, ColumnNo, Title(Caption, Employee.FieldCaption(Gender)), true, false, '', ExcelBuffer."Cell Type"::Text); // 16
        EnterCell(RowNo, ColumnNo, Title(Caption, Employee.FieldCaption("Manager No.")), true, false, '', ExcelBuffer."Cell Type"::Text); // 17
        EnterCell(RowNo, ColumnNo, Title(Caption, Employee.FieldCaption("Employee Posting Group")), true, false, '', ExcelBuffer."Cell Type"::Text); // 18
        Caption := Resource.TableCaption;
        EnterCell(RowNo, ColumnNo, Title(Caption, Resource.FieldCaption("No.")), true, false, '', ExcelBuffer."Cell Type"::Text); // 19
        EnterCell(RowNo, ColumnNo, Title(Caption, Resource.FieldCaption("Base Unit of Measure")), true, false, '', ExcelBuffer."Cell Type"::Text); // 20
        EnterCell(RowNo, ColumnNo, Title(Caption, Resource.FieldCaption("Resource Group No.")), true, false, '', ExcelBuffer."Cell Type"::Text); // 21
        EnterCell(RowNo, ColumnNo, Title(Caption, Resource.FieldCaption("Gen. Prod. Posting Group")), true, false, '', ExcelBuffer."Cell Type"::Text); // 22
        EnterCell(RowNo, ColumnNo, Title(Caption, Resource.FieldCaption("Time Sheet Owner User ID")), true, false, '', ExcelBuffer."Cell Type"::Text); // 23
        EnterCell(RowNo, ColumnNo, Title(Caption, Resource.FieldCaption("Time Sheet Approver User ID")), true, false, '', ExcelBuffer."Cell Type"::Text); // 24

        OnAfterExportTitles(pUser, ColumnNo);
    end;

    local procedure Title(pTableCaption: Text; pFieldCaption: Text): Text
    begin
        exit(pFieldCaption + LineFeed() + '(' + pTableCaption + ')');
    end;

    procedure LineFeed() ReturnValue: Text[2];
    begin
        ReturnValue[1] := 13;
        ReturnValue[2] := 10;
    end;

    local procedure ExportLine(pUser: Record "User")
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Resource: Record "Resource";
        Employee: Record "Employee";
        // UserGroupMember: Record "User Group Member";
        UserGroupMember: Record "Security Group Member Buffer";
        UserSetup: Record "User Setup";
        UserPersonalization: Record "User Personalization";
    begin
        RowNo += 1;
        ColumnNo := 1;
        EnterCell(RowNo, ColumnNo, pUser."User Security ID", false, false, '', ExcelBuffer."Cell Type"::Text); // 1
        EnterCell(RowNo, ColumnNo, pUser."User Name", false, false, '', ExcelBuffer."Cell Type"::Text); // 2
        EnterCell(RowNo, ColumnNo, FirstName(pUser."Full Name"), false, false, '', ExcelBuffer."Cell Type"::Text); // 3
        EnterCell(RowNo, ColumnNo, LastName(pUser."Full Name"), false, false, '', ExcelBuffer."Cell Type"::Text); // 4
        EnterCell(RowNo, ColumnNo, Format(pUser."License Type"), false, false, '', ExcelBuffer."Cell Type"::Text); // 5
        EnterCell(RowNo, ColumnNo, Format(pUser.State), false, false, '', ExcelBuffer."Cell Type"::Text); // 6
        EnterCell(RowNo, ColumnNo, pUser."Contact Email", false, false, '', ExcelBuffer."Cell Type"::Text); // 7

        UserGroupMember.SetCurrentKey("User Name");
        UserGroupMember.SetRange("User Name", pUser."User Name");
        // UserGroupMember.SetRange("Company Name", CompanyName);
        if UserGroupMember.FindFirst() then;
        // EnterCell(RowNo, ColumnNo, UserGroupMember."User Group Code", false, false, '', ExcelBuffer."Cell Type"::Text); // 8
        EnterCell(RowNo, ColumnNo, UserGroupMember."Security Group Code", false, false, '', ExcelBuffer."Cell Type"::Text); // 8

        UserPersonalization.SetCurrentKey("User SID");
        UserPersonalization.SetRange("User SID", pUser."User Security ID");
        UserPersonalization.SetRange(Company, CompanyName);
        if UserPersonalization.FindFirst() then;
        EnterCell(RowNo, ColumnNo, UserPersonalization."Profile ID", false, false, '', ExcelBuffer."Cell Type"::Text); // 9

        if UserSetup.Get(pUser."User Name") then;
        EnterCell(RowNo, ColumnNo, UserSetup."Approver ID", false, false, '', ExcelBuffer."Cell Type"::Text); // 10
        EnterCell(RowNo, ColumnNo, Format(UserSetup."Register Time"), false, false, '', ExcelBuffer."Cell Type"::Text); // 11

        if UserSetup."Salespers./Purch. Code" <> '' then
            if SalespersonPurchaser.Get(UserSetup."Salespers./Purch. Code") then;
        EnterCell(RowNo, ColumnNo, SalespersonPurchaser.Code, false, false, '', ExcelBuffer."Cell Type"::Text); // 12
        EnterCell(RowNo, ColumnNo, SalespersonPurchaser."Job Title", false, false, '', ExcelBuffer."Cell Type"::Text); // 13
        EnterCell(RowNo, ColumnNo, SalespersonPurchaser."Phone No.", false, false, '', ExcelBuffer."Cell Type"::Text); // 14

        if SalespersonPurchaser.Code <> '' then begin
            Employee.SetRange("Salespers./Purch. Code", SalespersonPurchaser.Code);
            if Employee.FindFirst() then;
        end;
        EnterCell(RowNo, ColumnNo, Employee."No.", false, false, '', ExcelBuffer."Cell Type"::Text); // 15
        EnterCell(RowNo, ColumnNo, Format(Employee.Gender), false, false, '', ExcelBuffer."Cell Type"::Text); // 16
        EnterCell(RowNo, ColumnNo, Employee."Manager No.", false, false, '', ExcelBuffer."Cell Type"::Text); // 17
        EnterCell(RowNo, ColumnNo, Employee."Employee Posting Group", false, false, '', ExcelBuffer."Cell Type"::Text); // 18

        if Employee."Resource No." <> '' then begin
            if Resource.Get(Employee."Resource No.") then;
        end else
            if UserSetup."User ID" <> '' then begin
                Resource.SetRange("Time Sheet Owner User ID", UserSetup."User ID");
                if Resource.FindFirst() then;
            end;
        EnterCell(RowNo, ColumnNo, Resource."No.", false, false, '', ExcelBuffer."Cell Type"::Text); // 19
        EnterCell(RowNo, ColumnNo, Resource."Base Unit of Measure", false, false, '', ExcelBuffer."Cell Type"::Text); // 20
        EnterCell(RowNo, ColumnNo, Resource."Resource Group No.", false, false, '', ExcelBuffer."Cell Type"::Text); // 21
        EnterCell(RowNo, ColumnNo, Resource."Gen. Prod. Posting Group", false, false, '', ExcelBuffer."Cell Type"::Text); // 22
        EnterCell(RowNo, ColumnNo, Resource."Time Sheet Owner User ID", false, false, '', ExcelBuffer."Cell Type"::Text); // 23
        EnterCell(RowNo, ColumnNo, Resource."Time Sheet Approver User ID", false, false, '', ExcelBuffer."Cell Type"::Text); // 24

        OnAfterExportLine(pUser, ColumnNo);
    end;
    /*
    local procedure BlankZero(pValue : Integer) : Text
    var
        lblNumber: Label '<number>';
    begin
        if pValue = 0 then
            exit('')
        else
            exit(format(pValue, 0, lblNumber));
    end;
    */

    local procedure FirstName(pFullName: Text): Text
    var
        lPos: Integer;
    begin
        lPos := StrPos(pFullName, ' ');
        if lPos = 0 then
            exit('')
        ELSE
            exit(CopyStr(pFullName, 1, lPos - 1));
    end;

    local procedure LastName(pFullName: Text): Text
    var
        lPos: Integer;
    begin
        lPos := StrPos(pFullName, ' ');
        if lPos = 0 then
            exit(pFullName)
        ELSE
            exit(CopyStr(pFullName, lPos + 1));
    end;

    local procedure ToBoolean(pCell: Text) ReturnValue: Boolean
    begin
        Evaluate(ReturnValue, ExcelBuffer."Cell Value as Text");
    end;

    local procedure ToInteger(pCell: Text) ReturnValue: Integer
    begin
        Evaluate(ReturnValue, ExcelBuffer."Cell Value as Text");
    end;


    local procedure ImportCell(var pUser: Record User; pColumnNo: Integer; pCell: Text)
    begin
        case pColumnNo of
            1:
                pUser."User Security ID" := pCell;
            2:
                begin
                    pUser.SetRange("User Name", pCell);
                    if not pUser.FindFirst then
                        pUser."User Security ID" := CreateGuid();
                    pUser.Validate("User Name", pCell);
                    if not UserSetup.Get(pCell) then
                        UserSetup."User ID" := pUser."User Name";
                end;
            3:
                pUser.Validate("Full Name", pCell);
            4:
                pUser.Validate("Full Name", pUser."Full Name" + ' ' + pCell);
            5:
                if Evaluate(pUser."License Type", pCell) then
                    pUser.Validate("License Type");
            6:
                if Evaluate(pUser.State, pCell) then
                    pUser.Validate(State);
            7:
                pUser.Validate("Contact Email", pCell);
            8:
                // if not UserGroupMember.Get(UserGroupMember."User Group Code", pUser."User Security ID", CompanyName) then begin
                if not UserGroupMember.Get(UserGroupMember."Security Group Code", pUser."User Security ID", CompanyName) then begin
                    // UserGroupMember.Validate("User Group Code", pCell);
                    UserGroupMember.Validate("Security Group Code", pCell);
                    UserGroupMember."User Security ID" := pUser."User Security ID";
                    // UserGroupMember.Validate("Company Name", CompanyName);
                end;
            9:
                begin
                    if not UserPersonalization.Get(pUser."User Security ID") then
                        UserPersonalization."User SID" := pUser."User Security ID";
                    UserPersonalization.Validate("Profile ID", pCell);
                    UserPersonalization.Company := CompanyName;
                end;
            10:
                UserSetup.Validate("Approver ID", pCell);
            11:
                UserSetup.Validate("Register Time", ToBoolean(pCell));
            12:
                begin
                    if not SalespersonPurchaser.Get(pCell) then
                        SalespersonPurchaser.Validate(Code, pCell);
                    SalespersonPurchaser.Validate(Name, pUser."Full Name");
                    SalespersonPurchaser.Validate("E-Mail", pUser."Contact Email");
                end;
            13:
                SalespersonPurchaser.Validate("Job Title", pCell);
            14:
                SalespersonPurchaser.Validate("Phone No.", pCell);
            15:
                begin
                    if not Employee.Get(pCell) then
                        Employee.Validate("No.", pCell);
                    Employee.Validate("First Name", CellValue(0, 2));
                    Employee.Validate("Last Name", CellValue(0, 3));
                    if SalespersonPurchaser.Code <> '' then
                        Employee.Validate("Salespers./Purch. Code", SalespersonPurchaser.Code);
                    Employee.Validate("Job Title", SalespersonPurchaser."Job Title");
                    Employee.Validate("Phone No.", SalespersonPurchaser."Phone No.");
                    Employee.Validate("Company E-Mail", pUser."Contact Email");
                end;
            16:
                if Evaluate(Employee.Gender, pCell) then
                    Employee.Validate(Gender);
            17:
                Employee.Validate("Manager No.", pCell);
            18:
                Employee.Validate("Employee Posting Group", pCell);
            19:
                begin
                    if not Resource.Get(pCell) then
                        Resource.Validate("No.", pCell);
                    Resource.Validate(Name, pUser."Full Name");
                    Resource.Validate("Time Sheet Owner User ID", UserSetup."User ID");
                end;
            20:
                Resource.Validate("Base Unit of Measure", pCell);
            21:
                Resource.Validate("Resource Group No.", pCell);
            22:
                Resource.Validate("Gen. Prod. Posting Group", pCell);
            23:
                begin
                    Resource.Validate("Time Sheet Owner User ID", pCell);
                    Resource.Validate("Use Time Sheet", true);
                end;
            24:
                Resource.Validate("Time Sheet Approver User ID", pCell);
        end;
    end;

    local procedure CellValue(pRowNo: Integer; pColumnNo: Integer): Text
    var
        lExcelBuffer: Record "Excel Buffer" temporary;
    begin
        if pRowNo = 0 then
            pRowNo := ExcelBuffer."Row No.";
        if pColumnNo = 0 then
            pColumnNo := ExcelBuffer."Column No.";
        lExcelBuffer.Copy(ExcelBuffer, true);
        if lExcelBuffer.Get(pRowNo, pColumnNo) then
            exit(lExcelBuffer."Cell Value as Text");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterExportTitles(User: Record User; Column: Integer)
    begin
    end;

    local procedure OnAfterExportLine(User: Record User; Column: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterImportCell(Column: Integer; var User: Record User)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsert(var User: Record User)
    begin
    end;
}

