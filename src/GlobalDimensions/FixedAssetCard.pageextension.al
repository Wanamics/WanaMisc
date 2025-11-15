namespace Wanamics.WanaDim.GlobalDimensions;

using Microsoft.FixedAssets.FixedAsset;
pageextension 87051 "Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addafter("FA Subclass Code")
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
