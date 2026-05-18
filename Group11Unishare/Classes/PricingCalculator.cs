using System;

namespace Group11Unishare
{
    public class CheckoutTotals
    {
        public CheckoutTotals(decimal subtotal, decimal discountPercent, decimal discountAmount, decimal discountedSubtotal, decimal deliveryFee, decimal total)
        {
            Subtotal = subtotal;
            DiscountPercent = discountPercent;
            DiscountAmount = discountAmount;
            DiscountedSubtotal = discountedSubtotal;
            DeliveryFee = deliveryFee;
            Total = total;
        }

        public decimal Subtotal { get; }
        public decimal DiscountPercent { get; }
        public decimal DiscountAmount { get; }
        public decimal DiscountedSubtotal { get; }
        public decimal DeliveryFee { get; }
        public decimal Total { get; }
    }

    public static class PricingCalculator
    {
        public static decimal CalculateDiscountAmount(decimal amount, decimal discountPercent)
        {
            return amount * (discountPercent / 100m);
        }

        public static decimal CalculateDiscountedPrice(decimal originalPrice, decimal discountPercent)
        {
            return originalPrice - CalculateDiscountAmount(originalPrice, discountPercent);
        }

        public static CheckoutTotals CalculateTotals(decimal subtotal, decimal discountPercent, bool includeDelivery)
        {
            decimal discountAmount = CalculateDiscountAmount(subtotal, discountPercent);
            decimal discountedSubtotal = subtotal - discountAmount;
            decimal deliveryFee = includeDelivery ? 50.00m : 0.00m;
            decimal total = discountedSubtotal + deliveryFee;

            return new CheckoutTotals(subtotal, discountPercent, discountAmount, discountedSubtotal, deliveryFee, total);
        }
    }
}
