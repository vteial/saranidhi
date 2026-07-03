import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(
    _ sender: NSApplication
  ) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    // Register CloudKit plugin for iCloud sync
    if let controller = mainFlutterWindow?.contentViewController
        as? FlutterViewController {
      let registrar = controller.registrar(forPlugin: "CloudKitPlugin")
      CloudKitPluginMacOS.register(with: registrar)
    }

    super.applicationDidFinishLaunching(notification)
  }
}
