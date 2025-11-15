namespace Wanamics.WanaMisc.SelfUsage;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.FixedAssets.Setup;
table 87069 "wan Self Usage Account"
{
    Caption = 'Self Usage Account';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(2; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(3; "Invoice Disc. Account No."; Code[20])
        {
            Caption = 'Invoice Disc. Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(4; "FA Subclass Code"; Code[20])
        {
            Caption = 'FA Subclass Code';
            DataClassification = ToBeClassified;
            TableRelation = "FA Subclass";
        }
    }
    keys
    {
        key(PK; "Gen. Bus. Posting Group", "Item Category Code")
        {
            Clustered = true;
        }
    }
}
