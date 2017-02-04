var bitcore = require('bitcore-lib');
var ECIES = require('bitcore-ecies');
var config_2 = require('./config_2');


/**
 * decrypt the message with the privateKey of identity
 * @param  {{privateKey: ?string, publicKey: string}} identity
 * @param  {string}   encrypted
 */
var decrypt = function(identity, encrypted) {
  var privKey = new bitcore.PrivateKey(identity.privateKey);

  var alice = ECIES().privateKey(privKey);

  var decryptMe = new Buffer(encrypted, 'hex');

  var decrypted = alice.decrypt(decryptMe);

  return decrypted.toString('ascii');
};

// get message encrypted on ethereum blockchain

// var dec = decrypt(config_2, enc);
