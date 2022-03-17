pragma ton-solidity >= 0.58.0;
import "iblob.sol";

contract sb0 {
    bogus_blob[] _blobs;

    function store_blob(bogus_blob b) external {
        tvm.accept();
        _blobs.push(b);
    }
}