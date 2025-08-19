# Guardio

Guardio is a decentralized insurance smart contract built on the Stacks blockchain. It enables trustless insurance policies, premium collection, and claims processing without the need for traditional intermediaries. By leveraging Clarity, Guardio ensures transparent execution, auditable records, and secure fund management.

## Key Features

* **Policy Creation**
  The contract owner can create insurance policies with defined coverage amounts, premium requirements, and policy durations.

* **Policy Purchase**
  Users can purchase policies directly by paying the calculated premium. Coverage terms and expiration dates are recorded on-chain.

* **Claims Management**
  Insured users can file claims against their active policies. Valid claims are settled automatically if the contract fund has sufficient balance.

* **Fund Management**
  Premium payments are collected into a central insurance fund that is used to settle approved claims. The balance is publicly viewable for transparency.

* **Read-Only Queries**
  Users can check policy details, claim history, and the overall insurance fund balance at any time.

## Contract Components

* **Constants**

  * Maximum coverage amount
  * Maximum policy duration
  * Minimum premium amount
  * Error codes for invalid actions

* **Data Maps**

  * `insurance-policies`: Stores policy details per user
  * `insurance-claims`: Stores claim amounts and their status

* **Variables**

  * `insurance-fund`: Tracks the balance of collected premiums available for claims

* **Public Functions**

  * `create-policy`: Allows the contract owner to define a new policy template
  * `purchase-policy`: Enables users to buy coverage by paying the premium
  * `file-claim`: Allows users to submit a claim request against their active policy

* **Read-Only Functions**

  * `get-policy-details`: Retrieves details of a given user’s policy
  * `get-claim-details`: Retrieves claim information for a given user
  * `get-fund-balance`: Returns the current balance of the insurance fund

## Error Handling

The contract defines structured error codes for clarity and easier debugging:

* `u100`: Owner-only action required
* `u101`: Invalid claim request
* `u102`: Insufficient funds to pay claim
* `u103`: User does not hold an active policy
* `u104`: Invalid parameters provided

## Usage Workflow

1. **Policy Setup**
   The contract owner creates a policy template with defined limits.

2. **Policy Purchase**
   A user selects coverage and duration, pays the required premium, and receives an active policy.

3. **Claims Filing**
   If an insured event occurs, the user files a claim within their coverage limit.

4. **Claims Settlement**
   If valid, the claim is automatically paid out from the insurance fund and recorded on-chain.

5. **Transparency**
   All details of policies, claims, and fund balances are queryable via read-only functions.