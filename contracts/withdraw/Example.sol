//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Importing zkSync contract interface
import "@matterlabs/zksync-contracts/contracts/interfaces/IZkSync.sol";
// Importing `Operations` library which has the `Operations.QueueType` and `Operations.OpTree` types
import "@matterlabs/zksync-contracts/contracts/libraries/Operations.sol";

//zkSyncAddress 0x71f33321375494206d23cc3950a923a9b4c615a4
//ethAddress 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
//tokenAddress 0x7Ae850936b4933b8FE1775f5715743279935E00A
//exampleAddress 0xA7Bfb290cf96a8796B90A3e385bC5b86FA3Ed930

contract Example {

    function getWithdrawTokenBaseCost(
        uint256 gasPrice,
        address zkSyncAddress
    ) public view returns (uint256){
         IZkSync zksync = IZkSync(zkSyncAddress);
         uint256 baseCost = zksync.withdrawBaseCost(
            gasPrice,
            // The queue type
            Operations.QueueType.Deque,
            // The operation tree type
            Operations.OpTree.Full
         );
         return baseCost;
    }


    function withdrawTokenFromL2(
        // The address of the zkSync smart contract.
        // It is not recommended to hardcode it during the alpha testnet as regenesis may happen.
        address zkSyncAddress,
        address tokenAddress,
        address recipient,
        uint256 amount
    ) external payable {
        IZkSync zksync = IZkSync(zkSyncAddress);

        zksync.requestWithdraw{value: msg.value}(
            // The address of the token to withdraw.
            tokenAddress,
            // amount
            amount,
            // recipient
            recipient,
            // The queue type
            Operations.QueueType.Deque,
            // The operation tree type
            Operations.OpTree.Full
        );
    }
}