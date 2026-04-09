# Good and Bad Tests

The examples below are in Go, apply those practices in the most ideomatic way
in the language and test framework the user is working in.


## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```go
// GOOD: Tests observable behavior
func TestUserCanCheckoutWithValidCart(t *testing.T) {
   cart := createCart()
   cart.Add(product)
   result, err := checkout(cart, paymentMethod)
   require.NoError(t, err)
   assert.Equal(t, "confirmed", result.Status)
}
```

Characteristics:

- Tests behavior users/callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```go
// BAD: Tests implementation details
func TestCheckoutCallsPaymentServiceProcess(t *testing.T) {
   mockPayment := &MockPaymentService{}
   checkout(cart, mockPayment)
   assert.True(t, mockPayment.ProcessCalledWith == cart.Total)
}
```

Red flags:

- Mocking internal collaborators
- Testing private methods
- Asserting on call counts/order
- Asserting on constant values
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT
- Verifying through external means instead of interface

```go
// BAD: Bypasses interface to verify
func TestCreateUserSavesToDatabase(t *testing.T) {
   createUser(UserInput{Name: "Alice"})
   var name string
   db.QueryRow("SELECT name FROM users WHERE name = ?", "Alice").Scan(&name)
   assert.Equal(t, "Alice", name)
}

// GOOD: Verifies through interface
func TestCreateUserMakesUserRetrievable(t *testing.T) {
   user, err := createUser(UserInput{Name: "Alice"})
   require.NoError(t, err)
   retrieved, err := getUser(user.ID)
   require.NoError(t, err)
   assert.Equal(t, "Alice", retrieved.Name)
}
```
