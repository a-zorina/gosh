/* Root contract of Repository */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";
import "commit.sol";

abstract contract ASnapshot {
    constructor(uint256 value0, address rootrepo, string nameBranch) public {}
    function setSnapshotCode(TvmCell code, TvmCell data) public {}
    function setSnapshot(string snaphot) public {}
}

struct Item {
        string key;
        address value;
        address snapshot;
}

contract Repository is Upgradable{
    string version = "0.0.1";
    uint256 pubkey;
    TvmCell m_CommitCode;
    TvmCell m_CommitData;
    TvmCell m_BlobCode;
    TvmCell m_BlobData;
    TvmCell m_codeSnapshot;
    TvmCell m_dataSnapshot;
    address _rootGosh;
    string _name;
    mapping(string => Item) _Branches;
    
    modifier onlyOwner {
        require(msg.sender == _rootGosh,500);
        _;
    }
    
    constructor(uint256 value0, string name) public {
        require(msg.value > 1.4 ton, 100);
        tvm.accept();
        pubkey = value0;
        _rootGosh = msg.sender;
        _name = name;
        deployNewSnapshot("master");
    }
    
    function deployNewSnapshot(string name) public onlyOwner {
        TvmBuilder b;
        b.store(address(this));
        b.store(name);
        b.store(version);
        TvmCell deployCode = tvm.setCodeSalt(m_codeSnapshot, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_dataSnapshot);
        TvmCell s1 = tvm.insertPubkey(_contractflex, pubkey);
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        TvmCell payload = tvm.encodeBody(ASnapshot, pubkey, address(this), name);
        addr.transfer({stateInit: s1, body: payload, value: 1 ton});
        ASnapshot(addr).setSnapshotCode{value: 0.1 ton, bounce: true, flag: 1}(m_codeSnapshot, m_dataSnapshot);
        ASnapshot(addr).setSnapshot{value: 0.1 ton, bounce: true, flag: 1}("");       
        _Branches["master"] = (Item("master", address.makeAddrNone(), addr));
    }

    function getSnapshotAddr(string name) private view returns(address) {
        TvmBuilder b;
        b.store(address(this));
        b.store(name);
        b.store(version);
        TvmCell deployCode = tvm.setCodeSalt(m_codeSnapshot, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_dataSnapshot);
        TvmCell s1 = tvm.insertPubkey(_contractflex, pubkey);
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        return addr;
    }

    function deployBranch(string newname, string fromname)  public {
        require(msg.value > 0.2 ton, 100);
        if (_Branches.exists(newname)) { return; }
        if (_Branches.exists(fromname) == false) { return; }
        _Branches[newname] = Item(newname, _Branches[fromname].value, getSnapshotAddr(newname));
    }
    
    function deleteBranch(string name) public {
        require(msg.value > 0.1 ton, 100);
        delete _Branches[name];
    }
    
    function deployCommit(string nameBranch, string nameCommit, string fullCommit) public {
        require(msg.value > 1.3 ton, 100);
        require(_Branches.exists(nameBranch));
        TvmBuilder b;
        b.store(address(this));
        b.store(nameBranch);
        b.store(nameCommit);
        TvmCell deployCode = tvm.setCodeSalt(m_CommitCode, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_CommitData);
        TvmCell s1 = tvm.insertPubkey(_contractflex, msg.pubkey());
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        new Commit {stateInit:s1, value: 1 ton, wid: 0} (msg.pubkey(), nameCommit, nameBranch, fullCommit);
        Commit(addr).setBlob{value: 0.2 ton}(m_BlobCode, m_BlobData);
        _Branches[nameBranch] = Item(nameBranch, addr, _Branches[nameBranch].snapshot);
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

    function setSnapshot(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_codeSnapshot = code;
        m_dataSnapshot = data;
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

