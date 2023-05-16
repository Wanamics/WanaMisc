pageextension 87056 "wan FA Subclasses" extends "FA Subclasses"
{
    layout
    {
        addlast(Control1)
        {
            field("Depreciation Method"; Rec."wan Def. Depreciation Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Depreciation Method field.';
            }
            field("No. of Depreciation Years"; Rec."wan Def. No. of Deprec. Years")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Depreciation Years field.';
            }
            field("Declining-Balance %"; Rec."wan Def. Declining-Balance %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Declining-Balance % field.';
            }
        }
    }
}
