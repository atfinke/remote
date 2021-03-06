# Hello!

When my plans for traveling and adventures after graduation were put on indefinite hold, I found myself with a bunch of extra time for [projects at home](https://github.com/atfinke/Stay-at-Home-Thoughts). One of those projects was the device you have in front of you now, RD.

RD is a tiny single button Bluetooth remote that can trigger actions based on the app you are using on your Mac.

# Setup

1. [Handling RD](#Handling-RD)
2. [Powering RD](#Powering-RD)
3. [Connecting to RD](#Connecting-to-RD)

## Handling RD
Hopefully you  made it this far without accidentally throwing your RD out a window. The top enclosure is only secured to the base by friction, which makes the device easier to disassemble. This also means I do not recommend holding the device upside down. On the base of the device is its serial number, a two character string.

## Powering RD
While this is a Bluetooth device, it uses Micro-USB for power because I did not feel comfortable shipping lithium-ion packs across the country. If you feel skilled with a soldering iron and want to add a permanent battery to your device, the circuit board does feature a battery input pin.

To turn RD on, grab a Micro-USB cable and plug it into a spare USB brick. While I recommend the USB brick approach, you can also directly connect RD to your Mac via cable. Powering RD from your Mac will cause it to appear as a flash drive in Finder. When prompted to set up RD as a keyboard, just close the window.

A few seconds after connecting RD to power, it should turn blue, indicating that it is ready to connect to your Mac. Note that if you put your Mac to sleep, while the RD light will turn off, RD itself is still on. When you use your Mac again, it will automatically reconnect. You should never need to unplug or reboot RD.

## Connecting to RD
Grab your Mac, we are almost done. First, download (or compile for yourself) the RX Preferences app and the RXd app from the releases section in the RX repo [here](https://github.com/atfinke/RX/releases).

Then, after turning RD on, open the RX Preferences app, and it should automatically find your device nearby.

Now you can start configuring the device for each of your apps! Press the + button to select an app. Whenever your Mac's frontmost app is the one you select, RD will configure itself based on the preferences you set next. You can click the color well circles to specify the color of the light in the specified state. Next, the fun part, click the “Select Action” button and select an *AppleScript* .scpt file to run when you press RD. Woah, AppleScript…

Yeah, AppleScript! AppleScript is perfect for this use case for a number of reasons. Here are just a few: 

- First, AppleScript can perform powerful system actions, like programmatic [key input events](https://apple.stackexchange.com/questions/36943/how-do-i-automate-a-key-press-in-applescript). 

- Secondly, AppleScript is one of the easiest ways to script apps interactions. Many apps provide native bridges to AppleScript and there are tons of resources available online to learn more. Additionally, in `Script Editor.app`, navigating to `File->Open Dictionary` will show you the available AppleScript dictionaries for the apps installed on your Mac. 

- Finally, running shell scripts from AppleScript is easy with [‘do shell script’](https://developer.apple.com/library/archive/technotes/tn2065/_index.html). This means that if AppleScript is not your thing, you can write your actions in Python, Swift, almost anything you can run from the command line! I generally write my actions entirely in AppleScript or by calling out to a Python script. 

You can see some sample workflows in the RX repo example actions folder [here](https://github.com/atfinke/RX/tree/main/Shared/Actions). If you are looking for a quick hello world alert script to test out your RD, I recommend the one in the RX repo [here](https://github.com/atfinke/RX/blob/main/Shared/Actions/System/Hello%20World.scpt).

The last piece of the puzzle is the RXd app, which is essentially a wannabe demon process (the RXd app has no interface and will not appear in your dock). Its function is to act as the bridge between your Mac and RD. 

After setting up your device in the RX Preferences app for the first time, launch RXd. RXd should automatically connect to RD and if you enable its notifications, will alert you once connected. I recommend adding the RXd app as a login item (System Preferences -> Users & Groups), which means the app will start whenever you log in. The RXd app is always up to date with changes you make in the RX Preferences app.

Congrats! You are all set up and ready to go! Feel free to stop reading here if you are not interested in learning more about how the device is made or ways to further customize the hardware.

# How It’s Made

RD started as a project to use up all the extra parts I had from my previous project, R1, but I decided to expand the scope a bit after some folks responded well to the first few prototypes. Planning for the first and only batch of 32 RDs started in early August 2020 and assembly was finished by mid September.

To create the CAD files, I used [Autodesk Inventor](https://www.autodesk.com/products/inventor/). You can find all the CAD files (+ most of the iterations) in the RX repo [here](https://github.com/atfinke/RX/tree/main/RD/cad).

The top of the enclosure is [6061-T6 aluminum](https://en.wikipedia.org/wiki/6061_aluminium_alloy#6061-T6) with a bead blast finish and was manufactured by [Shenzhen Kingsun Enterprises Co., Ltd.](https://www.kingsun1.com) (via [Xometry](https://www.xometry.com)).

The bottom is PLA plastic, 3D printed with a [Creality Ender 5](https://www.creality.com/goods-detail/ender-5-3d-printer) using [Cura](https://ultimaker.com/software/ultimaker-cura) to convert the CAD files into g-code instructions. The serial number font is SF Pro Rounded. Each takes about three hours to print with a 10% fill density.

Inside RD is an [ItsyBitsy nRF52840 board](https://www.adafruit.com/product/4481), which is a development board with the [nRF52840](https://www.nordicsemi.com/Products/Low-power-short-range-wireless/nRF52840) chip. This chip is powerful enough to run a fork of python called [CircuitPython](https://circuitpython.org) (it can also be modified to work with the [Arduino IDE](https://www.arduino.cc/en/main/software)). If you connect RD to your Mac via a USB cable, it will appear as a flash drive. On boot, it runs the code in `main.py`. It’s your chip now, so feel free to customize it anyway you like! `hardware_config.py` is unique to your device, so I recommend creating a copy of that before doing anything too crazy. The rest of the files can be restored from the microcontroller directory in the RX repo [here](https://github.com/atfinke/RX/tree/main/Shared/Microcontroller). 

The actual button is a custom sku manufactured by [Lanboo](https://www.lanbooswitch.com), which I first used for R1. You can read a bit about my multi-month long international button search [here](https://github.com/atfinke/Stay-at-Home-Thoughts#may). The button is a high head (the top sticks out) momentary (it doesn’t lock in place when pressed) 22mm diameter button with a built in resistor. There is also a red, green, and blue led inside. To show a color like white, all three leds illuminate at the same time. This is why some colors may have non-uniform illumination. 

Final assembly took about an hour per RD. I used a 30W soldering iron with [60/40 lead rosin-core solder](https://www.adafruit.com/product/145) for the internal connections, which I then tested using a [model 9205B multimeter](https://www.digikey.com/product-detail/en/adafruit-industries-llc/2034/1528-2034AD-ND/12084169). Finally, I configured the bootloader, uploaded the software, and ran a debug mode for a last check.

On the Mac side, the RXd app uses public [Foundation APIs](https://developer.apple.com/documentation/appkit/nsworkspace/1535049-didactivateapplicationnotificati) to detect active app changes and Core Bluetooth to communicate with RD. To trigger your actions, RXd launches [osascript](https://ss64.com/osx/osascript.html) via an [NSTask](https://developer.apple.com/documentation/foundation/nstask), passing the url to a cached copy of your selected script. You can click the script name in the RX Preferences app to show its location in Finder.

—

That’s about it! Hope you enjoy and let me know if you run into any issues.
<br><br><img src="https://github.com/atfinke/RX/blob/main/RD/images/Siri%20guarding%20the%20buttons.jpeg?raw=true" width="500"/><br><b>My mom's puppy, "Siri", protecting the completed RDs<b>
