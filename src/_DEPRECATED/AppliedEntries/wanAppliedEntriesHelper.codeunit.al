#if FALSE // moved to WanApply
namespace Wanamics.WanaMisc.AppliedEntries;

codeunit 87055 "wan Applied Entries Helper"
{
    procedure AppliedToCode(EntryNo: Integer; Open: Boolean; ClosedByEntryNo: Integer): Text
    begin
        if ClosedByEntryNo <> 0 then
            exit(Base26(ClosedByEntryNo))
        else if not Open then
            exit(Base26(EntryNo));
    end;

    local procedure Base26(pColumnNo: Integer) ReturnValue: Text
    var
        c: char;
    begin
        while pColumnNo >= 1 do begin
            c := pColumnNo mod 26 + 65;
            ReturnValue := c + ReturnValue;
            pColumnNo := pColumnNo div 26;
        end;
    end;
}
#endif
