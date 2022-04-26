codeunit 50022 AfkUnitPriceSuggestionTest
{

    Subtype = Test;

    trigger OnRun()
    begin

    end;

    [Test]
    procedure BestPriceMode_CustomerSpecificUnitPriceExists_ShouldSuggestCorrectly()
    var

    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Best price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer;
        SalesPrice."Sales Code" := '10000';
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4000;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;

    [Test]
    procedure BestPriceMode_GroupSpecificUnitPriceExists_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Best price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        PriceGroup.INIT;
        PriceGroup.Code := 'GR1';
        PriceGroup.INSERT;

        Cust.GET('10000');
        Cust."Customer Price Group" := PriceGroup.Code;
        Cust.MODIFY;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"Customer Price Group";
        SalesPrice."Sales Code" := PriceGroup.Code;
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);
        SalesHeader."Customer Price Group" := PriceGroup.Code;
        SalesLine."Customer Price Group" := PriceGroup.Code;

        //Verify
        ExpectedUnitPrice := 4000;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;

    [Test]
    procedure BestPriceMode_LowerPriceExistsWithNoStartingDate_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Best price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer;
        SalesPrice."Sales Code" := '10000';
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice."Starting Date" := DMY2Date(1, 1, 2022);
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4000;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;

    [Test]
    procedure BestPriceMode_LowerPriceExistsWithPastStartingDate_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Best price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer;
        SalesPrice."Sales Code" := '10000';
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice."Starting Date" := DMY2Date(1, 1, 2022);
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4000;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;


    [Test]
    procedure BestPriceMode_LowerPriceExistsWithPostStartingDate_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Best price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice."Starting Date" := DMY2Date(4, 1, 2022);
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer;
        SalesPrice."Sales Code" := '10000';
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice."Starting Date" := DMY2Date(1, 1, 2022);
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4000;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;

    [Test]
    procedure BestPriceMode_NoSalesPrice_ShouldSuggestItemUnitPrice()
    begin

        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Best price";
        SalesSetup.MODIFY;

        PrepareSalesOrder(SalesHeader, SalesLine);

        SalesPrice.DELETEALL;

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        Item.GET('1000');
        ExpectedUnitPrice := Item."Unit Price";
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);

    end;


    [Test]
    procedure BestPriceMode_NoSpecificUnitPriceExists_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Best price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice."Starting Date" := DMY2Date(1, 1, 2022);
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4300;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);

    end;


    [Test]
    procedure LastPriceMode_LowerPriceExistsWithNoStartingDate_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Last price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer;
        SalesPrice."Sales Code" := '10000';
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4000;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;


    [Test]
    procedure LastPriceMode_LowerPriceExistsWithPastStartingDate_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Last price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice."Starting Date" := 0D; //DMY2Date(1, 12, 2021);
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer;
        SalesPrice."Sales Code" := '10000';
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice."Starting Date" := DMY2Date(1, 1, 2022);
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4300;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;

    [Test]
    procedure LastPriceMode_LowerPriceExistsWithPostStartingDate_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Last price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice."Starting Date" := DMY2Date(4, 1, 2022);
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer;
        SalesPrice."Sales Code" := '10000';
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice."Starting Date" := DMY2Date(1, 1, 2022);
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4000;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);

    end;


    [Test]
    procedure LastPriceMode_NoSalesPrice_ShouldSuggestItemUnitPrice()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Last price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        Item.GET('1000');
        ExpectedUnitPrice := Item."Unit Price";
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);

    end;


    [Test]
    procedure SpecificPriceMode_CustomerSpecificUnitPriceExists_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Most specific price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer;
        SalesPrice."Sales Code" := '10000';
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4300;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;

    [Test]
    procedure SpecificPriceMode_GroupSpecificUnitPriceExists_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Most specific price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        PriceGroup.INIT;
        PriceGroup.Code := 'GR2';
        PriceGroup.INSERT;

        Cust.GET('10000');
        Cust."Customer Price Group" := PriceGroup.Code;
        Cust.MODIFY;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4000;
        SalesPrice.INSERT;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"Customer Price Group";
        SalesPrice."Sales Code" := PriceGroup.Code;
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);
        SalesHeader."Customer Price Group" := PriceGroup.Code;
        SalesLine."Customer Price Group" := PriceGroup.Code;

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4300;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;

    [Test]
    procedure SpecificPriceMode_NoSpecificUnitPriceExists_ShouldSuggestCorrectly()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Most specific price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        SalesPrice.INIT;
        SalesPrice."Sales Type" := SalesPrice."Sales Type"::"All Customers";
        SalesPrice."Item No." := '1000';
        SalesPrice."Unit Price" := 4300;
        SalesPrice."Starting Date" := DMY2Date(1, 1, 2022);
        SalesPrice.INSERT;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        ExpectedUnitPrice := 4300;
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);

    end;


    [Test]
    procedure SpecificPriceMode_NoSalesPrice_ShouldSuggestItemUnitPrice()
    begin
        //Prepare
        SalesSetup.GET;
        SalesSetup."Unit Price Suggestion Mode" := SalesSetup."Unit Price Suggestion Mode"::"Most specific price";
        SalesSetup.MODIFY;

        SalesPrice.DELETEALL;

        PrepareSalesOrder(SalesHeader, SalesLine);

        //Act
        SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);

        //Verify
        Item.GET('1000');
        ExpectedUnitPrice := Item."Unit Price";
        IF SalesLine."Unit Price" <> ExpectedUnitPrice THEN
            ERROR(ErrorText1, SalesLine."Unit Price", ExpectedUnitPrice);
    end;


    local procedure PrepareSalesOrder(VAR SalesH: Record "Sales Header"; VAR SalesL: Record "Sales Line")
    begin
        SalesH.INIT;
        SalesH."Document Type" := SalesH."Document Type"::Order;
        SalesH."No." := 'S' + FORMAT(RANDOM(10000));
        SalesH."Sell-to Customer No." := '10000';
        SalesH."Bill-to Customer No." := '10000';
        SalesH."Order Date" := DMY2Date(4, 1, 2022);
        SalesH.INSERT;


        SalesL.INIT;
        SalesL."Document No." := SalesH."No.";
        SalesL."Document Type" := SalesL."Document Type"::Order;
        SalesL.Type := SalesL.Type::Item;
        SalesL."No." := '1000';
        SalesL.INSERT;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPrice: Record "Sales Price";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ExpectedUnitPrice: Decimal;
        ErrorText1: Label 'The unit price was  %1 not %2 as expected';
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        Cust: Record Customer;
        PriceGroup: Record "Customer Price Group";
        Item: Record Item;
}