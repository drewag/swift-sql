import XCTest
@testable import SQL

class TimeTests: XCTestCase {
    func testDescription() throws {
        XCTAssertEqual(Time(hour: 0, minute: 0, second: 0).description, "12:00am")
        XCTAssertEqual(Time(hour: 0, minute: 0, second: 1).description, "12:00:01am")
        XCTAssertEqual(Time(hour: 0, minute: 0, second: 10).description, "12:00:10am")
        XCTAssertEqual(Time(hour: 12, minute: 0).description, "12:00pm")
        XCTAssertEqual(Time(hour: 23, minute: 0).description, "11:00pm")
        XCTAssertEqual(Time(hour: 6, minute: 1).description, "6:01am")
        XCTAssertEqual(Time(hour: 6, minute: 10).description, "6:10am")
    }

    func test24HourMinute() throws {
        var time = try Time("23:59")
        XCTAssertEqual(time.hour, 23)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 0)
        time = try Time("0:00")
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 23:59 ")
        XCTAssertEqual(time.hour, 23)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 0:00 ")
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)

        XCTAssertThrowsError(try Time("-1:27"))
        XCTAssertThrowsError(try Time("25:27"))
        XCTAssertThrowsError(try Time("23:-1"))
        XCTAssertThrowsError(try Time("23:60"))
    }

    func test24HourMinuteAndSeconds() throws {
        var time = try Time("23:59:59")
        XCTAssertEqual(time.hour, 23)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 59)
        time = try Time("0:00:00")
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 23:59:59 ")
        XCTAssertEqual(time.hour, 23)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 59)
        time = try Time(" 0:00:00 ")
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)

        XCTAssertThrowsError(try Time("-1:27:12"))
        XCTAssertThrowsError(try Time("25:27:12"))
        XCTAssertThrowsError(try Time("20:-1:12"))
        XCTAssertThrowsError(try Time("20:60:12"))
        XCTAssertThrowsError(try Time("20:27:-1"))
        XCTAssertThrowsError(try Time("20:27:60"))
    }

    func testAmHourMinute() throws {
        var time = try Time("12:59am")
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 0)
        time = try Time("1:00am")
        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 12:59 am ")
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 1:00 am ")
        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)

        XCTAssertThrowsError(try Time("13:59am"))
        XCTAssertThrowsError(try Time("0:59am"))
        XCTAssertThrowsError(try Time("12:60am"))
        XCTAssertThrowsError(try Time("12:-1am"))
    }

    func testAmHourMinuteAndSeconds() throws {
        var time = try Time("12:59:59am")
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 59)
        time = try Time("1:00:00am")
        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 12:59:59 am")
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 59)
        time = try Time(" 1:00:00 am ")
        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)


        XCTAssertThrowsError(try Time("13:59:59am"))
        XCTAssertThrowsError(try Time("0:59:59am"))
        XCTAssertThrowsError(try Time("12:60:59am"))
        XCTAssertThrowsError(try Time("12:-1:59am"))
        XCTAssertThrowsError(try Time("12:59:60am"))
        XCTAssertThrowsError(try Time("12:59:-1am"))
    }

    func testPmHourMinute() throws {
        var time = try Time("12:59pm")
        XCTAssertEqual(time.hour, 12)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 0)
        time = try Time("1:00pm")
        XCTAssertEqual(time.hour, 13)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 12:59 pm ")
        XCTAssertEqual(time.hour, 12)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 1:00 pm ")
        XCTAssertEqual(time.hour, 13)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)

        XCTAssertThrowsError(try Time("13:59pm"))
        XCTAssertThrowsError(try Time("0:59pm"))
        XCTAssertThrowsError(try Time("12:60pm"))
        XCTAssertThrowsError(try Time("12:-1pm"))
    }

    func testPmHourMinuteAndSeconds() throws {
        var time = try Time("12:59:59pm")
        XCTAssertEqual(time.hour, 12)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 59)
        time = try Time("1:00:00pm")
        XCTAssertEqual(time.hour, 13)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)
        time = try Time(" 12:59:59 pm ")
        XCTAssertEqual(time.hour, 12)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 59)
        time = try Time(" 1:00:00 pm ")
        XCTAssertEqual(time.hour, 13)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)

        XCTAssertThrowsError(try Time("13:59:59pm"))
        XCTAssertThrowsError(try Time("0:59:59pm"))
        XCTAssertThrowsError(try Time("12:60:59pm"))
        XCTAssertThrowsError(try Time("12:-1:59pm"))
        XCTAssertThrowsError(try Time("12:59:60pm"))
        XCTAssertThrowsError(try Time("12:59:-1pm"))
    }

    func testCompare() throws {
        XCTAssertLessThan(Time(hour: 12, minute: 30, second: 30), Time(hour: 13, minute: 30, second: 30))
        XCTAssertLessThan(Time(hour: 12, minute: 30, second: 30), Time(hour: 12, minute: 31, second: 30))
        XCTAssertLessThan(Time(hour: 12, minute: 30, second: 30), Time(hour: 12, minute: 30, second: 31))
    }

    func testCodable() throws {
        let data = try JSONEncoder().encode([Time(hour: 13, minute: 20, second: 30)])
        XCTAssertEqual(String(data: data, encoding: .utf8), #"["1:20:30pm"]"#)
        let time = try JSONDecoder().decode([Time].self, from: data)[0]
        XCTAssertEqual(time.hour, 13)
        XCTAssertEqual(time.minute, 20)
        XCTAssertEqual(time.second, 30)
    }

    func testSQLValue() {
        let time = Time(hour: 13, minute: 20, second: 30)
        switch time.sqlValue {
        case let .time(hour, minute, second):
            XCTAssertEqual(hour, 13)
            XCTAssertEqual(minute, 20)
            XCTAssertEqual(second, 30)
        default:
            XCTFail()
        }
    }

    func testMidnight() {
        XCTAssertEqual(Time.midnight.hour, 0)
        XCTAssertEqual(Time.midnight.minute, 0)
        XCTAssertEqual(Time.midnight.second, 0)
        XCTAssertEqual(Time.midnight.description, "12:00am")
    }
}
