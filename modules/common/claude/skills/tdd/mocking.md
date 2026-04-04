# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock. The examples
below are in Go, apply those practices in the most ideomatic way in the
language the user is working in.


**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```go
// Easy to mock
func processPayment(order Order, client PaymentClient) (Receipt, error) {
   return client.Charge(order.Total)
}

// Hard to mock
func processPayment(order Order) (Receipt, error) {
   client := stripe.NewClient(os.Getenv("STRIPE_KEY"))
   return client.Charge(order.Total)
}
```
``

**2. Prefer SDK-style interfaces over generic fetchers**

Create specific functions for each external operation instead of one generic function with conditional logic:

```go
// GOOD: Each method is independently mockable
type API interface {
   GetUser(id string) (*User, error)
   GetOrders(userID string) ([]Order, error)
   CreateOrder(data OrderInput) (*Order, error)
}

// BAD: Mocking requires conditional logic inside the mock
type API interface {
   Fetch(endpoint string, options RequestOptions) (*http.Response, error)
}
```

The SDK approach means:
- Each mock returns one specific shape
- No conditional logic in test setup
- Easier to see which endpoints a test exercises
- Type safety per endpoint
