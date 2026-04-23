# Interface Design for Testability

Good interfaces make testing natural, and apply to almost any language that
supports them in one way or another. Examples below are in Go, apply those
practices in the most ideomatic way in the language the user is working in.

1. **Accept dependencies, don't create them**

   ```go
   // Testable
   func processOrder(order Order, gateway PaymentGateway) error {}

   // Hard to test
   func processOrder(order Order) error {
       gateway := stripe.NewGateway()
   }
   ```

2. **Return results, don't produce side effects**

   ```go
   // Testable
   func calculateDiscount(cart Cart) Discount {}

   // Hard to test
   func applyDiscount(cart *Cart) {
       cart.Total -= discount
   }
   ```
 
3. **Small surface area**
   - Fewer methods = fewer tests needed
   - Fewer params = simpler test setup
