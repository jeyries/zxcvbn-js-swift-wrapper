import XCTest
@testable import ZxcvbnJS

final class ZxcvbnJSTests: XCTestCase {
    func testExample1() throws {
        let result = ZxcvbnJS().evaluate(password: "zxcvbn")
        debugPrint("testExample1", result)
        XCTAssertEqual(result.score, 0)
    }
    
    func testExample2() throws {
        let result = ZxcvbnJS().evaluate(password: "Tr0ub4dour&3")
        debugPrint("testExample2",  result)
        XCTAssertEqual(result.score, 2)
    }
    
}
