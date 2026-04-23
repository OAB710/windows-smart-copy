# Smart Copy

A lightweight Windows batch script that automates three repetitive tasks in one run:

1. Copy a source folder into a fresh build folder
2. Exclude selected files and folders
3. Create a ZIP archive from the copied output

This is useful when you frequently need to package a folder for delivery, backup, testing, or deployment without repeating manual copy-and-zip steps.

## Features

- Fast folder copy using `robocopy`
- Supports ignored files and folders by full path
- Rebuilds the destination folder from scratch every run
- Creates a ZIP archive automatically with PowerShell
- Easy to customize through simple variables at the top of the script

## Requirements

- Windows
- `robocopy` (built into modern Windows)
- PowerShell with `Compress-Archive`

## Usage

Open `smart-copy.bat` and update the configuration section:

```bat
set "SRC=<SOURCE_FOLDER>" & set "DST=<BUILD_FOLDER>" & set "ZIP=<ZIP_FILE_PATH>"
set "IGNORE_PATHS=<FULL_PATH>|<FULL_PATH>"
```

### Example

```bat
set "SRC=D:\Project"
set "DST=D:\Project_build"
set "ZIP=D:\Project_build.zip"
set "IGNORE_PATHS=D:\Project\.git|D:\Project\node_modules|D:\Project\temp.txt"
```

Then run:

```bat
smart-copy.bat
```

## How it works

The script performs the following steps:

- Validates that the source folder exists
- Deletes the previous build folder if present
- Recreates the build folder
- Converts ignored full paths into `robocopy` exclude arguments
- Copies the source into the build folder
- Compresses the build folder into a ZIP file

## Notes

- Ignored paths must be full paths
- Folder paths are passed to `robocopy /XD`
- File paths are passed to `robocopy /XF`
- The ZIP file is overwritten on each run if it already exists

## Suggested use cases

- Preparing release packages
- Creating clean handoff builds
- Excluding temporary files before sharing
- Rebuilding test bundles quickly after source changes

## Limitations

- Configuration is currently edited directly in the script
- Ignore rules are path-based, not pattern-based
- Intended for Windows environments only

## Roadmap

Possible future improvements:

- Read config from a separate `.ini` or `.txt` file
- Support wildcard ignore patterns
- Add logging to a file
- Add drag-and-drop usage
- Add safer validation for empty paths

## License

MIT License
