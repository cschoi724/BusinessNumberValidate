//
//  BusinessStatusRepositoryTests.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/4/24.
//
import XCTest

@testable import BusinessNumberValidate
import Combine

final class BusinessStatusRepositoryTests: XCTestCase {
    var repository: BusinessStatusRepositoryImpl!
    var mockAPIClient: MockAPIClient!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        repository = BusinessStatusRepositoryImpl(apiClient: mockAPIClient)
    }

    override func tearDown() {
        repository = nil
        mockAPIClient = nil
        cancellables = []
        super.tearDown()
    }

    func testFetchBusinessStatus_Success() {
        let validResponse = """
        {
            "request_cnt": 1,
            "status_code": "OK",
            "data": [
                {
                    "b_no": "1234567890",
                    "b_stt": "계속사업자",
                    "b_stt_cd": "01",
                    "tax_type": "부가가치세 일반과세자",
                    "tax_type_cd": "01",
                    "end_dt": "",
                    "utcc_yn": "N",
                    "tax_type_change_dt": "",
                    "invoice_apply_dt": "",
                    "rbf_tax_type": "해당없음",
                    "rbf_tax_type_cd": "99"
                }
            ]
        }
        """.data(using: .utf8)!

        mockAPIClient.response = .success(validResponse)

        let expectation = XCTestExpectation(description: "사업자 상태 조회 성공 테스트")
        repository.fetchBusinessStatus(for: "1234567890")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTFail("성공을 예상했으나 실패가 발생했습니다.")
                case .finished:
                    print("[Test] 에러 없이 종료됨.")
                }
            }, receiveValue: { businessStatus in
                print("사업자 상태:", businessStatus)
                XCTAssertEqual(businessStatus.bNo, "1234567890", "사업자 번호가 예상 값과 다릅니다.")
                XCTAssertEqual(businessStatus.bStt, "계속사업자", "사업자 상태가 예상 값과 다릅니다.")
                XCTAssertEqual(businessStatus.taxType, "부가가치세 일반과세자", "과세 유형이 예상 값과 다릅니다.")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchBusinessStatus_Failure_InvalidResponse() {
        let invalidResponse = """
        { "invalidKey": "invalidValue" }
        """.data(using: .utf8)!

        mockAPIClient.response = .success(invalidResponse)
        let expectation = XCTestExpectation(description: "유효하지 않은 응답으로 인해 실패")
        repository.fetchBusinessStatus(for: "1234567890")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    if case .decodingError = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("디코딩 오류를 예상했으나 \(error)가 발생했습니다.")
                    }
                case .finished:
                    XCTFail("실패를 예상했으나 정상적으로 완료되었습니다.")
                }
            }, receiveValue: { _ in
                XCTFail("실패를 예상했으나 성공적으로 응답을 받았습니다.")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10.0) // 재시도 대기 시간을 포함한 타임아웃
    }

    func testFetchBusinessStatus_RetryWithExponentialBackoff() {
        mockAPIClient.response = .failure(.networkError(NSError(domain: "Mock Network Error", code: -1, userInfo: nil)))
        mockAPIClient.delay = 0.1

        let expectation = XCTestExpectation(description: "지수 백오프를 사용한 재시도 테스트")
        repository.fetchBusinessStatus(for: "123-45-67890")
            .sink(receiveCompletion: { completion in
                // Then
                switch completion {
                case .failure(let error):
                    if case .networkError = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("네트워크 오류를 예상했으나 \(error)가 발생했습니다.")
                    }
                case .finished:
                    XCTFail("실패를 예상했으나 정상적으로 완료되었습니다.")
                }
            }, receiveValue: { _ in
                XCTFail("실패를 예상했으나 성공적으로 응답을 받았습니다.")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10.0) // 재시도 대기 시간을 포함한 타임아웃
    }
}
