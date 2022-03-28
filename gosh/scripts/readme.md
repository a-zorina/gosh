## Scripts

### Deploy GOSH

Will deploy GOSH contracts and create two files: `../gosh.addr` (contains address of the GOSH root) and `../gosh.keys` (GOSH owner's keypair). For redeploy GOSH from scratch - remove `gosh.addr` and `gosh.keys`

NETWORK - points to endpoint: **localhost** for Evernode SE (by default), **net.ton.dev** - devnet, **main.ton.dev** - mainnet
```sh
./deploy_gosh.sh <NETWORK>
```

### Create repository

```sh
./gosh_create_repo.sh REPO_NAME <NETWORK>
```

### Create branch

```sh
./gosh_create_branche.sh REPO_NAME BRANCH_NAME <FROM_BRANCH> <NETWORK>
```