pragma solidity ^0.5.0;

contract DeferredEquityPlan {
    address human_resources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    uint total_shares = 1000;
    uint annual_distribution = 250;

    uint start_time = now; // permanently store the time this contract was initialized

    uint unlock_time = now + 365 days;

    uint public distributed_shares; // starts at 0
    
    uint fakeNow = now;

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }
    
    function fastforward() public {
        fakeNow += 370 days;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        require(unlock_time <= fakeNow, "You need to wait more time");
        require(distributed_shares < total_shares, "All shares have been distruted.");

        unlock_time += 365 days;

        distributed_shares = (fakeNow - start_time) / 365 days * annual_distribution;

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
