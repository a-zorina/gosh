pragma ton-solidity >= 0.58.0;

struct bogus_blob {
    bogus_object obj;
}

struct bogus_oid {
    bytes hash;
    int32 algo;
}

struct bogus_object {
    uint8 parsed;
    uint8 otype;
    uint8 flags;
    bogus_oid oid;
    bytes short_blob; //source up to 15KB compressed
    string store_link; //link to storage contract(s)
}
