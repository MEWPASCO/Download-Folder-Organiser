# Download-Folder-Organiser
A lightweight, automated PowerShell script that dynamically monitors your Windows `Downloads` folder using a `FileSystemWatcher` and automatically organizes incoming files into dedicated subdirectories based on extension types.

> [!IMPORTANT]
> This script is inspired by this creator @ctrlaltalex on Insta but highly modified to my liking
> | https://www.instagram.com/p/DXZJ64mjCxZ/

## Mapping

The script evaluates and routes files into the following directory tree:

| Folder | Monitored Extensions |
| --- | --- |
| **`Images`** | `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`, `.avif`, `.svg`, `.ico`, `.pdn`, `.bmp`, `.tiff`, `.psd`, `.ai` |
| **`Videos`** | `.mp4`, `.mkv`, `.mov`, `.avi`, `.webm`, `.flv`, `.wmv` |
| **`Documents`** | `.pdf`, `.docx`, `.xlsx`, `.txt`, `.yaml`, `.html`, `.yml`, `.pptx`, `.csv`, `.md`, `.pdfx` |
| **`Audio`** | `.mp3`, `.wav`, `.flac`, `.aac`, `.ogg`, `.m4a`, `.wma` |
| **`Installers`** | `.exe`, `.msi`, `.zip`, `.rar`, `.7z`, `.bat`, `.msix`, `.iso`, `.tar`, `.gz`, `.tgz`, `.vhd`, `.vhdx` |
| **`3D Print Downloads`** | `.stl`, `.3mf`, `.obj`, `.step`, `.gcode`, `.amf`, `.f3d`, `.stp` |
| **`Web and Coding`** | `.json`, `.jsonc`, `.xml`, `.css`, `.scss`, `.js`, `.ts`, `.html`, `.php`, `.py`, `.cs`, `.unitypackage`, `.tf`, `.tfvars` |
| **`Gaming and Mods`** | `.dll`, `.apk`, `.xapk`, `.patched`, `.bin`, `.dat`, `.pak`, `.reg`, `.cfg`, `.config`, `.ini`, `.log`, `.unity3d`, `.assets`, `.bundle`, `.wad`, `.jar` |
| **`Fonts`** | `.ttf`, `.otf`, `.woff`, `.woff2` |


<img width="895" height="462" alt="image" src="https://github.com/user-attachments/assets/c4edaa4e-2523-4bd2-af48-4be8d48645ce" /> <img width="709" height="381" alt="image" src="https://github.com/user-attachments/assets/2e5044b7-505f-42e4-9a39-883adf4ba87c" />

## Setup & Automation

### 1. File Placement

Save the core script as `organise.ps1` in a permanent location on your drive (e.g., `C:\Users\YOUR_USERNAME\Desktop\organise.ps1`).

### 2. Automating with Task Scheduler

To make the script launch silently on startup without flashing console windows or taskbar items, deploy it via Windows **Task Scheduler**:

1. Open **Task Scheduler** and click **Create Basic Task**.
<img width="696" height="488" alt="image" src="https://github.com/user-attachments/assets/91f34c42-4ebf-407f-b007-621b16deb9e3" />

2. Set the **Trigger** to `When I log on`.
<img width="696" height="488" alt="image" src="https://github.com/user-attachments/assets/11856507-54bf-451e-8669-388e38c31b10" />

3. Set the **Action** to `Start a program`.
<img width="696" height="488" alt="image" src="https://github.com/user-attachments/assets/f1f1934c-b391-4d78-b71e-0dd6566a4131" />

4. In the **Program/script** field, type:
```text
powershell.exe
```
 In the **Add arguments (optional)** field, paste the execution parameters (make sure to update your actual system username path):
```text
-WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\YOUR_USERNAME\Desktop\organise.ps1"

```
<img width="696" height="488" alt="image" src="https://github.com/user-attachments/assets/b47978b9-1df2-49f7-90cf-96e283de205b" />

## Optional: Disable Taskbar Icon Flashing

When Task Scheduler launches background processes, Windows 11 may occasionally flash or blink the taskbar icon for a split second to notify you that a new process spawned. You can disable this flashing via the Windows Registry.

> [!WARNING] 
This is a system-wide registry change. Disabling this will stop **all** applications from flashing their taskbar icons. This means you will no longer get visual flashing alerts when apps (like Discord, Steam, or your browser) are flashing in the background to get your attention.

### How to apply the tweak:

1. Press `Win + R`, type `regedit`, and hit **Enter**.
2. Navigate to the following path in the registry address bar:
   ```text
   HKEY_CURRENT_USER\Control Panel\Desktop
   ```

3. Look for a DWORD value named **`ForegroundFlashCount`** on the right side.
* *If it exists:* Double-click it.
* *If it doesn't exist:* Right-click empty space ➡️ **New** ➡️ **DWORD (32-bit) Value** and name it `ForegroundFlashCount`.
4. Change the **Value Data** to `0` (this turns off the blinking animation completely).
5. **Restart your PC** to apply the changes.

## Modifying the Script

Want to track more file extensions? Simply open `organise.ps1` and add your required extensions in lowercase format to the `$global:FileMap` hashtable:

```powershell
"Your New Folder Name" = @(".ext1", ".ext2")

```
<img width="1282" height="721" alt="image" src="https://github.com/user-attachments/assets/8894098b-5714-4407-9601-b665197aae46" />

---

# Contact me through Discord

[![Discord](https://img.shields.io/discord/1196075698301968455?style=social&logo=discord&label=ΛVΛRIΛ)](https://discord.gg/avia)
