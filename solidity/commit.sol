/* Root contract of Object */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";

contract Commit is Upgradable{
    uint256 pubkey;
    address _rootRepo;
    string _nameCommit;
    string _nameBranch;
    
    modifier onlyOwner {
        require(msg.sender == _rootRepo,500);
        _;
    }
    
    constructor(uint256 value0, string nameCommit, string nameBranch) public {
        tvm.accept();
        pubkey = value0;
        _rootRepo = msg.sender;
        _nameCommit = nameCommit;
        _nameBranch = nameBranch;
    }

    function onCodeUpgrade() internal override {   
    }
    
    //Setters
    
    //Getters
    function getNameCommit() external view returns(string) {
        return _nameCommit;
    }

    function getNameBranch() external view returns(string) {
        return _nameBranch;
    }
    
    function getBranchAdress() external view returns(address) {
        return _rootRepo;
    }
}
