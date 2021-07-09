//
//  UserData.swift
//  knila project
//
//  Created by Fuzionest on 08/07/21.
//
import Foundation
struct Data : Codable {
    var id : Int?
    var email : String?
    var first_name : String?
    var last_name : String?
    var avatar : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case first_name = "first_name"
        case last_name = "last_name"
        case avatar = "avatar"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
    }

}

struct Userslist : Codable {
    let page : Int?
    let per_page : Int?
    let total : Int?
    let total_pages : Int?
    var data : [Data]?
    let support : Support?

    enum CodingKeys: String, CodingKey {

        case page = "page"
        case per_page = "per_page"
        case total = "total"
        case total_pages = "total_pages"
        case data = "data"
        case support = "support"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        data = try values.decodeIfPresent([Data].self, forKey: .data)
        support = try values.decodeIfPresent(Support.self, forKey: .support)
    }

}

struct Support : Codable {
    let url : String?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}

