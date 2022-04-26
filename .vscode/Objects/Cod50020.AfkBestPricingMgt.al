codeunit 50020 AfkBestPricingMgt
{
    trigger OnRun()
    begin

    end;

    procedure UpdateBestUnitPriceCalc(var SalesLine: Record "Sales Line"; var SalesPrice: Record "Sales Price" temporary; var FoundSalesPrice: Boolean; CalledByFieldNo: Integer)
    begin
        SalesSetup.get();
        IF SalesSetup."Unit Price Suggestion Mode" = SalesSetup."Unit Price Suggestion Mode"::"Last price" then
            CalcLastUnitPrice_AFK(SalesLine, SalesPrice, FoundSalesPrice)
        else
            if SalesSetup."Unit Price Suggestion Mode" = SalesSetup."Unit Price Suggestion Mode"::"Most specific price" THEN
                CalcMostSpecificPrice_AFK(SalesLine, SalesPrice, FoundSalesPrice);
    end;

    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal; var SalesLine: Record "Sales Line"): Boolean
    begin
        if UnitofMeasureCode = '' then
            exit(MinQty <= SalesLine."Qty. per Unit of Measure" * Abs(SalesLine.Quantity));
        exit(MinQty <= Abs(SalesLine.Quantity));
    end;
    
    procedure CalcLastUnitPrice_AFK(var SalesLine: Record "Sales Line"; var SalesPrice: Record "Sales Price" temporary; var FoundSalesPrice: Boolean)
    var
        BestSalesPrice: Record "Sales Price";
        BestSalesPriceFound: Boolean;
        Item: Record Item;
    begin
        Item.Get(SalesLine."No.");
        with SalesPrice do begin
            FoundSalesPrice := FindSet();
            if FoundSalesPrice then
                repeat
                    if IsInMinQty("Unit of Measure Code", "Minimum Quantity", SalesLine) then begin
                        //CalcBestUnitPriceConvertPrice(SalesPrice);

                        case true of
                            ((BestSalesPrice."Currency Code" = '') and ("Currency Code" <> '')) or
                            ((BestSalesPrice."Variant Code" = '') and ("Variant Code" <> '')):
                                begin
                                    BestSalesPrice := SalesPrice;
                                    BestSalesPriceFound := true;
                                end;
                            ((BestSalesPrice."Currency Code" = '') or ("Currency Code" <> '')) and
                          ((BestSalesPrice."Variant Code" = '') or ("Variant Code" <> '')):
                                if (BestSalesPrice."Unit Price" = 0) or
                                   (BestSalesPrice."Starting Date" <= SalesPrice."Starting Date")
                                then begin
                                    BestSalesPrice := SalesPrice;
                                    BestSalesPriceFound := true;
                                end;
                        end;
                    end;
                until Next() = 0;
        end;

        if (BestSalesPriceFound) then
                SalesPrice := BestSalesPrice;
    end;

    procedure CalcMostSpecificPrice_AFK(var SalesLine: Record "Sales Line"; var SalesPrice: Record "Sales Price" temporary; var FoundSalesPrice: Boolean)
    var
        BestSalesPrice: Record "Sales Price";
        BestSalesPriceFound: Boolean;
        Item: Record Item;
    begin
        Item.Get(SalesLine."No.");
        with SalesPrice do begin
            FoundSalesPrice := FindSet();
            if FoundSalesPrice then
                repeat
                    if IsInMinQty("Unit of Measure Code", "Minimum Quantity", SalesLine) then begin
                        //CalcBestUnitPriceConvertPrice(SalesPrice);

                        case true of
                            ((BestSalesPrice."Currency Code" = '') and ("Currency Code" <> '')) or
                            ((BestSalesPrice."Variant Code" = '') and ("Variant Code" <> '')):
                                begin
                                    BestSalesPrice := SalesPrice;
                                    BestSalesPriceFound := true;
                                end;
                            ((BestSalesPrice."Currency Code" = '') or ("Currency Code" <> '')) and
                          ((BestSalesPrice."Variant Code" = '') or ("Variant Code" <> '')):
                                if (BestSalesPrice."Unit Price" = 0) or
                                   (HasMoreSpecificUnitPrice_AFK(BestSalesPrice, SalesPrice))
                                then begin
                                    BestSalesPrice := SalesPrice;
                                    BestSalesPriceFound := true;
                                end;
                        end;
                    end;
                until Next() = 0;
        end;


        if (BestSalesPriceFound) then
            SalesPrice := BestSalesPrice;
    end;

    //Jn001 *************************************************************************
    // Check if SalesPrice unit price is more specific than BestSalesPrice unit price
    //Jn001 *************************************************************************

    local procedure HasMoreSpecificUnitPrice_AFK(BestSalesPrice: Record "Sales Price"; SalesPrice: Record "Sales Price"): Boolean
    begin

        IF SalesPrice."Sales Type" = SalesPrice."Sales Type"::Customer THEN
            EXIT(TRUE);

        IF SalesPrice."Sales Type" = SalesPrice."Sales Type"::Campaign THEN
            EXIT((BestSalesPrice."Sales Type" = BestSalesPrice."Sales Type"::"All Customers")
                OR (BestSalesPrice."Sales Type" = BestSalesPrice."Sales Type"::"Customer Price Group"));

        IF SalesPrice."Sales Type" = SalesPrice."Sales Type"::"Customer Price Group" THEN
            EXIT(BestSalesPrice."Sales Type" = BestSalesPrice."Sales Type"::"All Customers");
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
}