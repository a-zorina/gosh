pragma ton-solidity >= 0.54.0;

import "go.sol";

contract help is go {

    function _get_man_file(string arg, GoshHelp[] help_files) internal pure returns (uint8 ec, GoshHelp help_file) {
        ec = EXECUTE_FAILURE;
        for (GoshHelp bh: help_files)
            if (bh.name == arg)
                return (EXECUTE_SUCCESS, bh);
    }

    function display_man_page(string args, GoshHelp[] help_files) external pure returns (uint8 ec, string out, string err) {
        (string[] params, string flags, ) = _get_args(args);
//    function display_man_page(GoshHelp[] help_files, string[] e) external pure returns (uint8 ec, string out, string err) {
//        (string[] params, string flags, string argv) = _get_args(e[IS_ARGS]);
//        string dbg = argv;
        uint8 command_format = 1;

        for (string arg: params) {
            (uint8 t_ec, GoshHelp help_file) = _get_man_file(arg, help_files);
            if (t_ec == EXECUTE_SUCCESS)
                out.append(_get_man_text(command_format, help_file));
            else {
                ec = t_ec;
                err.append("-gosh: help: no help topics match `" + arg + "\'.  Try `help help\' or `man -k " + arg + "\' or `info " + arg + "\'.");
            }
        }
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
"help [-a|--all [--[no-]verbose]] [-g|--guide] [-i|--info|-m|--man|-w|--web] [COMMAND|GUIDE]",
"With no options and no COMMAND or GUIDE given, the synopsis of the git command and a list of the most commonly used Git commands are\n\
printed on the standard output.\n\
If the option --all or -a is given, all available commands are printed on the standard output.\n\
If the option --guide or -g is given, a list of the useful Git guides is also printed on the standard output.\n\
If a command, or a guide, is given, a manual page for that command or guide is brought up. The man program is used by default for this\n\
purpose, but this can be overridden by other options or configuration variables.\n\
If an alias is given, git shows the definition of the alias on standard output. To get the manual page for the aliased command, use git\n\
COMMAND --help.\n\
Note that git --help ... is identical to git help ... because the former is internally converted into the latter.\n\
To display the git(1) man page, use git help git.\n\
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
