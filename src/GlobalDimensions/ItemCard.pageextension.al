namespace Wanamics.WanaDim.GlobalDimensions;

using Microsoft.Inventory.Item;
pageextension 87053 "Item Card" extends "Item Card"
{
    layout
    {
        addlast("Costs & Posting")
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