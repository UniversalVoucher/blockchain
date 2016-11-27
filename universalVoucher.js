Web3 = require('web3');
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.post('/customers', function (req, res) {
    var id_customer = req.body.id_customer;
    var amount = req.body.amount;

    var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

    var abi = [{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"id","type":"uint256"},{"name":"amount","type":"uint256"}],"name":"changeCustomer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"customerWallets","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}];

    var universalVoucher = web3.eth.contract(abi);

    var universalVoucherInstance = universalVoucher.at("0xf928d7b7459c0ee855ccf6156d26a2360a129e5a");

    universalVoucherInstance.changeCustomer(id_customer, amount, {from: web3.eth.accounts[0]}, function(res,err) {
      if (err) {
        console.log(err);
      }
		});

		res.sendStatus(200)
});

app.listen(1212, function () {
 console.log('App listening on port 1212!');
});
