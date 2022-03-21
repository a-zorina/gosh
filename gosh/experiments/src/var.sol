pragma ton-solidity >= 0.54.0;

import "go.sol";

contract var_ is go {

    function b_exec(string args, string pool) external pure returns (uint8 ec, string out) {
        (string[] params, string flags, ) = _get_args(args);
//        string dbg = argv;
        bool function_names_only = _flag_set("F", flags);

        string s_attrs;
        string[] a_attrs = ["a", "A", "x", "i", "r", "t", "n", "f"];
        for (string attr: a_attrs)
            if (_flag_set(attr, flags))
                s_attrs.append(attr);

        s_attrs = "-" + (s_attrs.empty() ? "-" : s_attrs);
        bool print_reusable = _flag_set("p", flags) || function_names_only;

        if (params.empty()) {
            (string[] lines, ) = _split(pool, "\n");
            for (string line: lines) {
                (string attrs, ) = _strsplit(line, " ");
                if (_match_attr_set(s_attrs, attrs))
                    out.append(_print_reusable(line));
            }
        }
        if (print_reusable) {
            for (string p: params) {
                (string name, ) = _strsplit(p, "=");
                string cur_record = _get_pool_record(name, pool);
                if (!cur_record.empty()) {
                    (string cur_attrs, ) = _strsplit(cur_record, " ");
                    if (_match_attr_set(s_attrs, cur_attrs))
                        out.append(_print_reusable(cur_record));
                } else {
                    ec = EXECUTE_FAILURE;
                    out.append("variable: " + name + " not found\n");
                }
            }
        } else {
            for (string p: params)
                out = _set_var(s_attrs, p, pool);
        }
    }

    function _gosh_help_data() internal pure override returns (GoshHelp) {
        return GoshHelp(
"git-var",
"Show a Git logical variable",
"( -l | <variable> )",
"Prints a Git logical variable.",
"-l     Cause the logical variables to be listed. In addition, all the variables of the Git configuration file .git/config are listed as\n\
        well. (However, the configuration variables listing functionality is deprecated in favor of git config -l.)",
["EXAMPLES", "VARIABLES"],
["$ git var GIT_AUTHOR_IDENT    Eric W. Biederman <ebiederm@lnxi.com> 1121223278 -0600",
"GIT_AUTHOR_IDENT       The author of a piece of code.\n\
GIT_COMMITTER_IDENT     The person who put a piece of code into Git.\n\
GIT_EDITOR              Text editor for use by Git commands. The value is meant to be interpreted by the shell when it is used. Examples: ~/bin/vi,\n\
                        $SOME_ENVIRONMENT_VARIABLE, \"C:\\Program Files\\Vim\\gvim.exe\" --nofork. The order of preference is the $GIT_EDITOR environment\n\
                        variable, then core.editor configuration, then $VISUAL, then $EDITOR, and then the default chosen at compile time, which is usually\n\
                        vi. The build you are using chose editor as the default.\n\
GIT_PAGER               Text viewer for use by Git commands (e.g., less). The value is meant to be interpreted by the shell. The order of preference is the\n\
                        $GIT_PAGER environment variable, then core.pager configuration, then $PAGER, and then the default chosen at compile time (usually\n\
                        less). The build you are using chose pager as the default."],
"git-commit-tree(1) git-tag(1) git-config(1)",
"0.01");
    }
}
