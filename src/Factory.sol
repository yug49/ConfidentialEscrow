// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ConfidentialEscrow} from "./ConfidentialEscrow.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract Factory is Ownable {
    error NotBuyer();

    ConfidentialEscrow private escrow;
    address[] private escrowAddresses;
    mapping(address buyers => address escrowAddresses) private escrowAddressesOfBuyer;
    mapping(address sellers => address escrowAddresses) private escrowAddressesOfSeller;

    mapping(address => address) private vaults;

    constructor() Ownable(msg.sender) {}

    function createContract(
        address _seller,
        address _buyer,
        uint256 _amount,
        address _tokenAddress,
        address _governor,
        ConfidentialEscrow.Condition[] memory _conditions,
        uint256 _deadline
    ) external {
        if (msg.sender != _buyer) revert NotBuyer();
        escrow = new ConfidentialEscrow(_seller, _buyer, _amount, _tokenAddress, _governor, _conditions, _deadline);
        escrowAddresses.push(address(escrow));
        escrowAddressesOfBuyer[_buyer] = address(escrow);
        escrowAddressesOfSeller[_seller] = address(escrow);
    }
}
