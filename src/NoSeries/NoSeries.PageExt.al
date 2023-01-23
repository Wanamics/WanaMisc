pageextension 87055 "wan No. Series" extends "No. Series"
{
    actions
    {
        addlast(Processing)
        {
            action(wanSetNextNoSeriesLine)
            {
                Caption = 'Set Next No. Series Line';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Report.RunModal(Report::"wan Set Next No. Series Line", true, false);
                end;
            }
        }
    }
}
