/*	
    This file is part of Ever OS.
	
	Ever OS is free software: you can redistribute it and/or modify 
	it under the terms of the Apache License 2.0 (http://www.apache.org/licenses/)
	
	Copyright 2019-2022 (c) EverX
*/
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

/* Root contract of Blob */
contract Blob{
    string version = "0.0.1";
    address _rootCommit;
    string static _nameBlob;
    string _nameBranch;
    bool check = false;
    string _blob;
    
    constructor(string nameBranch, string blob) public {
        tvm.accept();
        _rootCommit = msg.sender;
        _nameBranch = nameBranch;
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
    
    function getBlob() external view returns(string sha, address commit, string content) {
        return (_nameBlob, _rootCommit, _blob);
    }
}
