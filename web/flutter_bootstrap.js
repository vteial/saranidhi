{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    // Use CanvasKit renderer with color emoji support
    canvasKitVariant: "chromium",
  },
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({
      useColorEmoji: true,
    });
    await appRunner.runApp();
  },
});
