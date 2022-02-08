pragma ton-solidity >= 0.54.0;

import "go.sol";

contract type_ is go {

    function run(string args, string hashes, string index, string pool) external pure returns (uint8 ec, string out) {
        (string[] params, string flags, ) = _get_args(args);
        (ec, out) = _type(params, flags, hashes, index, pool);
    }

    function terse(string arg, string hashes, string index, string pool) external pure returns (uint8 ec, string out) {
        (ec, out) = _type([arg], "t", hashes, index, pool);
    }

    function _type(string[] params, string flags, string hashes, string index, string pool) internal pure returns (uint8 ec, string out) {

        bool f_terse = _flag_set("t", flags);
        for (string arg: params) {
            string t = _get_array_name(arg, index);
            string value;
            if (t == "PORCELAIN")
                value = f_terse ? "porcelain" : (arg + " is a Porcelain command");
            else if (t == "MANIPULATORS")
                value = f_terse ? "manipul" : (arg + " is an Ancillary Command / Manipulator");
            else if (t == "INTERROGATORS")
                value = f_terse ? "interrog" : (arg + " is an Ancillary Command / Interrogator");
            else if (t == "INTERACT")
                value = f_terse ? "interact" : (arg + " is for Interacting with Others");
            else if (t == "LLCM")
                value = f_terse ? "llman" : (arg + " is a Low-level Command / Manipulator");
            else if (t == "LLCI")
                value = f_terse ? "llint" : (arg + " is a Low-level Command / Interrogator");
            else if (t == "LLSYNC")
                value = f_terse ? "llsync" : (arg + " is a Low-level Command / Syncing Repositories");
            else if (t == "HELPERS")
                value = f_terse ? "helper" : (arg + " is a Low-level Command / Internal Helper");
            else if (t == "EXTERNAL")
                value = f_terse ? "external" : (arg + " is an External command");
            else {
                value = "-gosh: type: " + arg + ": not found";
                ec = EXECUTE_FAILURE;
            }
            out.append(value + "\n");
        }
    }

    function _gosh_help_data() internal pure override returns (GoshHelp) {
        string[] empty;
        return GoshHelp(
"type",
"",
"Display information about command type.",
"For each NAME, indicate how it would be interpreted if used as a command name.",
"",
empty,
empty,
"",
"0.01");
    }
}
