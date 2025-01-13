## Sterling Order Management System Container Installation

### Before you begin

 The complete installation is performed under Linux user _admin_ context. The logged in user should be _admin_ and the user home directory should be /home/admin. 
The admin user should have sudo rights with password prompt not required.
To create the admin user with the above mentioned settings, follow the link below: <br>
_https://github.com/codersyacht/private/blob/main/system/Linux_User_Creation.md_ <br><br>

**Minikube** need to be installed. If not installed yet, follow the link below: <br>
_https://github.com/codersyacht/private/blob/main/system/Minikube.md_ <br><br>

**Operator** Runtime ** need to be installed, follow the link below: <br>
_https://github.com/codersyacht/private/blob/main/system/Operators.md_ <br><br>

Every installation of user specific applications are performed under apps directory unless it is a system application or applications that require a unique user like DB or IBM MQ. 
Therefore create a directory called _apps_ if not done so.

```CMD
mkdir -p /home/admin/apps
```

Clone or download this repository under /hope/admin/apps/ <br>
_https://github.com/codersyacht/oms-container_. <br>

The directory structure should be as follows:

 ```CMD
[admin@system1 oms-container]$ pwd
/home/admin/apps/oms-container
[admin@system1 oms-container]$ ls -ltv
total 84
-rw-r--r-- 1 admin admin  415 Dec 30 08:35 01.om-catalog.yaml
-rw-r--r-- 1 admin admin  156 Dec 30 08:35 02.om-operator-global.yaml
-rw-r--r-- 1 admin admin  237 Dec 30 08:35 03.om-subscription.yaml
-rw-r--r-- 1 admin admin  269 Dec 30 08:35 04.om-storage.yaml
-rw-r--r-- 1 admin admin  258 Dec 30 08:35 05.om-pv.yaml
-rw-r--r-- 1 admin admin  259 Dec 30 08:35 06.om-secret.yaml
-rw-r--r-- 1 admin admin  232 Dec 30 08:35 07.IBM_Entitlement.sh
-rw-r--r-- 1 admin admin   63 Dec 30 08:35 08.MQ_Bindings.sh
-rw-r--r-- 1 admin admin 5265 Dec 30 08:35 09.OMEnvironment.yaml
-rw-r--r-- 1 admin admin 5160 Jan 10 05:17 09.OMEnvironment_Custom_DB2.yaml
-rw-r--r-- 1 admin admin 5297 Dec 30 08:35 09.OMEnvironment_Custom_Postgres.yaml
-rw-r--r-- 1 admin admin  528 Dec 30 08:35 10.OMSServer.yaml
-rw-r--r-- 1 admin admin  266 Dec 30 08:35 11.OMSAgent.yaml
-rw-r--r-- 1 admin admin  401 Dec 30 08:35 12.OMSInt.yaml
-rw-r--r-- 1 admin admin 1231 Dec 30 08:35 13.OrderHub.yaml
-rw-r--r-- 1 admin admin  193 Dec 30 08:35 ibm-entitlement-key
-rw-r--r-- 1 admin admin  504 Dec 30 08:35 ingress_sample.yaml
drwxr-xr-x 2 admin admin   23 Dec 30 08:36 jndi
-rw-r--r-- 1 admin admin   91 Dec 30 08:35 portforward.sh
[admin@system1 oms-container]$ 
```


### Installation of OMS Containers

Create a namespace called oms in Kubernetes.
```CMD
kubectl create namespace oms
```

**1. OMS Catalog Installation**

```CMD
kubectl apply -f 01.om-catalog.yaml -n oms
```

**2. OMS OperatorGroup Installation**
```CMD
kubectl apply -f 02.om-operator-global.yaml -n oms
```

**3.  OMS Subscription Installation**
```CMD
kubectl apply -f 03.om-subscription.yaml -n oms
```

**4. Storage Class installation**

NFS folder need to be created as /home/admin/apps/omshare. <br>
_https://github.com/codersyacht/private/blob/main/system/Create_NFS_Disk.md_

```CMD
kubectl apply -f 04.om-storage.yaml -n oms
```

**5. Persistent Volume (PV) installation**
```CMD
kubectl apply -f 05.om-pv.yaml -n oms
```

**6. Secret Installation**

DB has to be installation. If not yet installed, then following the link below: <br>
https://github.com/codersyacht/private/blob/main/db2/01-Setup.md <br>
https://github.com/codersyacht/private/blob/main/db2/02-Create-DB.md <br>

Edit the dbPassword value in the 06.om-secret.yaml. 

```CMD
kubectl apply -f 06.om-secret.yaml -n oms
```

**7. Setting up the entitlement**

Entitelemt key is required to download the IBM software. Generate IBM software entitlement key following the link below: <br>
_https://myibm.ibm.com/products-services/containerlibrary_ <br>
Copy the into the file _ibm-entitlement-key_. <br>
Execute the below command:
```CMD
./07.IBM_Entitlement.sh
```
**8. Set the IBM MQ jndi file.**

A sample jndi file is available in the ./jndi directory. The file name is .binding (note the the file will be hidden as it has . prefix. However it can still be opened using vi editor). 
It is already preconfigured with a Queue Manager named **OMQM** and 10 queues namely OMQUEUE0, OMQUEUE1, .., OMQUEUE9. Therefore create a a Queue Manager as OMQM and 10 queues as OMQUEUE0, OMQUEUE1, .., OMQUEUE9 in your IBM MQ. You can follow the steps mentioned in the following link: <br>
_https://github.com/codersyacht/private/blob/main/MQ/01.Setup.md_ <br>
Ensure the setup works using a standalone client: <br>
_https://github.com/codersyacht/private/blob/main/MQ/02.Client-Setup.md_ <br><br>

Edit the ./jndi/.bindings file to change the host name mentioned as system1.fyre.ibm.com to the hostname where the Queue Manager in setup. <br>
Execute the below command: <br>
```CMD
./08.MQ_Bindings.sh
```

**9. Sterling OMS Environment Installation**

Edit the 09.OMEnvironment.yaml file. Verify all the properties. If the complete setup is based on this repository, then the only change perhaps that is required will be database:db2:host value.

```CMD
kubectl -apply -y 09.OMEnvironment.yaml -n oms
```

**10. Sterling OMS Application Server installation**

```CMD
kubectl apply -f 10.OMSServer.yaml -n oms
```

**11. Sterling OMS Agent Integration**

```CMD
kubectl apply -f 11.OMSAgent.yaml -n oms
```

**12. Sterling OMS Integration Integration**

```CMD
kubectl apply -f 12.OMSInt.yaml -n oms
```

**13. Sterling OMS Orderhub Integration**

```CMD
kubectl apply -f 13.OrderHub.yaml -n oms
```

