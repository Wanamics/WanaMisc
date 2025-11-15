namespace Wanamics.WanaMisc.Permissions;

using System.Reflection;
pageextension 87065 "wan All Objects with Caption" extends "All Objects with Caption"
{
    actions
    {
        addlast(Navigation)
        {
            action(PermissionSets)
            {
                ApplicationArea = All;
                RunObject = page "wan Permissions";
                RunPageLink = "Object Type" = field("Object Type"), "Object ID" = field("Object ID");
            }
        }
        addlast(Promoted)
        {
            actionref(PermissionSet_Promoted; PermissionSets) { }
        }
    }
}
