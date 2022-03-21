pragma ton-solidity >= 0.54.0;

struct GoshHelp {
    string name;
    string purpose;
    string synopsis;
    string description;
    string options;
    string[] headers;
    string[] contents;
    string see_also;
    string version;
}

import "../lib/Format.sol";
import "../include/Base.sol";

abstract contract go is Base, Format {

    function _fetch_value(string key, uint16 delimiter, string page) internal pure returns (string value) {
        string key_pattern = _wrap(key, W_SQUARE);
        (string val_pattern_start, string val_pattern_end) = _wrap_symbols(delimiter);
        return _strval(page, key_pattern + "=" + val_pattern_start, val_pattern_end);
    }

    function _val(string key, string page) internal pure returns (string value) {
        return _fetch_value(key, W_DQUOTE, page);
    }

    function _function_body(string key, string page) internal pure returns (string value) {
        return _fetch_value(key, W_BRACE, page);
    }

    function _get_map_value(string map_name, string page) internal pure returns (string value) {
        return _unwrap(_fetch_value(map_name, W_PAREN, page));
    }

    function _item_value(string item) internal pure returns (string, string) {
        (string key, string value) = _strsplit(item, "=");
        return (_unwrap(key), _unwrap(value));
    }

    function _match_attr_set(string part_attrs, string cur_attrs) internal pure returns (bool) {
        uint part_attrs_len = part_attrs.byteLength() / 2;
        for (uint i = 0; i < part_attrs_len; i++) {
            string attr_sign = part_attrs.substr(i * 2, 1);
            string attr_sym = part_attrs.substr(i * 2 + 1, 1);

            bool flag_cur = _strchr(cur_attrs, attr_sym) > 0;
            bool flag_match = (flag_cur && attr_sign == "-");
            if (!flag_match)
                return false;
        }
        return true;
    }

    function _meld_attr_set(string part_attrs, string cur_attrs) internal pure returns (string res) {
        res = cur_attrs;
        uint part_attrs_len = part_attrs.byteLength() / 2;
        for (uint i = 0; i < part_attrs_len; i++) {
            string attr_sign = part_attrs.substr(i * 2, 1);
            string attr_sym = part_attrs.substr(i * 2 + 1, 1);

            bool flag_cur = _strchr(cur_attrs, attr_sym) > 0;
            if (!flag_cur && attr_sign == "-")
                res.append(attr_sym);
            else if (flag_cur && attr_sign == "+")
                res = _translate(res, attr_sym, "");
        }
        if (res == "-")
            return "--";
        if (res.byteLength() > 2 && res.substr(0, 2) == "--")
            return res.substr(1);
    }

    function _wrap(string s, uint16 to) internal pure returns (string res) {
        if (to == W_COLON)
            return ":" + s + ":";
        else if (to == W_DQUOTE)
            return "\"" + s + "\"";
        else if (to == W_PAREN)
            return "(" + s + ")";
        else if (to == W_BRACE)
            return "{" + s + "}";
        else if (to == W_SQUARE)
            return "[" + s + "]";
        else if (to == W_SPACE)
            return " " + s + " ";
        else if (to == W_NEWLINE)
            return "\n" + s + "\n";
        else if (to == W_SQUOTE)
            return "\'" + s + "\'";
        else if (to == W_ARRAY)
            return "( " + s + " )";
        else if (to == W_HASHMAP)
            return "( " + s + " )";
        else if (to == W_FUNCTION)
            return "\n{\n" + s + "\n}\n";
    }

    function _unwrap(string s) internal pure returns (string) {
        uint len = s.byteLength();
        return len > 2 ? s.substr(1, len - 2) : "";
    }

    function _wrap_symbols(uint16 to) internal pure returns (string start, string end) {
        if (to == W_COLON)
            return (":", ":");
        else if (to == W_DQUOTE)
            return ("\"", "\"");
        else if (to == W_PAREN)
            return ("(", ")");
        else if (to == W_BRACE)
            return ("{", "}");
        else if (to == W_SQUARE)
            return ("[", "]");
        else if (to == W_SPACE)
            return (" ", " ");
        else if (to == W_NEWLINE)
            return ("\n", "\n");
        else if (to == W_SQUOTE)
            return ("\'", "\'");
        else if (to == W_ARRAY)
            return ("( ", " )");
        else if (to == W_HASHMAP)
            return ("( ", " )");
        else if (to == W_FUNCTION)
            return ("", "\n");
    }

    uint16 constant W_NONE      = 0;
    uint16 constant W_COLON     = 1;
    uint16 constant W_DQUOTE    = 2;
    uint16 constant W_PAREN     = 3;
    uint16 constant W_BRACE     = 4;
    uint16 constant W_SQUARE    = 5;
    uint16 constant W_SPACE     = 6;
    uint16 constant W_NEWLINE   = 7;
    uint16 constant W_SQUOTE    = 8;
    uint16 constant W_ARRAY     = 9;
    uint16 constant W_HASHMAP   = 10;
    uint16 constant W_FUNCTION  = 11;

    function _encode_items(string[][2] entries) internal pure returns (string res) {
        for (uint i = 0; i < entries.length; i++)
            res.append(_encode_item_2(entries[i][0], entries[i][1]) + " ");
    }

    function _encode_item(string key, string value) internal pure returns (string res) {
        res = _wrap(key, W_SQUARE) + "=" + _wrap(value, W_DQUOTE);
    }

    function _as_map(string value) internal pure returns (string res) {
        res = _wrap(value, W_HASHMAP);
    }

    function _encode_item_2(string key, string value) internal pure returns (string res) {
        res = _wrap(key, W_SQUARE);
        if (!value.empty())
            res.append("=" + (_strchr(value, "(") > 0 ? value : _wrap(value, W_DQUOTE)));
    }

    function _trim_spaces(string s_arg) internal pure returns (string res) {
        res = _tr_squeeze(s_arg, " ");
        uint len = res.byteLength();
        if (len > 0 && _strrchr(res, " ") == len)
            res = res.substr(0, len - 1);
        len = res.byteLength();
        if (len > 0 && res.substr(0, 1) == " ")
            res = res.substr(1);
    }
    function _get_array_name(string value, string context) internal pure returns (string name) {
        (string[] lines, ) = _split(context, "\n");
        string val_pattern = _wrap(value, W_SPACE);
        for (string line: lines)
            if (_strstr(line, val_pattern) > 0)
                return _strval(line, "[", "]");
    }

    function _set_item_value(string name, string value, string page) internal pure returns (string) {
        string cur_value = _val(name, page);
        string new_record = _encode_item(name, value);
        return cur_value.empty() ? page + " " + new_record : _translate(page, _encode_item(name, cur_value), new_record);
    }

    function _set_var(string attrs, string token, string pg) internal pure returns (string page) {
        (string name, string value) = _strsplit(token, "=");
        string cur_record = _get_pool_record(name, pg);
        string new_record = _pool_str(attrs, name, value);
        if (!cur_record.empty()) {
            (string cur_attrs, ) = _strsplit(cur_record, " ");
            (, string cur_value) = _strsplit(cur_record, "=");
            string new_value = !value.empty() ? value : !cur_value.empty() ? _unwrap(cur_value) : "";
            new_record = _pool_str(_meld_attr_set(attrs, cur_attrs), name, new_value);
            page = _translate(pg, cur_record, new_record);
        } else
            page = pg + new_record + "\n";
    }

    function _pool_str(string s_attrs, string name, string value) internal pure returns (string) {
        uint16 mask = _get_mask_ext(s_attrs);
        bool is_function = _strchr(s_attrs, "f") > 0;
        string var_value = value.empty() ? "" : "=";
        if (!value.empty())
            var_value.append(_wrap(value, (mask & ATTR_ASSOC + ATTR_ARRAY) > 0 ? W_PAREN : W_DQUOTE));
        return is_function ?
            (name + " () " + _wrap(value, W_FUNCTION)) :
            s_attrs + " " + _wrap(name, W_SQUARE) + var_value;
    }

    function _get_pool_record(string name, string pool) internal pure returns (string) {
        string pat = _wrap(name, W_SQUARE);
        (string[] lines, ) = _split(pool, "\n");
        for (string line: lines)
            if (_strstr(line, pat) > 0)
                return line;
    }

    function _print_reusable(string line) internal pure returns (string) {
        (string attrs, string stmt) = _strsplit(line, " ");
        (string name, string value) = _strsplit(stmt, "=");
        name = _unwrap(name);
        bool is_function = _strchr(attrs, "f") > 0;
        string var_value = value.empty() ? "" : "=" + value;
        return is_function ?
            (name + " ()" + _wrap(_indent(_translate(_unwrap(value), ";", "\n"), 4, "\n"), W_FUNCTION)) :
            "declare " + attrs + " " + name + var_value + "\n";
    }

    function _var_ext(string name, string pool) internal pure returns (Var) {
        /*string cur_record = _get_pool_record(name, pool);
        string attrs;
        string value;
        if (!cur_record.empty()) {
            (attrs, ) = _strsplit(cur_record, " ");
            (, value) = _strsplit(cur_record, "=");
        }
        return Var(name, attrs, value, "", _get_mask_ext(attrs), IS_POOL);*/
    }

    function _get_mask_ext(string s_attrs) internal pure returns (uint16 mask) {
        uint len = s_attrs.byteLength();
        for (uint i = 0; i < len; i++) {
            string c = s_attrs.substr(i, 1);
            if (c == "x") mask |= ATTR_EXPORTED;
            if (c == "r") mask |= ATTR_READONLY;
            if (c == "a") mask |= ATTR_ARRAY;
            if (c == "f") mask |= ATTR_FUNCTION;
            if (c == "i") mask |= ATTR_INTEGER;
            if (c == "l") mask |= ATTR_LOCAL;
            if (c == "A") mask |= ATTR_ASSOC;
            if (c == "t") mask |= ATTR_TRACE;
        }
    }

struct Var {
    string name;        // Symbol that the user types
    string decl;        // Declaration string (temp)
    string value;       // Value that is returned
    string export_str;  // String for the environment
    uint16 attributes;  // export, readonly, array, invisible...
    uint16 context;     // Which context this variable belongs to
}

    // The various attributes that a given variable can have.
    // First, the user-visible attributes
    uint16 constant ATTR_EXPORTED   = 1; // export to environment
    uint16 constant ATTR_READONLY   = 2; // cannot change
    uint16 constant ATTR_ARRAY      = 4; // value is an array
    uint16 constant ATTR_FUNCTION   = 8; // value is a function
    uint16 constant ATTR_INTEGER	= 16;// internal representation is int
    uint16 constant ATTR_LOCAL      = 32;// variable is local to a function
    uint16 constant ATTR_ASSOC      = 64;// variable is an associative array
    uint16 constant ATTR_TRACE  	= 128;// function is traced with DEBUG trap

    function _mask_base_type(uint16 mask) internal pure returns (string s_attrs) {
        if ((mask & ATTR_ARRAY) > 0) return "a";
        if ((mask & ATTR_FUNCTION) > 0) return "f";
        if ((mask & ATTR_ASSOC) > 0) return "A";
        return "-";
    }

    function _mask_str(uint16 mask) internal pure returns (string s_attrs) {
        s_attrs = _mask_base_type(mask);
        if ((mask & ATTR_INTEGER) > 0) s_attrs.append("i");
        if ((mask & ATTR_EXPORTED) > 0) s_attrs.append("x");
        if ((mask & ATTR_READONLY) > 0) s_attrs.append("r");
        if ((mask & ATTR_LOCAL) > 0) s_attrs.append("l");
        if ((mask & ATTR_TRACE) > 0) s_attrs.append("t");
        if (s_attrs == "-") s_attrs.append("-");
    }

    function gosh_help_data() external pure returns (GoshHelp gh) {
        return _gosh_help_data();
    }

    function _gosh_help_data() internal pure virtual returns (GoshHelp gh);

    function _flag_set(string name, string flags) internal pure returns (bool) {
        return _strchr(flags, name) > 0;
    }

    function _flag_values(string flags_query, string flags_set) internal pure returns (bool , bool , bool , bool , bool , bool , bool , bool ) {
        uint len = flags_query.byteLength();
        bool[] tmp;
        for (uint i = 0; i < len; i++)
            tmp.push(_strchr(flags_set, flags_query.substr(i, 1)) > 0);
        return (len > 0 ? tmp[0] : false,
                len > 1 ? tmp[1] : false,
                len > 2 ? tmp[1] : false,
                len > 3 ? tmp[1] : false,
                len > 4 ? tmp[1] : false,
                len > 5 ? tmp[1] : false,
                len > 6 ? tmp[1] : false,
                len > 7 ? tmp[1] : false);
    }

    function _get_args(string arg) internal pure returns (string[] args, string flags, string argv) {
        flags = _val("FLAGS", arg);
        string s_args = _val("PARAMS", arg);
        argv = _val("ARGV", arg);
        if (!s_args.empty())
            (args, ) = _split(s_args, " ");
        argv.append(format("> get_args: s_args \"{}\", flags \"{}\", page {}\n", s_args, flags, arg));
    }

    function _get_opts(string arg) internal pure returns (string flags, string opt_args) {
        flags = _val("FLAGS", arg);
        opt_args = _get_map_value("OPT_ARGS", arg);
    }

    function _opt_arg_value(string opt_name, string arg) internal pure returns (string) {
        return _val(opt_name, _get_map_value("OPT_ARGS", arg));
    }

}
