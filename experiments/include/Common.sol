pragma ton-solidity >= 0.54.0;

abstract contract Common {
    modifier accept {
        tvm.accept();
        _;
    }
}
