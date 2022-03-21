/* Root contract of gosh */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";
import "repository.sol";

contract Gosh is Upgradable{
    TvmCell m_RepositoryCode;
    TvmCell m_RepositoryData;
    TvmCell m_BranchCode;
    TvmCell m_BranchData;
    TvmCell m_ObjectCode;
    TvmCell m_ObjectData;
    
    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(),500);
        _;
    }
    
    constructor() public {
        tvm.accept();
    }
    
    function deployRepository(string name) view public {
        require(msg.value > 1.5 ton, 100);
        TvmBuilder b;
        b.store(address(this));
        b.store(msg.pubkey());
        TvmCell deployCode = tvm.setCodeSalt(m_RepositoryCode, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_RepositoryData);
        TvmCell s1 = tvm.insertPubkey(_contractflex, msg.pubkey());
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        new Repository {stateInit:s1, value: 1 ton, wid: 0} (msg.pubkey(), name);
        Repository(addr).setBranch{value: 0.2 ton}(m_BranchCode, m_BranchData);
        Repository(addr).setObject{value: 0.2 ton}(m_ObjectCode, m_ObjectData);
    }
    
    function onCodeUpgrade() internal override {   
    }
    
    //Setters
    
    function setRepository(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_RepositoryCode = code;
        m_RepositoryData = data;
    }
    
    function setBranch(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_BranchCode = code;
        m_BranchData = data;
    }
    
    function setObject(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_ObjectCode = code;
        m_ObjectData = data;
    }
    
    //Getters
    
    function getRepositoryCode() external view returns(TvmCell) {
        return m_RepositoryCode;
    }
    
    function getBranchCode() external view returns(TvmCell) {
        return m_BranchCode;
    }
    
    function getObjectCode() external view returns(TvmCell) {
        return m_ObjectCode;
    }
}
