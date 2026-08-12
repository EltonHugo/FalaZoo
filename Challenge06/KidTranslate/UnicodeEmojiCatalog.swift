import Foundation

struct UnicodeEmojiCatalog {
    // Mapeamento [Nome Oficial : Emoji] indexado uma única vez
    private static let map: [String: String] = {
        var catalog: [String: String] = [:]
        
        // Bloco onde se concentram os emojis na tabela Unicode
        let emojiRanges: [ClosedRange<UInt32>] = [
            0x1F300...0x1FAFF
        ]
        
        for range in emojiRanges {
            for codePoint in range {
                if let scalar = Unicode.Scalar(codePoint),
                   scalar.properties.isEmoji,
                   let name = scalar.properties.name {
                    catalog[name.uppercased()] = String(scalar)
                }
            }
        }
        return catalog
    }()
    
    /// Busca o emoji pelo nome em inglês (ex: "DOG FACE", "SLOTH", "LION")
    static func emoji(named name: String) -> String? {
        return map[name.uppercased()]
    }
}
