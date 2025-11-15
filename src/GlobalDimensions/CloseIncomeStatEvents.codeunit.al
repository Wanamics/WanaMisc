namespace Wanamics.WanaDim.GlobalDimensions;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Journal;
codeunit 87053 "Close Income Stat. Events"
{
    [EventSubscriber(ObjectType::Report, Report::"Close Income Statement", OnBeforeCheckDimPostingRules, '', false, false)]
    local procedure OnBeforeCheckDimPostingRules(var SelectedDimension: Record "Selected Dimension"; var ErrorText: Text[1024]; var Handled: Boolean; GenJnlLine: Record "Gen. Journal Line")
    begin
        ErrorText := CheckDimPostingRules(SelectedDimension);
        Handled := true;
    end;

    local procedure CheckDimPostingRules(var SelectedDim: Record "Selected Dimension"): Text[1024]
    // replace Report::"Close Income Statement" CheckDimPostingRules (with Handled := true)
    var
        DefaultDim: Record "Default Dimension";
        ErrorText: Text[1024];
        DimText: Text[1024];
        PrevAcc: Code[20];
        //[
        Handled: Boolean;
        Text020: Label 'The following G/L Accounts have mandatory dimension codes that have not been selected:';
        Text021: Label '\\In order to post to these accounts you must also select these dimensions:';
        GenJnlLine: Record "Gen. Journal Line";
        GLAccount: Record "G/L Account";
    //]
    begin
        /*[
        OnBeforeCheckDimPostingRules(SelectedDim, ErrorText, Handled, GenJnlLine);
        if Handled then
            exit(ErrorText);
        ]*/

        DefaultDim.SetRange("Table ID", DATABASE::"G/L Account");
        DefaultDim.SetFilter(
          "Value Posting", '%1|%2',
          DefaultDim."Value Posting"::"Same Code", DefaultDim."Value Posting"::"Code Mandatory");

        PrevAcc := '';
        if DefaultDim.Find('-') then
            repeat
                SelectedDim.SetRange("Dimension Code", DefaultDim."Dimension Code");
                //[
                if GLAccount.Get(DefaultDim."No.") and (GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement") then
                    //]
                    if not SelectedDim.Find('-') then begin
                        if StrPos(DimText, DefaultDim."Dimension Code") < 1 then
                            DimText := DimText + ' ' + Format(DefaultDim."Dimension Code");
                        if PrevAcc <> DefaultDim."No." then begin
                            PrevAcc := DefaultDim."No.";
                            if ErrorText = '' then
                                ErrorText := Text020;
                            ErrorText := ErrorText + ' ' + Format(DefaultDim."No.");
                        end;
                    end;
                SelectedDim.SetRange("Dimension Code");
            until (DefaultDim.Next() = 0) or (StrLen(ErrorText) > MaxStrLen(ErrorText) - MaxStrLen(DefaultDim."No.") - StrLen(Text021) - 1);
        if ErrorText <> '' then
            ErrorText := CopyStr(ErrorText + Text021 + DimText, 1, MaxStrLen(ErrorText));
        exit(ErrorText);
    end;
}
