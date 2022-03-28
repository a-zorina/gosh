/* Root contract of Blob */
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

contract Blob{
    string version = "0.0.1";
    address _rootCommit;
    string _nameBlob;
    string _nameBranch;
    bool check = false;
    string _blob;
    
    constructor(string nameBlob, string nameBranch, string blob) public {
        tvm.accept();
        _rootCommit = msg.sender;
        _nameBranch = nameBranch;
        _nameBlob = nameBlob;
        _blob = blob;
    }
    
    //Setters
    
    //Getters
    function getNameBlob() external view returns(string) {
        return _nameBlob;
    }

    function getNameBranch() external view returns(string) {
        return _nameBranch;
    }
    
    function getCommitAdress() external view returns(address) {
        return _rootCommit;
    }
    
    function getBlob() external view returns(string) {
        return _blob;
    }
}
