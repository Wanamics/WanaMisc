namespace Wanamics.WanaDim.GlobalDimensions;

using Microsoft.Projects.Resources.Resource;
pageextension 87054 "Resource Card" extends "Resource Card"
{
    layout
    {
        addlast(Invoicing)
        {
            field(wanGlobalDimension1Code; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Dimensions;
            }
            field(wanGlobalDimension2Code; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = Dimensions;
            }
        }
    }
}