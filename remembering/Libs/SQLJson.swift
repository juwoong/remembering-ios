//
//  SQLJson.swift
//  remembering
//
//  Created by 배주웅 on 1/26/25.
//
import Foundation

func jsonEncode<T: Encodable>(_ value: T) throws -> String {
    let encoder = JSONEncoder()
    let data = try encoder.encode(value)
    guard let jsonString = String(data: data, encoding: .utf8) else {
        throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Failed to convert JSON data to string"))
    }
    return jsonString
}

func jsonDecode<T: Decodable>(_ jsonString: String, to type: T.Type) throws -> T {
    let decoder = JSONDecoder()
    guard let data = jsonString.data(using: .utf8) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid UTF-8 string"))
    }
    return try decoder.decode(T.self, from: data)
}
