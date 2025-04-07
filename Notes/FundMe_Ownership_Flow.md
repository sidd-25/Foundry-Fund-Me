# 🧭 Ownership Flow: FundMe Deployment via DeployFundMe

## 🔁 Actors

| Name               | Description                                      |
|--------------------|--------------------------------------------------|
| **DefaultSender**  | `0x1804...` - Default Foundry broadcaster         |
| **FundMeTest**     | Your test contract (`address(this)` in test)     |
| **DeployFundMe**   | Contract that deploys `FundMe`                   |
| **FundMe**         | Contract with an `owner` variable                |
| **USER**           | Mock EOA from `makeAddr("user")` + `vm.prank()` |

---

## 🛠️ Flow Diagram

```
[Test Phase]
+--------------------+
| FundMeTest         |   <-- Test Contract (address(this))
| Address: A         |
+--------------------+
         |
         | calls
         v
+---------------------+
| DeployFundMe        |   <-- Deployed by DefaultSender (0x1804...)
| Address: B          |
+---------------------+
         |
         | calls new FundMe()
         v
+---------------------+
| FundMe              |   <-- Deployed by DeployFundMe
| Address: C          |
| owner = msg.sender  |  --> owner = DeployFundMe (B)
+---------------------+
```

---

## 🧠 Key Points

- **`FundMe.owner = msg.sender`** during deployment
- `msg.sender` = `DefaultSender (0x1804...)`
- Unless you use `vm.startBroadcast(address)`, Foundry will use the **DefaultSender** (`0x1804...`) to deploy `DeployFundMe`
- `tx.origin` = `0x1804...` unless overridden (but don't use `tx.origin` for ownership!)

---

## ✅ Recommendations

- Always use `msg.sender` (✅) not `tx.origin` (❌) for ownership and access control
- If you want to set owner as a specific EOA, use:

```solidity
vm.startBroadcast(<desired_owner_address>);
DeployFundMe deployer = new DeployFundMe();
deployer.run();
vm.stopBroadcast();
```

---

