pragma solidity ^0.6.10;


contract Test {

    address public owner;
    uint256 public gasBefore;
    uint256 public gasAfter;

    constructor() public {
        owner = msg.sender;
    }

    function publicCost() public returns (address) {
        gasBefore = gasleft();
        address own = owner;
        gasAfter = gasleft();
        return own;
    }

    function externalCost() external returns (address) {
        gasBefore = gasleft();
        address own = owner;
        gasAfter = gasleft();
        return own;
    }

    function externalPrivateCost() external returns (address) {
        gasBefore = gasleft();
        address own = privateCost();
        gasAfter = gasleft();
        return own;
    }

    function externalInternalCost() external returns (address) {
        gasBefore = gasleft();
        address own = internalCost();
        gasAfter = gasleft();
        return own;
    }

    function privateCost() private view returns (address) {
        return owner;
    }

    function internalCost() internal view returns (address) {
        return owner;
    }
}