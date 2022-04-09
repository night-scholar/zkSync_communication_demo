//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Importing zkSync contract interface
import "@matterlabs/zksync-contracts/contracts/interfaces/IZkSync.sol";
// Importing `Operations` library which has the `Operations.QueueType` and `Operations.OpTree` types
import "@matterlabs/zksync-contracts/contracts/libraries/Operations.sol";


//exampleAddress 0xf7A936A83CedCba50060B71db7bA0D4645382374
//zkSyncAddress 0x71f33321375494206d23cc3950a923a9b4c615a4
//tokenAddress 	0x7Ae850936b4933b8FE1775f5715743279935E00A
contract Example {
    function depositMainnetTokenToL2(
        // The address of the zkSync smart contract.
        // It is not recommended to hardcode it during the alpha testnet as regenesis may happen.
        address zkSyncAddress,
        address recipient,
        uint256 amount
    ) external payable {
        IZkSync zksync = IZkSync(zkSyncAddress);

        // Example of depositing ETH.
        // Even though currently deposits are free, the contracts
        // should be built in mind that deposits may require fee in the future.
        zksync.depositETH{value: msg.value}(
            // The amount to deposit
            amount,
            // The address of the recipient of the funds on L2.
            recipient,
            // The queue type
            Operations.QueueType.Deque,
            // The operation tree type
            Operations.OpTree.Full
        );
    }

    function depositTokenToL2(
        // The address of the zkSync smart contract.
        // It is not recommended to hardcode it during the alpha testnet as regenesis may happen.
        address tokenAddress,
        address zkSyncAddress,
        address recipient,
        uint256 amount
    ) external payable {
        IZkSync zksync = IZkSync(zkSyncAddress);
        IERC20 token = IERC20(tokenAddress);
        // Example of depositing an ERC20 token.
        // Make sure that your contract has ERC20 balance before running this code.
        // Also, make sure tha the zkSync smart contract has enough allowance.
        // Even though currently deposits are free, the contracts
        // should be built in mind that deposits may require fee in the future.
        token.transferFrom(msg.sender,address(this),amount);
        token.approve(zkSyncAddress,amount);
        
        zksync.depositERC20{value:msg.value}(
            // The ERC20 token address to deposit.
            token,
            // The amount to deposit
            amount,
            // The address of the recipient of the funds on L2.
            recipient,
            // The queue type
            Operations.QueueType.Deque,
            // The operation tree type
            Operations.OpTree.Full

        );
    }
}