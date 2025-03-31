//
//  Manga.swift
//  MangaVerse
//
//  Created by Бабаханова Шаира on 28.03.2025.
//

import Foundation
struct Manga: Identifiable, Codable {
    let id: String
    let title: String
    var coverURL: URL?
    var localPath: String?
    var isDownloaded: Bool
}
