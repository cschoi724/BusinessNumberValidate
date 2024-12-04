//
//  BusinessStatusReducer.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import Foundation
import ComposableArchitecture
import Combine


struct BusinessStatusReducer: Reducer {
    struct State: Equatable {
        var businessNumber: String = ""
        var businessStatus: BusinessStatus? = nil
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }

    enum Action {
        case updateBusinessNumber(String)
        case fetchBusinessStatus
        case businessStatusResponse(Result<BusinessStatus, BusinessError>)
        case cancelFetch
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let fetchBusinessStatusUseCase: FetchBusinessStatusUseCase
    }
    
    let environment: Environment

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        let env = environment
        switch action {
        case .updateBusinessNumber(let businessNumber):
            state.businessNumber = businessNumber
            return .none

        case .fetchBusinessStatus:
            state.isLoading = true
            state.errorMessage = nil
            return Effect.publisher {
                env.fetchBusinessStatusUseCase.execute(businessNumber: state.businessNumber)
                    .receive(on: env.mainQueue)
                    .map { result in
                        Action.businessStatusResponse(.success(result))
                    }
                    .catch { error in
                        Just(
                            Action.businessStatusResponse(
                                .failure(error as? BusinessError ?? .unknownError("Unexpected error"))
                            )
                        )
                    }
                    .eraseToAnyPublisher()
            }
        case .businessStatusResponse(let result):
            state.isLoading = false
            switch result {
            case .success(let businessStatus):
                state.businessStatus = businessStatus
                if businessStatus.bStt.isEmpty {
                    state.errorMessage = "국세청에 등록되지 않은 사업자등록번호입니다."
                } else {
                    state.errorMessage = nil
                }

            case .failure(let error):
                state.errorMessage = error.userFriendlyMessage
            }
            return .none
        case .cancelFetch:
            state.isLoading = false
            return .cancel(id: "fetchBusinessStatus")
        }
    }
}
