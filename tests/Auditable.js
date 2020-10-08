const Auditable = artifacts.require("Auditable");
const Token = artifacts.require("Token");
const Token2 = artifacts.require("Token2");
const truffleAssert = require("truffle-assertions");

contract("Auditable", async (accounts) => {

    let owner;
    // let auditable;
    let platform;
    let token;
    let token2;

    before(() => {
        owner = accounts[0];
        auditor = accounts[1];
        platform = accounts[2];
    });

    beforeEach(async () => {
        // auditable = await Auditable.new(_auditor = auditor, _platform = platform, {from: owner});
        token2 = await Token2.new({from: owner});
        token = await Token.new(token = token2.address, {from: owner});
    });

    // it("Sets the platform", () => {
    //     const transaction = auditable.setPlatform(_platform = accounts[4], {from: owner});
    //     console.log(transaction);
    // });

    it("aaa", async () => {
        await token.makeBytesCall();
        await token.makeStringCall();

        const beforeB = await token.bgB();
        const afterB = await token.bgA();

        const beforeS = await token.sgB();
        const afterS = await token.sgA();

        const btotal = beforeB - afterB;
        const stotal = beforeS - afterS;
        console.log("Bytes Gas used: " + btotal);
        console.log("String Gas used: " + stotal);
        console.log("Strings are more expensive by: " + (stotal - btotal));
    });

})