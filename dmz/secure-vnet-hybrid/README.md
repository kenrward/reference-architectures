# DMZ between Azure and your on-premises datacenter

This reference architecture shows a secure hybrid network that extends an on-premises network to Azure. The architecture implements a DMZ, also called a perimeter network, between the on-premises network and an Azure virtual network (VNet). The DMZ includes network virtual appliances (NVAs) that implement security functionality such as firewalls and packet inspection. All outgoing traffic from the VNet is force-tunneled to the Internet through the on-premises network, so that it can be audited.

![](https://docs.microsoft.com/azure/architecture/reference-architectures/dmz/images/dmz-private.png)

For deployment instructions and guidance about best practices, see the article [DMZ between Azure and your on-premises datacenter](https://docs.microsoft.com/azure/architecture/reference-architectures/dmz/secure-vnet-hybrid) on the Azure Architecture Center.

The deployment uses [Azure Building Blocks](https://github.com/mspnp/template-building-blocks/wiki) (azbb), a command line tool that simplifies deployment of Azure resources.