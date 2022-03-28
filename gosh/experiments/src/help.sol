pragma ton-solidity >= 0.54.0;

import "go.sol";

contract help is go {

    function _get_man_file(string arg, GoshHelp[] help_files) internal pure returns (uint8 ec, GoshHelp help_file) {
        ec = EXECUTE_FAILURE;
        for (GoshHelp bh: help_files)
            if (bh.name == arg)
                return (EXECUTE_SUCCESS, bh);
    }

    function display_man_page(string args, GoshHelp[] help_files) external pure returns (uint8 ec, string out) {
        (string[] params, string flags, ) = _get_args(args);
        uint8 command_format = 1;

        if (params.empty())
            out = _print_usage();

        for (string arg: params) {
            (uint8 t_ec, GoshHelp help_file) = _get_man_file(arg, help_files);
            ec = t_ec;
            out.append(t_ec == EXECUTE_SUCCESS ? _get_man_text(command_format, help_file) : ("No manual entry for " + arg + ".\n"));
        }
    }

    function _print_usage() internal pure returns (string out) {
        out = "\
usage: git [--version] [--help] [-C <path>] [-c <name>=<value>]\n\
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]\n\
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]\n\
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]\n\
           <command> [<args>]\n\n\
These are common Git commands used in various situations:\n\n\
start a working area (see also: git help tutorial)\n\
   clone             Clone a repository into a new directory\n\
   init              Create an empty Git repository or reinitialize an existing one\n\n\
work on the current change (see also: git help everyday)\n\
   add               Add file contents to the index\n\
   mv                Move or rename a file, a directory, or a symlink\n\
   restore           Restore working tree files\n\
   rm                Remove files from the working tree and from the index\n\
   sparse-checkout   Initialize and modify the sparse-checkout\n\n\
examine the history and state (see also: git help revisions)\n\
   bisect            Use binary search to find the commit that introduced a bug\n\
   diff              Show changes between commits, commit and working tree, etc\n\
   grep              Print lines matching a pattern\n\
   log               Show commit logs\n\
   show              Show various types of objects\n\
   status            Show the working tree status\n\n\
grow, mark and tweak your common history\n\
   branch            List, create, or delete branches\n\
   commit            Record changes to the repository\n\
   merge             Join two or more development histories together\n\
   rebase            Reapply commits on top of another base tip\n\
   reset             Reset current HEAD to the specified state\n\
   switch            Switch branches\n\
   tag               Create, list, delete or verify a tag object signed with GPG\n\n\
collaborate (see also: git help workflows)\n\
   fetch             Download objects and refs from another repository\n\
   pull              Fetch from and integrate with another repository or a local branch\n\
   push              Update remote refs along with associated objects\n\n\
'git help -a' and 'git help -g' list available subcommands and some\n\
concept guides. See 'git help <command>' or 'git help <concept>'\n\
to read about a specific subcommand or concept.\n\
See 'git help git' for an overview of the system.";
    }

    function _get_man_text(uint8 command_format, GoshHelp help_file) private pure returns (string) {
        (string name, string purpose, string synopsis, string description, string options, string[] headers, string[] contents, string see_also, string version) = help_file.unpack();

        if (command_format == 1)
            return _join_fields([
                _format_list("NAME", name + " - " + purpose, 4, "\n"),
                _format_list("SYNOPSIS", name + " " + synopsis, 4, "\n"),
                _format_list("DESCRIPTION", description, 4, "\n"),
                _format_list("OPTIONS", options, 4, "\n"),
                _format_list("SEE ALSO", see_also, 4, "\n"),
                _format_list("Version ", version, 0, " ")], "\n");
    }

    function _gosh_help_data() internal pure override returns (GoshHelp bh) {
        return GoshHelp(
"help",
"Display help information about Gosh",
"[-a|--all [--[no-]verbose]] [-g|--guide] [-i|--info|-m|--man|-w|--web] [COMMAND|GUIDE]",
"With no options and no COMMAND or GUIDE given, the synopsis of the git command and a list of the most commonly used Git commands are\n\
printed on the standard output.\n\n\
If the option --all or -a is given, all available commands are printed on the standard output.\n\n\
If the option --guide or -g is given, a list of the useful Git guides is also printed on the standard output.\n\n\
If a command, or a guide, is given, a manual page for that command or guide is brought up. The man program is used by default for this\n\
purpose, but this can be overridden by other options or configuration variables.\n\n\
If an alias is given, git shows the definition of the alias on standard output. To get the manual page for the aliased command, use git\n\
COMMAND --help.\n\n\
Note that git --help ... is identical to git help ... because the former is internally converted into the latter.\n\
To display the git(1) man page, use git help git.\n\n\
This page can be displayed with git help help or git help --help",
"-a, --all       Prints all the available commands on the standard output. This option overrides any given command or guide name.\n\
--verbose       When used with --all print description for all recognized commands. This is the default.\n\
-c, --config    List all available configuration variables. This is a short summary of the list in git-config(1).",
["CONFIGURATION VARIABLES"],
["help.format If no command-line option is passed, the help.format configuration variable will be checked. The following values are supported for this variable; they make git help behave as their corresponding command- line option:\n man corresponds to -m|--man,\n info corresponds to -i|--info,\n web or html correspond to -w|--web."],
"",
"0.01");
    }

}
