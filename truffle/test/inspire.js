const Inspire = artifacts.require('Inspire');

contract('Inspire', (accounts) => {
    let inspire = null
    before(async () => {
      inspire = await Inspire.deployed();
    })

    it('should register a user in whitelist', async () => {
        await inspire.register()
        const val = await inspire.getEntries();
        assert(val[0] === accounts[0])
    })

    it()
})