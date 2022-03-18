pragma ton-solidity >= 0.58.0;

library lenv {

    string constant GIT_DIR_ENVIRONMENT                = "GIT_DIR";
    string constant GIT_COMMON_DIR_ENVIRONMENT         = "GIT_COMMON_DIR";
    string constant GIT_NAMESPACE_ENVIRONMENT          = "GIT_NAMESPACE";
    string constant GIT_WORK_TREE_ENVIRONMENT          = "GIT_WORK_TREE";
    string constant GIT_PREFIX_ENVIRONMENT             = "GIT_PREFIX";
    string constant GIT_SUPER_PREFIX_ENVIRONMENT       = "GIT_INTERNAL_SUPER_PREFIX";
    string constant DEFAULT_GIT_DIR_ENVIRONMENT        = ".git";
    string constant DB_ENVIRONMENT                     = "GIT_OBJECT_DIRECTORY";
    string constant INDEX_ENVIRONMENT                  = "GIT_INDEX_FILE";
    string constant GRAFT_ENVIRONMENT                  = "GIT_GRAFT_FILE";
    string constant GIT_SHALLOW_FILE_ENVIRONMENT       = "GIT_SHALLOW_FILE";
    string constant TEMPLATE_DIR_ENVIRONMENT           = "GIT_TEMPLATE_DIR";
    string constant CONFIG_ENVIRONMENT                 = "GIT_CONFIG";
    string constant CONFIG_DATA_ENVIRONMENT            = "GIT_CONFIG_PARAMETERS";
    string constant CONFIG_COUNT_ENVIRONMENT           = "GIT_CONFIG_COUNT";
    string constant EXEC_PATH_ENVIRONMENT              = "GIT_EXEC_PATH";
    string constant CEILING_DIRECTORIES_ENVIRONMENT    = "GIT_CEILING_DIRECTORIES";
    string constant NO_REPLACE_OBJECTS_ENVIRONMENT     = "GIT_NO_REPLACE_OBJECTS";
    string constant GIT_REPLACE_REF_BASE_ENVIRONMENT   = "GIT_REPLACE_REF_BASE";
    string constant GITATTRIBUTES_FILE                 = ".gitattributes";
    string constant INFOATTRIBUTES_FILE                = "info/attributes";
    string constant ATTRIBUTE_MACRO_PREFIX             = "[attr]";
    string constant GITMODULES_FILE                    = ".gitmodules";
    string constant GITMODULES_INDEX                   = ":.gitmodules";
    string constant GITMODULES_HEAD                    = "HEAD:.gitmodules";
    string constant GIT_NOTES_REF_ENVIRONMENT          = "GIT_NOTES_REF";
    string constant GIT_NOTES_DEFAULT_REF              = "refs/notes/commits";
    string constant GIT_NOTES_DISPLAY_REF_ENVIRONMENT  = "GIT_NOTES_DISPLAY_REF";
    string constant GIT_NOTES_REWRITE_REF_ENVIRONMENT  = "GIT_NOTES_REWRITE_REF";
    string constant GIT_NOTES_REWRITE_MODE_ENVIRONMENT = "GIT_NOTES_REWRITE_MODE";
    string constant GIT_LITERAL_PATHSPECS_ENVIRONMENT  = "GIT_LITERAL_PATHSPECS";
    string constant GIT_GLOB_PATHSPECS_ENVIRONMENT     = "GIT_GLOB_PATHSPECS";
    string constant GIT_NOGLOB_PATHSPECS_ENVIRONMENT   = "GIT_NOGLOB_PATHSPECS";
    string constant GIT_ICASE_PATHSPECS_ENVIRONMENT    = "GIT_ICASE_PATHSPECS";
    string constant GIT_QUARANTINE_ENVIRONMENT         = "GIT_QUARANTINE_PATH";
    string constant GIT_OPTIONAL_LOCKS_ENVIRONMENT     = "GIT_OPTIONAL_LOCKS";
    string constant GIT_TEXT_DOMAIN_DIR_ENVIRONMENT    = "GIT_TEXTDOMAINDIR";
    string constant GIT_PROTOCOL_ENVIRONMENT           = "GIT_PROTOCOL"; // Environment variable used in handshaking the wire protocol. Contains a colon ':' separated list of keys with optional values "key[=value]'.  Presence of unknown keys and values must be ignored.
    string constant GIT_PROTOCOL_HEADER                = "Git-Protocol";   // HTTP header used to handshake the wire protocol
    string constant GIT_IMPLICIT_WORK_TREE_ENVIRONMENT = "GIT_IMPLICIT_WORK_TREE"; // This environment variable is expected to contain a boolean indicating whether we should or should not treat GIT_DIR=foo.git git ... as if GIT_WORK_TREE=. was given. It's not expected that users will make use of this, but we use it internally to communicate to sub-processes that we are in a bare repo. If not set, defaults to true.
    string constant ALTERNATE_DB_ENVIRONMENT           = "GIT_ALTERNATE_OBJECT_DIRECTORIES";
    function setup_git_env(string git_dir) internal {}
}
