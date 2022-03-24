# Content Signature Maintenance

Provides ability to deploy content signature account onto EverScale network.

Content signature account provides proof for specific content from specific person/organisation.

## Requirements

- Node.js

## Install

```shell
npm i
tsc 
```

## Usage

### Deploy Signature

```shell
node cli sign <signer-secret> <content> --topup-amount <topup-amount> --giver-address <giver-address> --giver-secret <giver-secret>  
```

Where:

- `signer-secret` secret key of the signer.
- `content` any string that will be proofed by the signer.
- `topup-amount` amount of the initial proof account balance that will be given from giver account.
- `giver-address` account that will be used to topup proof account's balance.
  Supported giver contracts are:
  - SafeMultisigWallet
  - SetCodeMultisigWallet
  - GiverV2
- `giver-secret` secret key of the giver account.

Expected output:

- Address of proof account

### Check Signature

```shell
node cli check <signer-public> <content>  
```

Where:

- `signer-public` public key of the signer.
- `content` any string that was proofed by the signer.

Expected output:

- `true` if proof account was deployed on the network.
- `false` if proof account wasn't deployed on the network.
