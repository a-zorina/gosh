pragma ton-solidity >= 0.58.0;
import "repository.sol";
import "sys/gtypes.sol";
import "iblob.sol";

contract blobc {
    function type_name(uint8 itype) internal returns (string) {}
    function type_from_string_gently(string str, uint32, bool gentle) internal returns (uint8) {}
    function get_max_object_index() internal returns (uint32) {}
    function get_indexed_object(uint32) internal returns (object) {}
    function lookup_blob(repository r, object_id oid) internal returns (blob) {}
    function parse_blob_buffer(blob item, bytes buffer, uint32 size) internal returns (int) {}
}
