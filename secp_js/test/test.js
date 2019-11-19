const assert = require('assert');

const {
  signWrapper,
} = require('../index.js');

function dec2hex(str){ // .toString(16) only works up to 2^53
    var dec = str.toString().split(''), sum = [], hex = [], i, s
    while(dec.length){
        s = 1 * dec.shift()
        for(i = 0; s || i < sum.length; i++){
            s += (sum[i] || 0) * 10
            sum[i] = s % 16
            s = (s - sum[i]) / 16
        }
    }
    while(sum.length){
        hex.push(sum.pop().toString(16))
    }
    return hex.join('')
}

describe('index.js', function() {
  describe('signWrapper', function() {
    it('case 1', function() {
      const sign = signWrapper(
        Buffer.from('0000000000000000000000000000000000000000000000000000000000000002', 'hex'),
        Buffer.from('0000000000000000000000000000000000000000000000000000000000000001', 'hex'),
      );
      const shouldBe = {
        "r": Buffer.from(dec2hex('38938543279057362855969661240129897219713373336787331739561340553100525404231'), 'hex'),
        "s": Buffer.from(dec2hex('23772455091703794797226342343520955590158385983376086035257995824653222457926'), 'hex'),
        "v": 28,
      };

      assert.equal(sign.r.toString(), shouldBe.r.toString());
      assert.equal(sign.s.toString(), shouldBe.s.toString());
      assert.equal(sign.v, shouldBe.v);
    });

    it('case 2', function() {
      const sign = signWrapper(
        Buffer.from('0000000000000000000000000000000000000000000000000000000000000005', 'hex'),
        Buffer.from('0000000000000000000000000000000000000000000000000000000000000001', 'hex'),
      );
      const shouldBe = {
        "r": Buffer.from(dec2hex('74927840775756275467012999236208995857356645681540064312847180029125478834483'), 'hex'),
        "s": Buffer.from(dec2hex('56037731387691402801139111075060162264934372456622294904359821823785637523849'), 'hex'),
        "v": 27,
      };

      assert.equal(sign.r.toString(), shouldBe.r.toString());
      assert.equal(sign.s.toString(), shouldBe.s.toString());
      assert.equal(sign.v, shouldBe.v);
    });
  });
});
