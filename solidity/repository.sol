/* Root contract of Repository */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";
import "branch.sol";

contract Repository is Upgradable{
    uint256 pubkey;
    TvmCell m_BranchCode;
    TvmCell m_BranchData;
    TvmCell m_ObjectCode;
    TvmCell m_ObjectData;
    address _rootGosh;
    string _name;
    
    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(),500);
        _;
    }
    
    constructor(uint256 value0, string name) public {
        require(msg.pubkey() != 0, 101);
        tvm.accept();
        pubkey = value0;
        _rootGosh = msg.sender;
        _name = name;
    }
    
    function deployBranch(string name) view public {
        require(msg.value > 1.3 ton, 100);
        TvmBuilder b;
        b.store(address(this));
        b.store(msg.pubkey());
        TvmCell deployCode = tvm.setCodeSalt(m_BranchCode, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_BranchData);
        TvmCell s1 = tvm.insertPubkey(_contractflex, msg.pubkey());
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        new Repository {stateInit:s1, value: 1 ton, wid: 0} (msg.pubkey(), name);
        Repository(addr).setObject{value: 0.2 ton}(m_ObjectCode, m_ObjectData);
    }
    
    function onCodeUpgrade() internal override {   
    }
    
    //Setters
    
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
    
    function getObjectCode() external view returns(TvmCell) {
        return m_ObjectCode;
    }
    
    function getGoshAdress() external view returns(address) {
        return _rootGosh;
    }
}