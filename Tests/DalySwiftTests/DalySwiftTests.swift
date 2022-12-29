import XCTest
import DalySwift


final class DalySwiftTests: XCTestCase {

    func testExample() async throws {
        let client = DalyClient(path: "/dev/ttyUSB0")
        try await client.open()
        print(try await client.getStatus())
        print(try await client.getCellVoltageLimits())
        print(try await client.getCellTemperatureLimits())
        print(try await client.getMosfetStatus())
        print(try await client.getStateOfCharge())
        print(try await client.getFailures())
        print(try await client.getCellBalanceState())
        print(try await client.getCellVoltages())
        print(try await client.getCellTemperatures())
    }
}
