namespace Wanamics.WanaMisc.CheckDirectPosting;

using Microsoft.Finance.GeneralLedger.Account;
pageextension 87067 "WanaMisc Chart of Accounts" extends "Chart of Accounts"
{
    actions
    {
        addlast(processing)
        {
            action(wanCheckDirectPosting)
            {
                ApplicationArea = All;
                Caption = 'Check Direct Posting';
                Image = CheckList;
                RunObject = report "WanaMisc Check Direct Posting";
            }
        }
    }
}
