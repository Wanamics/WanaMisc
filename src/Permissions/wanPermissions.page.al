namespace Wanamics.WanaMisc.Permissions;

using System.Security.AccessControl;
page 87068 "wan Permissions"
{
    ApplicationArea = All;
    Caption = 'Permissions';
    PageType = List;
    SourceTable = "Expanded Permission";
    UsageCategory = Administration;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Role ID"; Rec."Role ID") { }
                field("Role Name"; Rec."Role Name") { }
                field("Read Permission"; Rec."Read Permission") { }
                field("Insert Permission"; Rec."Insert Permission") { }
                field("Modify Permission"; Rec."Modify Permission") { }
                field("Delete Permission"; Rec."Delete Permission") { }
                field("Execute Permission"; Rec."Execute Permission") { }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(PermissionSetContent)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Permissions';
                Image = Permission;
                Scope = Repeater;
                ToolTip = 'View or edit which feature objects users need to access, and set up the related permissions in permission sets that you can assign to the users.';
                AboutTitle = 'View permission set details';
                AboutText = 'Go here to see which permissions the selected permission set defines for which objects.';

                trigger OnAction()
                var
                    PermissionSetRelation: Codeunit "Permission Set Relation";
                begin
                    PermissionSetRelation.OpenPermissionSetPage('', Rec."Role ID", Rec."App ID", Rec.Scope);
                end;
            }
        }
        area(Promoted)
        {
            actionref(PermissionSetContent_Promoted; PermissionSetContent) { }
        }
    }
}
