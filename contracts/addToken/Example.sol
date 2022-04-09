//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Importing zkSync contract interface
import "@matterlabs/zksync-contracts/contracts/interfaces/IZkSync.sol";
// Importing `Operations` library which has the `Operations.QueueType` and `Operations.OpTree` types
import "@matterlabs/zksync-contracts/contracts/libraries/Operations.sol";


//zkSyncAddress 0x71f33321375494206d23cc3950a923a9b4c615a4
//tokenAddress 0x7Ae850936b4933b8FE1775f5715743279935E00A
//exampleAddress 0xCc4af41f7817D63C067AA57b86AF4cEe4385Cd6D
contract Example {

    function getAddTokenBaseCost(
        uint256 gasPrice,
        address zkSyncAddress
    ) public view returns (uint256){
         IZkSync zksync = IZkSync(zkSyncAddress);
         uint256 baseCost = zksync.addTokenBaseCost(
            gasPrice,
            // The queue type
            Operations.QueueType.Deque,
            // The operation tree type
            Operations.OpTree.Full
         );
         return baseCost;
    }

    function addTokenOnL1(
        // The address of the zkSync smart contract.
        // It is not recommended to hardcode it during the alpha testnet as regenesis may happen.
        address zkSyncAddress,
        address tokenAddress
    ) external payable {
        IZkSync zksync = IZkSync(zkSyncAddress);
        IERC20 token = IERC20(tokenAddress);
        zksync.addToken{value: msg.value}(
            // The L1 address of the ERC20 token to add.
            token,
            // The queue type
            Operations.QueueType.Deque,
            // The operation tree type
            Operations.OpTree.Full
        );
    }
}