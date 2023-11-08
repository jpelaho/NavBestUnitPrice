codeunit 50021 AfkOnAfterFindSLItemPriceSubs
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineItemPrice', '', false, false)]
    local procedure UpdateBestUnitPriceCalc(var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary; var FoundSalesPrice: Boolean; CalledByFieldNo: Integer)
    var
        AfkBPMgt: codeunit AfkBestPricingMgt;
    begin
        AfkBPMgt.UpdateBestUnitPriceCalc(SalesLine, TempSalesPrice, FoundSalesPrice, CalledByFieldNo);
    end;
}