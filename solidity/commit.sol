/* Root contract of Commit */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "blob.sol";

contract Commit {
    string version = "0.0.1";
    uint256 pubkey;
    address _rootRepo;
    string _nameCommit;
    string _nameBranch;
    string _commit;
    bool check = false;
    address[] _blob;
    TvmCell m_BlobCode;
    TvmCell m_BlobData;
    
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
    
    constructor(uint256 value0, string nameCommit, string nameBranch, string commit) public {
        tvm.accept();
        pubkey = value0;
        _rootRepo = msg.sender;
        _nameCommit = nameCommit;
        _nameBranch = nameBranch;
        _commit = commit;
    }
    
    function deployBlob(string nameBlob, string fullblob) public onlyOwner {
        require(msg.value > 1.3 ton, 100);
        TvmBuilder b;
        b.store(address(this));
        b.store(_nameBranch);
        b.store(version);
        b.store(nameBlob);
        TvmCell deployCode = tvm.setCodeSalt(m_BlobCode, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_BlobData);
        TvmCell s1 = tvm.insertPubkey(_contractflex, msg.pubkey());
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        new Blob{stateInit:s1, value: 1 ton, wid: 0} (nameBlob, _nameBranch, fullblob);
        _blob.push(addr);
    }

    //Setters
    function setBlob(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_BlobCode = code;
        m_BlobData = data;
    }
    
    //Getters
    function getBlobs() external view returns(address[]) {
        return _blob;
    }
    
    function getNameCommit() external view returns(string) {
        return _nameCommit;
    }

    function getNameBranch() external view returns(string) {
        return _nameBranch;
    }
    
    function getRepoAdress() external view returns(address) {
        return _rootRepo;
    }
}
