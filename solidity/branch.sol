/* Root contract of Branch */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";
import "object.sol";

contract Branch is Upgradable{
    uint256 pubkey;
    TvmCell m_ObjectCode;
    TvmCell m_ObjectData;
    address _rootRepo;
    string _name;
    
    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(),500);
        _;
    }
    
    constructor(uint256 value0, string name) public {
        require(msg.pubkey() != 0, 101);
        tvm.accept();
        pubkey = value0;
        _rootRepo = msg.sender;
        _name = name;
    }
    
    function deployBranch(string name) view public onlyOwner {
        require(msg.value > 1.1 ton, 100);
        TvmBuilder b;
        b.store(address(this));
        b.store(msg.pubkey());
        TvmCell deployCode = tvm.setCodeSalt(m_ObjectCode, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_ObjectData);
        TvmCell s1 = tvm.insertPubkey(_contractflex, msg.pubkey());
        new Object {stateInit:s1, value: 1 ton, wid: 0} (msg.pubkey(), name);
    }
    
    function onCodeUpgrade() internal override {   
    }
    
    //Setters
    
    function setObject(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_ObjectCode = code;
        m_ObjectData = data;
    }
    
    //Getters
    
    function getName() external view returns(string) {
        return _name;
    }
    
    function getObjectCode() external view returns(TvmCell) {
        return m_ObjectCode;
    }
    
    function getRepoAdress() external view returns(address) {
        return _rootRepo;
    }
}