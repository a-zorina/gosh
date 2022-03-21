pragma ton-solidity >= 0.58.0;
import "iblob.sol";

contract sb1 {
    string[] _text;
    bytes[] _data;
    TvmCell[] _cells;
    address[] _peers;

    function store_data(bytes b) external {
        tvm.accept();
        _data.push(b);
    }

    function store_text(string s) external {
        tvm.accept();
        _text.push(s);
    }

    function store_cell(TvmCell c) external {
        tvm.accept();
        _cells.push(c);
    }

    function import_data(bytes[] bb) external {
        tvm.accept();
        for (bytes b: bb)
            _data.push(b);
    }

    function import_text(string[] ss) external {
        tvm.accept();
        for (string s: ss)
            _text.push(s);
    }

    function import_cell(TvmCell[] cc) external {
        tvm.accept();
        for (TvmCell c: cc)
            _cells.push(c);
    }

    function export_data() external view {
        sb1(msg.sender).import_data{value: 1 ton, flag: 1}(_data);
    }

    function export_text() external view {
        sb1(msg.sender).import_text{value: 1 ton, flag: 1}(_text);
    }

    function export_cell() external view {
        sb1(msg.sender).import_cell{value: 1 ton, flag: 1}(_cells);
    }

    function add_peer(address a) external {
        tvm.accept();
        _peers.push(a);
    }

    function query_peer(uint8 n, uint8 k) external view {
        address peer = _peers[k - 1];
        tvm.accept();
        if (n == 1)
            sb1(peer).import_data{value: 1 ton, flag: 1}(_data);
        else if (n == 2)
            sb1(peer).import_text{value: 1 ton, flag: 1}(_text);
        if (n == 3)
            sb1(peer).import_cell{value: 1 ton, flag: 1}(_cells);
    }
}