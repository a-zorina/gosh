pragma ton-solidity >= 0.54.0;

import "go.sol";

contract gosh is go {

    function on_exec(s_proc p_in, uint8 ec, string out, string[] e) external pure returns (s_proc p, string[] env) {
        p = p_in;
        env = e;
        string dbg;

//        env[IS_STDOUT].append(out);
        p.puts(out);
        string exec_line;// = e[IS_PIPELINE];
        if (ec > EXECUTE_SUCCESS)
            dbg.append("Executed " + exec_line + " with status " + format("{}", ec) + "\n");

        p.puts(dbg);
//        env[IS_STDERR].append(dbg);
    }

    /*function read_line(string args, string[] e) external pure returns (string[] env) {
        env = e;
        string s_input = _trim_spaces(args);
        delete env[IS_STDOUT];
        delete env[IS_STDERR];
        delete env[IS_PIPELINE];
        string dbg;
        dbg.append(s_input + "\n");

        env[IS_STDERR].append(dbg);
    }*/

    function set_args(string s_input, string opt_string, string pool) external pure returns (uint8 ec, string out) {
        (ec, out) = _set_args(s_input, opt_string, pool);
    }

    function _set_args(string s_input, string opt_string, string pool) internal pure returns (uint8 ec, string out) {

        (string cmd, string s_args) = _strsplit(s_input, " ");
        /* Expand aliases */
        string cmd_opt_string = _val(cmd, opt_string);

        (string[] params, uint n_params) = _split(s_args, " ");

        uint p = _strrchr(s_input, ">");
        uint q = _strrchr(s_input, "<");
        string redir_out = p > 0 ? _strtok(s_input, p, " ") : "";
        string redir_in = q > 0 ? _strtok(s_input, q, " ") : "";

        (uint8 t_ec, string s_flags, string opt_values, , string pos_params, , string pos_map) = _parse_params(params, cmd_opt_string);
        ec = t_ec;
        pos_map = "( [0]=\"" + cmd + "\"" + pos_map + " )";

        for (string arg: params) {
            if (_strchr(arg, "$") > 0) {
                string ref = _strval(arg, "$", " ");
                if (_strchr(ref, "{") > 0)
                    ref = _unwrap(ref);
                Var v = _var_ext(ref, pool);
                string ref_val = v.value;
                pos_params = _translate(pos_params, arg, ref_val);
            }
        }
        return (ec, _trim_spaces(_encode_items([
            ["COMMAND", cmd],
            ["PARAMS", pos_params],
            ["FLAGS", s_flags],
            ["OPT_ARGS", opt_values],
            ["ARGV", s_input],
            ["POS_ARGS", pos_map],
            ["#", format("{}", n_params)],
            ["@", s_args],
            ["?", format("{}", ec)],
            ["REDIR_IN", redir_in],
            ["REDIR_OUT", redir_out]])));
    }

    function set_gosh_vars(string profile) external pure returns (uint8 ec, string out) {
        string gosh_path = _val("GOSH", profile);
        string gosh_flags = _val("-", profile);
        string gosh_aliases = _val("GOSH_ALIASES", profile);
        (ec, out) = _set_gosh_vars(gosh_path, gosh_flags, gosh_aliases);
    }

    function _set_gosh_vars(string gosh_path, string gosh_flags, string gosh_aliases) internal pure returns (uint8 ec, string out) {
        return (0, _trim_spaces(_encode_items([
            ["_", gosh_path],
            ["-", gosh_flags],
            ["GOSH", gosh_path],
            ["GOSHOPTS", _as_map("expand_aliases")],
            ["GOSHPID", ""],
            ["GOSH_SUBSHELL", "0"],
            ["GOSH_ALIASES", gosh_aliases],
            ["SHELLOPTS", "allexport:hashall"],
            ["TMPDIR", "tmp"],
            ["SHLVL", "1"]
            ])));
    }

    function build_exec_pipeline(string args, string gosh_vars, string comp_spec, string pool) external pure returns (uint8 ec, string out) {
        (ec, out, ) = _build_command_queue(args, gosh_vars, comp_spec, pool);
    }

    function _build_command_queue(string args, string gosh_vars, string comp_spec, string pool) internal pure returns (uint8 ec, string exec_line, string cmd_queue) {
        ec = 0;
        string cmd = _val("COMMAND", args);
        string s_args = _val("@", args);
        string tosh_path = _val("GOSH", gosh_vars);
        string fn_name = _get_array_name(cmd, comp_spec);
        string f_body = _function_body(fn_name, pool);
        if (!f_body.empty()) {
            (string[] lines, uint n_lines) = _split(f_body, ";");
            for (uint i = 0; i < n_lines; i++) {
                string s_line = lines[i];
                if (s_line.empty())
                    continue;
                if (s_line.substr(0, 1) == '.')
                    s_line = tosh_path + s_line.substr(1);
                if (s_line.byteLength() > 2) {
                    s_line = _translate(s_line, "$@", s_args);
                    s_line = _translate(s_line, "$0", cmd);
                }
                cmd_queue.append(format("[{}]=\"{}\"\n", i, s_line));
                exec_line.append(s_line + "\n");
            }
        } else {
            exec_line = tosh_path + " " + fn_name + " " + cmd + " " + s_args + ";";
            cmd_queue = "[0]=\"" + exec_line + "\"\n";
        }
    }

    function _parse_params(string[] params, string opt_string) internal pure returns (uint8 ec, string s_flags, string opt_values, string dbg, string pos_params, string s_attrs, string pos_map) {
        uint n_params = params.length;
        uint opt_str_len = opt_string.byteLength();
        opt_values = "(";
        for (uint i = 0; i < n_params; i++) {
            string token = params[i];
            uint t_len = token.byteLength();
            if (t_len == 0)
                continue;
            if (token.substr(0, 1) == "-") {
                string o;
                string val;
                if (t_len == 1)
                    continue; // stdin redirect
                if (token.substr(1, 1) == "-") {
                    if (t_len == 2) // arg separator
                        continue;
                    o = token.substr(2); // long option
                } else {
                    o = token.substr(1);
                    if (t_len > 2) {     // short option sequence has no value
                        for (uint j = 1; j < t_len; j++)
                            s_flags.append(token.substr(j, 1));
                        continue;
                    }
                }
                uint p = _strchr(opt_string, o); // _strstr() for long options ?
                if (p > 0) {
                    if (p < opt_str_len && opt_string.substr(p, 1) == ":") {
                        if (i + 1 < n_params) {
                            val = params[i + 1];
                            i++;
                        } else {
                            ec = EX_BADUSAGE;
                            dbg.append(format("error: missing option {} value in {} at {} pos {}\n", o, opt_string, p, i));
                        }
                    } else
                        val = o;
                } else {
                    ec = EX_BADUSAGE;
                    dbg.append("error: unrecognized option: " + o + " opt_string: " + opt_string + "\n");
                }
                opt_values.append(format(" [{}]=\"{}\"", o, val));
                pos_map.append(format(" [{}]=\"{}\"", i + 1, token));
                s_flags.append(o);
            } else if (token.substr(0, 1) == "+") {
                s_attrs.append(token);
            } else {
                pos_map.append(format(" [{}]=\"{}\"", i + 1, token));
                if (pos_params.empty())
                    pos_params = token;
                else
                    pos_params.append(" " + token);
            }
        }
        opt_values.append(" )");
    }

    function _gosh_help_data() internal pure override returns (GoshHelp gh) {
        return GoshHelp(
"gosh",
"generic on-chain source holder from decentralized hell",
"[--version] [--help] [-C <path>] [-c <name>=<value>]\n\
[--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]\n\
[-p|--paginate|-P|--no-pager] [--no-replace-objects] [--bare]\n\
[--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]\n\
[--super-prefix=<path>]\n\
<command> [<args>]",
"Gosh is a sluggish, no-so-scalable-yet, potentially ubiquitous source control system\n\
with an obscenely rich command set that provides both high-level operations and full access to internals.\n\
Some sunny day see goshtutorial(7) to get started, then see gosheveryday(7) for a useful minimum set of commands.\n\
After you mastered the basic concepts, you can come back to this page to learn what commands Gosh offers. You can\n\
learn more about individual Gosh commands with \"gosh help command\". goshcli(7) manual page gives you an overview\n\
of the command-line command syntax.",
"--version   Prints the Git suite version that the git program came from.\n\
--help      Prints the synopsis and a list of the most commonly used commands. If the option --all or -a is given then all\n\
            available commands are printed. If a Git command is named this option will bring up the manual page for that command.",
["GOSH COMMANDS", "ENVIRONMENT VARIABLES"],
[" Main porcelain commands\n\
git-add(1)      Add file contents to the index.\n\
git-am(1)       Apply a series of patches from a mailbox.\n\
git-archive(1)  Create an archive of files from a named tree.\n\
git-bisect(1)   Use binary search to find the commit that introduced a bug.\n\
git-branch(1)   List, create, or delete branches.\n\
git-bundle(1)   Move objects and refs by archive.\n\
git-checkout(1) Switch branches or restore working tree files.\n\
git-cherry-pick(1) Apply the changes introduced by some existing commits.\n\
git-citool(1)   Graphical alternative to git-commit.\n\
git-clean(1)    Remove untracked files from the working tree.\n\
git-clone(1)    Clone a repository into a new directory.\n\
git-commit(1)   Record changes to the repository.\n\
git-describe(1) Give an object a human readable name based on an available ref.",
"Various Git commands use the following environment variables:\n\
The Git Repository\n\
These environment variables apply to all core Git commands. Nb: it is worth noting that they may be used/overridden by SCMS sitting\n\
above Git so take care if using a foreign front-end.\n\
GIT_INDEX_FILE\n\
    This environment allows the specification of an alternate index file. If not specified, the default of $GIT_DIR/index is used.\n\
GIT_INDEX_VERSION\n\
    This environment variable allows the specification of an index version for new repositories. It won’t affect existing index files.\n\
    By default index file version 2 or 3 is used. See git-update-index(1) for more information.\n\
GIT_OBJECT_DIRECTORY\n\
    If the object storage directory is specified via this environment variable then the sha1 directories are created underneath -\n\
    otherwise the default $GIT_DIR/objects directory is used.\n\
GIT_ALTERNATE_OBJECT_DIRECTORIES\n\
    Due to the immutable nature of Git objects, old objects can be archived into shared, read-only directories. This variable specifies\n\
    a \":\" separated (on Windows \";\" separated) list of Git object directories which can be used to search for Git objects. New objects\n\
    will not be written to these directories.\n\
    Entries that begin with \" (double-quote) will be interpreted as C-style quoted paths, removing leading and trailing double-quotes\n\
    and respecting backslash escapes. E.g., the value \"path-with-\"-and-:-in-it\":vanilla-path has two paths: path-with-\"-and-:-in-it\n\
    and vanilla-path.\n\
GIT_DIR\n\
    If the GIT_DIR environment variable is set then it specifies a path to use instead of the default .git for the base of the\n\
    repository. The --git-dir command-line option also sets this value.\n\
GIT_WORK_TREE\n\
    Set the path to the root of the working tree. This can also be controlled by the --work-tree command-line option and the\n\
    core.worktree configuration variable."],
"gittutorial(7), gittutorial-2(7), giteveryday(7), gitcvs-migration(7), gitglossary(7), gitcore-tutorial(7), gitcli(7), gitworkflows(7)",
"0.01");
    }
}
