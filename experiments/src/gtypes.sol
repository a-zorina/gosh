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
enum fetch_head_status { FETCH_HEAD_MERGE, FETCH_HEAD_NOT_FOR_MERGE, FETCH_HEAD_IGNORE }
enum match_status { REF_NOT_MATCHED, REF_MATCHED, REF_UNADVERTISED_NOT_ALLOWED }
enum recurse_submodules { RECURSE_SUBMODULES_ONLY, RECURSE_SUBMODULES_CHECK, RECURSE_SUBMODULES_ERROR, RECURSE_SUBMODULES_NONE, RECURSE_SUBMODULES_ON_DEMAND, RECURSE_SUBMODULES_OFF, RECURSE_SUBMODULES_DEFAULT, RECURSE_SUBMODULES_ON } // starts at -5
enum submodule_update_type { SM_UPDATE_UNSPECIFIED, SM_UPDATE_CHECKOUT, SM_UPDATE_REBASE, SM_UPDATE_MERGE, SM_UPDATE_NONE, SM_UPDATE_COMMAND }
enum pattern_match_result { UNDECIDED, NOT_MATCHED, MATCHED, MATCHED_RECURSIVE } // starts at -1
enum untracked_dir_flags { DIR_SHOW_IGNORED, DIR_SHOW_OTHER_DIRECTORIES, DIR_HIDE_EMPTY_DIRECTORIES, DIR_NO_GITLINKS, DIR_COLLECT_IGNORED, DIR_SHOW_IGNORED_TOO, DIR_COLLECT_KILLED_ONLY, DIR_KEEP_UNTRACKED_CONTENTS, DIR_SHOW_IGNORED_TOO_MODE_MATCHING, DIR_SKIP_NESTED_GIT } // powers of 2
enum commit_graph_write_flags { COMMIT_GRAPH_WRITE_APPEND, COMMIT_GRAPH_WRITE_PROGRESS, COMMIT_GRAPH_WRITE_SPLIT, COMMIT_GRAPH_WRITE_BLOOM_FILTERS, COMMIT_GRAPH_NO_WRITE_BLOOM_FILTERS }  // powers of 2
enum commit_graph_split_flags { COMMIT_GRAPH_SPLIT_UNSPECIFIED, COMMIT_GRAPH_SPLIT_MERGE_PROHIBITED, COMMIT_GRAPH_SPLIT_REPLACE }

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

struct ewah_bitmap {
    uint64[] buffer;
    uint16 buffer_size;
    uint16 alloc_size;
    uint16 bit_size;
    uint64[] rlw;
}

struct split_index {
    object_id base_oid;
    ewah_bitmap delete_bitmap;
    ewah_bitmap replace_bitmap;
    cache_entry[] saved_cache;
    uint16 saved_cache_nr;
    uint16 nr_deletions;
    uint16 nr_replacements;
    uint16 refcount;
}

struct index_state {
    cache_entry[] cache;
    uint16 version;
    uint16 cache_nr;
    uint16 cache_alloc;
    uint16 cache_changed;
    string[] resolve_undo;
    cache_tree ccache_tree;
    split_index ssplit_index;
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
    ewah_bitmap fsmonitor_dirty;
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

struct refspec_item {
    bool force;
    bool pattern;
    bool matching;
    bool exact_sha1;
    bool negative;
    string src;
    string dst;
}

// An array of strings can be parsed into a struct refspec using parse_fetch_refspec() or parse_push_refspec().
struct refspec {
    refspec_item[] items;
    uint16 alloc;
    uint16 nr;
    string[] raw;
    uint16 raw_alloc;
    uint16 raw_nr;
    bool fetch;
}

struct remote {
    hashmap_entry ent;
    string name;        // The users nickname for the remote
    bool origin;
    bool configured_in_repo;
    string foreign_vcs;
    string[] url;      // An array of all of the url_nr URLs configured for the remote
    uint16 url_nr;
    uint16 url_alloc;
    string[] pushurl;  // An array of all of the pushurl_nr push URLs configured for the remote
    uint16 pushurl_nr;
    uint16 pushurl_alloc;
    refspec push;
    refspec fetch;
    uint8 fetch_tags;
    bool skip_default_update;
    bool mirror;
    bool prune;
    bool prune_tags;
    string receivepack;  // The configured helper programs to run on the remote side,
    string uploadpack;   // for Git-native protocols.
    string http_proxy;  // The proxy to use for curl (http, https, ftp, etc.) URLs.
    string http_proxy_authmethod;   // The method used for authenticating against `http_proxy`.
}

struct ref_push_report {
    string ref_name;
    object_id old_oid;
    object_id new_oid;
    bool forced_update;
}

struct ref {
    object_id old_oid;
    object_id new_oid;
    object_id old_oid_expect; // used by expect-old
    string symref;
    string tracking_ref;
    bool force;
    bool forced_update;
    bool expect_old_sha1;
    bool exact_oid;
    bool deletion;
    bool check_reachable; // Need to check if local reflog reaches the remote tip.
    bool unreachable;     // Store the result of the check enabled by "check_reachable";
    match_status mmatch_status;
    fetch_head_status ffetch_head_status;
}

// struct branch holds the configuration for a branch. It can be looked up with
// branch_get(name) for "refs/heads/{name}", or with branch_get(NULL) for HEAD.
struct branch {
    hashmap_entry ent;
    string name;         // The short name of the branch.
    string refname;      // The full path for the branch ref.
    string remote_name;  // The name of the remote listed in the configuration.
    string pushremote_name;
    string[] merge_name; // An array of the "merge" lines in the configuration.
    refspec_item[] merge;// An array of the struct refspecs used for the merge lines. That is, merge[i].dst is a local tracking ref which should be merged into this branch by default.
    uint16 merge_nr;     // The number of merge configurations
    uint16 merge_alloc;
    string  push_tracking_ref;
}

struct remote_state {
    remote[] remotes;
    uint16 remotes_alloc;
    uint16 remotes_nr;
    hashmap remotes_hash;
    hashmap branches_hash;
    branch current_branch;
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

struct submodule_update_strategy {
    submodule_update_type utype;
    string command;
}

struct submodule {
    string path;
    string name;
    string url;
    bool fetch_recurse;
    string ignore;
    string branch;
    submodule_update_strategy update_strategy;
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

struct commit_graph {
    string data;
    uint16 data_len;
    uint8 hash_len;
    uint8 num_chunks;
    uint32 num_commits;
    object_id oid;
    string filename;
    object_directory odb;
    uint32 num_commits_in_base;
    uint16 read_generation_data;
    uint32[] chunk_oid_fanout;
    string chunk_oid_lookup;
    string chunk_commit_data;
    string chunk_generation_data;
    string chunk_generation_data_overflow;
    string chunk_extra_edges;
    string chunk_base_graphs;
    string chunk_bloom_indexes;
    string chunk_bloom_data;
    struct topo_level_slab *topo_levels;
    struct bloom_filter_settings *bloom_filter_settings;
}

struct raw_object_store {
    object_directory odb;               // Set of all object directories; the main directory is first (and cannot be NULL after initialization). Subsequent directories are alternates.
    object_directory[] odb_tail;
// kh_odb_path_map_t *odb_by_path;
    bool loaded_alternates;
    string[] alternate_db;              // A list of alternate object directories loaded from the environment; this should not generally need to be accessed directly, but will populate the "odb" list when prepare_alt_odb() is run.
    oidmap replace_map;                 // Objects that should be substituted by other objects (see git-replace(1)).
    bool replace_map_initialized;
    uint16 replace_mutex;               // protect object replace functions
// struct commit_graph *commit_graph;
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
    alloc_state blob_state;
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
//  struct buffer_slab *buffer_slab;
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
    bytes k; // FLEX_ARRAY arbitrary data, unaligned
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
    uint32 cmpfn; 	     // Stores the comparison function specified in `hashmap_init()`.
    bytes cmpfn_data;
    uint32 private_size; // total number of entries (0 means the hashmap is empty). use hashmap_get_size()
    uint32 tablesize;    // allocated size of the hash table. A non-0 value indicates that the hashmap is initialized.
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
    bool local;
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

struct dir_entry {
    uint8 len;
    string name;
}

struct path_pattern {
    string pattern;
    uint16 patternlen;
    uint16 nowildcardlen;
    string base;
    uint16 baselen;
    uint16 flags; // PATTERN_FLAG_*
    int16 srcpos; // Counting starts from 1 for line numbers in ignore files, and from -1 decrementing for patterns from CLI args.
}

// used for hashmaps for cone patterns
struct pattern_entry {
    hashmap_entry ent;
    string pattern;
    uint16 patternlen;
}

struct pattern_list {
    uint16 nr;
    uint16 alloc;
    string filebuf; // remember pointer to exclude file contents so we can free()
    string src;     // origin of list, e.g. path to filename, or descriptive string
    path_pattern[] patterns;
    bool use_cone_patterns;
    bool full_cone;
    hashmap recursive_hashmap;  // Stores paths where everything starting with those paths is included.
    hashmap parent_hashmap;     // Used to check single-level parents of blobs.
}

// The contents of the per-directory exclude files are lazily read on demand and then cached in memory, one per exclude_stack struct, in
// order to avoid opening and parsing each one every time that directory is traversed.
struct exclude_stack {
    uint16 baselen;
    uint16 exclude_ix; // index of exclude_list within EXC_DIRS exclude_list_group
    untracked_cache_dir ucd;
}

struct exclude_list_group {
    uint16 nr;
    uint16 alloc;
    pattern_list pl;
}

struct oid_stat {
    stat_data stat;
    object_id oid;
    bool valid;
}

struct untracked_cache_dir {
    string[] untracked;
    stat_data sstat_data;
    uint16 untracked_alloc;
    uint16 dirs_nr;
    uint16 dirs_alloc;
    uint16 untracked_nr;
    bool check_only;
    bool valid;         // all data except 'dirs' in this struct are good
    bool recurse;
    object_id exclude_oid; // null object ID means this directory does not have .gitignore
    string name;
}

struct untracked_cache {
    oid_stat ss_info_exclude;
    oid_stat ss_excludes_file;
    string exclude_per_dir;
    strbuf ident;
    uint16 dir_flags; // dir_struct#flags must match dir_flags or the untracked cache is ignored.
    untracked_cache_dir[] root;
    uint16 dir_created; // Statistics
    uint16 gitignore_invalidated;
    uint16 dir_invalidated;
    uint16 dir_opened;
    bool use_fsmonitor; // fsmonitor invalidation data
}

struct dir_struct {
    uint16 nr;      // The number of members in `entries[]` array.
    uint16 alloc;   // Internal use; keeps track of allocation of `entries[]` array
    uint16 ignored_nr; // The number of members in `ignored[]` array.
    uint16 ignored_alloc;
    dir_entry[] entries;        // An array of `struct dir_entry`, each element of which describes a path.
    dir_entry[] ignored;        // used for ignored paths with the `DIR_SHOW_IGNORED_TOO` and `DIR_COLLECT_IGNORED` flags.
    untracked_dir_flags flags;  // bit-field of options
    string exclude_per_dir;     // The name of the file to be read in each directory for excluded files (typically `.gitignore`).
    exclude_list_group[3] eexclude_list_group;
    exclude_stack eexclude_stack; // points to the top of the exclude_stack
    path_pattern pattern;
    strbuf basebuf;     // contains the full path to the current (sub)directory in the traversal
    untracked_cache untracked;         // Enable untracked file cache if set
    oid_stat ss_info_exclude;
    oid_stat ss_excludes_file;
    uint16 unmanaged_exclude_files;
    uint16 visited_paths;         // Stats about the traversal
    uint16 visited_directories;
}
