var bitcore = require('bitcore-lib');
var ECIES = require('bitcore-ecies');
var config_1 = require('./config_1');

var message = "{'id': 'abcd','first_name': 'alice','last_name': 'bob','email': 'alice@bob.eve','phone_number': '3141592653'}";

/**
 * encrypt the message with the publicKey of identity
 * @param  {{privateKey: ?string, publicKey: string}} identity
 * @param  {string} message
 */
var encrypt = function(identity, message) {
  var privKey = new bitcore.PrivateKey(identity.privateKey);
  var alice = ECIES().privateKey(privKey).publicKey(new bitcore.PublicKey(identity.publicKey));
  var encrypted = alice.encrypt(message);

  return encrypted.toString('hex');
};

var enc = encrypt(config_1, message);
