pragma solidity ^0.4.24;

contract StaffingRequest {
	address public creator; 
	bytes32 public requestId;
	string public account;
	string public project;
	string public role;
	uint256 public start;
	uint256 public duration;
	bool public open;
	
	constructor(address _creator, bytes32 _requestId, string _account, string _project, 
											 string _role, uint256 _start, uint256 _duration, bool _open) public {
												
		creator = _creator;
		requestId = _requestId;
		account = _account;
		project = _project;
		role = _role;
		start = _start; 
		duration = _duration;
		open = _open;
	}

}

contract Staffing {

	StaffingRequest[] staffingRequests;
	mapping(bytes32 => bool) existingRequests;

	// approve
	// apply

	function listOpenStaffingRequests() view public returns (StaffingRequest[]) {
		return staffingRequests;
	}	

	function getStaffingRequestDetails() view public returns (string, string) {
		return (staffingRequests[0].account(), staffingRequests[0].project());
	}

	function createStaffingRequest(uint256 index, 
																 string _account, 
																 string _project, 
																 string _role,
																 uint256 _start,
																 uint256 _duration) public {

		bytes32 requestIdentity = keccak256(abi.encodePacked(index, _account, _project));
		require(!existingRequests[requestIdentity]);

		StaffingRequest	request = new StaffingRequest(
			msg.sender,
			requestIdentity,
			_account,
			_project,
			_role,
			_start,
			_duration,
			true
		);

		staffingRequests.push(request);

	}
}
