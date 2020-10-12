pragma solidity ^0.6.10;

import "./AccessControl.sol";
import "./Context.sol";

abstract contract AuditorControl is AccessControl {



    modifier onlyAuditor() {

    }
}