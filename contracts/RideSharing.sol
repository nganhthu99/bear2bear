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

    enum UPDATE_DRIVER_MESSAGE{
        ADD_DRIVER, REMOVE_DRIVER
    }

    // DRIVER
    Driver[] public listDrivers;

    function driversCount() public constant returns (uint count){
        return listDrivers.length;
    }

    function getListDrivers() public view returns (Driver[]) {
        return listDrivers;
    }

    function removeDriverByIndex (uint index) {
        listDrivers[index] = listDrivers[listDrivers.length - 1];
        listDrivers[index].driverIndex = index;
        delete listDrivers[listDrivers.length - 1];
    }

    function findSuitableDrivers(string _riderPosition, VEHICLE_TYPE _riderSelectedVechcle) public view returns(Driver[] resultList, uint resultCount){
        uint MAX_DRIVERS = 10;
        uint suiIndex = 0;
        Driver[] memory  suitableDrivers  = new Driver[](MAX_DRIVERS);
        for (uint index = 0; index< driversCount(); index++){
            if (listDrivers[index].ownedVehicle == _riderSelectedVechcle && suiIndex < MAX_DRIVERS){
                suitableDrivers[suiIndex] = listDrivers[index];
                suiIndex++;
            }
        }
        uint count = suiIndex;
        return (suitableDrivers, count);
    }

    struct Driver {
        uint driverIndex;
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

        Driver memory driver = Driver(
            listDrivers.length,
            _driverAddress,
            _phoneNumber,
            _ownedVehicle,
            _detailVehicle,
            _position,
            _pricePerKm,
            DRIVER_STATE.FREE,
            Rider('', '', '', VEHICLE_TYPE.MOTORCYCLE)
        );

        listDrivers.push(driver);
        emit UpdateListDrivers(UPDATE_DRIVER_MESSAGE.ADD_DRIVER,
            driver.driverIndex,
            driver.driverAddress,
            driver.phoneNumber,
            driver.ownedVehicle,
            driver.detailVehicle,
            driver.position,
            driver.pricePerKm,
            driver.state
        );
    }

    // RIDER
    struct Rider {
        string riderAddress;
        string phoneNumber;
        string position;
        VEHICLE_TYPE selectedVehicle;
    }

    function processRide(uint _driverIndex, address _driverAddress, string _riderAddress, string _riderPhoneNumber, string _riderPosition, VEHICLE_TYPE _riderSelectedVechcle) public {
        Rider memory rider = Rider(_riderAddress, _riderPhoneNumber, _riderPosition, _riderSelectedVechcle);
        listDrivers[_driverIndex].state = DRIVER_STATE.IS_PROCESSING;
        listDrivers[_driverIndex].rider = rider;
        emit NewRideIsProcessing(_driverAddress, rider.riderAddress, rider.phoneNumber, rider.position, rider.selectedVehicle);
    }

    function confirmRide(uint _index) public {
        Driver memory driver = listDrivers[_index];
        emit UpdateListDrivers(UPDATE_DRIVER_MESSAGE.REMOVE_DRIVER,
            driver.driverIndex,
            driver.driverAddress,
            driver.phoneNumber,
            driver.ownedVehicle,
            driver.detailVehicle,
            driver.position,
            driver.pricePerKm,
            driver.state
        );
        removeDriverByIndex(_index);
    }

    event UpdateListDrivers (
        UPDATE_DRIVER_MESSAGE message,
        uint driverIndex,
        address driverAddress,
        string phoneNumber,
        VEHICLE_TYPE ownedVehicle,
        string detailVehicle,
        string position,
        uint pricePerKm,
        DRIVER_STATE state
    );

    event NewRideIsProcessing (
        address driverAddress,
        string riderAddress,
        string phoneNumber,
        string position,
        VEHICLE_TYPE selectedVehicle
    );
}

