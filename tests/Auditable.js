// const Auditable = artifacts.require("Auditable");
const Test = artifacts.require("Test");
const truffleAssert = require("truffle-assertions");

contract("Auditable", async (accounts) => {

    let owner;
    // let auditable;
    let platform;
    let test;

    before(() => {
        owner = accounts[0];
        auditor = accounts[1];
        platform = accounts[2];
    });

    beforeEach(async () => {
        // auditable = await Auditable.new(_auditor = auditor, _platform = platform, {from: owner});
        test = await Test.new({from: owner});
    });

    // it("Sets the platform", () => {
    //     const transaction = auditable.setPlatform(_platform = accounts[4], {from: owner});
    //     console.log(transaction);
    // });

    it("aaa", async () => {

        await test.publicCost();
        const beforeB = await test.gasBefore();
        const afterB = await test.gasAfter();
        const public = beforeB - afterB;
        console.log("Public: " + public);

        await test.externalCost();
        const beforeS = await test.gasBefore();
        const afterS = await test.gasAfter();
        const external = beforeS - afterS;
        console.log("External: " + external);

        await test.externalPrivateCost();
        const beforeX = await test.gasBefore();
        const afterX = await test.gasAfter();
        const c = beforeX - afterX;
        console.log("External Priv: " + c);

        await test.externalInternalCost();
        const beforeP = await test.gasBefore();
        const afterP = await test.gasAfter();
        const d = beforeP - afterP;
        console.log("External Inte: " + d);        
    });

})