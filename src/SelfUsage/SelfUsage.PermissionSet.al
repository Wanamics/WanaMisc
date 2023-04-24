permissionset 87059 "WanaMisc_Self_Usage"
{
    Assignable = true;
    Caption = 'WanaMisc Self-usage';
    Permissions =
        tabledata "WanaMisc Self Usage Account" = RIMD,
        table "WanaMisc Self Usage Account" = X,
        codeunit "WanaMisc Self Usage Events" = X;
}