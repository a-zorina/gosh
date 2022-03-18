pragma ton-solidity >= 0.58.0;

enum untracked_cache_setting { UNTRACKED_CACHE_KEEP, UNTRACKED_CACHE_REMOVE, UNTRACKED_CACHE_WRITE }
enum fetch_negotiation_setting { FETCH_NEGOTIATION_DEFAULT, FETCH_NEGOTIATION_SKIPPING, FETCH_NEGOTIATION_NOOP }
enum list_objects_filter_choice { LOFC_DISABLED, LOFC_BLOB_NONE, LOFC_BLOB_LIMIT, LOFC_TREE_DEPTH, LOFC_SPARSE_OID, LOFC_OBJECT_TYPE, LOFC_COMBINE, LOFC__COUNT }
enum whence { OI_CACHED, OI_LOOSE, OI_PACKED, OI_DBCACHED }
enum object_type { OBJ_NONE, OBJ_COMMIT, OBJ_TREE, OBJ_BLOB, OBJ_TAG, OBJ_BAD, OBJ_OFS_DELTA, OBJ_REF_DELTA, OBJ_ANY, OBJ_MAX }
enum cb_next { CB_CONTINUE, CB_BREAK }
enum remotes { REMOTE_UNCONFIGURED, REMOTE_CONFIG, REMOTE_REMOTES, REMOTE_BRANCHES }
enum lookup_type { lookup_name, lookup_path }
enum attr_match_mode { MATCH_SET, MATCH_UNSET, MATCH_VALUE, MATCH_UNSPECIFIED }
enum ps_skip_worktree_action { PS_HEED_SKIP_WORKTREE, PS_IGNORE_SKIP_WORKTREE }
enum branch_track { BRANCH_TRACK_NEVER, BRANCH_TRACK_REMOTE, BRANCH_TRACK_ALWAYS, BRANCH_TRACK_EXPLICIT, BRANCH_TRACK_OVERRIDE, BRANCH_TRACK_INHERIT }
enum git_attr_direction { GIT_ATTR_CHECKIN, GIT_ATTR_CHECKOUT, GIT_ATTR_INDEX }
enum sharedrepo { PERM_UMASK, OLD_PERM_GROUP, OLD_PERM_EVERYBODY, PERM_GROUP, PERM_EVERYBODY }
enum scld_error { SCLD_OK, SCLD_FAILED, SCLD_PERMS, SCLD_EXISTS, SCLD_VANISHED }
enum unpack_loose_header_result { ULHR_OK, ULHR_BAD, ULHR_TOO_LONG }
enum date_mode_type { DATE_NORMAL, DATE_HUMAN, DATE_RELATIVE, DATE_SHORT, DATE_ISO8601, DATE_ISO8601_STRICT, DATE_RFC2822, DATE_STRFTIME, DATE_RAW, DATE_UNIX }
enum want_ident { WANT_BLANK_IDENT, WANT_AUTHOR_IDENT, WANT_COMMITTER_IDENT }
enum log_refs_config { LOG_REFS_NONE, LOG_REFS_NORMAL, LOG_REFS_ALWAYS }
enum rebase_setup_type { AUTOREBASE_NEVER, AUTOREBASE_LOCAL, AUTOREBASE_REMOTE, AUTOREBASE_ALWAYS }
enum push_default_type { PUSH_DEFAULT_NOTHING, PUSH_DEFAULT_MATCHING, PUSH_DEFAULT_SIMPLE, PUSH_DEFAULT_UPSTREAM, PUSH_DEFAULT_CURRENT, PUSH_DEFAULT_UNSPECIFIED }
enum object_creation_mode { OBJECT_CREATION_USES_HARDLINKS, OBJECT_CREATION_USES_RENAMES }
enum get_oid_result { FOUND, MISSING_OBJECT, SHORT_NAME_AMBIGUOUS, DANGLING_SYMLINK, SYMLINK_LOOP, NOT_DIR } 

struct object_list {
    object item;
    object next;
}

struct object_array_entry {
    object item;
    string name; // name or NULL.  If non-NULL, the memory pointed to is owned by this object *except* if it points at object_array_slopbuf, which is a static copy of the empty string.
    string path;
    uint16 mode;
}

struct object_array {
    uint16 nr;
    uint16 alloc;
    object_array_entry objects;
}

struct object_id {
//    bytes20 hash;   // [GIT_MAX_RAWSZ];
    string hash;   // [GIT_MAX_RAWSZ];
    uint8 algo;     // XXX requires 4-byte alignment
}

struct object {
    uint32 flags; // bool parsed; uint8 otype; uint28 flags
    object_id oid;
}

struct string_list_item {
    string sstring;
    bytes util;
}

struct string_list {
    string_list_item[] items;
    uint16 nr;
    uint16 alloc;
    bool strdup_strings;
    uint32 cmp; // NULL uses strcmp()
}

struct git_hash_algo {
    string name;          // The name of the algorithm, as appears in the config file and in messages.
    uint32 format_id;     // A four-byte version identifier, used in pack indices.
    uint8 rawsz;         // The length of the hash in binary.
    uint8 hexsz;         // The length of the hash in hex characters.
    uint8 blksz;         // The block size of the hash.
    /*uint32 init_fn;       // The hash initialization function.
    uint32 clone_fn;      // The hash context cloning function.
    uint32 update_fn;     // The hash update function.
    uint32 final_fn;      // The hash finalization function.
    uint32 final_oid_fn;  // The hash finalization function for object IDs.*/
    object_id empty_tree; // The OID of the empty tree.
    object_id empty_blob; // The OID of the empty blob.
    object_id null_oid;   // The all-zeros OID.
}

struct repo_settings {
	bool initialized;
	bool core_commit_graph;
	bool commit_graph_read_changed_paths;
	bool gc_write_commit_graph;
	bool fetch_write_commit_graph;
	bool command_requires_full_index;
	bool sparse_index;
	bool index_version;
	untracked_cache_setting core_untracked_cache;
	bool pack_use_sparse;
	fetch_negotiation_setting fetch_negotiation_algorithm;
	bool core_multi_pack_index;
}

struct pack_window {
	string base;
	uint32 offset;
	uint32 len;
	uint32 last_used;
	uint32 inuse_cnt;
}

struct pack_entry {
	uint32 offset;
	uint16 p;
}

struct revindex_entry {
	uint32 offset;
	uint16 nr;
}

struct packed_git {
    hashmap_entry packmap_ent;
    uint16[] mru;
    pack_window[] windows;
    uint32 pack_size;
    bytes index_data;
    uint32 index_size;
    uint32 num_objects;
    uint32 crc_offset;
    oidset bad_objects;
    uint16 index_version;
    uint32 mtime;
    uint16 pack_fd;
    uint16 index;   // for builtin/pack-objects.c
    bool pack_local;
    bool pack_keep;
    bool pack_keep_in_core;
    bool freshened;
    bool do_not_close;
    bool pack_promisor;
    bool multi_pack_index;
    bytes20 hash;    //[GIT_MAX_RAWSZ];
    revindex_entry revindex;
    uint32 revindex_data;
    uint32 revindex_map;
    uint32 revindex_size;
    string pack_name; // something like ".git/objects/pack/xxxxx.pack"
}

struct path_cache {
	string squash_msg;
	string merge_msg;
	string merge_rr;
	string merge_mode;
	string merge_head;
	string merge_autostash;
	string auto_merge;
	string fetch_head;
	string shallow;
}

struct cache_header {
    uint32 hdr_signature;
    uint32 hdr_version;
    uint32 hdr_entries;
}

struct cache_entry {
    hashmap_entry ent;
    stat_data ce_stat_data;
    uint16 ce_mode;
    uint32 ce_flags;
    bool mem_pool_allocated;
    uint16 ce_namelen;
    uint16 index;     // for link extension
    object_id oid;
    string name; // [FLEX_ARRAY]; more
}

struct cache_tree_sub {
    uint16 count;   // internally used by update_one()
    uint16 namelen;
    uint16 used;
    string name;    //[FLEX_ARRAY];
}

struct cache_tree {
    int16 entry_count; // negative means "invalid"
    object_id oid;
    uint16 subtree_nr;
    uint16 subtree_alloc;
    cache_tree_sub[] down;
}

struct index_state {
    cache_entry[] cache;
    uint16 version;
    uint16 cache_nr;
    uint16 cache_alloc;
    uint16 cache_changed;
    string[] resolve_undo;
    cache_tree ccache_tree;
//    split_index split_index;
    cache_time timestamp;
    bool name_hash_initialized;
    bool initialized;
    bool drop_cache_tree;
    bool updated_workdir;
    bool updated_skipworktree;
    bool fsmonitor_has_run_once;
    bool sparse_index; // sparse_index == 1 when sparse-directory entries exist. Requires sparse-checkout in cone mode.
    hashmap name_hash;
    hashmap dir_hash;
    object_id oid;
//    struct untracked_cache *untracked;
    string fsmonitor_last_update;
//    struct ewah_bitmap *fsmonitor_dirty;
    mem_pool ce_mem_pool;
//    struct progress *progress;
//    struct pattern_list *sparse_checkout_patterns;
}

struct rewrite {
    string base;
    uint32 baselen;
    string instead_of;
    uint16 instead_of_nr;
    uint16 instead_of_alloc;
}

struct rewrites {
    rewrite[] rrewrite;
    uint16 rewrite_alloc;
    uint16 rewrite_nr;
}

struct remote_state {
//   struct remote **remotes;
   uint16 remotes_alloc;
   uint16 remotes_nr;
   hashmap remotes_hash;
   hashmap branches_hash;
//   struct branch *current_branch;
   string pushremote_name;
   rewrites rrewrites;
   rewrites rewrites_push;
   bool initialized;
}

struct config_set_element {
    hashmap_entry ent;
    string key;
    string[] value_list;
}

struct configset_list_item {
    config_set_element e;
    uint16 value_index;
}

struct configset_list {
    configset_list_item[] items;
    uint16 nr;
    uint16 alloc;
}

struct config_set {
    hashmap config_hash;
    bool hash_initialized;
    configset_list list;
}

struct ref_storage_be {
	string name;
	uint32 init;
	uint32 init_db;
	uint32 transaction_prepare;
	uint32 transaction_finish;
	uint32 transaction_abort;
	uint32 initial_transaction_commit;
	uint32 pack_refs;
	uint32 create_symref;
	uint32 delete_refs;
	uint32 rename_ref;
	uint32 copy_ref;
	uint32 iterator_begin;
	uint32 read_raw_ref;
	uint32 reflog_iterator_begin;
	uint32 for_each_reflog_ent;
	uint32 for_each_reflog_ent_reverse;
	uint32 reflog_exists;
	uint32 create_reflog;
	uint32 delete_reflog;
	uint32 reflog_expire;
}

struct ref_store {
	ref_storage_be be; 	// The backend describing this ref_store's storage scheme:
	string gitdir;      // The gitdir that this ref_store applies to. Note that this is not necessarily repo->gitdir if the repo has multiple worktrees.
}

struct submodule_cache {
    hashmap for_path;
    hashmap for_name;
    bool initialized;
    bool gitmodules_read;
}

struct submodule {
    string path;
    string name;
    string url;
    bool fetch_recurse;
    string ignore;
    string branch;
//    struct submodule_update_strategy update_strategy;
    object_id gitmodules_oid; // the object id of the responsible .gitmodules file
    bool recommend_shallow;
}

// thin wrapper struct needed to insert 'struct submodule' entries to the hashmap
struct submodule_entry {
    hashmap_entry ent;
    submodule config;
}

struct promisor_remote {
    string partial_clone_filter;
    string name; //[FLEX_ARRAY];
}

struct promisor_remote_config {
    promisor_remote promisors;
    promisor_remote[] promisors_tail;
}

struct repository {
	string gitdir;
	string commondir;
	raw_object_store objects;
	parsed_object_pool parsed_objects;
	ref_store refs_private;
	path_cache cached_paths;
	string graft_file;
	string index_file;
	string worktree;
	string submodule_prefix;
	repo_settings settings;
	config_set config;
	submodule_cache ssubmodule_cache;
	index_state index;
	remote_state rremote_state;
	git_hash_algo hash_algo;
	uint16 trace2_repo_id;
	bool commit_graph_disabled;
	string repository_format_partial_clone;
    promisor_remote_config ppromisor_remote_config;
	bool different_commondir;
}

struct attr_match {
    string value;
    attr_match_mode match_mode;
}

struct git_attr {
    uint16 attr_nr; // unique attribute number
    string name; // [FLEX_ARRAY]; attribute name
}

struct attr_check_item {
    git_attr attr;
    string value;
}

 // This structure represents a collection of `attr_check_item`. It is passed to `git_check_attr()` function, specifying the attributes to check, and
 // receives their values.
struct attr_check {
    uint16 nr;
    uint16 alloc;
    attr_check_item[] items;
    uint16 all_attrs_nr;
    all_attrs_item all_attrs;
    attr_stack stack;
}

struct all_attrs_item {
    git_attr attr;
    string value;
    match_attr mmacro; // If 'macro' is non-NULL, indicates that 'attr' is a macro based on the current attribute stack and contains a pointer to the match_attr definition of the macro
}

struct check_vector {
    uint16 nr;
    uint16 alloc;
    attr_check[] checks;
    uint16 mutex;
}

struct attr_hashmap {
    hashmap map;
    uint16 mutex;
}

struct attr_hash_entry {
    hashmap_entry ent;
    string key;     // the key; memory should be owned by value
    uint16 keylen;  // length of the key
    bytes value;    // the stored value
}

struct attr_state {
    git_attr[] attr;
    string setto;
}

struct pattern {
    string ppattern;
    uint16 patternlen;
    uint16 nowildcardlen;
    uint16 flags;         // PATTERN_FLAG_*
}

struct match_attr {
    pattern pat;    // union start
    git_attr attr;  // union end
    bool is_macro;
    uint16 num_attr;
    attr_state[] state; //[FLEX_ARRAY];
}

struct attr_stack {
    string origin;
    uint16 originlen;
    uint16 num_matches;
    uint16 alloc;
    match_attr[] attrs;
}

struct pathspec_item {
    string mmatch;
    string original;
    uint16 magic;
    uint16 len;
    uint16 prefix;
    uint16 nowildcard_len;
    uint16 flags;
    uint16 attr_match_nr;
    attr_match aattr_match;
    attr_check aattr_check;
}

struct pathspec {
    uint16 nr;
    bool has_wildcard;
    bool recursive;
    bool recurse_submodules;
    uint16 magic;
    uint16 max_depth;
    pathspec_item[] items;
}

// Define a custom repository layout. Any field can be NULL, which will default back to the path according to the default layout.
struct set_gitdir_args {
	string commondir;
	string object_dir;
	string graft_file;
	string index_file;
	string alternate_db;
	bool disable_ref_updates;
}

struct object_directory {
	// Used to store the results of readdir(3) calls when we are OK sacrificing accuracy due to races for speed. That includes object existence with OBJECT_INFO_QUICK, as well as
	// our search for unique abbreviated hashes. Don't use it for tasks requiring greater accuracy! Be sure to call odb_load_loose_cache() before using.
	uint32[8] loose_objects_subdir_seen; // 256 bits
	oidtree[] loose_objects_cache;
    bool disable_ref_updates;   // This is a temporary object store created by the tmp_objdir facility. Disable ref updates since the objects in the store might be discarded on rollback.
	bool will_destroy;          // This object store is ephemeral, so there is no need to fsync.
	string path;                // Path to the alternative object store. If this is a relative path, it is relative to the current working directory.
}

struct kept_pack_cache {
	packed_git[] packs;
	uint32 flags;
}

struct raw_object_store {
	object_directory odb;               // Set of all object directories; the main directory is first (and cannot be NULL after initialization). Subsequent directories are alternates.
	object_directory[] odb_tail;
//	kh_odb_path_map_t *odb_by_path;
	bool loaded_alternates;
	string[] alternate_db;                // A list of alternate object directories loaded from the environment; this should not generally need to be accessed directly, but will populate the "odb" list when prepare_alt_odb() is run.
	oidmap replace_map;                 // Objects that should be substituted by other objects (see git-replace(1)).
	bool replace_map_initialized;
	uint16 replace_mutex;               // protect object replace functions
//	struct commit_graph *commit_graph;
	bool commit_graph_attempted;        // if loading has been attempted
	multi_pack_index mmulti_pack_index; // private data should only be accessed directly by packfile.c and midx.c
	packed_git ppacked_git; 	        // private data. should only be accessed directly by packfile.c
	uint16[] packed_git_mru;            // A most-recently-used ordered version of the packed_git list
    kept_pack_cache ekept_pack_cache;
	hashmap pack_map; 	                // A map of packfiles to packed_git structs for tracking which packs have been loaded already.
	uint32 approximate_object_count;    // A fast, rough count of the number of objects in the repository. These two fields are not meant for direct access. Use approximate_object_count() instead.
	bool approximate_object_count_valid;
	bool packed_git_initialized;        // Whether packed_git has already been populated with this repository's packs.
}

struct multi_pack_index {
	string data;
	uint32 data_len;
	uint32[] revindex_data;
	uint32[] revindex_map;
	uint32 revindex_len;
	uint32 signature;
	uint8 version;
	uint8 hash_len;
	uint8 num_chunks;
	uint32 num_packs;
	uint32 num_objects;
	bool local;
	string chunk_pack_names;
	uint32 chunk_oid_fanout;
	string chunk_oid_lookup;
	string chunk_object_offsets;
	string chunk_large_offsets;
	string[] pack_names;
	packed_git[] packs;
	string object_dir;  //[FLEX_ARRAY];
}

struct packed {
	packed_git pack;
	uint32 offset;
	bool is_delta;
}

struct object_info {
	object_type typep; // Request
	uint32 sizep;
	uint32 disk_sizep;
	object_id delta_base_oid;
	strbuf type_name;
	bytes[] contentp;
    whence ewhence; 	// Response
    packed u;
}

struct alloc_state {
	uint16 count;   // total number of nodes allocated
	uint16 nr;      // number of nodes left in current allocation
	bytes p;        // first free node in current allocation
	bytes[] slabs;  // bookkeeping of allocations
	uint16 slab_nr;
    uint16 slab_alloc;
}

struct commit_graft {
	object_id oid;
	int16 nr_parent;    // < 0 if shallow commit
	object_id[] parent; // FLEX_ARRAY more
}

struct cache_time {
	uint32 sec;
	uint32 nsec;
}

struct stat_data {
	cache_time sd_ctime;
	cache_time sd_mtime;
	uint16 sd_dev;
	uint16 sd_ino;
	uint16 sd_uid;
	uint16 sd_gid;
	uint16 sd_size;
}

struct stat_validity {
	stat_data sd;
}

struct strbuf {
	uint32 alloc;
	uint32 len;
	string buf;
}

struct parsed_object_pool {
	object[] obj_hash;
	uint16 nr_objs;
    uint16 obj_hash_size;
    alloc_state blob_state; // TODO: migrate alloc_states to mem-pool?
	alloc_state tree_state;
	alloc_state commit_state;
	alloc_state tag_state;
	alloc_state object_state;
	commit_graft[] grafts; 	// parent substitutions from .git/info/grafts and .git/shallow
	uint16 grafts_alloc;
    uint16 grafts_nr;
	bool is_shallow;
	stat_validity shallow_stat;
	string alternate_shallow_file;
	bool commit_graft_prepared;
	bool substituted_parent;

//	struct buffer_slab *buffer_slab;
}

struct oidmap_entry {
	hashmap_entry internal_entry; // For internal use only
	object_id oid;
}

struct oidmap {
	hashmap map;
}

struct oidmap_iter {
	hashmap_iter h_iter;
}

struct oidset {
	uint32[] set;
}

struct oidset_iter {
	uint32[] set;
	uint32 iter;
}

struct cb_node {
    uint16[2] child;
    uint32 xbyte; // n.b. uint32_t for `byte' is excessive for OIDs, we may consider shorter variants if nothing else gets stored.
    uint8 otherbits;
    uint8[] k; // FLEX_ARRAY arbitrary data, unaligned
}

struct cb_tree {
    cb_node root;
}

struct mp_block {
    uint16 next_block;
    string next_free;
    string end;
    uint16[] space; // FLEX_ARRAY more
}

struct mem_pool {
    mp_block[] mp_blocks;
    uint32 block_alloc; // The amount of available memory to grow the pool by. This size does not include the overhead for the mp_block.
    uint32 pool_alloc; // The total amount of memory allocated by the pool.
}

struct oidtree {
	cb_tree tree;
	mem_pool mmem_pool;
}

struct cmdname {
    uint32 len; // also used for similarity index in help.c
	string name; // [FLEX_ARRAY];
}

struct cmdnames {
	uint16 alloc;
	uint16 cnt;
	cmdname[] names;
}

struct hashmap_entry {
	uint32 hash;
}

struct hashmap {
	hashmap_entry[] table;
	uint32 cmpfn; 	/* Stores the comparison function specified in `hashmap_init()`. */
	bytes cmpfn_data;
	/* total number of entries (0 means the hashmap is empty) */
	uint32 private_size; /* use hashmap_get_size() */

	// tablesize is the allocated size of the hash table. A non-0 value indicates that the hashmap is initialized. It may also be useful
	// for statistical purposes (i.e. `size / tablesize` is the current load factor).
	uint32 tablesize;
	uint32 grow_at;
	uint32 shrink_at;
	bool do_count_items;
}

struct hashmap_iter {
	hashmap map;
	hashmap_entry next;
	uint32 tablepos;
}

struct lock_file {
    tempfile ttempfile;
}

struct tempfile {
    uint16 active;
    uint16 fd;
//    s_of fp;
    uint16 owner;
    strbuf filename;
}

struct startup_info {
    bool have_repository;
    string prefix;
    string original_cwd;
}

struct cache_def {
    strbuf path;
    uint16 flags;
    uint16 track_flags;
    uint16 prefix_len_stat_func;
}

struct ident_split {
    string name_begin;
    string name_end;
    string mail_begin;
    string mail_end;
    string date_begin;
    string date_end;
    string tz_begin;
    string tz_end;
}

struct date_mode {
    date_mode_type dtype;
    string strftime_fmt;
    int local;
}

struct repository_format {
    int16 version;
    bool precious_objects;
    string partial_clone; // value of extensions.partialclone
    uint16 worktree_config;
    int16 is_bare;
    uint8 hash_algo;
    bool sparse_index;
    string work_tree;
    string[] unknown_extensions;
    string[] v1_only_extensions;
}

struct object_context {
    uint16 mode;
    strbuf symlink_path;
    string path;
}

struct interpret_branch_name_options {
    uint16 allowed;
    bool nonfatal_dangling_mark;
}

