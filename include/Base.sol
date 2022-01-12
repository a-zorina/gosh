pragma ton-solidity >= 0.54.0;

import "Common.sol";
/* Base functions and definitions */
contract Base is Common {

    uint8 constant EXECUTE_SUCCESS  = 0;
    uint8 constant EXECUTE_FAILURE  = 1;
    uint8 constant EX_BADUSAGE      = 2; // Usage messages by builtins result in a return status of 2

    function upgrade(TvmCell c) external {
        tvm.accept();
        tvm.setcode(c);
        tvm.setCurrentCode(c);
        onCodeUpgrade();
    }

    function onCodeUpgrade() internal {
    }

    function reset_storage() external accept {
        tvm.resetStorage();
    }
}
