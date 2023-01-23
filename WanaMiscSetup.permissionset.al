permissionset 87051 WanaMisc_SETUP
{
    Assignable = true;
    Permissions =
        tabledata "wan Global Dimension Setup" = RIMD,
        table "wan Global Dimension Setup" = X,
        report "wan Remaining VAT" = X,
        report "wan Set Next No. Series Line" = X,
        codeunit "wan Global Dimension Events" = X,
        codeunit "wan VAT Events" = X;
}