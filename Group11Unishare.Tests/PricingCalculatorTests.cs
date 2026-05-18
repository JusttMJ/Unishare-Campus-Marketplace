using Group11Unishare;

namespace Group11Unishare.Tests;

[TestClass]
public sealed class PricingCalculatorTests
{
    [TestMethod]
    public void CalculateTotals_NoDiscount_NoDelivery()
    {
        CheckoutTotals totals = PricingCalculator.CalculateTotals(100m, 0m, false);

        Assert.AreEqual(100m, totals.Subtotal);
        Assert.AreEqual(0m, totals.DiscountAmount);
        Assert.AreEqual(0m, totals.DeliveryFee);
        Assert.AreEqual(100m, totals.Total);
    }

    [TestMethod]
    public void CalculateTotals_Discount_WithDelivery()
    {
        CheckoutTotals totals = PricingCalculator.CalculateTotals(200m, 10m, true);

        Assert.AreEqual(20m, totals.DiscountAmount);
        Assert.AreEqual(180m, totals.DiscountedSubtotal);
        Assert.AreEqual(50m, totals.DeliveryFee);
        Assert.AreEqual(230m, totals.Total);
    }

    [TestMethod]
    public void CalculateTotals_FullDiscount_NoDelivery()
    {
        CheckoutTotals totals = PricingCalculator.CalculateTotals(75m, 100m, false);

        Assert.AreEqual(75m, totals.DiscountAmount);
        Assert.AreEqual(0m, totals.DiscountedSubtotal);
        Assert.AreEqual(0m, totals.Total);
    }

    [TestMethod]
    public void CalculateDiscountedPrice_ReturnsPriceAfterDiscount()
    {
        decimal discountedPrice = PricingCalculator.CalculateDiscountedPrice(120m, 25m);

        Assert.AreEqual(90m, discountedPrice);
    }
}
