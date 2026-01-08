import Foundation

/// 表示一次 Git 提交记录
public struct GitCommit: Identifiable, Equatable {
    /// 提交哈希（唯一标识）
    public let id: String
    /// 提交哈希
    public let hash: String
    /// 作者名称
    public let author: String
    /// 作者邮箱
    public let email: String
    /// 提交日期
    public let date: Date
    /// 提交信息
    public let message: String
    /// 关联的引用（如分支、tag 等）
    public let refs: [String]
    /// 关联的标签名
    public let tags: [String]

    /// 初始化提交记录
    public init(id: String, hash: String, author: String, email: String, date: Date, message: String, refs: [String] = [], tags: [String] = []) {
        self.id = id
        self.hash = hash
        self.author = author
        self.email = email
        self.date = date
        self.message = message
        self.refs = refs
        self.tags = tags
    }
}

/// 表示带标签的提交
public struct CommitWithTag {
    public let hash: String
    public let message: String
    public let tags: [String]

    /// 初始化带标签的提交
    public init(hash: String, message: String, tags: [String]) {
        self.hash = hash
        self.message = message
        self.tags = tags
    }
}


/// 提交详细信息
public struct GitCommitDetail {
    public let id: String
    public let author: String
    public let email: String
    public let date: Date
    public let message: String
    public let body: String
    public let files: [GitDiffFile]
    public let diff: String

    /// 初始化提交详细信息
    public init(id: String, author: String, email: String, date: Date, message: String, body: String, files: [GitDiffFile], diff: String) {
        self.id = id
        self.author = author
        self.email = email
        self.date = date
        self.message = message
        self.body = body
        self.files = files
        self.diff = diff
    }
}