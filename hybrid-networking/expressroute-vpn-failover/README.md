# Connect an on-premises network to Azure using ExpressRoute with VPN failover

This reference architecture shows how to connect an on-premises network to an Azure virtual network (VNet) using ExpressRoute, with a site-to-site virtual private network (VPN) as a failover connection. Traffic flows between the on-premises network and the Azure VNet through an ExpressRoute connection. If there is a loss of connectivity in the ExpressRoute circuit, traffic is routed through an IPSec VPN tunnel.

![](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/images/expressroute-vpn-failover.png)

For deployment instructions and guidance about best practices, see the article [Connect an on-premises network to Azure using ExpressRoute with VPN failover](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/expressroute-vpn-failover) on the Azure Architecture Center.
