pragma ton-solidity >= 0.58.0;
import "gtypes.sol";
import "cache.sol";
import "sys/libstring.sol";
import "lib/local_env.sol";

library librepo {

    using libstring for string;

    function repo_set_gitdir(repository repo, string root, set_gitdir_args extra_args) internal {
        (string commondir, string object_dir, string graft_file, string index_file, string alternate_db, bool disable_ref_updates) = extra_args.unpack();
        repo.gitdir = root;
        repo.commondir = commondir.alt(lenv.GIT_COMMON_DIR_ENVIRONMENT);
        if (!object_dir.empty()) {
            object_directory od;
            od.path = object_dir;
            od.disable_ref_updates = disable_ref_updates;
            repo.objects.odb_tail.push(od);
        }
        if (!alternate_db.empty()) {
            repo.objects.alternate_db.push(alternate_db);
        }
        repo.graft_file = graft_file.alt(lenv.GRAFT_ENVIRONMENT);
        repo.index_file = index_file.alt(lenv.INDEX_ENVIRONMENT);
    }

    function repo_set_worktree(repository repo, string path) internal {
        repo.worktree = path;
    }

    function repo_set_hash_algo(repository repo, uint8 algo) internal {
        repo.hash_algo = libghash.get_hash_algo(algo);
    }

    function repo_init(repository repo, string gitdir, string worktree) internal returns (uint16) {
        repo.gitdir = gitdir;
        repo.worktree = worktree;
    }

    function repo_submodule_init(repository subrepo, repository superproject, string path, object_id treeish_name) internal returns (uint16) {

    }

    function repo_clear(repository repo) internal {
        delete repo;
    }
    function repo_read_index(repository repo) internal returns (uint16) {

    }
    function repo_hold_locked_index(repository repo, lock_file lf, uint16 flags) internal returns (uint16) {}
    function repo_read_index_preload(repository repo, pathspec ppathspec, uint16 refresh_flags) internal returns (uint16) {}
    function repo_read_index_unmerged(repository repo) internal returns (uint16) {}
    function repo_update_index_if_able(repository repo, lock_file lf) internal {}
    function prepare_repo_settings(repository repo) internal {}
}
contract repositoryc {

    using librepo for repository;
    repository _r;
/*struct repository {
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
} */

    function initialize_the_repository() internal {
    }

    function upgrade_repository_format(uint16 target_version) internal returns (uint16) {

    }
}