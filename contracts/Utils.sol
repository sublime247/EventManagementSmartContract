// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

library Errors {
    error ZeroAddressDetected();
    error NotAuthorized();
    error InvalidId();
    error InvalidNFT();
}

library Events {
    event EventCreated(
        string indexed eventName,
        uint indexed  id,
        uint indexed timeCreated,
        bool iscreated
    );
    event RegistredSuccessful(
        string indexed eventName,
        uint indexed id,
        uint indexed timeRegistered,
        address userName
    );
    event EventRemoved(
        uint indexed id,
        uint indexed timeRemoved
    );
    event EventsUpdated(
        string indexed eventName,
        uint indexed id,
        uint indexed timeUpdated
    );
}
