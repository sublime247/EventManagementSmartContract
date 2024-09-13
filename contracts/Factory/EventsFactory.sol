// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import {EventManagement} from "../Events.sol";


contract EventFactory{
     EventManagement[] _eventmanagementClones;

     function createEventManagement() external returns(EventManagement _newEventMagement, uint256 _length){
        _newEventMagement = new EventManagement();
        _eventmanagementClones.push(_newEventMagement);
        _length = _eventmanagementClones.length;
     }

     function getEventmanagementClones() external view returns(EventManagement[] memory){
        return _eventmanagementClones;
     }
}