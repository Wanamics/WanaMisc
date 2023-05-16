tableextension 87051 "wan FA Subclass" extends "FA Subclass"
{
    fields
    {
        field(87050; "wan Def. Depreciation Method"; Enum "FA Depreciation Method")
        {
            Caption = 'Def. Depreciation Method';
            trigger OnValidate()
            begin
                if not DecliningMethod() then
                    Validate("wan Def. Declining-Balance %", 0);
            end;
        }
        field(87051; "wan Def. No. of Deprec. Years"; Decimal)
        {
            BlankZero = true;
            Caption = 'Def. No. of Depreciation Years';
            DecimalPlaces = 2 : 8;
            MinValue = 0;
        }
        field(87052; "wan Def. No. of Deprec. Months"; Decimal)
        {
            BlankZero = true;
            Caption = 'Def. No. of Depreciation Months';
            DecimalPlaces = 2 : 8;
            MinValue = 0;
        }
        field(87053; "wan Def. Declining-Balance %"; Decimal)
        {
            Caption = 'Def. Declining-Balance %';
            DecimalPlaces = 2 : 8;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("wan Def. Declining-Balance %" <> 0) and not DecliningMethod() then
                    FieldError("wan Def. Depreciation Method");
            end;
        }
    }
    protected procedure DecliningMethod(): Boolean
    begin
        exit(
          "wan Def. Depreciation Method" in
          ["wan Def. Depreciation Method"::"Declining-Balance 1",
           "wan Def. Depreciation Method"::"Declining-Balance 2",
           "wan Def. Depreciation Method"::"DB1/SL",
           "wan Def. Depreciation Method"::"DB2/SL"]);
    end;
}