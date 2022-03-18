pragma ton-solidity >= 0.58.0;
import "sys/gtypes.sol";

library librepo {
    function repo_set_gitdir(repository repo, string root, set_gitdir_args extra_args) internal {
        repo.gitdir = root;
    }
    function repo_set_worktree(repository repo, string path) internal {
        repo.worktree = path;
    }
    function repo_set_hash_algo(repository repo, uint8 algo) internal {
        repo.hash_algo = algo;
    }

    function initialize_the_repository() internal {}
    function repo_init(repository repo, string gitdir, string worktree) internal returns (uint16) {
        repo.gitdir = gitdir;
        repo.worktree = worktree;
    }
    function repo_submodule_init(repository subrepo, repository superproject, string path, object_id treeish_name) internal returns (uint16) {}
    function repo_clear(repository repo) internal {
        delete repo;
    }
    function repo_read_index(repository repo) internal returns (uint16) {

    }
    function repo_hold_locked_index(repository repo, lock_file lf, uint16 flags) internal returns (uint16) {}
    function repo_read_index_preload(repository repo, pathspec ppathspec, uint16 refresh_flags) internal returns (uint16) {}
    function repo_read_index_unmerged(repository repo) internal returns (uint16) {}
    function repo_update_index_if_able(repository repo, lock_file lf) internal {}
/*struct repo_settings {
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
}*/
    function prepare_repo_settings(repository repo) internal {}
}
contract repositoryc {

    using librepo for repository;
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

    function upgrade_repository_format(uint16 target_version) internal returns (uint16) {

    }
}