/* Root contract of Object */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";

contract Object is Upgradable{
    uint256 pubkey;
    address _rootBranch;
    string _name;
    
    modifier onlyOwner {
        require(msg.sender == _rootBranch,500);
        _;
    }
    
    constructor(uint256 value0, string name) public {
        tvm.accept();
        pubkey = value0;
        _rootBranch = msg.sender;
        _name = name;
    }

    function onCodeUpgrade() internal override {   
    }
    
    //Setters
    
    //Getters
    function getName() external view returns(string) {
        return _name;
    }
    
    function getBranchAdress() external view returns(address) {
        return _rootBranch;
    }
}