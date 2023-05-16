report 87058 "wan Employee - Trial Balance"
//report 329 "Employee - Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Employee/EmployeeTrialBalance.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Employee - Trial Balance';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("Employee Posting Group");
            RequestFilterFields = "No.", "Date Filter", "Employee Posting Group";
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(PeriodPeriodFilter; StrSubstNo(Text003, PeriodFilter))
            {
            }
            column(EmplPostGrpGroupTotal; StrSubstNo(Text005, FieldCaption("Employee Posting Group")))
            {
            }
            column(EmplTblCapEmplFilter; TableCaption + ': ' + EmplFilter)
            {
            }
            column(EmplFilter; EmplFilter)
            {
            }
            column(PeriodStartDate; Format(PeriodStartDate))
            {
            }
            column(PeriodFilter; PeriodFilter)
            {
            }
            column(FiscalYearStartDate; Format(FiscalYearStartDate))
            {
            }
            column(FiscalYearFilter; FiscalYearFilter)
            {
            }
            column(PeriodEndDate; Format(PeriodEndDate))
            {
            }
            column(EmployeePostingGroup_Employee; "Employee Posting Group")
            {
            }
            column(YTDTotal; YTDTotal)
            {
                AutoFormatType = 1;
            }
            column(YTDCreditAmt; YTDCreditAmt)
            {
                AutoFormatType = 1;
            }
            column(YTDDebitAmt; YTDDebitAmt)
            {
                AutoFormatType = 1;
            }
            column(YTDBeginBalance; YTDBeginBalance)
            {
            }
            column(PeriodCreditAmt; PeriodCreditAmt)
            {
            }
            column(PeriodDebitAmt; PeriodDebitAmt)
            {
            }
            column(PeriodBeginBalance; PeriodBeginBalance)
            {
            }
            //[
            /*
            column(Name_Employee; Name)
            {
                IncludeCaption = true;
            }
            */
            column(Name_Employee; FullName())
            {
                //IncludeCaption = true;
            }
            column(Name_EmployeeCaption; Name_EmployeeCaption)
            {
                //IncludeCaption = true;
            }
            //]

            column(No_Employee; "No.")
            {
                IncludeCaption = true;
            }
            column(TotForFrmtEmplPostGrp; Text004 + Format(' ') + "Employee Posting Group")
            {
            }
            column(EmplTrialBalanceCap; EmplTrialBalanceCapLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AmountsinLCYCaption; AmountsinLCYCaptionLbl)
            {
            }
            column(EmplWithEntryPeriodCapt; EmplWithEntryPeriodCaptLbl)
            {
            }
            column(PeriodBeginBalCap; PeriodBeginBalCapLbl)
            {
            }
            column(PeriodDebitAmtCaption; PeriodDebitAmtCaptionLbl)
            {
            }
            column(PeriodCreditAmtCaption; PeriodCreditAmtCaptionLbl)
            {
            }
            column(YTDTotalCaption; YTDTotalCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(FiscalYearToDateCaption; FiscalYearToDateCaptionLbl)
            {
            }
            column(NetChangeCaption; NetChangeCaptionLbl)
            {
            }
            column(TotalinLCYCaption; TotalinLCYCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcAmounts(
                  PeriodStartDate, PeriodEndDate,
                  PeriodBeginBalance, PeriodDebitAmt, PeriodCreditAmt, YTDTotal);

                CalcAmounts(
                  FiscalYearStartDate, PeriodEndDate,
                  YTDBeginBalance, YTDDebitAmt, YTDCreditAmt, YTDTotal);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        with Employee do begin
            PeriodFilter := GetFilter("Date Filter");
            PeriodStartDate := GetRangeMin("Date Filter");
            PeriodEndDate := GetRangeMax("Date Filter");
            SetRange("Date Filter");
            EmplFilter := GetFilters();
            SetRange("Date Filter", PeriodStartDate, PeriodEndDate);
            AccountingPeriod.SetRange("Starting Date", 0D, PeriodEndDate);
            AccountingPeriod.SetRange("New Fiscal Year", true);
            if AccountingPeriod.FindLast() then
                FiscalYearStartDate := AccountingPeriod."Starting Date"
            else
                Error(Text000, AccountingPeriod.FieldCaption("Starting Date"), AccountingPeriod.TableCaption());
            FiscalYearFilter := Format(FiscalYearStartDate) + '..' + Format(PeriodEndDate);
        end;
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        PeriodBeginBalance: Decimal;
        PeriodDebitAmt: Decimal;
        PeriodCreditAmt: Decimal;
        YTDBeginBalance: Decimal;
        YTDDebitAmt: Decimal;
        YTDCreditAmt: Decimal;
        YTDTotal: Decimal;
        PeriodFilter: Text;
        FiscalYearFilter: Text;
        EmplFilter: Text;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        FiscalYearStartDate: Date;
        EmplTrialBalanceCapLbl: Label 'Employee - Trial Balance';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AmountsinLCYCaptionLbl: Label 'Amounts in LCY';
        EmplWithEntryPeriodCaptLbl: Label 'Only includes Employees with entries in the period';
        PeriodBeginBalCapLbl: Label 'Beginning Balance';
        PeriodDebitAmtCaptionLbl: Label 'Debit';
        PeriodCreditAmtCaptionLbl: Label 'Credit';
        YTDTotalCaptionLbl: Label 'Ending Balance';
        PeriodCaptionLbl: Label 'Period';
        FiscalYearToDateCaptionLbl: Label 'Fiscal Year-To-Date';
        NetChangeCaptionLbl: Label 'Net Change';
        TotalinLCYCaptionLbl: Label 'Total in LCY';

        Text000: Label 'It was not possible to find a %1 in %2.';
        Text003: Label 'Period: %1';
        Text004: Label 'Total for';
        Text005: Label 'Group Totals: %1';
        //[
        Name_EmployeeCaption: Label 'Name';
    //]

    local procedure CalcAmounts(DateFrom: Date; DateTo: Date; var BeginBalance: Decimal; var DebitAmt: Decimal; var CreditAmt: Decimal; var TotalBalance: Decimal)
    var
        EmployeeCopy: Record Employee;
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";

    begin
        EmployeeCopy.Copy(Employee);
        EmployeeCopy.SetRange("Date Filter", 0D, DateFrom - 1);
        //[
        /*
        EmployeeCopy.CalcFields("Net Change (LCY)");
        BeginBalance := -EmployeeCopy."Net Change (LCY)";

        EmployeeCopy.SetRange("Date Filter", DateFrom, DateTo);
        EmployeeCopy.CalcFields("Debit Amount (LCY)", "Credit Amount (LCY)");
        DebitAmt := EmployeeCopy."Debit Amount (LCY)";
        CreditAmt := EmployeeCopy."Credit Amount (LCY)";
        */
        EmployeeCopy.CalcFields(Balance);
        BeginBalance := -EmployeeCopy.Balance;

        DetailedEmployeeLedgerEntry.SetRange("Employee No.", Employee."No.");
        DetailedEmployeeLedgerEntry.SetRange("Posting Date", DateFrom, DateTo);
        DetailedEmployeeLedgerEntry.CalcSums("Debit Amount (LCY)", "Credit Amount (LCY)");
        DebitAmt := DetailedEmployeeLedgerEntry."Debit Amount (LCY)";
        CreditAmt := DetailedEmployeeLedgerEntry."Credit Amount (LCY)";
        //]

        TotalBalance := BeginBalance + DebitAmt - CreditAmt;
    end;
}

