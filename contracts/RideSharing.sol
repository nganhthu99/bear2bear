pragma experimental ABIEncoderV2;

// contract.registerDrive('0x5110E08969264C603C62a9805687Dd065B7c4789', '0829527843', 0, 'Honda Alpha', "Thanh Da", 25000)

contract RideSharing {
    function RideSharing() {

    }

    enum VEHICLE_TYPE {
        MOTORCYCLE, FOUR_SEAT_CAR, SEVEN_SEAT_CAR
    }

    enum DRIVER_STATE {
        FREE, IS_PROCESSING
    }

    // DRIVER
    Driver[] public listDrivers;

    function getListDrivers() public view returns (Driver[]) {
        return listDrivers;
    }

    struct Driver {
        uint index;
        address addr;
        string phoneNumber;
        VEHICLE_TYPE vehicleType;
        string vehicleDetail;
        string position;
        uint pricePerKm;
        DRIVER_STATE state;
        Rider rider;
    }

    function registerDrive(
        address addr,
        string phoneNumber,
        VEHICLE_TYPE vehicleType,
        string vehicleDetail,
        string position,
        uint pricePerKm) {

        Driver memory driver = Driver(
            listDrivers.length,
            addr,
            phoneNumber,
            vehicleType,
            vehicleDetail,
            position,
            pricePerKm,
            DRIVER_STATE.FREE,
            Rider('', '', '', '')
        );

        listDrivers.push(driver);
    }

    // RIDER
    struct Rider {
        string riderAddress;
        string phoneNumber;
        string position;
        string destination;
    }

    function processRide(uint driverIndex, address driverAddress, string riderAddress, string riderPhoneNumber, string riderPosition, string riderDestination) public {
        Rider memory rider = Rider(riderAddress, riderPhoneNumber, riderPosition, riderDestination);
        listDrivers[driverIndex].state = DRIVER_STATE.IS_PROCESSING;
        listDrivers[driverIndex].rider = rider;
        emit NewRide(driverIndex, driverAddress, rider.riderAddress, rider.phoneNumber, rider.position, rider.destination);
    }

    function removeDriverByIndex (uint index) {
        listDrivers[index] = listDrivers[listDrivers.length - 1];
        listDrivers[index].index = index;
//        delete listDrivers[listDrivers.length - 1];
        listDrivers.length--;
    }

    function confirmRide(uint driverIndex) public {
        removeDriverByIndex(driverIndex);
    }

    event NewRide (
        uint driverIndex,
        address driverAddress,
        string riderAddress,
        string riderPhoneNumber,
        string riderPosition,
        string riderDestination
    );
}

