const Staffing = artifacts.require('Staffing')

contract('Staffing', accounts => {
	
	beforeEach(async function() {
		this.contract = await Staffing.new({from: accounts[0]})
	})

	describe('staffing request', () => {
		
		it('creates a staffing request', async function() {
			await this.contract.createStaffingRequest(1, 'Premier', 'AMP', 'Tech Lead', 10122929911, 10)

			//openRequests = this.contract.listOpenStaffingRequests()

			console.log(openRequests)
		})

	})

})
