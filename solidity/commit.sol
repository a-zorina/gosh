/* Root contract of Object */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";

struct object_id {
    string hash;   // [GIT_MAX_RAWSZ];
    uint8 algo;    // XXX requires 4-byte alignment
}

contract Commit is Upgradable{
    uint256 pubkey;
    address _rootRepo;
    string _nameBlob;
    string _nameBranch;
    bool check = false;
    
    uint8 _parsed;
    uint8 _type;
    uint8 _flags;
    object_id _hash;
    string _short_blob;
    address _store_link;
    
    modifier onlyOwner {
        bool checkOwn = false;
        if (msg.sender == _rootRepo) { checkOwn = true; }    
        if (msg.pubkey() == pubkey) { checkOwn = true; }
        require(checkOwn ,500);
        _;
    }
    
    modifier onlyFirst {
        require(check == false,600);
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
    function setCommit(uint8 m_parsed, uint8 m_type, uint8 m_flags, object_id m_hash) public onlyFirst {
        tvm.accept();
        check = true;
        _parsed = m_parsed;
        _type = m_type;
        _flags = m_flags;
        _hash = m_hash;    
    }
    
    //Getters
    function getNameCommit() external view returns(string) {
        return _nameBlob;
    }

    function getNameBranch() external view returns(string) {
        return _nameBranch;
    }
    
    function getRepoAdress() external view returns(address) {
        return _rootRepo;
    }
}
