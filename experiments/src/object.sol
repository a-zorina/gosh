pragma ton-solidity >= 0.58.0;
import "repository.sol";
import "sys/gtypes.sol";

contract objectc {

    uint8 constant OBJECT_INFO_INIT = 0;
    uint8 constant OBJECT_INFO_LOOKUP_REPLACE = 1; // Invoke lookup_replace_object() on the given hash
    uint8 constant OBJECT_INFO_ALLOW_UNKNOWN_TYPE = 2; // Allow reading from a loose object file of unknown/bogus type
    uint8 constant OBJECT_INFO_QUICK = 8; // Do not retry packed storage after checking packed and loose storage
    uint8 constant OBJECT_INFO_IGNORE_LOOSE = 16; // Do not check loose object
    uint8 constant OBJECT_INFO_SKIP_FETCH_OBJECT = 32; // Do not attempt to fetch the object if missing (even if fetch_is_missing is nonzero).
    uint8 constant OBJECT_INFO_FOR_PREFETCH = OBJECT_INFO_SKIP_FETCH_OBJECT | OBJECT_INFO_QUICK; // This is meant for bulk prefetching of missing blobs in a partial clone. Implies OBJECT_INFO_SKIP_FETCH_OBJECT and OBJECT_INFO_QUICK
	uint8 constant FOR_EACH_OBJECT_LOCAL_ONLY = 1 << 0; // Iterate only over local objects, not alternates
	uint8 constant FOR_EACH_OBJECT_PROMISOR_ONLY = 1 << 1; // Only iterate over packs obtained from the promisor remote.
	uint8 constant FOR_EACH_OBJECT_PACK_ORDER = 1 << 2;     //  Visit objects within a pack in packfile order rather than .idx order
	uint8 constant FOR_EACH_OBJECT_SKIP_IN_CORE_KEPT_PACKS = 1 << 3; // Only iterate over packs that are not marked as kept in-core.
	uint8 constant FOR_EACH_OBJECT_SKIP_ON_DISK_KEPT_PACKS = 1 << 4; // Only iterate over packs that do not have .keep files.

    uint8 constant FLAG_BITS = 28;

    /*
     * This can be used to see if we have heard of the object before, but
     * it can return "yes we have, and here is a half-initialised object"
     * for an object that we haven't loaded/parsed yet.
     *
     * When parsing a commit to create an in-core commit object, its
     * parents list holds commit objects that represent its parents, but
     * they are expected to be lazily initialized and do not know what
     * their trees or parents are yet.  When this function returns such a
     * half-initialised objects, the caller is expected to initialize them
     * by calling parse_object() on them.
     */
    function lookup_object(repository r, object_id oid) internal returns (object) {}
    function create_object(repository r, object_id oid, bytes obj) internal returns (bytes) {}
    function object_as_type(object obj, object_type otype, bool quiet) internal returns (bytes) {}
    /*
     * Returns the object, having parsed it to find out what it is.
     *
     * Returns NULL if the object is missing or corrupt.
     */
    function parse_object(repository r, object_id oid) internal returns (object) {}
}