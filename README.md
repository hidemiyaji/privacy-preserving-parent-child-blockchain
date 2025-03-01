Our proposal enables privacy-preserving and scalable cross-chain communication across different blockchains. The type of cross-chain communication adopted in our approach is the parent-child blockchain model.

The algorithms for our proposed approach are implemented in the following files:

0-PBC_Commit.sol
1-CBC_B_Commit.sol
2-CBC_A_Commit.sol
3-PBC_verify.sol
4-CBC_decommit.sol
5_PBC_Decommit.sol.

For comparison, we also provide an implementation of a Smart contract-based cross-chain communication scheme in the Existing files.

The 'scripts' folder has four typescript files which help to deploy the 'Storage' contract using 'web3.js' and 'ethers.js' libraries.

For the deployment of any other contract, just update the contract name from 'Storage' to the desired contract and provide constructor arguments accordingly 
in the file `deploy_with_ethers.ts` or  `deploy_with_web3.ts`

In the 'tests' folder there is a script containing Mocha-Chai unit tests for 'Storage' contract.

To run a script, right click on file name in the file explorer and click 'Run'. Remember, Solidity file must already be compiled.
Output from script will appear in remix terminal.

Please note, require/import is supported in a limited manner for Remix supported modules.
