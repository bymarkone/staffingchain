pragma solidity ^0.4.24;

contract StaffingRequestApproval {
	StaffingRequest public staffingRequest;
	address public approver;

	constructor(StaffingRequest _request, address _approver) public {
		staffingRequest = _request;
		approver = _approver;
	}
}

contract StaffingRequest {
	address public creator; 
	bytes32 public requestId;
	string public account;
	string public project;
	string public role;
	uint256 public start;
	uint256 public duration;
	bool public open;

	mapping(address => bool) candidates;
	uint candidatesCount;
	address public occupant;
	
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
		candidates[candidate] = true;
		candidatesCount += 1;
	}

	function close() public {
		open = false;
	}

	function numberOfCandidates() public view returns (uint) {
		return candidatesCount;
	}

	function hasCandidate(address candidate) public view returns (bool) {
		return candidates[candidate];
	}
}

contract Staffing {

	event StaffingRequestCreated(StaffingRequest request);

	StaffingRequest[] staffingRequests;
	mapping(bytes32 => bool) existingRequests;
	StaffingRequestApproval[] approvals;

	// approve
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

	function approveCandidate(StaffingRequest request, address candidate) public {
		require(request.open());
		require(request.hasCandidate(candidate));

		bool inTeam;

		if (request.creator() == msg.sender) {
			inTeam = true;
		} else {
			for (uint i = 0; i < staffingRequests.length; i++) {
				StaffingRequest sr = staffingRequests[i];
				if (!sr.open() && sr.occupant() == msg.sender
						&& isEqual(sr.account(), request.account())
						&& isEqual(sr.project(), request.project())) {
					inTeam = true;
				}
			}
		}
		
		require(inTeam);

		approvals.push(new StaffingRequestApproval(request, msg.sender));

		attemptApproveRequest(request);
	}

	function attemptApproveRequest(StaffingRequest request) private {
		
		bool teamApproval = false;

		for (uint i = 0; i < staffingRequests.length; i++) {
			StaffingRequest sr = staffingRequests[i];
			if (!sr.open() 
					&& isEqual(sr.account(), request.account())
					&& isEqual(sr.project(), request.project())) {

				bool hasApproved = false;
				
				for (uint j = 0; j < approvals.length; j++) {
					StaffingRequestApproval approval = approvals[j];
					if (approval.request() == request &&
							sr.occupant() == aproval.approver()) {
						hasApproved = true;
					}
				}

				if (!hasApproved) {
					teamApproval = false;
					return;
				}

				teamApproval = true;
			}
		}

		if (teamApproval) {
			request.close();
		}
	}

	function isEqual(string first, string second) private pure returns (bool) {
		return keccak256(first) == keccak256(second);
	}

}
