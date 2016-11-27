# Smart contract

The smart contract is deploy on this address `0xD48ed9488c5b96e86e8B4719040abE7D2619346a` (see https://testnet.etherscan.io/address/0xd48ed9488c5b96e86e8b4719040abe7d2619346a).

To use this smart contract, create a node with :
```
geth --testnet --rpc --datadir "~/.ethereum-testnet" console
```

In the geth console add a new account with `account new`.

And attach the node to create the smart contract :
```
geth attach ipc:$HOME/.ethereum-testnet/testnet/geth.ipc
```

In this console, add the signature of the samrt contract :
```
 var contractDesc = [{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"id","type":"uint256"},{"name":"amount","type":"uint256"}],"name":"changePassager","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"passagerWallets","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}];
 ```

 And get the contract with :
 ```
 var myContractInstance = MyContract.at('0xD48ed9488c5b96e86e8B4719040abE7D2619346a');
 ```

To execute a edition of the smart contract you must begin to unlock your account :
```
web3.personal.unlockAccount(web3.eth.accounts[0], "your_password", 1000);
```

Now you can add or change the wallet of a customer with :
```
myContractInstance.changePassager(1,10, {from: web3.eth.accounts[0]})
```
Test the API
-----------

To test the Api, run this command :

```
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -H  -d 'id_customer=123&amount=123' "http://104.131.177.14:1212/customers"
```

That's all!
