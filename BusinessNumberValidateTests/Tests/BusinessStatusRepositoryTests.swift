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
    var repository: BusinessStatusRepository!
    var mockAPIClient: MockAPIClient!
    var mockStorage: BusinessStatusStorageProtocol!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        mockStorage = MockCoreDataStorage()
        repository = BusinessStatusRepositoryImpl(
            apiClient: mockAPIClient,
            storage: mockStorage
        )
    }

    override func tearDown() {
        repository = nil
        mockAPIClient = nil
        mockStorage = nil
        cancellables = []
        super.tearDown()
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
    
    func testFetchBusinessStatus_ValidCache() {
            let validCachedStatus = BusinessStatus(
                bNo: "1234567890",
                bStt: "계속사업자",
                bSttCd: "01",
                taxType: "부가가치세 일반과세자",
                taxTypeCd: "01",
                endDt: "",
                utccYn: "N",
                taxTypeChangeDt: "",
                invoiceApplyDt: "",
                rbfTaxType: "해당없음",
                rbfTaxTypeCd: "99",
                lastUpdated: Date()
            )
            mockStorage.save(validCachedStatus)

            let expectation = XCTestExpectation(description: "유효한 캐시 데이터를 반환해야 함")
            repository.fetchBusinessStatus(for: "1234567890")
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("캐시 데이터를 반환할 것으로 예상했으나 실패했습니다.")
                    }
                }, receiveValue: { businessStatus in
                    XCTAssertEqual(businessStatus.bNo, "1234567890", "사업자 번호가 예상과 다릅니다.")
                    XCTAssertEqual(businessStatus.taxType, "부가가치세 일반과세자", "과세 유형이 예상과 다릅니다.")
                    expectation.fulfill()
                })
                .store(in: &cancellables)

            wait(for: [expectation], timeout: 5.0)
        }

        func testFetchBusinessStatus_ExpiredCache() {
            let expiredCachedStatus = BusinessStatus(
                bNo: "1234567890",
                bStt: "계속사업자",
                bSttCd: "01",
                taxType: "부가가치세 일반과세자",
                taxTypeCd: "01",
                endDt: "",
                utccYn: "N",
                taxTypeChangeDt: "",
                invoiceApplyDt: "",
                rbfTaxType: "해당없음",
                rbfTaxTypeCd: "99",
                lastUpdated: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) // 만료된 데이터
            )
            mockStorage.save(expiredCachedStatus)

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

            let expectation = XCTestExpectation(description: "만료된 캐시 데이터가 무시되고 네트워크 요청이 성공해야 함")
            repository.fetchBusinessStatus(for: "1234567890")
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("네트워크 요청이 성공할 것으로 예상했으나 실패했습니다.")
                    }
                }, receiveValue: { businessStatus in
                    // Then
                    XCTAssertEqual(businessStatus.bNo, "1234567890", "사업자 번호가 예상과 다릅니다.")
                    expectation.fulfill()
                })
                .store(in: &cancellables)

            wait(for: [expectation], timeout: 5.0)
        }

        func testFetchBusinessStatus_NoCache() {
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

            let expectation = XCTestExpectation(description: "캐시가 없는 경우 네트워크 요청이 성공해야 함")
            repository.fetchBusinessStatus(for: "1234567890")
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("네트워크 요청이 성공할 것으로 예상했으나 실패했습니다.")
                    }
                }, receiveValue: { businessStatus in
                    XCTAssertEqual(businessStatus.bNo, "1234567890", "사업자 번호가 예상과 다릅니다.")
                    XCTAssertEqual(businessStatus.taxType, "부가가치세 일반과세자", "과세 유형이 예상과 다릅니다.")
                    expectation.fulfill()
                })
                .store(in: &cancellables)

            wait(for: [expectation], timeout: 5.0)
        }
    
}
