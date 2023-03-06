// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
contract checkDate {

function getTimestamp(uint16 year, uint8 month, uint8 day) internal  pure returns (uint256) {
 
    uint256 timestamp = 0;

    // Calculate the number of seconds in each month up to the given month
    for (uint8 i = 1; i < month; i++) {
        if (i == 2 && isLeapYear(year)) {
            timestamp += 29 days;
        } else {
            timestamp += daysInMonth(i, year) * 1 days;
        }
    }

    // Add the number of seconds in the given day
    timestamp += (day - 1) * 1 days;

    // Add the number of seconds in each year up to the given year
    for (uint16 i = 1970; i < year; i++) {
        timestamp += isLeapYear(i) ? 366 days : 365 days;
    }

    return timestamp;
    }

    function isLeapYear(uint16 year) private pure returns (bool) {
        if (year % 4 != 0) {
            return false;
        } else if (year % 100 != 0) {
            return true;
        } else if (year % 400 != 0) {
            return false;
        } else {
            return true;
        }
    }

    function daysInMonth(uint8 month, uint16 year) private pure returns (uint8) {
        if (month == 2) {
            return isLeapYear(year) ? 29 : 28;
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        } else {
            return 31;
        }
    }


    function isPast(uint16 year, uint8 month, uint8 day) public view returns (bool) {
        uint256 timestamp = getTimestamp(year, month, day);
        return timestamp < block.timestamp;
    }

}