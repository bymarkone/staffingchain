const Staffing = artifacts.require('Staffing')

contract('Staffing', accounts => {
	
	beforeEach(async function() {
		this.contract = await Staffing.new({from: accounts[0]})
	})

	describe('staffing request', () => {
		
		it('creates a staffing request', async function() {
			await this.contract.createStaffingRequest(1, 'An Account', 'A Project', 'Tech Lead', 10122929911, 10)

			const openRequests = await this.contract.listOpenStaffingRequests()
			const request = await this.contract.getStaffingRequestDetails(openRequests[0])
	
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

	describe('role application', () => {

		it('apply for a staffing request', async function() {
			await this.contract.createStaffingRequest(1, 'An Account 2', 'A Project', 'Tech Lead', 10122929911, 10)
			const openRequests = await this.contract.listOpenStaffingRequests()

			const account = await this.contract.applyForRole(openRequests[0])

			const request = await this.contract.getStaffingRequestDetails(openRequests[0])

			assert.equal(request[2], 1)
		})
	})

	describe('role approval', () => {

		it('approve a role', async function() {
			await this.contract.createStaffingRequest(1, 'An Account 3', 'A Project', 'Tech Lead', 10122929911, 10)
			const openRequests = await this.contract.listOpenStaffingRequests()

			const account = await this.contract.applyForRole(openRequests[0])

			await this.contract.approveCandidate(openRequests[0], accounts[0])

		})
	})
})
