permissionset 87059 "WanaMisc_Self_Usage"
{
    Assignable = true;
    Caption = 'WanaMisc Self-usage';
    Permissions =
        tabledata "wan Self Usage Account" = RIMD,
        table "wan Self Usage Account" = X,
        codeunit "wan Self Usage Events" = X;
}