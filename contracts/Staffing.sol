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

	address[] public candidates;
	
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

	function addCandidate(address candidate) public {
		candidates.push(candidate);
	}

	function numberOfCandidates() public view returns (uint) {
		return candidates.length;
	}
}

contract Staffing {

	event StaffingRequestCreated(StaffingRequest request);

	StaffingRequest[] staffingRequests;
	mapping(bytes32 => bool) existingRequests;

	// approve
	// apply
	function listOpenStaffingRequests() view public returns (StaffingRequest[]) {
		return staffingRequests;
	}	

	function getStaffingRequestDetails(address id) view public returns (string, string, uint) {
		StaffingRequest request;
		for (uint i = 0; i < staffingRequests.length; i++) {
			if (address(staffingRequests[i]) == id) {
				request = staffingRequests[i];
			}
		}
		return (request.account(), request.project(), request.numberOfCandidates());
	}

	function createStaffingRequest(uint256 index, string _account, string _project, 
																 string _role, uint256 _start, uint256 _duration) public {

		bytes32 requestIdentity = keccak256(abi.encodePacked(index, _account, _project));
		require(!existingRequests[requestIdentity]);

		existingRequests[requestIdentity] = true;

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

		emit StaffingRequestCreated(request);

	}

	function applyForRole(StaffingRequest request) public returns (string) {
		require(request.open());
		
		request.addCandidate(msg.sender);
	}

}
