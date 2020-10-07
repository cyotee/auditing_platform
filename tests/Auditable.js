const Auditable = artifacts.require("Auditable");
const Token = artifacts.require("Token");
const truffleAssert = require("truffle-assertions");

contract("Auditable", async (accounts) => {

    let owner;
    let auditable;
    let platform;
    let token;

    before(() => {
        owner = accounts[0];
        auditor = accounts[1];
        platform = accounts[2];
    });

    beforeEach(async () => {
        auditable = await Auditable.new(_auditor = auditor, _platform = platform, {from: owner});
        token = await Token.new({from: owner});
    });

    // it("Sets the platform", () => {
    //     const transaction = auditable.setPlatform(_platform = accounts[4], {from: owner});
    //     console.log(transaction);
    // });

    it("aaa", async () => {
        console.log("Sender:        " + owner);
        console.log("\n metadata:     " + await token.metaData());
    });

})