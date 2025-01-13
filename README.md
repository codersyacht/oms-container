## Sterling Order Management System Container Installation

**Before you begin**

 The complete installation is performed under Linux user _admin_ context. The logged in user should be _admin_ and the user home directory should be /home/admin. 
The admin user should have sudo rights with password prompt not required.
To create the admin user with the above mentioned settings, follow the link below: <br>
_https://github.com/codersyacht/private/blob/main/system/Linux_User_Creation.md_ <br><br>

**Minikube** need to be installed. If not installed yet, follow the link below: <br>
_https://github.com/codersyacht/private/blob/main/system/Minikube.md_ <br><br>

**Operator** Runtime ** need to be installed, follow the link below: <br>
_https://github.com/codersyacht/private/blob/main/system/Operators.md_ <br><br>

Clone or download this repository under /hope/admin/apps/ <br>
_https://github.com/codersyacht/oms-container_. <br>

The directory structure should be as follows:

 ```OOUTPUT
[admin@system1 oms-container]$ pwd
/home/admin/apps/oms-container
[admin@system1 oms-container]$ ls
01.om-catalog.yaml          05.om-pv.yaml          09.OMEnvironment_Custom_DB2.yaml       11.OMSAgent.yaml     ingress_sample.yaml
02.om-operator-global.yaml  06.om-secret.yaml      09.OMEnvironment_Custom_Postgres.yaml  12.OMSInt.yaml       jndi
03.om-subscription.yaml     07.IBM_Entitlement.sh  09.OMEnvironment.yaml                  13.OrderHub.yaml     portforward.sh
04.om-storage.yaml          08.MQ_Bindings.sh      10.OMSServer.yaml                      ibm-entitlement-key
```


**Installation of OMS Containers**

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

