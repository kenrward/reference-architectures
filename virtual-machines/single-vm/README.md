# Deploying a single VM to Azure

You can read the [guidance on deploying a single VM to Azure][guidance] document to understand the best practices related to single VM deployment that accompanies the reference architecture below.

![[0]][0]

## Solution components

The reference architecture above is deployed using different building blocks for virtual network, network security group, and virtual machine.

You can deploy these template building blocks by using the [Azure Building Blocks][azbbv2].

Each building block consumes a set of parameters provided in a single file that you can download and modify for your own environment. The parameters used in this deployment scenario are as follows.

Download the parameter file for a [Windows VM][windows-parameters] or [Linux VM][linux-parameters] and make any necessary changes.

Notice that the parameter file contains a different building block for:
- virtual network
- network security group
- virtual machine
- virtual machine extensions

### Virtual network

Before editing the values in the virtual network building block, make sure you understand what values are expected for its [parameters][bb-vnet]. The parameters below are used to create a single virtual network named `ra-single-linux-vm-vnet` with an address prefix of `10.0.0.0/16` containing a single subnet named `web` with an address prefix of `10.0.1.0/24`.

```json
	{
		"type": "VirtualNetwork",
		"settings": [
			{
				"name": "ra-single-linux-vm-vnet",
				"addressPrefixes": [
					"10.0.0.0/16"
				],
				"subnets": [
					{
						"name": "web",
						"addressPrefix": "10.0.1.0/24"
					}
				]
			}
		]
	},
```

### Network security group

Before editing the values in the network security group building block, make sure you understand what values are expected for its [parameters][bb-nsg]. The parameters below are used to create an NSG named `ra-single-linux-vm-nsg` that allows SSH and HTTP traffic to the default ports for those services in the `web` subnet in a virtual network named `ra-single-linux-vm-vnet`.

```json
	{
		"type": "NetworkSecurityGroup",
		"settings": [
			{
				"name": "ra-single-linux-vm-nsg",
				"securityRules": [
					{
						"name": "SSH"
					},
					{
						"name": "HTTP"
					}
				],
				"virtualNetworks": [
					{
						"name": "ra-single-linux-vm-vnet",
						"subnets": [
							"web"
						]
					}
				]
			}
		]
	},
```

### Virtual machine

Before editing the values in the virtual machine building block, make sure you understand what values are expected for its [parameters][bb-vm]. You need to at least substitute the `yyy` value for the `sshPublicKey` parameter with your own SSH public key used to access your Linux VM. If you are using a Windows VM, substitute the `sshPublicKey` parameter with `adminPassword` and specify your own password value.

The parameters below create a VM named `ra-single-linux-vm1` in the `web` subnet running the latest version of Ubuntu with 2 data disks. It uses several defaults from the Azure Building Blocks to:
- Enable managed disks
- Enable boot diagnostics
- Create a public IP address

```json
	{
		"type": "VirtualMachine",
		"settings": {
			"vmCount": 1,
			"namePrefix": "ra-single-linux",
			"computerNamePrefix": "web",
			"size": "Standard_DS1_v2",
			"adminUsername": "",
			"sshPublicKey":"",
			"virtualNetwork": {
				"name": "ra-single-linux-vm-vnet"
			},
			"nics": [
				{
					"subnetName": "web"
				}
			],
			"osType": "linux",
			"dataDisks": {
				"count": 2
			}
		}
	},
```

### Virtual machine extensions

Before editing the values in the virtual machine extension building block, make sure you understand what values are expected for its [parameters][bb-extensions].

The parameters below are used to download three different bash scripts to a Linux VM, then run one of those scripts. The script being executed simply makes calls to the other scripts to:

- install apache
- format two data disks

```json
	{
		"type": "VirtualMachineExtension",
		"settings": [
			{
				"vms": [
					"ra-single-linux-vm1"
				],
				"extensions": [
					{
						"name": "ra-single-linux-vm1-ext",
						"publisher": "Microsoft.Azure.Extensions",
						"type": "CustomScript",
						"typeHandlerVersion": "2.0",
						"autoUpgradeMinorVersion": true,
						"settings": {
							"fileUris": [
								"https://raw.githubusercontent.com/mspnp/reference-architectures/master/scripts/linux/format-disk.sh",
								"https://raw.githubusercontent.com/mspnp/reference-architectures/master/scripts/linux/install-apache.sh",
								"https://raw.githubusercontent.com/mspnp/reference-architectures/master/virtual-machines/single-vm/extensions/linux/single-vm.sh"
							]
						},
						"protectedSettings": {
							"commandToExecute": "sh single-vm.sh"
						}
					}
				]
			}
		]
	}
```

The extension building block for a Windows VM is similar tot he Linux one, except that it uses two blocks - one to install IIS, and another one to format the data disks.

```json
	{
		"type": "VirtualMachineExtension",
		"settings": [
			{
				"vms": [
					"ra-single-windows-vm1"
				],
				"extensions": [
					{
						"name": "format-disks",
						"publisher": "Microsoft.Compute",
						"type": "CustomScriptExtension",
						"typeHandlerVersion": "1.8",
						"autoUpgradeMinorVersion": true,
						"settings": {
							"fileUris": [
								"https://raw.githubusercontent.com/mspnp/reference-architectures/master/scripts/windows/format-disk.ps1",
								"https://raw.githubusercontent.com/mspnp/reference-architectures/master/virtual-machines/single-vm/extensions/windows/format-disks.ps1"
							]
						},
						"protectedSettings": {
							"commandToExecute": "powershell -ExecutionPolicy Unrestricted -File format-disks.ps1"
						}
					},
					{
						"name": "iis-config-ext",
						"publisher": "Microsoft.Powershell",
						"type": "DSC",
						"typeHandlerVersion": "2.7",
						"autoUpgradeMinorVersion": true,
						"settings": {
							"configuration":
							{
								"url": "https://raw.githubusercontent.com/mspnp/reference-architectures/master/scripts/windows/iisaspnet.ps1.zip",
								"script": "iisaspnet.ps1",
								"function": "iisaspnet"
							}
						},
						"protectedSettings": {
							"configurationArguments": { }
						}
					}                
				]
			}
		]
	}
```

## Solution deployment

You can deploy this reference architecture by using the [Azure Building Blocks][azbbv2]. To deploy the reference archtiecture:

1. Follow the steps to install `azbb` in [Windows][install-azbb-windows] or in [Linux/MacOS][install-azbb-linux].

2. Download all the files and folders in this folder.

3. In the **parameters** folder, customize the parameter file according to your needs.

4. From a command prompt, login to your Azure account by using the `az login` command and following its prompt.

```bash
	az login
```

5. Run the `azbb` command as shown below.

```bash
	azbb -s <subscription_id> -g <resource_group_name> -l <location> -p <parameter_file> --deploy
```

	For instance, the command below can be used to deploy a Windows VM to a resource group named `ra-single-windows-vm-rg` in the `West US` Azure region:

	```bash
		azbb -s xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -g ra-single-windows-vm-rg -l westus -p ./single-vm.json --deploy
	```

<!-- links -->
[0]: ./diagram.png
[bb]: https://github.com/mspnp/template-building-blocks
[bb-vnet]: https://github.com/mspnp/template-building-blocks/wiki/virtual-network
[bb-nsg]: https://github.com/mspnp/template-building-blocks/wiki/network-security-group
[bb-vm]: https://github.com/mspnp/template-building-blocks/wiki/Virtual-Machines
[bb-extensions]: https://github.com/mspnp/template-building-blocks/wiki/virtual-machine-extensions
[deployment]: #Solution-deployment
[guidance]: https://docs.microsoft.com/azure/architecture/reference-architectures/virtual-machines-linux/single-vm
[azbbv2]: https://github.com/mspnp/template-building-blocks/wiki
[windows-parameters]: ./parameters/windows/single-vm-v2.json
[linux-parameters]: ./parameters/linux/single-vm-v2.json
[install-azbb-windows]: https://github.com/mspnp/template-building-blocks/wiki/Install-Azure-Building-Blocks-(Windows)
[install-azbb-linux]: https://github.com/mspnp/template-building-blocks/wiki/Install-Azure-Building-Blocks-(Linux)