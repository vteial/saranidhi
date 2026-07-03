import Flutter
import CloudKit

/// Flutter MethodChannel plugin for CloudKit operations.
///
/// Handles save, fetch, and delete operations against the user's
/// private CloudKit database in the `iCloud.com.vteial.saranidhi` container.
class CloudKitPlugin {
    private let container: CKContainer
    private let database: CKDatabase

    init() {
        container = CKContainer(
            identifier: "iCloud.com.vteial.saranidhi"
        )
        database = container.privateCloudDatabase
    }

    /// Register this plugin with the Flutter engine.
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.vteial.saranidhi/cloudkit",
            binaryMessenger: registrar.messenger()
        )
        let instance = CloudKitPlugin()
        channel.setMethodCallHandler(instance.handle)
    }

    /// Handle incoming method calls from Dart.
    func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case "getAccountStatus":
            getAccountStatus(result: result)
        case "saveRecord":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(
                    code: "INVALID_ARGS",
                    message: "Missing arguments",
                    details: nil
                ))
                return
            }
            saveRecord(args: args, result: result)
        case "fetchRecordsByType":
            guard let args = call.arguments as? [String: Any],
                  let recordType = args["recordType"] as? String
            else {
                result(FlutterError(
                    code: "INVALID_ARGS",
                    message: "Missing recordType",
                    details: nil
                ))
                return
            }
            fetchRecordsByType(
                recordType: recordType,
                result: result
            )
        case "deleteRecord":
            guard let args = call.arguments as? [String: Any],
                  let recordName = args["recordName"] as? String
            else {
                result(FlutterError(
                    code: "INVALID_ARGS",
                    message: "Missing recordName",
                    details: nil
                ))
                return
            }
            deleteRecord(recordName: recordName, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }


    // MARK: - Account Status

    private func getAccountStatus(result: @escaping FlutterResult) {
        container.accountStatus { status, error in
            DispatchQueue.main.async {
                if let error = error {
                    result(FlutterError(
                        code: "ACCOUNT_ERROR",
                        message: error.localizedDescription,
                        details: nil
                    ))
                    return
                }
                result(status == .available)
            }
        }
    }

    // MARK: - Save Record

    private func saveRecord(
        args: [String: Any],
        result: @escaping FlutterResult
    ) {
        guard let recordType = args["recordType"] as? String,
              let recordName = args["recordName"] as? String,
              let fields = args["fields"] as? [String: Any]
        else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "Missing recordType, recordName, or fields",
                details: nil
            ))
            return
        }

        let recordID = CKRecord.ID(recordName: recordName)
        let record = CKRecord(
            recordType: recordType,
            recordID: recordID
        )

        // Set all fields on the record
        for (key, value) in fields {
            if let stringValue = value as? String {
                record[key] = stringValue as CKRecordValue
            } else if let intValue = value as? Int {
                record[key] = intValue as CKRecordValue
            } else if let doubleValue = value as? Double {
                record[key] = doubleValue as CKRecordValue
            }
        }

        // Use save with policy to handle updates
        let operation = CKModifyRecordsOperation(
            recordsToSave: [record],
            recordIDsToDelete: nil
        )
        operation.savePolicy = .changedKeys
        operation.modifyRecordsResultBlock = { operationResult in
            DispatchQueue.main.async {
                switch operationResult {
                case .success:
                    result(true)
                case .failure(let error):
                    result(FlutterError(
                        code: "SAVE_ERROR",
                        message: error.localizedDescription,
                        details: nil
                    ))
                }
            }
        }

        database.add(operation)
    }


    // MARK: - Fetch Records by Type

    private func fetchRecordsByType(
        recordType: String,
        result: @escaping FlutterResult
    ) {
        let query = CKQuery(
            recordType: recordType,
            predicate: NSPredicate(value: true)
        )
        query.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        var allRecords: [[String: Any]] = []

        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { recordID, recordResult in
            switch recordResult {
            case .success(let record):
                var recordDict: [String: Any] = [
                    "recordName": record.recordID.recordName
                ]
                var fieldsDict: [String: Any] = [:]
                for key in record.allKeys() {
                    if let value = record[key] {
                        if let str = value as? String {
                            fieldsDict[key] = str
                        } else if let num = value as? NSNumber {
                            // Determine if it's an int or double
                            if CFNumberIsFloatType(num) {
                                fieldsDict[key] = num.doubleValue
                            } else {
                                fieldsDict[key] = num.intValue
                            }
                        }
                    }
                }
                recordDict["fields"] = fieldsDict
                allRecords.append(recordDict)
            case .failure(let error):
                print("[CloudKit] Record match error: \(error)")
            }
        }

        operation.queryResultBlock = { operationResult in
            DispatchQueue.main.async {
                switch operationResult {
                case .success:
                    result(allRecords)
                case .failure(let error):
                    result(FlutterError(
                        code: "FETCH_ERROR",
                        message: error.localizedDescription,
                        details: nil
                    ))
                }
            }
        }

        database.add(operation)
    }

    // MARK: - Delete Record

    private func deleteRecord(
        recordName: String,
        result: @escaping FlutterResult
    ) {
        let recordID = CKRecord.ID(recordName: recordName)

        database.delete(withRecordID: recordID) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    result(FlutterError(
                        code: "DELETE_ERROR",
                        message: error.localizedDescription,
                        details: nil
                    ))
                    return
                }
                result(true)
            }
        }
    }
}
