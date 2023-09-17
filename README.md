# What is Duo?
![Legend](Images/Legend.png)
Duo is a multiseat suite based around [RdpWrap](https://github.com/sebaxakerhtc/rdpwrap), [Sunshine](https://github.com/DuoStream/Sunshine), [Moonlight](https://github.com/moonlight-stream), and several driver & library patches.  
  
Its main purpose is to streamline and improve self-hosted cloud computer setups by providing each user with their own independent session.

## What is multiseating?
Multiseating is like having multiple people sit at one computer at the same time, each with their own keyboard, mouse, gamepad and monitor.  
  
Every single user can use the computer as if they were the sole user of it, without interfering with each other.  
  
It's like sharing a car but with each person having their own steering wheel and pedals.

## Is Duo available for free?
Patreon supporters enjoy exclusive benefits, including access to additional sessions and the ability to control refresh rates.  
  
All remaining features are accessible to all users.

## What are the minimum requirements?
Any computer capable of running Windows 11 22H2 or newer should be compatible.  
  
The overall system requirements will rise or fall with the number of concurrent users though.

## My Antivirus software claims to have found a virus, what's going on?
Duo performs several actions that Windows typically discourages.  
Consequently, many antivirus programs may quickly raise concerns.  
  
Here's a list of activities undertaken by Duo that might trigger suspicion from your antivirus software:
- It adds selected local user accounts to the "Remote Desktop Users" group so they can be used as headless session logon accounts
- It patches termsrv.dll (in RAM) to enable the possibility of running multiple concurrent active sessions
- It patches RdpIdd.dll (in RAM) to enable the possibility of capturing uncompressed SwapChain frames
- It modifies xinput*.dll (on Disk) to segregate gamepad input for each session, preventing interference between them
- It initiates headless localhost RDP sessions to prompt termsrv.dll to create a new session

## Known issues and workarounds

### Global-exclusive applications
While each user is provided their own dedicated session, it's important to acknowledge that ultimately, you are operating on a single computer, which comes with both its benefits and drawbacks.  
  
You'll be sharing common resources such as processing capacity, the registry, storage space, and more.  
This can pose a problem with system-global-exclusive processes, like Steam, that claim to not support running multiple instances on a single computer.  
  
To address this limitation, it is highly recommended to employ [Sandboxie-Plus](https://github.com/sandboxie-plus/Sandboxie/releases/latest).  
This tool allows you to isolate and sandbox problematic processes, like Steam, into their individual segregated environments, making them believe they got the computer all to themselves.  
  
This, in turn, enables you to initiate multiple instances of such applications, effectively circumventing these artificial restrictions.

### Experimental gamepad segregation support
While Windows provides internal mechanisms for session-specific mouse & keyboard segregation, there is no such feature for other HID devices like gamepads.  
  
To work around this limitation, a proof of concept userspace wrapper was developed that creates a virtual set of 4 session-specific Xinput devices.  
  
This wrapper is experimental, doesn't support DirectInput or RawInput (yet), and will trigger newer EAC implementations.  
  
For games that don't support Xinput natively, this wrapper can be supplemented with additional wrappers like [Xidi](https://github.com/samuelgr/Xidi/releases), or Steam's built-in Steam Input.  
  
Just keep in mind that you'll have to re-start Steam after enabling Steam Input for Xinput.  
  
Should you have no need for gamepad segregation at all (which is the case if you can guarantee that there will never be more than one gamepad-compatible game running at a time), feel free to disable this feature via the Duo Manager.

## Downloads
- [Free version](https://github.com/DuoStream/Duo/raw/main/Duo.exe)
- [Full version](https://patreon.com/blackseraph)
