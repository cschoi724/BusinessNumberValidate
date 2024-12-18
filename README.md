의존성관리 도구는 SPM 사용했고, 인덱싱이 완료되면 프로젝트파일에서 바로 빌드및 실행 가능하게 되어 있습니다.<br>

### 사용한 라이브러리<br>
- Swinject<br>
- ComposableArchitecture<br>

### 사용한 기술스택
- SwiftUI<br>
- CoreData<br>
- async-await<br>
- Combine<br>
- TCA <br>
- Clean Architecture<br>

## 설명
- 공공 데이터 포털에서 '국세청_사업자등록정보 진위확인 및 상태조회 서비스' 를 사용했고, 사업자번호를 조회해 현재 사업자의 상태를 확인하는 간단한 앱입니다.
- 기초 구조는 Clean Architecture 를 따르고 있고, ComposableArchitecture 프레임워크 사용해서 TCA 구조를 구현했습니다. 
- URLSession과 async-await를 사용하여 비동기 네트워크 처리를 구현되어있습니다.
- HTTP 상태 코드와 응답 메시지를 기반으로 에러를 세분화하여 처리했고, 네트워크 오류, 서버 오류 등을 구분하여 사용자에게 적절한 메시지를 제공합니다.
- 실패한 요청에 대해 지수 백오프 알고리즘을 적용하여 재시도합니다.
- TCA에 기반한 동시성 처리 및 반응형 프로그래밍 따르며 Combine 프레임워크를 활용하여 데이터 스트림을 관리하며 UI와 데이터의 생명주기를 업데이트 합니다.
- CoreData를 사용하여 데이터 캐시를 관리하고, 시간 기반의 캐시 무효화 정책을 수립하여 데이터의 최신성을 유지합니다.
