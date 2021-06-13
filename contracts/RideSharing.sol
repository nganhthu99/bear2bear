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

    struct Geometry {
        string lat;
        string lng;
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
        string riderAddress;
        Geometry geometry;
    }

    function registerDrive(
        address addr,
        string phoneNumber,
        VEHICLE_TYPE vehicleType,
        string vehicleDetail,
        string position,
        uint pricePerKm,
        string lat,
        string lng) {

        Geometry memory geometry = Geometry(lat, lng);
        Geometry memory geometryRider = Geometry("0", "0");

        Driver memory driver = Driver(
            listDrivers.length,
            addr,
            phoneNumber,
            vehicleType,
            vehicleDetail,
            position,
            pricePerKm,
            DRIVER_STATE.FREE,
            '',
            geometry
        );

        listDrivers.push(driver);
    }

    // RIDER
    struct Rider {
        string riderAddress;
        string phoneNumber;
        string position;
        string destination;
        uint distance;
        Geometry geometry;
    }

    function processRide(uint driverIndex, address driverAddress, string riderAddress, string riderPhoneNumber, string riderPosition, string riderDestination, uint riderDistance, string lat, string lng) public {
        Geometry memory geometry = Geometry(lat, lng);
        listDrivers[driverIndex].state = DRIVER_STATE.IS_PROCESSING;
        listDrivers[driverIndex].riderAddress = riderAddress;
        emit NewRide(driverIndex, driverAddress, riderAddress, riderPhoneNumber, riderPosition, riderDestination, riderDistance, lat, lng);
    }

    function removeDriverByIndex (uint index) {
        listDrivers[index] = listDrivers[listDrivers.length - 1];
        listDrivers[index].index = index;
        listDrivers.length--;
    }

    function confirmRide(uint driverIndex) public {
        emit DriverConfirm(listDrivers[driverIndex].riderAddress);
        removeDriverByIndex(driverIndex);
    }

    event NewRide (
        uint driverIndex,
        address driverAddress,
        string riderAddress,
        string riderPhoneNumber,
        string riderPosition,
        string riderDestination,
        uint riderDistance,
        string lat,
        string lng
    );

    event DriverConfirm (
        string riderAddress
    );
}
