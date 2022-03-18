pragma ton-solidity >= 0.58.0;

import "gtypes.sol";
library libghash {

    uint8 constant GIT_HASH_UNKNOWN     = 0; // An unknown hash function.
    uint8 constant GIT_HASH_SHA1        = 1; // SHA-1
    uint8 constant GIT_HASH_SHA256      = 2; // SHA-256

    uint8 constant GIT_HASH_NALGOS      = GIT_HASH_SHA256 + 1; // Number of algorithms supported (including unknown).

    uint32 constant GIT_SHA1_FORMAT_ID  = 0x73686131;       // "sha1", big-endian
    uint8 constant GIT_SHA1_RAWSZ       = 20;               // The length in bytes and in hex digits of an object name (SHA-1 value).
    uint8 constant GIT_SHA1_HEXSZ       = 2 * GIT_SHA1_RAWSZ;
    uint8 constant GIT_SHA1_BLKSZ       = 64;               // The block size of SHA-1.
    uint32 constant GIT_SHA256_FORMAT_ID = 0x73323536;      // "s256", big-endian
    uint8 constant GIT_SHA256_RAWSZ     = 32;               // The length in bytes and in hex digits of an object name (SHA-256 value).
    uint8 constant GIT_SHA256_HEXSZ     = 2 * GIT_SHA256_RAWSZ;
    uint8 constant GIT_SHA256_BLKSZ     = 64;               // The block size of SHA-256.
    uint8 constant GIT_MAX_RAWSZ        = GIT_SHA256_RAWSZ; // The length in byte and in hex digits of the largest possible hash value.
    uint8 constant GIT_MAX_HEXSZ        = GIT_SHA256_HEXSZ;
    uint8 constant GIT_MAX_BLKSZ        = GIT_SHA256_BLKSZ; // The largest possible block size for any supported hash.

    // sha-1 compression function that takes an already expanded message, and additionally store intermediate states
    // only stores states ii (the state between step ii-1 and step ii) when DOSTORESTATEii is defined in ubc_check.h
    function sha1_compression_states(uint32[5], uint32[16], uint32[80], uint32[80][5]) internal {}

    /*
    // Function type for sha1_recompression_step_T (uint32_t ihvin[5], uint32_t ihvout[5], const uint32_t me2[80], const uint32_t state[5]).
    // Where 0 <= T < 80
    //       me2 is an expanded message (the expansion of an original message block XOR'ed with a disturbance vector's message block difference.)
    //       state is the internal state (a,b,c,d,e) before step T of the SHA-1 compression function while processing the original message block.
    // The function will return:
    //       ihvin: The reconstructed input chaining value.
    //       ihvout: The reconstructed output chaining value.
    */
    //typedef void(*sha1_recompression_type)(uint32_t*, uint32_t*, const uint32_t*, const uint32_t*);

    struct SHA1_CTX {
        uint64 total;
        uint32[5] ihv;
        uint8[64] buffer;
        bool found_collision;
        bool safe_hash;
        bool detect_coll;
        bool ubc_check;
        bool reduced_round_coll;
        uint32 callback;
        uint32[5] ihv1;
        uint32[5] ihv2;
        uint32[80] m1;
        uint32[80] m2;
        uint32[80][5] states;
    }

    uint32 constant blk_SHA256_BLKSIZE = 64;
    uint8 constant MAX_HEADER_LEN = 32; // The maximum size for an object header.

    string constant EMPTY_TREE_SHA1_BIN_LITERAL = "\x4b\x82\x5d\xc6\x42\xcb\x6e\xb9\xa0\x60" + "\xe5\x4b\xf8\xd6\x92\x88\xfb\xee\x49\x04";
    string constant EMPTY_TREE_SHA256_BIN_LITERAL = "\x6e\xf1\x9b\x41\x22\x5c\x53\x69\xf1\xc1" + "\x04\xd4\x5d\x8d\x85\xef\xa9\xb0\x57\xb5" + "\x3b\x14\xb4\xb9\xb9\x39\xdd\x74\xde\xcc" + "\x53\x21";
    string constant EMPTY_BLOB_SHA1_BIN_LITERAL = "\xe6\x9d\xe2\x9b\xb2\xd1\xd6\x43\x4b\x8b" + "\x29\xae\x77\x5a\xd8\xc2\xe4\x8c\x53\x91";
    string constant EMPTY_BLOB_SHA256_BIN_LITERAL = "\x47\x3a\x0f\x4c\x3b\xe8\xa9\x36\x81\xa2" + "\x67\xe3\xb1\xe9\xa7\xdc\xda\x11\x85\x43" + "\x6f\xe1\x41\xf7\x74\x91\x20\xa3\x03\x72" + "\x18\x13";

    function git_hash_sha1_init(git_hash_ctx ctx) internal {
        git_SHA1DCInit(ctx.sha1);
    }

    function git_hash_sha1_clone(git_hash_ctx dst, git_hash_ctx src) internal {
        git_SHA1_Clone(dst.sha1, src.sha1);
    }

    function git_hash_sha1_update(git_hash_ctx ctx, bytes data, uint32 len) internal {
        git_SHA1DCUpdate(ctx.sha1, data, len);
    }

    function git_hash_sha1_final(string hash, git_hash_ctx ctx) internal {
        git_SHA1DCFinal(hash, ctx.sha1);
    }

    function git_hash_sha1_final_oid(object_id oid, git_hash_ctx ctx) internal {
        git_SHA1DCFinal(oid.hash, ctx.sha1);
//        memset(oid.hash + GIT_SHA1_RAWSZ, 0, GIT_MAX_RAWSZ - GIT_SHA1_RAWSZ);
        oid.algo = GIT_HASH_SHA1;
    }

    /*function git_hash_sha256_init(git_hash_ctx ctx) internal {
        git_SHA256_Init(ctx.sha256);
    }

    function git_hash_sha256_clone(git_hash_ctx dst, git_hash_ctx src) internal {
        git_SHA256_Clone(dst.sha256, src.sha256);
    }

    function git_hash_sha256_update(git_hash_ctx ctx, bytes data, uint32 len) internal {
        git_SHA256_Update(ctx.sha256, data, len);
    }

    function git_hash_sha256_final(string hash, git_hash_ctx ctx) internal {
        git_SHA256_Final(hash, ctx.sha256);
    }

    function git_hash_sha256_final_oid(object_id oid, git_hash_ctx ctx) internal {
        git_SHA256_Final(oid.hash, ctx.sha256);
        oid.algo = GIT_HASH_SHA256;
    }*/

    struct blk_SHA256_CTX {
        uint32[8] state;
        uint64 size;
        uint32 offset;
        uint8[64] buf; // blk_SHA256_BLKSIZE
    }

    function blk_SHA256_Init(blk_SHA256_CTX ctx) internal {}
    function blk_SHA256_Update(blk_SHA256_CTX ctx, bytes data, uint32 len) internal {}
    function blk_SHA256_Final(string digest, blk_SHA256_CTX ctx) internal {}
    function git_SHA1DCInit(SHA1_CTX) internal {}

    function SHA1DCSetSafeHash(SHA1_CTX ctx, bool flag) internal {
        ctx.safe_hash = flag;
    }

    function SHA1DCSetUseUBC(SHA1_CTX ctx, bool flag) internal {
        ctx.ubc_check = flag;
    }

    function SHA1DCSetUseDetectColl(SHA1_CTX ctx, bool flag) internal {
        ctx.detect_coll = flag;
    }

    function SHA1DCSetDetectReducedRoundCollision(SHA1_CTX ctx, bool flag) internal {
        ctx.reduced_round_coll = flag;
    }

    function SHA1DCSetCallback(SHA1_CTX ctx, uint32 collision_block_callback) internal {
        ctx.callback = collision_block_callback;
    }

    function git_SHA1DCUpdate(SHA1_CTX ctx, bytes data, uint32 len) internal {}

    function git_SHA1DCFinal(string, SHA1_CTX ctx) internal returns (bool) {
        return ctx.found_collision;
    }

    function git_SHA1_Clone(SHA1_CTX dst, SHA1_CTX src) internal {
        dst = src;
    }

struct git_hash_ctx {
    SHA1_CTX sha1;
//    SHA2
//    git_SHA256_CTX sha256;
}


    function hash_algo_by_name(string name) internal returns (uint8) {
        if (name == "sha1")
            return GIT_HASH_SHA1;
        else if (name == "sha256")
            return GIT_HASH_SHA256;
        return GIT_HASH_UNKNOWN;
    }

    function hash_algo_by_id(uint32 format_id) internal returns (uint8) {
        if (format_id == GIT_SHA1_FORMAT_ID)
            return GIT_HASH_SHA1;
        else if (format_id == GIT_SHA256_FORMAT_ID)
            return GIT_HASH_SHA256;
        return GIT_HASH_UNKNOWN;
    }

    function hash_algo_by_length(uint8 len) internal returns (uint8) {
        if (len == GIT_SHA1_RAWSZ)
            return GIT_HASH_SHA1;
        else if (len == GIT_SHA256_RAWSZ)
            return GIT_HASH_SHA256;
        return GIT_HASH_UNKNOWN;
    }

    function hash_algo_by_ptr(git_hash_algo p) internal returns (uint8) {
        return hash_algo_by_length(p.rawsz);
    }

    function hashcmp_algop(git_hash_algo algop, string sha1, string sha2) internal returns (bool) {
        if (algop.rawsz == GIT_MAX_RAWSZ)
            sha1.substr(0, GIT_MAX_RAWSZ) == sha2.substr(0, GIT_MAX_RAWSZ);
        return sha1.substr(0, GIT_SHA1_RAWSZ) == sha2.substr(0, GIT_SHA1_RAWSZ);
    }

    function hasheq_algop(git_hash_algo algop, string sha1, string sha2) internal returns (bool) {
        if (algop.rawsz == GIT_MAX_RAWSZ)
           return sha1.substr(0, GIT_MAX_RAWSZ) == sha2.substr(0, GIT_MAX_RAWSZ);
        return sha1.substr(0, GIT_SHA1_RAWSZ) == sha2.substr(0, GIT_SHA1_RAWSZ);
    }

    function hashcpy(string sha_dst, string sha_src) internal {
        sha_dst = sha_src;
    }
    function oidcpy(object_id dst, object_id src) internal {
        dst.hash = src.hash;
        dst.algo = src.algo;
    }

    function get_hash_algo(uint8 n) internal returns (git_hash_algo) {
        if (n == GIT_HASH_SHA1)
            return git_hash_algo("sha1", GIT_SHA1_FORMAT_ID, GIT_SHA1_RAWSZ, GIT_SHA1_HEXSZ, GIT_SHA1_BLKSZ,
		        object_id(EMPTY_TREE_SHA1_BIN_LITERAL, GIT_HASH_SHA1),
                object_id(EMPTY_BLOB_SHA1_BIN_LITERAL, GIT_HASH_SHA1),
                object_id("", GIT_HASH_SHA1));
        else if (n == GIT_HASH_SHA256)
            return git_hash_algo("sha256", GIT_SHA256_FORMAT_ID, GIT_SHA256_RAWSZ, GIT_SHA256_HEXSZ, GIT_SHA256_BLKSZ,
                object_id(EMPTY_TREE_SHA256_BIN_LITERAL, GIT_HASH_SHA256),
                object_id(EMPTY_BLOB_SHA256_BIN_LITERAL, GIT_HASH_SHA256),
                object_id("", GIT_HASH_SHA256));
    }
    function oid_set_algo(object_id oid, git_hash_algo algop) internal {
        oid.algo = hash_algo_by_ptr(algop);
    }

    function oiddup(object_id src) internal returns (object_id dst) {
        dst = src;
    }
    function hashclr(string hash) internal {
        delete hash;
    }
}

contract ghash {

	git_hash_algo the_hash_algo;
    using libghash for git_hash_algo;

    function hashcmp(string sha1, string sha2) internal returns (bool) {
        return the_hash_algo.hashcmp_algop(sha1, sha2);
    }

    function oidcmp(object_id oid1, object_id oid2) internal view returns (bool) {
        git_hash_algo algop;
        if (oid1.algo == 0)
            algop = the_hash_algo;
        else
            algop = libghash.get_hash_algo(oid1.algo);
        return algop.hashcmp_algop(oid1.hash, oid2.hash);
    }

    function is_null_oid(object_id oid) internal returns (bool) {
        return oideq(oid, null_oid());
    }

    function null_oid() internal returns (object_id) {
    }

    function oideq(object_id oid1, object_id oid2) internal view returns (bool) {
        git_hash_algo algop;
        if (oid1.algo == libghash.GIT_HASH_UNKNOWN)
            algop = the_hash_algo;
        else
            algop = libghash.get_hash_algo(oid1.algo);
        return algop.hasheq_algop(oid1.hash, oid2.hash);
    }

    function hasheq(string sha1, string sha2) internal returns (bool) {
        return the_hash_algo.hasheq_algop(sha1, sha2);
    }

    function init() internal {
    }

    function oidcpy_with_padding(object_id dst, object_id src) internal view  {
        uint32 hashsz;
        if (src.algo == libghash.GIT_HASH_UNKNOWN)
            hashsz = the_hash_algo.rawsz;
        else
            hashsz = libghash.get_hash_algo(src.algo).rawsz;
        dst.hash = src.hash;
        dst.algo = src.algo;
    }

    function oidclr(object_id oid) internal {
        delete oid.hash;
        oid.algo = the_hash_algo.hash_algo_by_ptr();
    }

    function oidread(object_id oid, string hash) internal {
        oid.hash = hash;
        oid.algo = the_hash_algo.hash_algo_by_ptr();
    }

    function is_empty_blob_sha1(string sha1) internal returns (bool) {
        return hasheq(sha1, string(the_hash_algo.empty_blob.hash));
    }

    function is_empty_blob_oid(object_id oid) internal view returns (bool) {
        return oideq(oid, the_hash_algo.empty_blob);
    }

    function is_empty_tree_sha1(string sha1) internal returns (bool) {
        return hasheq(sha1, string(the_hash_algo.empty_tree.hash));
    }

    function is_empty_tree_oid(object_id oid) internal view returns (bool) {
        return oideq(oid, the_hash_algo.empty_tree);
    }

    function empty_tree_oid_hex() internal returns (string) {}
    function empty_blob_oid_hex() internal returns (string) {}
}
