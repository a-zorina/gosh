pragma ton-solidity >= 0.58.0;

contract imgsgn {

    string static _image_hash;
    uint static _pubkey;

    string _signature;

    constructor(string signature) public {
        _signature = signature;
    }

    function getSignature() external view returns (string signature) {
        signature = _signature;
    }
}
