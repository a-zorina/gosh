/* Root contract of Object */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";

contract Blob is Upgradable{
    uint256 pubkey;
    address _rootRepo;
    string _nameBlob;
    string _nameBranch;
    
    modifier onlyOwner {
        require(msg.sender == _rootRepo,500);
        _;
    }
    
    constructor(uint256 value0, string nameBlob, string nameBranch) public {
        tvm.accept();
        pubkey = value0;
        _rootRepo = msg.sender;
        _nameBlob = nameBlob;
        _nameBranch = nameBranch;
    }

    function onCodeUpgrade() internal override {   
    }
    
    //Setters
    
    //Getters
    function getNameCommit() external view returns(string) {
        return _nameBlob;
    }

    function getNameBranch() external view returns(string) {
        return _nameBranch;
    }
    
    function getBranchAdress() external view returns(address) {
        return _rootRepo;
    }
}
