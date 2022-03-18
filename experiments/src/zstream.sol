pragma ton-solidity >= 0.58.0;
import "sys/gtypes.sol";
struct git_zstream {
//    z_stream z;
    uint32 avail_in;
    uint32 avail_out;
    uint32 total_in;
    uint32 total_out;
    string next_in;
    string next_out;
}
library libgit_zstream {
    function git_inflate_init(git_zstream) internal {}
    function git_inflate_init_gzip_only(git_zstream) internal {}
    function git_inflate_end(git_zstream) internal {}
    function git_inflate(git_zstream, bool flush) internal returns (uint8) {}
    function git_deflate_init(git_zstream, uint8 level) internal {}
    function git_deflate_init_gzip(git_zstream, uint8 level) internal {}
    function git_deflate_init_raw(git_zstream, uint8 level) internal {}
    function git_deflate_end(git_zstream) internal {}
    function git_deflate_abort(git_zstream) internal returns (uint8) {}
    function git_deflate_end_gently(git_zstream) internal returns (uint8) {}
    function git_deflate(git_zstream, bool flush) internal returns (uint8) {}
    function git_deflate_bound(git_zstream, uint32) internal returns (uint32 {}
}
