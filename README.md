# WInstaller - Installation Guide

## Disclaimer
Full credits to the author of the original idea [goku6464646](https://github.com/goku6464646).
Please be aware that you assume full responsibility for all risks associated with this installation.

## Introduction
This guide provides step-by-step instructions for installing Windows in almost any VPS. 

- Tested VPS:
    - Contabo
    - Heltzner

- Tested Resuce OS:
    - Debian Rescue

- Tested Windows versions:
    - 10 LTSC
    - 10 Server 2019

## Prerequisites

- A VPS with VNC and linux rescue system

### 1. Prepare the VPS

- Switch the VPS into rescue mode and connect (via SSH). This guide is tested in Debian Rescue, but any linux based OS should work.

- Execute the following commands:
    - `screen -S sesion` (optional, but useful if you get disconnected from the server in the middle of the installation)
    - `apt install git -y`
    - `git clone https://github.com/supermegazinc/WinstallerVPS.git`
    - `cd WinstallerVPS`
    - `chmod +x script.sh`

- Customize installation: (optional)
    - Download custom ISO: `nano script.sh` and modify the "iso_os_url"

- Perform installation:
    - `./script.sh` (if you want to specify a custom disk "./script.sh $disk". default disk: /dev/sda)
    - The process takes approximately 15 minutes and completes when the ssh session disconnects due to the machine rebooting. If the script fail, try running it again at least two times.

### 2. Connnect to the VPS via VNC to install Windows
- Upon connecting, you will see a screen as shown in the image. Press Enter.

  ![text](https://i.ibb.co/j8Ckb0x/windows-installer.png)

- Follow the on-screen prompts to install Windows.
- Install the virtIO drivers as shown in the following images.
- Click on "Browse"
  
  ![text](https://i.ibb.co/x2S5brz/browser.png)

- From Boot select `virtio_drivers`
  
  ![text](https://i.ibb.co/MghHSxm/virtio.png)

- Select `amd64\w10` and click on "Ok"
  
  ![text](https://i.ibb.co/jTmb57J/w10.png)

- Click on "Next"
  
  ![text](https://i.ibb.co/LS3sq47/next.png)

- Click on "Custom: Install Windows Only (advanced)"

  ![text](https://i.ibb.co/X7swb6C/custom-install.png)

- For the installation, select the partition `Drive 0 Partition 1`
  
  ![text](https://i.ibb.co/mSq9KjR/select-partition.png)

- Choose the operating system and then click on "Next"
  
  ![text](https://i.ibb.co/2FF8W7b/os-select.png)

### 3. Install the Ethernet adapter for internet connection

- Open the `Device Manager`

  ![text](https://i.ibb.co/PxGQ9Rz/device-manager.png)

- Right-click on `Ethernet Controller` and select `Update Driver`
  
  ![text](https://i.ibb.co/Ycjf3b4/update-driver.png)

- Choose `Browse my computer for drivers`
  
  ![text](https://i.ibb.co/X7vht8v/browse-computer-drivers.png)

- Click on `Browse` and select the path `C:\sources\virtio`, and click "Next"
  
  ![text](https://i.ibb.co/7WJXyxW/driver-path.png)

- Click on `Install`
  
  ![text](https://i.ibb.co/0nqRzJG/install-driver.png)

### 4. Allow Remote Access Connection for RDP

- Search for `allow remote connections to this computer` and select the first option.

  ![text](https://i.ibb.co/Xb4hwQp/allow-remote.png)

- In the Remote Desktop section, click on `Show settings`
  
  ![text](https://i.ibb.co/kD4tN2P/show-settings.png)

- Choose `Allow remote connections to this computer`, click "Apply" and then "Ok"
  
  ![text](https://i.ibb.co/Rv0R5L1/allow-remote-connections.png)

- Now, connect remotely using your Remote Desktop Connection program with the credentials created during the Windows installation.