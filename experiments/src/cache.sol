pragma ton-solidity >= 0.58.0;
import "sys/gtypes.sol";

library cache {
    uint8 constant DT_UNKNOWN = 0;
    uint8 constant DT_DIR     = 1;
    uint8 constant DT_REG     = 2;
    uint8 constant DT_LNK     = 3;
//#define DTYPE(de)       DT_UNKNOWN
    uint16 constant S_IFINVALID = 0x3000; //    0030000
    uint16 constant S_IFGITLINK = 0xE000;// 0160000

    function S_ISGITLINK(uint16 m) internal returns (bool) {
        return (m & S_IFMT) == S_IFGITLINK;
    }

    uint32 constant S_DIFFTREE_IFXMIN_NEQ = 0x80000000;
    uint16 constant DEFAULT_GIT_PORT = 9418;

   uint32 constant CACHE_SIGNATURE = 0x44495243;      /* "DIRC" */

    uint8 constant INDEX_FORMAT_LB = 2;
    uint8 constant INDEX_FORMAT_UB = 4;

    uint16 constant CE_STAGEMASK = 0x3000;
    uint16 constant CE_EXTENDED  = 0x4000;
    uint16 constant CE_VALID     = 0x8000;

    uint8 constant CE_STAGESHIFT = 12;

    uint32 constant CE_UPDATE            = 1 << 16;
    uint32 constant CE_REMOVE            = 1 << 17;
    uint32 constant CE_UPTODATE          = 1 << 18;
    uint32 constant CE_ADDED             = 1 << 19;
    uint32 constant CE_HASHED            = 1 << 20;
    uint32 constant CE_FSMONITOR_VALID   = 1 << 21;
    uint32 constant CE_WT_REMOVE         = 1 << 22; /* remove in work directory */
    uint32 constant CE_CONFLICTED        = 1 << 23;
    uint32 constant CE_UNPACKED          = 1 << 24;
    uint32 constant CE_NEW_SKIP_WORKTREE = 1 << 25;
    uint32 constant CE_MATCHED           = 1 << 26; /* used to temporarily mark paths matched by pathspecs */
    uint32 constant CE_UPDATE_IN_BASE    = 1 << 27;
    uint32 constant CE_STRIP_NAME        = 1 << 28;
    uint32 constant CE_INTENT_TO_ADD     = 1 << 29;
    uint32 constant CE_SKIP_WORKTREE     = 1 << 30;
    uint32 constant CE_EXTENDED2         = 1 << 31; /* CE_EXTENDED2 is for future extension */
    uint32 constant CE_EXTENDED_FLAGS = CE_INTENT_TO_ADD | CE_SKIP_WORKTREE;

    function S_ISSPARSEDIR(uint16 m) internal returns (bool) {
        return m == S_IFDIR;
    }

    function copy_cache_entry(cache_entry dst, cache_entry src) internal {
        uint16 state = dst.ce_flags & CE_HASHED;
        bool mem_pool_allocated = dst.mem_pool_allocated;
        /* Don't copy hash chain and name */
        memcpy(dst.ce_stat_data, src.ce_stat_data,
                        offsetof(struct cache_entry, name) -
                        offsetof(struct cache_entry, ce_stat_data));

        /* Restore the hash state */
        dst.ce_flags = (dst.ce_flags & ~CE_HASHED) | state;
        /* Restore the mem_pool_allocated flag */
        dst.mem_pool_allocated = mem_pool_allocated;
}

    function create_ce_flags(uint32 stage) internal returns (uint32) {
        return stage << CE_STAGESHIFT;
    }

    function ce_permissions(uint16 mode) internal returns (uint16) {
        return (mode & 0x0040) > 0 ? 0x01ED : 0x01A4; // 0755 : 0644;
    }

    function create_ce_mode(unsigned int mode) internal returns (uint16) {
        if (S_ISLNK(mode))
            return S_IFLNK;
        if (S_ISSPARSEDIR(mode))
            return S_IFDIR;
        if (S_ISDIR(mode) || S_ISGITLINK(mode))
            return S_IFGITLINK;
        return S_IFREG | ce_permissions(mode);
    }

    function ce_mode_from_stat(cache_entry ce, unsigned int mode) internal returns (uint16) {
        extern int trust_executable_bit, has_symlinks;
        if (!has_symlinks && S_ISREG(mode) &&
            ce && S_ISLNK(ce.ce_mode))
                return ce.ce_mode;
        if (!trust_executable_bit && S_ISREG(mode)) {
                if (ce && S_ISREG(ce.ce_mode))
                    return ce.ce_mode;
                return create_ce_mode(0x01B6); //  0666
        }
        return create_ce_mode(mode);
    }

    function ce_to_dtype(cache_entry ce) internal returns (uint16) {
        uint16 ce_mode = ntohl(ce.ce_mode);
        if (S_ISREG(ce_mode))
            return DT_REG;
        else if (S_ISDIR(ce_mode) || S_ISGITLINK(ce_mode))
            return DT_DIR;
        else if (S_ISLNK(ce_mode))
            return DT_LNK;
        else
            return DT_UNKNOWN;
    }
    function canon_mode(uint16 mode) internal returns (uint16) {
        if (S_ISREG(mode))
            return S_IFREG | ce_permissions(mode);
        if (S_ISLNK(mode))
            return S_IFLNK;
        if (S_ISDIR(mode))
            return S_IFDIR;
        return S_IFGITLINK;
    }

    uint16 constant SOMETHING_CHANGED    = 1 << 0; // unclassified changes go here
    uint16 constant CE_ENTRY_CHANGED     = 1 << 1;
    uint16 constant CE_ENTRY_REMOVED     = 1 << 2;
    uint16 constant CE_ENTRY_ADDED       = 1 << 3;
    uint16 constant RESOLVE_UNDO_CHANGED = 1 << 4;
    uint16 constant CACHE_TREE_CHANGED   = 1 << 5;
    uint16 constant SPLIT_INDEX_ORDERED  = 1 << 6;
    uint16 constant UNTRACKED_CHANGED    = 1 << 7;
    uint16 constant FSMONITOR_CHANGED    = 1 << 8;

    function make_cache_entry(index_state istate, uint16 mode, object_id oid, string path, uint16 stage, uint16 refresh_options) internal returns (cache_entry) {}
    function make_empty_cache_entry(index_state istate, uint16 name_len) internal returns (cache_entry) {}
    function make_transient_cache_entry(uint16 mode, object_id oid, string path, uint16 stage, mem_pool ce_mem_pool) internal returns (cache_entry) {}
    function make_empty_transient_cache_entry(uint16 len, mem_pool ce_mem_pool) internal returns (cache_entry) {}
    function discard_cache_entry(cache_entry ce) internal {}
    function should_validate_cache_entries() internal returns (uint16) {}
    function dup_cache_entry(cache_entry ce, index_state istate) internal returns (cache_entry) {}
    function validate_cache_entries(index_state istate) internal {}
    function prefetch_cache_entries(index_state istate, uint32 must_prefetch) internal {}

    uint8 constant TYPE_BITS = 3;
    function object_type(uint16 mode) internal returns (object_type) {}
        return S_ISDIR(mode) ? OBJ_TREE : S_ISGITLINK(mode) ? OBJ_COMMIT : OBJ_BLOB;
    }

    function have_git_dir() internal returns (bool) {}
    function is_bare_repository() internal returns (bool) {}
    function is_inside_git_dir() internal returns (bool) {}
    function is_inside_work_tree() internal returns (bool) {}
    function get_git_dir() internal returns (string) {}

    function get_git_common_dir() internal returns (string) {}
    function get_object_directory() internal returns (string) {}
    function get_index_file() internal returns (string) {}
    function get_graft_file(repository r) internal returns (string) {}
    function set_git_dir(string path, bool make_realpath) internal {}
    function get_common_dir_noenv(strbuf sb, string gitdir) internal returns (uint8) {}
    function get_common_dir(strbuf sb, string gitdir) internal returns (uint8) {}
    function get_git_namespace() internal returns (string) {}
    function strip_namespace(string namespaced_ref) internal returns (string) {}
    function get_super_prefix() internal returns (string) {}
    function get_git_work_tree() internal returns (string) {}

    function is_git_directory(string path) internal returns (bool) {}
    function is_nonbare_repository_dir(strbuf path) internal returns (bool) {}
    function read_gitfile_error_die(uint8 error_code, string path, string dir) internal {}
    function read_gitfile_gently(string path) internal returns (string, uint8 return_error_code) {}
    function read_gitfile(string path) internal returns (string) {
        return read_gitfile_gently(path, 0);
    }
    function resolve_gitdir_gently(string suspect) internal returns (string, uint8 return_error_code) {}
    function resolve_gitdir(string path) internal returns (string) {
        (string res, ) = resolve_gitdir_gently(path);
        return res;
    }
    function set_git_work_tree(string tree) internal {}
    function setup_work_tree() internal {}
    function discover_git_directory(strbuf commondir, strbuf gitdir) internal returns (int) {}
    function setup_git_directory_gently(int *) internal returns (string) {}
    function setup_git_directory() internal returns (string) {}
    function prefix_path(string prefix, int len, string path) internal returns (string) {}
    function prefix_path_gently(string prefix, uint16 len, string path) internal returns (string, uint16 remaining) {}
    function prefix_filename(string prefix, string path) internal returns (string) {}
    function check_filename(string prefix, string name) internal returns (bool) {}
    function verify_filename(string prefix, string name, bool diagnose_misspelt_rev) internal {}
    function verify_non_filename(string prefix, string name) internal {}
    function path_inside_repo(string prefix, string path) internal returns (bool) {}
    function init_db(string git_dir, string real_git_dir, string template_dir, uint8 hash_algo, string initial_branch, uint16 flags) internal returns (int) {}
    function initialize_repository_version(uint8 hash_algo, bool reinit) internal {}
    function sanitize_stdfds() internal {}
    function daemonize() internal returns (uint8) {}

    uint8 constant READ_GITFILE_ERR_STAT_FAILED    = 1;
    uint8 constant READ_GITFILE_ERR_NOT_A_FILE     = 2;
    uint8 constant READ_GITFILE_ERR_OPEN_FAILED    = 3;
    uint8 constant READ_GITFILE_ERR_READ_FAILED    = 4;
    uint8 constant READ_GITFILE_ERR_INVALID_FORMAT = 5;
    uint8 constant READ_GITFILE_ERR_NO_PATH        = 6;
    uint8 constant READ_GITFILE_ERR_NOT_A_REPO     = 7;
    uint8 constant READ_GITFILE_ERR_TOO_LARGE      = 8;


    string constant ALTERNATE_DB_ENVIRONMENT = "GIT_ALTERNATE_OBJECT_DIRECTORIES";

    uint16 constant INIT_DB_QUIET    = 0x0001;
    uint16 constant INIT_DB_EXIST_OK = 0x0002;

    function preload_index(index_state index, pathspec ppathspec, unsigned int refresh_flags) internal {}
    function do_read_index(index_state istate, string path, int must_exist) internal returns (int) {} // for testtinintg only!
    function read_index_from(index_state, string path, string gitdir) internal returns (int) {}
    function is_index_unborn(index_state) internal returns (int) {}
    function ensure_full_index(index_state istate) internal {}
    function write_locked_index(index_state, lock_file lock, unsigned flags) internal returns (int) {}
    function discard_index(index_state) internal returns (int) {}
    function move_index_extensions(index_state dst, index_state src) internal {}
    function unmerged_index(index_state) internal returns (int) {}
    function repo_index_has_changes(repository repo, tree ttree, strbuf sb) internal returns (int) {}
    function verify_path(string path, unsigned mode) internal returns (int) {}
    function strcmp_offset(string s1, string s2, size_t *first_change) internal returns (int) {}
    function index_dir_exists(index_state istate, string name, int namelen) internal returns (int) {}
    function adjust_dirname_case(index_state istate, string name) internal {}
    function index_file_exists(index_state istate, string name, int namelen, int igncase) internal returns (cache_entry) {}
    function index_name_pos(index_state, string name, int namelen) internal returns (int) {}
    function index_entry_exists(index_state, string name, int namelen) internal returns (int) {}
    function add_index_entry(index_state, cache_entry ce, int option) internal returns (int) {}
    function rename_index_entry_at(index_state, int pos, string new_name) internal {}
    function remove_index_entry_at(index_state, int pos) internal returns (int) {}
    function remove_marked_cache_entries(index_state istate, int invalidate) internal {}
    function remove_file_from_index(index_state , string path) internal returns (int) {}
    function add_to_index(index_state, string path, s_stat, int flags) internal returns (int) {}
    function add_file_to_index(index_state, string path, int flags) internal returns (int) {}
    function chmod_index_entry(index_state, cache_entry ce, char flip) internal returns (int) {}
    function ce_same_name(cache_entry a, const cache_entry b) internal returns (int) {}
    function set_object_name_for_intent_to_add_entry(cache_entry ce) internal {}
    function index_name_is_other(index_state, string , int) internal returns (int) {}
    function read_blob_data_from_index(index_state, string , unsigned long *) internal returns (bytes) {}
    function is_racy_timestamp(index_state istate, cache_entry ce) internal returns (int) {}
    function has_racy_timestamp(index_state istate) internal returns (int) {}
    function ie_match_stat(index_state, cache_entry, s_stat, unsigned int) internal returns (int) {}
    function ie_modified(index_state, cache_entry, s_stat, unsigned int) internal returns (int) {}
    function index_fd(index_state istate, object_id oid, int fd, s_stat st, object_type otype, string path, unsigned flags) internal returns (int) {}
    function index_path(index_state istate, object_id oid, string path, s_stat st, unsigned flags) internal returns (int) {}
    function fill_stat_data(stat_data sd, s_stat st) internal {}
    function match_stat_data(stat_data sd, s_stat st) internal returns (int) {}
    function match_stat_data_racy(index_state istate, stat_data sd, s_stat st) internal returns (int) {}
    function fill_stat_cache_info(index_state istate, cache_entry ce, s_stat st) internal {}
    function refresh_index(index_state, unsigned int flags, pathspec ppathspec, string seen, string header_msg) internal returns (int) {}
    function repo_refresh_and_write_index(repository, unsigned int refresh_flags, unsigned int write_flags, int gentle, pathspec, string seen, string header_msg) internal returns (int) {}
    function refresh_cache_entry(index_state, cache_entry, unsigned int) internal returns (cache_entry) {}
    function set_alternate_index_output(string ) internal {}
    function set_shared_repository(int value) internal {}
    function get_shared_repository(void) internal returns (int) {}
    function reset_shared_repository(void) internal {}
    function use_optional_locks(void) internal returns (int) {}

    uint8 constant ADD_CACHE_OK_TO_ADD = 1;           // Ok to add
    uint8 constant ADD_CACHE_OK_TO_REPLACE = 2;       // Ok to replace file/directory
    uint8 constant ADD_CACHE_SKIP_DFCHECK = 4;        // Ok to skip DF conflict checks
    uint8 constant ADD_CACHE_JUST_APPEND = 8;         // Append only
    uint8 constant ADD_CACHE_NEW_ONLY = 16;           // Do not replace existing ones
    uint8 constant ADD_CACHE_KEEP_CACHE_TREE = 32;    // Do not invalidate cache-tree
    uint8 constant ADD_CACHE_RENORMALIZE = 64;        // Pass along HASH_RENORMALIZE

    uint8 constant ADD_CACHE_VERBOSE = 1;
    uint8 constant ADD_CACHE_PRETEND = 2;
    uint8 constant ADD_CACHE_IGNORE_ERRORS = 4;
    uint8 constant ADD_CACHE_IGNORE_REMOVAL = 8;
    uint8 constant ADD_CACHE_INTENT = 16;

    uint8 constant CE_MATCH_IGNORE_VALID           = 1;   // do stat comparison even if CE_VALID is true
    uint8 constant CE_MATCH_RACY_IS_DIRTY          = 2;   // do not check the contents but report dirty on racily-clean entries
    uint8 constant CE_MATCH_IGNORE_SKIP_WORKTREE   = 4;   // do stat comparison even if CE_SKIP_WORKTREE is true
    uint8 constant CE_MATCH_IGNORE_MISSING         = 0x08; // ignore non-existent files during stat update
    uint8 constant CE_MATCH_REFRESH                = 0x10; // ignore non-existent files during stat update
    uint8 constant CE_MATCH_IGNORE_FSMONITOR       = 0X20; // don't refresh_fsmonitor state or do stat comparison even if CE_FSMONITOR_VALID is true
    uint8 constant HASH_WRITE_OBJECT = 1;
    uint8 constant HASH_FORMAT_CHECK = 2;
    uint8 constant HASH_RENORMALIZE  = 4;
    uint8 constant HASH_SILENT = 8;

    uint8 constant REFRESH_REALLY               = 1 << 0; // ignore_valid
    uint8 constant REFRESH_UNMERGED             = 1 << 1; // allow unmerged
    uint8 constant REFRESH_QUIET                = 1 << 2; // be quiet about it
    uint8 constant REFRESH_IGNORE_MISSING       = 1 << 3; // ignore non-existent
    uint8 constant REFRESH_IGNORE_SUBMODULES    = 1 << 4; // ignore submodules
    uint8 constant REFRESH_IN_PORCELAIN         = 1 << 5; // user friendly output, not "needs update"
    uint8 constant REFRESH_PROGRESS             = 1 << 6; // show progress bar if stderr is tty
    uint8 constant REFRESH_IGNORE_SKIP_WORKTREE = 1 << 7; // ignore skip_worktree entries

    uint8 constant GIT_REPO_VERSION = 0;
    uint8 constant GIT_REPO_VERSION_READ    = 1;

    function REPOSITORY_FORMAT_INIT(repository_format rf) internal {
        rf.version = -1;
        rf.is_bare = -1;
        rf.hash_algo = GIT_HASH_SHA1;
        rf.unknown_extensions = STRING_LIST_INIT_DUP;
        rf.v1_only_extensions = STRING_LIST_INIT_DUP;
    }

    uint16 constant MTIME_CHANGED = 0x0001;
    uint16 constant CTIME_CHANGED = 0x0002;
    uint16 constant OWNER_CHANGED = 0x0004;
    uint16 constant MODE_CHANGED  = 0x0008;
    uint16 constant INODE_CHANGED = 0x0010;
    uint16 constant DATA_CHANGED  = 0x0020;
    uint16 constant TYPE_CHANGED  = 0x0040;

   int is_absolute_path(string path) {
        return is_dir_sep(path[0]) || has_dos_drive_prefix(path);
    }
    uint16 constant PERM_GROUP          = 0x01B0; //0660;
    uint16 constant PERM_EVERYBODY      = 0x01B4; // 0664;

    function read_repository_format(repository_format format, string path) internal returns (int) {}
    function clear_repository_format(repository_format format) internal {}
    function verify_repository_format(repository_format format, strbuf err) internal returns (int) {}
    function check_repository_format(repository_format fmt) internal {}
    function repo_find_unique_abbrev(repository r, object_id oid, int len) internal returns (string) {}
    function repo_find_unique_abbrev_r(repository r, string hex, object_id oid, int len) internal returns (int) {}
    function git_mkstemps_mode(string pattern, int suffix_len, int mode) internal returns (int) {}
    function git_mkstemp_mode(string pattern, int mode) internal returns (int) {}
    function git_config_perm(string vvar, string value) internal returns (int) {}
    function adjust_shared_perm(string path) internal returns (int) {}
    function safe_create_leading_directories(string path) internal returns (scld_error) {}
    function safe_create_leading_directories_const(string path) internal returns (scld_error) {}
    function safe_create_leading_directories_no_share(string path) internal returns (scld_error) {}
    function mkdir_in_gitdir(string path) internal returns (int) {}
    function interpolate_path(string path, int real_home) internal returns (string) {}
    function enter_repo(string path, int strict) internal returns (string) {}
    function is_directory(string) internal returns (int) {}
    function strbuf_realpath(strbuf resolved, string path, bool die_on_error) internal returns (string) {}
    function strbuf_realpath_forgiving(strbuf resolved, string path, bool die_on_error) internal returns (string) {}
    function real_pathdup(string path, bool die_on_error) internal returns (string) {}
    function absolute_path(string path) internal returns (string) {}
    function absolute_pathdup(string path) internal returns (string) {}
    function remove_leading_path(string in, string prefix) internal returns (string) {}
    function relative_path(string inn, string prefix, strbuf sb) internal returns (string) {}
    function normalize_path_copy_len(string dst, string src, int prefix_len) internal returns (int) {}
    function normalize_path_copy(string dst, string src) internal returns (int) {}
    function longest_ancestor_length(string path, string[] prefixes) internal returns (int) {}
    function strip_path_suffix(string path, string suffix) internal returns (string) {}
    function daemon_avoid_alias(string path) internal returns (int) {}
    function is_ntfs_dotgit(string name) internal returns (int) {}
    function is_ntfs_dotgitmodules(string name) internal returns (int) {}
    function is_ntfs_dotgitignore(string name) internal returns (int) {}
    function is_ntfs_dotgitattributes(string name) internal returns (int) {}
    function is_ntfs_dotmailmap(string name) internal returns (int) {}
    function looks_like_command_line_option(string str) internal returns (int) {}
    function xdg_config_home_for(string subdir, string filename) internal returns (string) {}
    function xdg_config_home(string filename) internal returns (string) {}
    function xdg_cache_home(string filename) internal returns (string) {}
    function git_open_cloexec(string name, int flags) internal returns (int) {}
    function unpack_loose_header(git_zstream stream, string map, unsigned long mapsize, void *buffer, unsigned long bufsiz, strbuf hdrbuf) internal returns (unpack_loose_header_result) {}
    function parse_loose_header(string hdr, object_info oi) internal returns (int) {}
    function check_object_signature(repository r, object_id oid, bytes buf, unsigned long size, string otype, object_id real_oidp) internal returns (int) {}
    function finalize_object_file(string tmpfile, string filename) internal returns (int) {}
    function check_and_freshen_file(string fn, int freshen) internal returns (int) {}

    int hex2chr(string s) {
        unsigned int val = hexval(s[0]);
        return (val & ~0xf) ? val : (val << 4) | hexval(s[1]);
    }

/* Convert to/from hex/sha1 representation */
    uint8 constant MINIMUM_ABBREV = minimum_abbrev;
    uint8 constant DEFAULT_ABBREV = default_abbrev;

/* used when the code does not know or care what the default abbrev is */
    uint8 constant FALLBACK_DEFAULT_ABBREV = 7;

    uint16 constant GET_OID_QUIETLY           = 01;
    uint16 constant GET_OID_COMMIT            = 02;
    uint16 constant GET_OID_COMMITTISH        = 04;
    uint16 constant GET_OID_TREE             = 010;
    uint16 constant GET_OID_TREEISH          = 020;
    uint16 constant GET_OID_BLOB             = 040;
    uint16 constant GET_OID_FOLLOW_SYMLINKS = 0100;
    uint16 constant GET_OID_RECORD_PATH     = 0200;
    uint16 constant GET_OID_ONLY_TO_DIE    = 04000;
    uint16 constant GET_OID_REQUIRE_PATH  = 010000;

    uint16 GET_OID_DISAMBIGUATORS = GET_OID_COMMIT | GET_OID_COMMITTISH | GET_OID_TREE | GET_OID_TREEISH | GET_OID_BLOB;

    function repo_get_oid(repository r, string str, object_id oid) internal returns (uint16) {}
    function get_oidf(object_id oid, string fmt) internal returns (uint16) {}
    function repo_get_oid_commit(repository r, string str, object_id oid) internal returns (uint16) {}
    function repo_get_oid_committish(repository r, string str, object_id oid) internal returns (uint16) {}
    function repo_get_oid_tree(repository r, string str, object_id oid) internal returns (uint16) {}
    function repo_get_oid_treeish(repository r, string str, object_id oid) internal returns (uint16) {}
    function repo_get_oid_blob(repository r, string str, object_id oid) internal returns (uint16) {}
    function repo_get_oid_mb(repository r, string str, object_id oid) internal returns (uint16) {}
    function maybe_die_on_misspelt_object_name(repository repo, string name, string prefix) internal {}
    function get_oid_with_context(repository repo, string str, unsigned flags, object_id oid, object_context oc) internal returns (get_oid_result) {}
    function repo_for_each_abbrev(repository r, string prefix, each_abbrev_fn, bytes) internal returns (uint16) {}
    function set_disambiguate_hint_config(string vvar, string value) internal returns (uint16) {}
    function get_sha1_hex(string hex, string sha1) internal returns (int) {}
    function get_oid_hex(string hex, object_id sha1) internal returns (int) {}
    function get_oid_hex_algop(string hex, object_id oid, git_hash_algo algop) internal returns (int) {}
    function hex_to_bytes(string binary, string hex, uint32 len) internal returns (int) {}
    function hash_to_hex_algop_r(string buffer, string hash, git_hash_algo) internal returns (string) {}
    function oid_to_hex_r(string out, object_id oid) internal returns (string) {}
    function hash_to_hex_algop(string hash, git_hash_algo) internal returns (string) {}
    function hash_to_hex(string hash) internal returns (string) {}
    function oid_to_hex(object_id oid) internal returns (string) {}
    function parse_oid_hex(string hex, object_id oid, string[] end) internal returns (int) {}
    function parse_oid_hex_algop(string hex, object_id oid, string[] end, git_hash_algo algo) internal returns (int) {}
    function get_oid_hex_any(string hex, object_id oid) internal returns (int) {}
    function parse_oid_hex_any(string hex, object_id oid, string[] end) internal returns (int) {}

    uint8 constant INTERPRET_BRANCH_LOCAL   = 1 << 0;
    uint8 constant INTERPRET_BRANCH_REMOTE  = 1 << 1;
    uint8 constant INTERPRET_BRANCH_HEAD    = 1 << 2;
    function repo_interpret_branch_name(repository r, string str, int len, strbuf buf, interpret_branch_name_options options) internal returns (int) {}
    function validate_headref(string ref) internal returns (int) {}
    function base_name_compare(string name1, int len1, int mode1, string name2, int len2, int mode2) internal returns (int) {}
    function df_name_compare(string name1, int len1, int mode1, string name2, int len2, int mode2) internal returns (int) {}
    function name_compare(string name1, size_t len1, string name2, size_t len2) internal returns (int) {}
    function cache_name_stage_compare(string name1, int len1, int stage1, string name2, int len2, int stage2) internal returns (int) {}
    function read_object_with_reference(repository r, object_id oid, string required_type, uint32 size, object_id oid_ret) internal returns (bytes) {}
    function repo_peel_to_type(repository r, string name, int namelen, object o, object_type) internal returns (object) {}
    function date_mode_from_type(date_mode_type dtype) internal returns (date_mode) {}
    function show_date(timestamp_t time, int timezone, date_mode mode) internal returns (string) {}
    function show_date_relative(timestamp_t time, strbuf timebuf) internal {}
    function show_date_human(timestamp_t time, int tz, uint32 nnow, strbuf timebuf) internal {}
    function parse_date(string date, strbuf out) internal returns (int) {}
    function parse_date_basic(string date, uint32 timestamp, uint32 offset) internal returns (int) {}
    function parse_expiry_date(string date, uint32 timestamp) internal returns (int) {}
    function datestamp(strbuf out) internal {}
    function approxidate_careful(string , uint32 ) internal returns (uint32) {}
    function approxidate_relative(string date) internal returns (uint32) {}
    function parse_date_format(string format, date_mode mode) internal {}
    function date_overflows(uint32 date) internal returns (int) {}
//time_t tm_to_time_t(const struct tm *tm);

    uint8 constant IDENT_STRICT  = 1;
    uint8 constant IDENT_NO_DATE = 2;
    uint8 constant IDENT_NO_NAME = 4;

    function git_author_info(int) internal returns (string) {}
    function git_committer_info(int) internal returns (string) {}
    function fmt_ident(string name, string email, want_ident whose_ident, string date_str, int) internal returns (string) {}
    function fmt_name(want_ident) internal returns (string) {}
    function ident_default_name() internal returns (string) {}
    function ident_default_email() internal returns (string) {}
    function git_editor() internal returns (string) {}
    function git_sequence_editor() internal returns (string) {}
    function git_pager(int stdout_is_tty) internal returns (string) {}
    function is_terminal_dumb() internal returns (int) {}
    function git_ident_config(string , string , bytes) internal returns (int) {}
    function prepare_fallback_ident(string name, string email) internal {}
    function reset_ident_date() internal {}
    function split_ident_line(ident_split, string, int) internal returns (int) {}
    function show_ident_date(ident_split id, date_mode mode) internal returns (string) {}


    function cache_def_clear(cache_def cache) {
        strbuf_release(&cache->path);
    }

    function has_symlink_leading_path(string name, int len) internal returns (int) {}
    function threaded_has_symlink_leading_path(cache_def, string , int) internal returns (int) {}
    function check_leading_path(string name, int len, int warn_on_lstat_err) internal returns (int) {}
    function has_dirs_only_path(string name, int len, int prefix_len) internal returns (int) {}
    function invalidate_lstat_cache() internal {}
    function schedule_dir_for_removal(string name, int len) internal {}
    function remove_scheduled_dirs() internal {}
    function odb_mkstemp(strbuf temp_filename, string pattern) internal returns (int) {}
    function odb_pack_keep(string name) internal returns (int) {}
    function update_server_info(int) internal returns (int) {}
    function get_log_output_encoding() internal returns (string) {}
    function get_commit_output_encoding() internal returns (string) {}
    function committer_ident_sufficiently_given() internal returns (int) {}
    function author_ident_sufficiently_given() internal returns (int) {}
    function copy_fd(int ifd, int ofd) internal returns (int) {}
    function copy_file(string dst, string src, int mode) internal returns (int) {}
    function copy_file_with_time(string dst, string src, int mode) internal returns (int) {}
    function write_or_die(int fd, bytes buf, size_t count) internal {}
    function fsync_or_die(int fd, string ) internal {}
    function read_in_full(int fd, bytes buf, size_t count) internal returns (ssize_t) {}
    function write_in_full(int fd, bytes buf, size_t count) internal returns (ssize_t) {}
    function pread_in_full(int fd, bytes buf, size_t count, off_t offset) internal returns (ssize_t) {}

    function fprintf_or_die(FILE, string fmt) internal {}
    function fwrite_or_die(FILE, bytes buf, size_t count) internal {}
    function fflush_or_die(FILE) internal {}
    function write_file_buf(string path, string buf, size_t len) internal {}

    int8 constant COPY_READ_ERROR = -2;
    int8 constant COPY_WRITE_ERROR = -3;

    ssize_t write_str_in_full(int fd, string str) {
        return write_in_full(fd, str, strlen(str));
    }

    function write_file(string path, string fmt, ...) internal {}
    function setup_pager() internal {}
    function pager_in_use() internal returns (uint16) {}
    function term_columns() internal returns (uint16) {}
    function term_clear_line() internal {}
    function decimal_width(uintmax_t) internal returns (uint16) {}
    function check_pager_config(string cmd) internal returns (uint16) {}
//    function prepare_pager_args(struct child_process *, string pager) internal {}
    function decode_85(string dst, string line, int linelen) internal returns (uint16) {}
    function encode_85(string buf, string data, int bytes) internal {}
    function packet_trace_identity(string prog) internal {}
    function add_files_to_cache(string prefix, pathspec pathspec, int flags) internal returns (uint16) {}
    function shift_tree(repository, object_id, object_id, object_id, int) internal {}
    function shift_tree_by(repository,object_id, object_id, object_id, string) internal {}
    uint16 constant WS_BLANK_AT_EOL         = 0100;
    uint16 constant WS_SPACE_BEFORE_TAB     = 0200;
    uint16 constant WS_INDENT_WITH_NON_TAB  = 0400;
    uint16 constant WS_CR_AT_EOL           = 01000;
    uint16 constant WS_BLANK_AT_EOF        = 02000;
    uint16 constant WS_TAB_IN_INDENT       = 04000;
    uint16 constant WS_TRAILING_SPACE      = WS_BLANK_AT_EOL| WS_BLANK_AT_EOF;
    uint16 constant WS_DEFAULT_RULE = (WS_TRAILING_SPACE| WS_SPACE_BEFORE_TAB|8;
    uint16 constant WS_TAB_WIDTH_MASK        = 077;
    uint16 constant WS_RULE_MASK           = 07777;

    function whitespace_rule(index_state, string ) internal returns (unsigned) {}
    function parse_whitespace_rule(string ) internal returns (unsigned) {}
    function ws_check(string line, int len, unsigned ws_rule) internal returns (unsigned) {}
    function ws_check_emit(string line, int len, unsigned ws_rule, FILE *stream, string set, string reset, string ws) internal {}
    function whitespace_error_string(unsigned ws) internal returns (string) {}
    function ws_fix_copy(strbuf, string , int, unsigned, int *) internal {}
    function ws_blank_line(string line, int len, unsigned ws_rule) internal returns (int) {}
    function overlay_tree_on_index(index_state istate, string tree_name, string prefix) internal {}
    function try_merge_command(repository r, string strategy, size_t xopts_nr, string[] xopts, struct commit_list *common, string head_arg, struct commit_list *remotes) internal returns (int) {}
    function checkout_fast_forward(repository r, object_id from, object_id to, int overwrite_ignore) internal returns (int) {}
    function sane_execvp(string file, string[] argv) internal returns (int) {}
    function stat_validity_check(stat_validity sv, string path) internal returns (int) {}
    function stat_validity_clear(stat_validity sv) internal {}
    function stat_validity_update(stat_validity sv, uint16 fd) internal {}
    function versioncmp(string s1, string s2) internal returns (int) {}
    function safe_create_dir(string dir, int share) internal {}
    function print_sha1_ellipsis() internal returns (int) {}
    function is_empty_or_missing_file(string filename) internal returns (int) {}

    uint8 constant COMMIT_LOCK       = 1 << 0;
    uint8 constant SKIP_IF_UNCHANGED = 1 << 1;


//#define alloc_nr(x) (((x)+16)*3/2)


}