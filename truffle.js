var HDWalletProvider = require('truffle-hdwallet-provider')
var mnemonic = 'plate cancel general file clinic buzz garbage hub empty thought recycle grit'

module.exports = {
	networks: {
		development: {
			host: '127.0.0.1',
			port: 8545, 
			network_id: 5777
		},
		rinkeby: {
			provider: () => new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/fe2e30a2a6ea47b38d6ea1314ec8fddb'),
			network_id: 4,
			gas: 4500000,
			gasPrice: 10000000000
		},
		ropsten: {
			provider: () => new HDWalletProvider(mnemonic, 'https://ropsten.infura.io/v3/fe2e30a2a6ea47b38d6ea1314ec8fddb'),
			network_id: 4,
			gas: 4700000,
		}
	}
}
