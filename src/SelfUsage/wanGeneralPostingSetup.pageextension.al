namespace Wanamics.WanaMisc.SelfUsage;

using Microsoft.Finance.GeneralLedger.Setup;
pageextension 87064 "wan General Posting Setup" extends "General Posting Setup"
{
    actions
    {
        addlast(Navigation)
        {
            action(wanSelfUsageInvDiscAccounts)
            {
                Caption = 'Inv. Disc. Acc. per Item Category';
                ApplicationArea = All;
                RunObject = Page "wan Self Usage Accounts";
                RunPageLink = "Gen. Bus. Posting Group" = field("Gen. Bus. Posting Group");
            }
        }
    }
}
