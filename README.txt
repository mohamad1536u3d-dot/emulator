Native runtime boundary

The Godot app is the UI/orchestrator.
The native runtime boundary is:

Godot UI
  -> game path
  -> Wine prefix
  -> Box64/Box86
  -> Wine executable
  -> Windows game

Do not bundle random prebuilt native binaries. Build and package versions
whose licenses and Android ABI match the application.
