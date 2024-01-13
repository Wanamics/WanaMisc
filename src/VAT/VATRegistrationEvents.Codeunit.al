codeunit 87052 "wan VAT Registration Events"
{
    [EventSubscriber(ObjectType::Table, Database::"VAT Registration Log", OnBeforeValidateField, '', false, false)]
    local procedure SplitAddress(var RecordRef: RecordRef; FieldName: Text; var Value: Text; var IsHandled: Boolean)
    var
        Customer: Record Customer; // Address FieldIds are the same for Customer, Vendor or Contact 
        FieldRef: FieldRef;
        i, j : Integer;
    begin
        if (FieldName <> Customer.FieldName(Address)) or (Value = '') then
            exit;
        i := StrLen(Value);
        while (i > 1) and (Value[i] <> ',') and (not (Value[i] in ['0' .. '9']) or (not (Value[i - 1] in ['0' .. '9']) or not (Value[i - 2] in ['0' .. '9']))) do
            i -= 1;
        if Value[i] = ',' then
            i += 1
        else
            while (i > 1) and (Value[i - 1] in ['0' .. '9', 'A' .. 'Z', '-', '_', '.']) do
                i -= 1;
        FieldRef := RecordRef.Field(Customer.FieldNo(Address));
        FieldRef.Value := Value.Substring(1, i - 2);

        if Value[i] <> ',' then
            while (i + j < Strlen(Value)) and ((Value[i + j] <> ' ') or (Value[i + j + 1] in ['0' .. '9'])) do
                j += 1;
        FieldRef := RecordRef.Field(Customer.FieldNo("Post Code"));
        FieldRef.Value := Value.Substring(i, j);

        i += j + 1;
        while Value[i] in [' ', '-', '_'] do
            i += 1;
        FieldRef := RecordRef.Field(Customer.FieldNo(City));
        FieldRef.Value := CopyStr(Value, i, MaxStrLen(Customer.City));

        IsHandled := true;
    end;
}
