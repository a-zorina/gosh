/* Root contract of gosh */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";
import "repository.sol";

contract Gosh is Upgradable{
    string version = "0.0.1";
    TvmCell m_RepositoryCode;
    TvmCell m_RepositoryData;
    TvmCell m_CommitCode;
    TvmCell m_CommitData;
    TvmCell m_BlobCode;
    TvmCell m_BlobData;
    TvmCell m_codeSnapshot;
    TvmCell m_dataSnapshot;
    
    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(),500);
        _;
    }
    
    constructor() public {
        tvm.accept();
    }
    
    function deployRepository(string name) view public {
        require(msg.value > 1.7 ton, 100);
        tvm.accept();
        TvmBuilder b;
        b.store(address(this));
        b.store(name);
        b.store(version);
        TvmCell deployCode = tvm.setCodeSalt(m_RepositoryCode, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_RepositoryData);
        TvmCell s1 = tvm.insertPubkey(_contractflex, msg.pubkey());
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        new Repository {stateInit:s1, value: 1 ton, wid: 0} (msg.pubkey(), name);
        Repository(addr).setCommit{value: 0.2 ton}(m_CommitCode, m_CommitData);
        Repository(addr).setBlob{value: 0.2 ton}(m_BlobCode, m_BlobData);    
        Repository(addr).setSnapshot{value: 0.2 ton}(m_codeSnapshot, m_dataSnapshot);
    }
    
    function onCodeUpgrade() internal override {   
    }
    
    //Setters
    
    function setRepository(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_RepositoryCode = code;
        m_RepositoryData = data;
    }
    
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
    
    function getAddrRepository(string name) external view returns(address) {
        TvmBuilder b;
        b.store(address(this));
        b.store(name);
        b.store(version);
        TvmCell deployCode = tvm.setCodeSalt(m_RepositoryCode, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_RepositoryData);
        TvmCell s1 = tvm.insertPubkey(_contractflex, msg.pubkey());
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        return addr;
    }
    
    function getRepositoryCode() external view returns(TvmCell) {
        return m_RepositoryCode;
    }
    
    function getCommitCode() external view returns(TvmCell) {
        return m_CommitCode;
    }
    
    function getBlobCode() external view returns(TvmCell) {
        return m_BlobCode;
    }
}
