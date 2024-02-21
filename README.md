# What is Duo?
![Legend](Images/Legend.png)
Duo is a multiseat suite based around [RdpWrap](https://github.com/sebaxakerhtc/rdpwrap), [Sunshine](https://github.com/DuoStream/Sunshine), [Moonlight](https://github.com/moonlight-stream), and several driver & library patches.  
  
Its main purpose is to streamline and improve self-hosted cloud computer setups by providing each user with their own independent session.  
  
Each session's resolution, refresh rate, scaling and dynamic range are controlled directly via [Moonlight](https://github.com/moonlight-stream).

# What is multiseating?
Multiseating is like having multiple people sit at one computer at the same time, each with their own keyboard, mouse, gamepad and monitor.  
  
Every single user can use the computer as if they were the sole user of it, without interfering with each other.  
  
It's like sharing a car but with each person having their own steering wheel and pedals.

# Is Duo available for free?
Patreon supporters enjoy exclusive benefits, including access to additional sessions, an increased maximum refresh rate, and HDR support.  
  
All remaining features are accessible to all users.

# What are the minimum requirements?
Any computer capable of running Windows 10 21H2 or newer should be compatible.  
  
If you wish to make use of Duo's HDR support, you'll need Windows 11 23H2 or newer.  
  
The overall system requirements will rise or fall with the number of concurrent users though.

## Additional requirements for gamepad support
Gamepad support is facilitated through [ViGEmBus](https://github.com/nefarius/ViGEmBus/releases/latest), which must be installed prior to Duo to ensure proper gamepad functionality.  
  
Versions prior to 1.2.1 also required [HidHide](https://github.com/nefarius/HidHide/releases/latest), but that is no longer the case.  
  
Should you still have HidHide installed, uninstall it, or at the very least wipe its filter table before upgrading to a newer Duo version.

# My Antivirus software claims to have found a virus, what's going on?
Duo performs several actions that Windows typically discourages.  
Consequently, many antivirus programs may quickly raise concerns.  
  
Here's a list of activities undertaken by Duo that might trigger suspicion from your antivirus software:
- It adds selected local user accounts to the "Remote Desktop Users" group so they can be used as headless session logon accounts
- It patches termsrv.dll (in RAM) to enable the possibility of running multiple concurrent active sessions
- It patches IddCx.dll & RdpIdd.dll (in RAM) to enable the possibility of capturing uncompressed SwapChain frames
- It initiates headless localhost RDP sessions to prompt termsrv.dll to create a new session

# Tips & Tricks

## Getting HDR running on the new Steam Deck OLED
**Note: HDR and custom refresh rate support are Patreon supporter benefits and are not available in the free version of Duo.**

**OS Requirements: Windows 11 23H2+ is required to make use of Duo's HDR support.**

1. Install the latest [Moonlight nightly build](https://github.com/FrogTheFrog/com.moonlight_stream.Moonlight) on your Steam Deck OLED.
2. Add Moonlight as a non-Steam game on your Steam Deck OLED.
3. **Optional:** Install [Decky](https://github.com/SteamDeckHomebrew/decky-loader) and the [Reshadeck](https://github.com/safijari/Reshadeck) plugin on your Steam Deck OLED.
4. **Optional:** Save this [corrective shader](https://github.com/DuoStream/Duo/raw/main/Files/SteamOS/ImageAdjustment.fx) into your Deck's **~/.local/share/gamescope/reshade/Shaders** folder and enable it in Reshadeck to fix the Steam Deck OLED's known [black level issue](https://github.com/moonlight-stream/moonlight-qt/issues/1117).
5. Create a new instance in Duo Manager with a minimum luminance of 0 nits, a full-frame maximum luminance of 1000 nits, and a maximum luminance of 1000 nits, then restart Duo.
6. Start Moonlight on your Steam Deck OLED in game mode, enable HDR in the settings, and pair it to your Duo instance by entering the pairing PIN via its Sunshine web admin panel.

# Known issues and workarounds

## Windows 10 host instances won't auto-adjust their display configuration
This is a known IddCx remote driver limitation on Windows 10.  
  
You can either upgrade to Windows 11 23H2+, which doesn't have this issue, or connect to your instance via Moonlight, and **Sign Out** of your user profile via the instance's Windows start menu.  
  
Doing so will restart the IddCx remote driver, which, in turn, will reset the instance's display configuration to match that of the last connected Moonlight client.

## HDR support requires a one-time post-install host system reboot to start functioning
Duo incorporates HDR functionality through Microsoft's new IddCx 1.10 interface, which gets enabled as part of Duo's installation process.  
  
However, the Windows feature API necessitates several minutes and a subsequent system reboot to seamlessly transition from the older IddCx 1.9 to the newer IddCx 1.10 interface.  
  
Until this transition is completed, all instances with HDR capability will revert to SDR, using the older IddCx 1.9 interface, to maintain functionality.

## Occasional HDR stream decoding issues on Steam Deck OLED
Moonlight sometimes has issues decoding HDR-enabled streams on the Steam Deck OLED, which will result in a black screen.  
  
Should you run into this issue, reboot your Steam Deck OLED, and everything should be back in working order once again.

## Microsoft accounts not working right
Microsoft accounts appear as local accounts to most Windows operating system components but fail to authenticate via Network Level Authentication.  
  
This poses a problem as that is the authentication method Duo uses to spawn additional sessions.  
  
As such it's recommended to create one, or more, dedicated local user accounts for use with Duo.  
  
The easiest way to do so is to open an administrative cmd.exe command line and execute the following two commands (with slight adjustments to fit your wanted username and password):

```
net user "<username>" "<password>" /add /passwordchg:no
net localgroup administrators "<username>" /add
```

## Windows Updates breaking RdpWrap (and thus Duo)
The termsrv.dll patches are provided by [RdpWrap](https://github.com/sebaxakerhtc/rdpwrap) and might need to be manually updated after Microsoft drops a termsrv.dll update.  
  
This can be done by executing **C:\\Program Files\\RDP Wrapper\\RDP\_CnC.exe** and clicking on "Update INI".  

## Certain DirectX applications may struggle to obtain exclusive full-screen contexts
This can result in a switch to windowed mode or fully render an application broken in Duo instances.  
  
I am actively investigating this issue.  
  
In the meantime, one can address this issue by either selecting borderless windowed mode (if available) or forcing the application to run in Vulkan through [DXVK](https://github.com/doitsujin/dxvk).

## Running global-exclusive applications
While each user is provided their own dedicated session, it's important to acknowledge that ultimately, you are operating on a single computer, which comes with both its benefits and drawbacks.  
  
You'll be sharing common resources such as processing capacity, the registry, storage space, and more.  
This can pose a problem with system-global-exclusive processes, that claim to not support running multiple instances on a single computer.  
  
To address this limitation, it is highly recommended to employ [Sandboxie-Plus](https://github.com/sandboxie-plus/Sandboxie/releases/latest).  
This tool allows you to isolate and sandbox problematic processes into their individual segregated environments, making them believe they got the computer all to themselves.  
  
This, in turn, enables you to initiate multiple instances of such applications, effectively circumventing these artificial restrictions.

# Downloads
- [Free version](https://github.com/DuoStream/Duo/raw/main/Duo.exe)
- [Full version](https://www.patreon.com/posts/duo-1-pc-users-89568993)
