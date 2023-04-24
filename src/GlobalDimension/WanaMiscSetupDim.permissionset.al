permissionset 87050 WanaMisc_DIM
{
    Caption = 'WanaMisc Dimensions';
    Assignable = true;
    Permissions =
        tabledata "wan Global Dimension Setup" = RIMD,
        table "wan Global Dimension Setup" = X,
        report "wan Set Next No. Series Line" = X,
        codeunit "wan Global Dimension Events" = X;
}