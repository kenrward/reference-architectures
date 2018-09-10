# Implement a hub-spoke network topology with shared services in Azure

This reference architecture builds on the [hub-spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) reference architecture to include shared services in the hub that can be consumed by all spokes. As a first step toward migrating a datacenter to the cloud, and building a [virtual datacenter](https://aka.ms/vdc), the first services you need to share are identity and security. This reference architecture shows you how to extend your Active Directory services from your on-premises datacenter to Azure, and how to add a network virtual appliance (NVA) that can act as a firewall, in a hub-spoke topology

![](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/images/shared-services.png)

For deployment instructions and guidance about best practices, see the article [Implement a hub-spoke network topology with shared services in Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/shared-services) on the Azure Architecture Center.

The deployment uses [Azure Building Blocks](https://github.com/mspnp/template-building-blocks/wiki) (azbb), a command line tool that simplifies deployment of Azure resources.
