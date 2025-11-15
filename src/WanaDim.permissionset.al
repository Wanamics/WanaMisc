namespace Wanamics.WanaDim.GlobalDimensions;

permissionset 87050 "WanaDim"
{
    Caption = 'WanaDim Dimensions';
    Assignable = true;
    Permissions =
        tabledata "wan Global Dimension Setup" = RIMD,
        table "wan Global Dimension Setup" = X,
        codeunit "Global Dimension Events" = X;
}