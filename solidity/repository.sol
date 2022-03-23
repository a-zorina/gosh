/* Root contract of Repository */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";
import "commit.sol";

struct Item {
        string key;
        address value;
}

contract Repository is Upgradable{
    uint256 pubkey;
    TvmCell m_CommitCode;
    TvmCell m_CommitData;
    TvmCell m_BlobCode;
    TvmCell m_BlobData;
    address _rootGosh;
    string _name;
    mapping(string => Item) _Branches;
    
    modifier onlyOwner {
        require(msg.sender == _rootGosh,500);
        _;
    }
    
    constructor(uint256 value0, string name) public {
        tvm.accept();
        pubkey = value0;
        _rootGosh = msg.sender;
        _name = name;
        _Branches["master"] = (Item(name, address.makeAddrNone()));
    }
    
    
    function deployBranch(string newname, string fromname)  public {
        require(msg.value > 0.1 ton, 100);
        if (_Branches.exists(newname)) { return; }
        if (_Branches.exists(newname) == false) { return; }
        _Branches[newname] = _Branches[fromname];
    }
    
    function deleteBranch(string name) public {
        require(msg.value > 0.1 ton, 100);
        delete _Branches[name];
    }
    
    function deployCommit(string nameBranch, string nameCommit) public {
        require(msg.value > 1.3 ton, 100);
        TvmBuilder b;
        b.store(address(this));
        b.store(nameBranch);
        b.store(nameCommit);
        TvmCell deployCode = tvm.setCodeSalt(m_CommitCode, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_CommitData);
        TvmCell s1 = tvm.insertPubkey(_contractflex, msg.pubkey());
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        new Commit {stateInit:s1, value: 1 ton, wid: 0} (msg.pubkey(), nameCommit, nameBranch);
        _Branches[nameBranch] = Item(nameBranch, addr);
    }
    
    function onCodeUpgrade() internal override {   
    }
    
    //Setters
    
    function setCommit(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_CommitCode = code;
        m_CommitData = data;
    }
    
    function setBlob(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_BlobCode = code;
        m_BlobData = data;
    }
    
    //Getters
    
    function getAddrBranch(string name) external view returns(Item) {
        return _Branches[name];
    }
    
    function getAllAddress() external view returns(Item[]) {
        Item[] AllBranches;
        for ((string _key, Item value) : _Branches) { 
            _key;
            AllBranches.push(value);
        }
        return AllBranches;
    }
    
    function getCommitCode() external view returns(TvmCell) {
        return m_CommitCode;
    }
    
    function getGoshAdress() external view returns(address) {
        return _rootGosh;
    }
}

