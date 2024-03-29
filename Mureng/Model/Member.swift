//
//  Member.swift
//  Mureng
//
//  Created by 김수현 on 3/29/24.
//

import Foundation

struct Answer {
    let replyId: Int
    let questionId: Int
    let content: String
    let image: String
    let regDate: Date?
    let replyLikeCount: Int
    let question: Question?
    let author: Member?
    let requestedByAuthor: Bool
    let likedByRequester: Bool
}
