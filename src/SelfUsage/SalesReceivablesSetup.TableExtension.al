tableextension 87058 "wan Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(87058; "wan Self Usage Customer No."; Code[20])
        {
            Caption = 'Self Usage Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            //ValidateTableRelation = false;
        }
    }
}
