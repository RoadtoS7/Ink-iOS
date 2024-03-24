//
//  WriteDiaryAPITests.swift
//  MurengTests
//
//  Created by 김수현 on 3/24/24.
//

import XCTest
@testable import Mureng

// 리모트 서버로 보내는 요청. 시간이 걸리는 테스트이기 때문에 필요할 때만 호출해야 한다.
final class WriteDiaryAPITests: XCTestCase {
    private var acessToken: String!
    
    override func setUp() async throws {
        MemberAuthAPI.shared.signUp(signUPDTO: <#T##SignUpDTO#>, completion: <#T##(MemberDTO?) -> Void#>)
    }

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUploadImage() async throws {
        // given
        guard let url = Bundle(for: MurengTests.self).url(forResource: "IMG_0417", withExtension: "JPG") else {
            XCTFail("image not exist")
            return
        }
        
        let data = try Data(contentsOf: url)
        
        let response = try await WriteDiaryAPI.shared.uploadImage(data: data)

        XCTAssertTrue(response.data.imagePath.isNotEmpty, "image path가 존재하지 않습니다.")
    }
    
    func testGetDefaultImages() async throws {
        let response = try await WriteDiaryAPI.shared.loadDefaultImages()
        XCTAssertTrue(response.data.imagePath.isNotEmpty, "default image의  path가 서버로부터 내려오지 않았습니다..")
    }
}
