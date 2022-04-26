tableextension 50020 AfkSalesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Unit Price Suggestion Mode"; Enum AfkSalesSetupUPSuggestMode)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unit Price Suggestion Mode';
        }
    }

}