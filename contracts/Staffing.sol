pragma solidity ^0.4.24;

contract Staffing {

	struct StaffingRequest {
		address creator; 
		bytes32 requestId;
		string account;
		string project;
		string role;
		uint256 start;
		uint256 duration;
		bool open;
	}

	mapping(uint256 => StaffingRequest) public staffingRequests;
	mapping(bytes32 => bool) public existingRequests;

	// approve
	// apply

	//function listOpenStaffingRequests() public {
	//	return "";
	//}	

	function createStaffingRequest(uint256 index, 
																 string _account, 
																 string _project, 
																 string _role,
																 uint256 _start,
																 uint256 _duration) {

		bytes32 requestIdentity = keccak256(abi.encodePacked(index, _account, _project));
		require(!existingRequests[requestIdentity]);

		StaffingRequest	memory request = StaffingRequest(
			msg.sender,
			requestIdentity,
			_account,
			_project,
			_role,
			_start,
			_duration,
			true
		);
	}
}
