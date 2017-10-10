//
//  User.swift
//  MyGithub
//
//  Created by yang on 10/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let location: Any?
    let hireable: Any?
    let publicGists: Int
    let url: URL
    let followingUrl: String
    let eventsUrl: String
    let receivedEventsUrl: URL
    let company: Any?
    let updatedAt: String
    let bio: Any?
    let avatarUrl: URL
    let name: Any?
    let type: String
    let subscriptionsUrl: URL
    let gistsUrl: String
    let userId: Int
    let starredUrl: String
    let organizationsUrl: URL
    let reposUrl: URL
    let siteAdmin: Bool
    let email: Any?
    let login: String
    let blog: String
    let publicRepos: Int
    let followers: Int
    let following: Int
    let createdAt: String
    let gravatarId: String
    let followersUrl: URL
    let htmlUrl: URL
    private enum CodingKeys: String, CodingKey {
        case location
        case hireable
        case publicGists = "public_gists"
        case url
        case followingUrl = "following_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case company
        case updatedAt = "updated_at"
        case bio
        case avatarUrl = "avatar_url"
        case name
        case type
        case subscriptionsUrl = "subscriptions_url"
        case gistsUrl = "gists_url"
        case userId = "id"
        case starredUrl = "starred_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case siteAdmin = "site_admin"
        case email
        case login
        case blog
        case publicRepos = "public_repos"
        case followers
        case following
        case createdAt = "created_at"
        case gravatarId = "gravatar_id"
        case followersUrl = "followers_url"
        case htmlUrl = "html_url"
    }
    
//    init(from decoder: Decoder) throws {
//
//    }
//
//    func encode(to encoder: Encoder) throws {
//
//    }
}
