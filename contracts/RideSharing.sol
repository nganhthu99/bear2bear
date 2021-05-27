pragma experimental ABIEncoderV2;

// contract.registerDrive('0xBa981Bac71ABf0bf4c6FBa5949b1eb8F75adaA6d', '0829527843', 'MOTORCYCLE', 'Honda Alpha', "Thanh Da", 25000)

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

    function getListDrivers() returns (Driver[]) {
        return listDrivers;
    }

    function removeDriverByIndex(uint index) {
        listDrivers[index] = listDrivers[listDrivers.length - 1];
        delete listDrivers[listDrivers.length - 1];
    }

    struct Driver {
        address driverAddress;
        string phoneNumber;
        VEHICLE_TYPE ownedVehicle;
        string detailVehicle;
        string position;
        uint pricePerKm;
        DRIVER_STATE state;
        Rider rider;
    }

    function registerDrive(
        address _driverAddress,
        string _phoneNumber,
        VEHICLE_TYPE _ownedVehicle,
        string _detailVehicle,
        string _position,
        uint _pricePerKm) {

        listDrivers.push(
            Driver(
                _driverAddress,
                _phoneNumber,
                _ownedVehicle,
                _detailVehicle,
                _position,
                _pricePerKm,
                DRIVER_STATE.FREE,
                Rider('', '', '')
            )
        );
        emit UpdateListDrivers("HELLO FROM CONTRACT");
    }

    // RIDER
    struct Rider {
        string riderAddress;
        string phoneNumber;
        string position;
    }

    function processRide(uint _driverIndex, address _driverAddress, string _riderAddress, string _riderPhoneNumber, string _riderPosition) {
        listDrivers[_driverIndex].state = DRIVER_STATE.IS_PROCESSING;
        listDrivers[_driverIndex].rider = Rider(_riderAddress, _riderPhoneNumber, _riderPosition);
        emit NewRideIsProcessing(_driverAddress, Rider(_riderAddress, _riderPhoneNumber, _riderPosition));
    }

    function confirmRide(uint _index) {
        removeDriverByIndex(_index);
        emit UpdateListDrivers("HELLO FROM CONTRACT");
    }

    event UpdateListDrivers(
        string message
    );

    event NewRideIsProcessing (
        address driverAddress,
        Rider rider
    );
}

