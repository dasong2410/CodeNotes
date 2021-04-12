[![SQLpassion](Pics/logo.png)](https://www.sqlpassion.at/ "SQLpassion")

https://www.sqlshack.com/sql-server-2016-always-availability-group-direct-seeding/

SQL Server Availability Groups were introduced back with SQL Server
2012. They are an awesome replacement for Database Mirroring (introduced
back with SQL Server 2005 SP1), but with one huge limitation: the nodes
on which the replicas are hosted must be part of the same Windows
cluster. This doesn’t sound that at first, but a Windows cluster
requires an Active Directory domain.

Over the last few years I have worked with a lot of different customers
who were not able to deploy SQL Server Availability Groups because their
nodes would be standalone workgroup servers that would not be part of
any Active Directory domain. Things are different with SQL Server 2016
and Windows Server 2016. Let’s have a more detailed look at that.

### Introducing SQL Server 2016 & Windows Server 2016

Prior to SQL Server 2016, Availability Groups were only part of the
Enterprise Edition of SQL Server. This was yet another drawback when
compared with Database Mirroring (because synchronous mirroring was
available even in the Standard Edition). With SQL Server 2016 Microsoft
now provides us with so-called **Basic Availability Groups** in the
Standard Edition of SQL Server, which provides the same functionality as
Database Mirroring:

-   Only 2 Replicas
-   Synchronous Commit
-   1 Database per Availability Group
-   No readable Secondary

That’s great but there is still the requirement of a Windows Cluster,
because SQL Server uses the functionality of WSFC (Windows Server
Failover Clustering) to run the Availability Groups. But things are
changing now with Windows Server 2016: in Windows Server 2016 you can
create now a Windows cluster WITHOUT any Active Directory domain! That’s
a BIG DEAL!

With SQL Server 2016 and Windows Server 2016 we finally have a
replacement technology for Database Mirroring that also works with the
Standard Edition of SQL Server. Over the remaining part of this blog
post I now want to show you how you can configure a simple Basic
Availability Group between 2 cluster nodes that are not part of any
Active Directory domain. Let’s start!

### Preparing the Windows Server 2016 Cluster

My specific scenario consists of 2 virtual machines that are running a
fresh installation of Windows Server 2016 Technical Preview 4 (the
latest preview version of Windows Server 2016 that was available at the
time of this blog posting). After you have installed the Windows OS, you
have to install the Failover Cluster feature on both nodes through the
Server Manager.

![Installing the Windows Server Cluster Failover Feature on both
nodes](Pics/01_FailoverClusterInstallation.png "Installing the Windows Server Cluster Failover Feature on both nodes")

To be able to create a Windows cluster without any Active Directory
domain you have to create a so-called **Primary DNS suffix** on both
nodes. This is also documented in more detail on
[TechNet](https://technet.microsoft.com/en-us/library/cc786695(v=ws.10).aspx).
In my case I have chosen the DNS suffix **sqlpassion.com** on both
nodes.

![Creating a DNS
Suffix](Pics/02_DNS_Suffix.png "Creating a DNS Suffix")

After the configuration of the DNS suffix it is also very important that
both nodes can be pinged from both sides through the FQDN (fully
qualified domain name), like:

-   node1.sqlpassion.com
-   node2.sqlpassion.com

Because of simplicity I have configured a static IP address on both
nodes (**192.168.1.101** and **192.168.1.102**) and disabled the
firewall. I haven’t configured any DNS server in my simple scenario,
therefore I have added the FQDN of other node into the **HOSTS** file
(stored in c:\\windows\\system32\\drivers\\etc) on both nodes. If the
FQDN can’t be resolved, then you are not able to create the Windows
cluster.

If you create the Windows cluster with another account as the default
built-in admin account, you also have to change a registry policy
through PowerShell as follows on both nodes (make sure to start the
PowerShell command prompt with administrative privileges):

``` {.lang:tsql .decode:true}
new-itemproperty -path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy -Value 1
```

If you have done all these prerequisites you are now finally able to
create the Windows cluster. With the Technical Preview 4 of Windows
Server 2016 you are only able to create the cluster through PowerShell,
because there isn’t yet any GUI support available for this. The
following PowerShell command creates the Windows cluster between both
nodes, names the cluster **sqlbag** and gives it the static IP address
**192.168.1.110**:

``` {.lang:tsql .decode:true}
new-cluster -name sqlbag –Node node1,node2 -StaticAddress 192.168.1.110 -NoStorage –AdministrativeAccessPoint DNS
```

### Creating the SQL Server Availibilty Group

After the successful creation of the Windows cluster, you can now
install SQL Server 2016 CTP 3.2 on both nodes. When the installation has
succeeded you are finally also able to enable the Availability Group
support through the SQL Server Configuration Manager (and you have to
restart SQL Server!):

![Enabling SQL Server Availability
Groups](Pics/EnableAG.png "Enabling SQL Server Availability Groups")

Now you have done all the preparations to finally deploy your first
Availability Group. Unfortunately you also have to think about the
security configuration between both nodes. In my case I have chosen to
use a **Certificate based security configuration**, because it implies
the same security configuration as in a distributed Service Broker
scenario. Let’s walk step by step through the security configuration,
because it is a little bit more complex to set up.

In the first step you have to perform the following actions on both
nodes:

-   Create a Database Master Key
-   Create a new security certificate
-   Backup the public-key portion of the security certificate to the
    file system
-   Create a new SQL Server endpoint that is used for \*Database
    Mirroring\* – ouch…

The following code shows all these steps.

``` {.lang:tsql .decode:true}
-- ====================================
-- Execute the following code on NODE1
-- ====================================

USE master
GO

-- Create a database master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'passw0rd1!'
GO

-- Create a new certificate
CREATE CERTIFICATE SQLBAG_Certificate_Node1_Private
WITH SUBJECT = 'SQLBAG_Certificate_Private - Node 1',
START_DATE = '20160101'
GO

-- Backup the public key of the certificate to the filesystem
BACKUP CERTIFICATE SQLBAG_Certificate_Node1_Private
TO FILE = 'c:\temp\SQLBAG_Certificate_Node1_Public.cert'
GO

-- Create an endpoint for the Availability Group
CREATE ENDPOINT SQLBAG_Endpoint
STATE = STARTED
AS TCP
(
    LISTENER_PORT = 5022
)
FOR DATABASE_MIRRORING
(
    AUTHENTICATION = CERTIFICATE SQLBAG_Certificate_Node1_Private,
    ROLE = ALL, 
    ENCRYPTION = REQUIRED ALGORITHM AES
)
GO

-- ====================================
-- Execute the following code on NODE2
-- ====================================

USE master
GO

-- Create a database master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'passw0rd1!'
GO

-- Create a new certificate
CREATE CERTIFICATE SQLBAG_Certificate_Node2_Private
WITH SUBJECT = 'SQLBAG_Certificate_Private - Node 2',
START_DATE = '20160101'
GO

-- Backup the public key of the certificate to the filesystem
BACKUP CERTIFICATE SQLBAG_Certificate_Node2_Private
TO FILE = 'c:\temp\SQLBAG_Certificate_Node2_Public.cert'
GO

-- Create an endpoint for the Availability Group
CREATE ENDPOINT SQLBAG_Endpoint
STATE = STARTED
AS TCP
(
    LISTENER_PORT = 5022
)
FOR DATABASE_MIRRORING
(
    AUTHENTICATION = CERTIFICATE SQLBAG_Certificate_Node2_Private,
    ROLE = ALL, 
    ENCRYPTION = REQUIRED ALGORITHM AES
)
GO
```

In the next step we establish a trusted relationship between both nodes
by creating a new login and user for the other node, and finally
authorizing the user on the public key portion of the certificate from
the other node. And you also have to grant the **CONNECT** permission to
the previous created login. The following code shows how to accomplish
these steps.

``` {.lang:tsql .decode:true}
-- ====================================
-- Execute the following code on NODE1
-- ====================================

-- Create login for the other node
CREATE LOGIN Node2Login WITH PASSWORD = 'passw0rd1!'
GO

-- Create user for the login
CREATE USER Node2User FOR LOGIN Node2Login
GO

-- Import the public key portion of the certificate from the other node
CREATE CERTIFICATE SQLBAG_Certificate_Node2_Public
AUTHORIZATION Node2User
FROM FILE = 'c:\temp\SQLBAG_Certificate_Node2_Public.cert'
GO

-- Grant the CONNECT permission to the login
GRANT CONNECT ON ENDPOINT::SQLBAG_Endpoint TO Node2Login
GO

-- ====================================
-- Execute the following code on NODE2
-- ====================================

-- Create login for the other node
CREATE LOGIN Node1Login WITH PASSWORD = 'passw0rd1!'
GO

-- Create user for the login
CREATE USER Node1User FOR LOGIN Node1Login
GO

-- Import the public key portion of the certificate from the other node
CREATE CERTIFICATE SQLBAG_Certificate_Node1_Public
AUTHORIZATION Node1User
FROM FILE = 'c:\temp\SQLBAG_Certificate_Node1_Public.cert'
GO

-- Grant the CONNECT permission to the login
GRANT CONNECT ON ENDPOINT::SQLBAG_Endpoint TO Node1Login
GO
```

After these various steps, the security configuration between both nodes
is completed and you are finally able to deploy your first Availability
Group. The following code creates a simple database, performs a full
database backup, and finally creates the Availability Group with 2
replicas (primary & secondary replica).

``` {.lang:tsql .decode:true}
-- ====================================
-- Execute the following code on NODE1
-- ====================================

USE master
GO

-- Create a new database
CREATE DATABASE TestDatabase1
GO

-- Use the database
USE TestDatabase1
GO

-- Create a simple table
CREATE TABLE Foo
(
    Bar INT NOT NULL
)
GO

-- Make a Full Backup of the database
BACKUP DATABASE TestDatabase1 TO DISK = 'c:\temp\TestDatabase1.bak'
GO

USE master
GO

-- Create a new Availability Group with 2 replicas
CREATE AVAILABILITY GROUP TestAG
WITH
(
    AUTOMATED_BACKUP_PREFERENCE = PRIMARY,
    BASIC,
    DB_FAILOVER = OFF,
    DTC_SUPPORT = NONE
)
FOR DATABASE [TestDatabase1]
REPLICA ON
'NODE1' WITH
(
    ENDPOINT_URL = 'TCP://node1.sqlpassion.com:5022', 
    FAILOVER_MODE = AUTOMATIC, 
    AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, 
    SECONDARY_ROLE
    (
        ALLOW_CONNECTIONS = NO
    )
),
'NODE2' WITH
(
    ENDPOINT_URL = 'TCP://node2.sqlpassion.com:5022', 
    FAILOVER_MODE = AUTOMATIC, 
    AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, 
    SECONDARY_ROLE
    (
        ALLOW_CONNECTIONS = NO
    )
)
GO
```

Afterwards you have to join the Availability Group on the other node as
shown in the following listing.

``` {.lang:tsql .decode:true}
-- ====================================
-- Execute the following code on NODE2
-- ====================================

-- Make the Availability Group available on NODE2
ALTER AVAILABILITY GROUP [TestAG] JOIN
GO
```

And finally we have to prepare the database on the 2nd node. Therefore
you have to perform now a transaction log backup on the primary replica
in the first step. And afterwards you restore the full database backup
and the completed transaction log backup on the 2nd node (both with
**NORECOVERY**). And then you just move the database on the 2nd node
into the Availability Group.

``` {.lang:tsql .decode:true}
-- ====================================
-- Execute the following code on NODE1
-- ====================================

-- Make a TxLog Backup of the database
BACKUP LOG TestDatabase1 TO DISK = 'c:\temp\TestDatabase1.trn'
GO

-- ====================================
-- Execute the following code on NODE2
-- ====================================

-- Restore the Full Backup with NORECOVEY
RESTORE DATABASE TestDatabase1 FROM DISK = 'c:\temp\TestDatabase1.bak' WITH NORECOVERY
GO

-- Restore the TxLog Backup with NORECOVERY
RESTORE LOG TestDatabase1 FROM DISK = 'c:\temp\TestDatabase1.trn' WITH NORECOVERY
GO

-- Move the database into the Availability Group
ALTER DATABASE TestDatabase1 SET HADR AVAILABILITY GROUP = TestAG
GO
```

When you now check the health of the Availability Group through the
Dashboard, you can see that everything works as expected – a Basic
Availability Group in SQL Server 2016 without any need for an Active
Directory domain in Windows Server 2016 – nice .

### Summary

In the course of this blog posting I have shown you how easy it is to
configure a Basic Availability Group in SQL Server 2016 without any
Active Directory domain. Microsoft made this possible by removing the
requirement for a domain for a Windows cluster in Windows Server 2016.
After 4 years we have finally a fully functional replacement technology
for Database Mirroring. Sometimes good things take time…

If you want to learn more about Availability Groups in SQL Server, make
sure to checkout my other blog postings that I wrote about a few years
ago:

-   [SQL Server 2012 AlwayOn Availability Groups – Part
    1](http://www.sqlpassion.at/archive/2012/03/21/sql-server-2012-alwayson-availability-groups-part-1/)
-   [SQL Server 2012 AlwayOn Availability Groups – Part
    2](http://www.sqlpassion.at/archive/2012/07/19/sql-server-2012-alwayson-availability-groups-part-2/)
-   [SQL Server 2012 AlwayOn Availability Groups – Part
    3](http://www.sqlpassion.at/archive/2012/07/23/sql-server-2012-alwayson-availability-groups-part-3-setting-up-alwayson-through-t-sql/)
-   [SQL Server 2012 AlwayOn Availability Groups – Part
    4](http://www.sqlpassion.at/archive/2012/07/26/sql-server-2012-alwayson-availability-groups-part-4-adding-new-replicas/)
