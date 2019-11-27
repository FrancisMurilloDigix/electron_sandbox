const secp256k1 = require('secp256k1');

const signWrapper = (
  msgHash,
  privateKey,
  chainId,
) => {
  const sig = secp256k1.sign(msgHash, privateKey)
  const recovery = sig.recovery

  const ret = {
    r: sig.signature.slice(0, 32),
    s: sig.signature.slice(32, 64),
    v: chainId ? recovery + (chainId * 2 + 35) : recovery + 27,
  }

  return ret;
};

module.exports = {
  signWrapper,
};
