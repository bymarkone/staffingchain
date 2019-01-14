const Staffing = artifacts.require('Staffing')

contract('Staffing', accounts => {
	
	beforeEach(async function() {
		this.contract = await Staffing.new({from: accounts[0]})
	})

	describe('staffing request', () => {
		
		it('creates a staffing request', async function() {
			await this.contract.createStaffingRequest(1, 'An Account', 'A Project', 'Tech Lead', 10122929911, 10)

			openRequests = await this.contract.listOpenStaffingRequests()
			request = await this.contract.getStaffingRequestDetails(openRequests[0])

			assert.equal(openRequests.length, 1)
			assert.equal(request[0], 'An Account')
			assert.equal(request[1], 'A Project')
		})

		it('cannot create a duplicated staffing request', async function() {
			await this.contract.createStaffingRequest(1, 'An Account', 'A Project', 'Tech Lead', 10122929911, 10)

			try {
				await this.contract.createStaffingRequest(1, 'An Account', 'A Project', 'Tech Lead', 10122929911, 10)
			} catch (error) {
				openRequests = await this.contract.listOpenStaffingRequests()
				assert.equal(openRequests.length, 1)
			}
			
		})

	})

})
