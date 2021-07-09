pragma solidity 0.5.4;

import "./VestingVault.sol";

/**
 * @title Contract for distribution of tokens
 * Copyright 2021
 */
contract LocalTokenDistribution is Ownable {
    using SafeMath for uint256;

    IERC20 public token;
    VestingVault public vestingVault;

    bool public finished;

    modifier isAllowed() {
        require(finished == false, "Minting was already finished");
        _;
    }

    /**
     * @dev Constructor
     * @param _token Contract address of LocalToken
     * @param _vestingVault Contract address of VestingVault
     */
    constructor (
        address _token,
        VestingVault _vestingVault
    ) public {
        require(address(_token) != address(0), "Address should not be zero");
        require(address(_vestingVault) != address(0), "Address should not be zero");

        token = IERC20(_token);
        vestingVault = _vestingVault;
        finished = false;
    }

    /**
     * @dev updateToken update base token
     * @notice this will be done by only owner any time
     */
    function updateToken(address _token) public onlyOwner {
        require(address(_token) != address(0), "Token address should not be zero");
        token = IERC20(_token);
    }

    /**
     * @dev Function to allocate tokens for vested contributor
     * @param _from Source address that tokens will be from
     * @param _to Withdraw address that tokens will be sent
     * @param _value Amount to hold during vesting period
     * @param _start Unix epoch time that vesting starts from
     * @param _duration Seconds amount of vesting duration
     * @param _cliff Seconds amount of vesting cliff
     * @param _scheduleTimes Array of Unix epoch times for vesting schedules
     * @param _scheduleValues Array of Amount for vesting schedules
     * @param _level Indicator that will represent types of vesting
     */
    function allocVestedUser(
        address _from, address _to, uint _value, uint _start, uint _duration, uint _cliff, uint[] memory _scheduleTimes,
        uint[] memory _scheduleValues, uint _level) public onlyOwner isAllowed {
        _value = vestingVault.grant(_to, _value, _start, _duration, _cliff, _scheduleTimes, _scheduleValues, _level);
        token.transferFrom(_from, address(vestingVault), _value);
    }

    /**
     * @dev Function to get back Ownership of VestingVault Contract after minting finished
     */
    function transferBackVestingVaultOwnership() public onlyOwner {
        vestingVault.transferOwnership(owner);
    }

    /**
     * @dev Function to finish token distribution
     */
    function finalize() public onlyOwner {
        finished = true;
    }
}