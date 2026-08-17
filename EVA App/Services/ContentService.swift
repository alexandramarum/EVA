//
//  ContentService.swift
//  EVA App
//
//  Created by Alexandra Marum on 8/9/26.
//

import Foundation

enum EVAContentServiceError: Error, LocalizedError {
    case fileNotFound(String)
    case loadFailed(Error)
    case decodeFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "Could not find \(name) in the app bundle."
        case .loadFailed(let error):
            return "Could not read the content file: \(error.localizedDescription)"
        case .decodeFailed(let error):
            return "Could not decode the content file: \(error.localizedDescription)"
        }
    }
}

struct EVAContentService {
    private let resourceName: String
    private let bundle: Bundle

    init(resourceName: String = "EVAContent", bundle: Bundle = .main) {
        self.resourceName = resourceName
        self.bundle = bundle
    }
    
    func loadContent() throws -> EVAContentLibrary {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw EVAContentServiceError.fileNotFound("\(resourceName).json")
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw EVAContentServiceError.loadFailed(error)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(EVAContentLibrary.self, from: data)
        } catch {
            throw EVAContentServiceError.decodeFailed(error)
        }
    }

    func loadContentAsync() async throws -> EVAContentLibrary {
        try await Task.detached(priority: .userInitiated) {
            try loadContent()
        }.value
    }
}
