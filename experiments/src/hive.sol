pragma ton-solidity >= 0.58.0;

import "../include/Base.sol";
import "sys/fmt.sol";

struct Entry {
    uint16 version;
    string name;
    string source;
    TvmCell code;
    uint32 updated_at;
}

struct Live {
    uint8 kind;
    uint16 version;
    address addr;
    uint32 deployedAt;
}

contract hive {

    Entry[] _images;
    Live[] _live;
    uint16[] _counter;

    modifier accept {
        tvm.accept();
        _;
    }

    function spawn(uint8 k, uint8 n) external {
        Entry img = _images[k - 1];
        tvm.accept();
        repeat (n) {
            TvmCell si = tvm.buildStateInit({pubkey: _counter[k - 1]++, code: img.code});
            address addr = address.makeAddrStd(0, tvm.hash(si));
            _live.push(Live(k, img.version, addr, now));
            new Base{stateInit: si, value: 1 ton}();
        }
    }

    function _get_image_index(string name) internal view returns (uint) {
        for (uint i = 0; i < _images.length; i++)
            if (_images[i].name == name)
                return i + 1;
    }

    function update_source(string name, string source) external accept {
        uint index = _get_image_index(name);
        if (index > 0) {
            Entry img = _images[index - 1];
            if (source != img.source) {
                img.source = source;
                img.updated_at = now;
                _images[index - 1] = img;
            }
        }
    }

    function nsync(uint8 n) external accept {
        if (n == 1)
            _counter.push(0);
    }

    function update_model_at_index(uint16 index, string name, TvmCell c) external {
        if (index == 0) {
            tvm.accept();
            _images.push(Entry(0, name, "", c, now));
            _counter.push(0);
        } else {
            Entry img = _images[index - 1];
            require(img.code != c);
            tvm.accept();
            img.version++;
            img.code = c;
            img.updated_at = now;
            _images[index - 1] = img;
        }
    }

    function models() external view returns (string out) {
        Column[] columns_format = [
            Column(true, 3, fmt.LEFT),
            Column(true, 3, fmt.RIGHT),
            Column(true, 20, fmt.RIGHT),
            Column(true, 6, fmt.RIGHT),
            Column(true, 5, fmt.RIGHT),
            Column(true, 6, fmt.RIGHT),
            Column(true, 5, fmt.RIGHT),
            Column(true, 30, fmt.LEFT)];

        string[][] table = [["N", "ver", "Name", "source", "cells", "bytes", "refs", "Updated at"]];
        for (uint i = 0; i < _images.length; i++) {
            Entry img = _images[i];
            (uint16 version, string name, string source, TvmCell code, uint32 updated_at) = img.unpack();
            (uint cells, uint bits, uint refs) = code.dataSize(1000);
            uint bytess = bits / 8;
            table.push([
                str.toa(i + 1),
                str.toa(version),
                name,
                str.toa(str.strlen(source)),
                str.toa(cells),
                str.toa(bytess),
                str.toa(refs),
                fmt.ts(updated_at)]);
        }
        out = fmt.format_table_ext(columns_format, table, " ", "\n");
    }

    function live_hosts() external view returns (string out) {
        Column[] columns_format = [
            Column(true, 3, fmt.LEFT),
            Column(true, 3, fmt.RIGHT),
            Column(true, 66, fmt.LEFT),
            Column(true, 30, fmt.LEFT)];

        string[][] table;
        for (uint i = 0; i < _live.length; i++) {
            (uint8 kind, uint16 version, address addr, uint32 deployedAt) =  _live[i].unpack();
            table.push([
                str.toa(kind),
                str.toa(version),
                format("{}", addr),
                fmt.ts(deployedAt)]);
        }
        out = fmt.format_table_ext(columns_format, table, " ", "\n");
    }

    function upgrade_code(TvmCell c) external {
        tvm.accept();
        tvm.commit();
        tvm.setcode(c);
        tvm.setCurrentCode(c);
    }

    function upgrade(TvmCell c) external pure {
        tvm.accept();
        tvm.setcode(c);
        tvm.setCurrentCode(c);
    }

    function reset_storage() external accept {
        tvm.resetStorage();
    }

}

