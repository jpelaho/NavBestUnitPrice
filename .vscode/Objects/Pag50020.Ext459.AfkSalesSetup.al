pageextension 50020 AfkSalesSetup extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Unit Price Suggestion Mode"; Rec."Unit Price Suggestion Mode")
            {
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}