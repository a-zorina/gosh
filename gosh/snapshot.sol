/*	
    This file is part of Ever OS.
	
	Ever OS is free software: you can redistribute it and/or modify 
	it under the terms of the Apache License 2.0 (http://www.apache.org/licenses/)
	
	Copyright 2019-2022 (c) EverX
*/
pragma ton-solidity >=0.54.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "Upgradable.sol";

/* Snapshot contract of Branch */
abstract contract ASnapshot {
    constructor(uint256 value0, address rootrepo, string nameBranch) public {}
    function setSnapshotCode(TvmCell code, TvmCell data) public {}
    function setSnapshot(string snaphot) public {}
}

contract Snapshot is Upgradable{
    string version = "0.0.1";
    uint256 pubkey;
    address _rootRepo;
    string _snapshot;
    string _nameBranch;
    TvmCell m_codeSnapshot;
    TvmCell m_dataSnapshot;

    modifier onlyOwner {
        bool check = false;
        if (msg.sender == _rootRepo) { check = true; }
        if (msg.pubkey() == pubkey) { check = true; }
        require(check ,500);
        _;
    }

    constructor(uint256 value0, address rootrepo, string nameBranch) public {
        tvm.accept();
        pubkey = value0;
        _rootRepo = rootrepo;
        _snapshot = "";
        _nameBranch = nameBranch;
    }

    function deployNewSnapshot(string name) public view onlyOwner {
        require(msg.value > 1.3 ton, 100);
        TvmBuilder b;
        b.store(_rootRepo);
        b.store(name);
        b.store(version);
        TvmCell deployCode = tvm.setCodeSalt(m_codeSnapshot, b.toCell());
        TvmCell _contractflex = tvm.buildStateInit(deployCode, m_dataSnapshot);
        TvmCell s1 = tvm.insertPubkey(_contractflex, pubkey);
        address addr = address.makeAddrStd(0, tvm.hash(s1));
        TvmCell payload = tvm.encodeBody(ASnapshot, pubkey, _rootRepo, name);
        addr.transfer({stateInit: s1, body: payload, value: 1 ton});
        ASnapshot(addr).setSnapshotCode{value: 0.1 ton, bounce: true, flag: 1}(m_codeSnapshot, m_dataSnapshot);
        ASnapshot(addr).setSnapshot{value: 0.1 ton, bounce: true, flag: 1}(_snapshot);
    }

    function onCodeUpgrade() internal override {
    }

    //Setters

    function setSnapshot(string snaphot) public onlyOwner {
        tvm.accept();
        _snapshot = snaphot;
    }

    function setSnapshotCode(TvmCell code, TvmCell data) public  onlyOwner {
        tvm.accept();
        m_codeSnapshot = code;
        m_dataSnapshot = data;
    }

    //Getters
    function getSnapshot() external view returns(string) {
        return _snapshot;
    }

    function getNameBranch() external view returns(string) {
        return _nameBranch;
    }

    function getBranchAdress() external view returns(address) {
        return _rootRepo;
    }
}
