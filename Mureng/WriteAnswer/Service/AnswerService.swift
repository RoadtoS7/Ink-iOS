//
//  AnswerService.swift
//  Mureng
//
//  Created by 김수현 on 3/24/24.
//

import Foundation

protocol DiaryWriterAdapter {
    
}

class RemoteDiaryWriterAdapter {
    
    func writeDiary(questionId: String, content: String ,imageUrl: String) async {
        
    }
    
    func getImages() {
        
    }
}

class LocalDiaryWriterAdapter {
    
}
