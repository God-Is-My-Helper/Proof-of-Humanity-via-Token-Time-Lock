# 🛡️ Proof of Humanity via Token Time Lock

A minimalist Clarity smart contract that verifies a user is human — not through KYC, biometrics, or AI — but through **time-based token commitment**.

### 🚀 One contract. No frontend. No backend. No dependencies.

---

## ✅ Problem

In web3, bots are everywhere. Sybil attacks distort voting, airdrops, and public goods funding.

Most solutions rely on:
- Centralized identity systems (KYC)
- Oracles and zero-knowledge proofs
- Complex infrastructure

**What if you could verify humanity without any of that?**

---

## 💡 Solution

This smart contract proves someone is **probably human** if they’re willing to:

1. **Lock 1 STX** for 24 hours.
2. Wait patiently.
3. Return to unlock and verify themselves.

Bots can’t scale this behavior efficiently. Humans can.

---

## 🧠 How it works

- `prove-humanness`: Locks 1 STX for 144 blocks (~24 hours).
- `claim-humanness`: After 24 hours, lets you retrieve your STX and marks you verified.
- `is-human`: Check if an address is verified.

---

## ✨ Use Cases

- Airdrop protection
- DAO voting eligibility
- Universal Basic Income filters
- Anti-bot whitelists
- Quadratic funding Sybil resistance

---

## 🧾 Contract Functions

### `prove-humanness`

Locks 1 STX from the user.

```clarity
(contract-call? .humans prove-humanness)
