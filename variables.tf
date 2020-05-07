variable "resource_group" {
  default = "ratheesh"
}

variable "location" {
  default = "North Europe"
}

variable "vnetname" {
  default = "Dev1-vnet"
}

variable "subnetnames" {
  description = "values of all ip values to be used for subnets"
  type = "list"
  default = ["bccorda-subnet","bcase-subnet","bcapim-subnet","bcappgatw-subnet","bcmngmt-subnet"]
}

variable "nsgnames" {
  description = "names of all NSGs to be created in this environment"
  type = "list"
  default = ["dev1dn-nsg","dev1agw-nsg","dev1api-nsg","dev1ase-nsg","dev1co-nsg","dev1mgmt-nsg","BlockInternetTraffic"]
}

variable "agwname" {
  default = "icagw"
}

variable "asename" {
  default = "bcdev1nease"
}

variable "aseplan" {
  default = "bcdev1neaseplan"
}

variable "uihostname" {
  default = "dummyhost.uk.ey.com"
}

variable "apihostname" {
  default = "dummyapi.uk.ey.com"
}

variable "cordavmnames"{
  description = "values of all linux corda virtual machine names"
  type = "list"
  default = ["brdev1ap02-VM","indev1ap02-VM","mndev1ap02-VM","sopdev1ap02-VM","opdev1ap02-VM", "prdev1ap02-VM","redev1ap02-VM","ridev1ap02-VM"]
}

variable "dnsavailabilityset" {
  default = "avsetDNS"
}

variable "dnsvmname" {
  default = "bcdev1dns"
}

variable "keyvaultnames" {
  description = "names of all Keyvaults to be created in this environment"
  type = "list"
  default = ["kvapi","kvcorda","kvopservice"]
}

variable "sanames" {
  description = "names of all storage accounts to be created in this environment"
  type = "list"
  default = ["dev1bmnadfslvl01","dev1diagslvl01","dev1coslvl01","dev1omsslvl01"]
}

variable "adfcontainers" {
  description = "names of all container to be created in ADF Storage account this environment"
  type = "list"
  default = ["filearchival","rejectrecords-claims","rejectrecords-vessel","srcfile-claimshistory","srcfile-vesseldetails"]
}

variable "appcontainers"  {
  description = "names of all container to be created in ADF Storage account this environment"
  type = "list"
  default = ["operator-logs","mnc-logs","insurer-logs", "proxy-logs","retro-logs","reinsurer-logs","broker-logs"]
}

variable "sqlservername" {
  default = "bcdev1sqlserver01"
}

variable "sqldbnames" {
  description = "names of all SQL Database to be created in this environment"
  type = "list"
  default = ["operatoroffledgerDb","operatoronledgerDb","notaryonledgerDb","mncoffledgerDb","mnconledgerDb","brokeroffledgerDb","brokeronledgerDb","insureroffledgerDb","insureronledgerDb","proxyoffledgerDb","proxyonledgerDb","retrooffledgerDb","retroonledgerDb","reinsureroffledgerDb","reinsureronledgerDb"]
}

variable "sqluser" {
  default = "bcadmin"
}

variable "sqlpassword" {
  default = "DH~a{Nn:26e%vv"
}

variable "pipnames" {
  description = "names of all public ips to be created in this environment"
  type = "list"
  default = ["brdev1ap02-pip","indev1ap02-pip","mndev1ap02-pip","opdev1ap02-pip","sodev1ap02-pip", "prdev1ap02-pip","redev1ap02-pip","ridev1ap02-pip","dev1dns1-pip", "dev1dns2-pip", "dev1gw-pip"]
}

variable "domainnames" {
  description = "names of all public ips to be created in this environment"
  type = "list"
  default = ["brdev1ap02","indev1ap02","mndev1ap02","opdev1ap02","sopdev1ap02", "prdev1ap02","redev1ap02","ridev1ap02","dev1dns1", "dev1dns2"]
}

variable "appinsname" {
  default = "dev1appinsweb"
}

variable "adfname" {
  default = "dev1adf"
}

variable "apimname" {
  default = "dev1neapim"
}

variable "apimadminemai" {
  default = "ratheesh.kumarms@xe04.ey.com"
}

variable "apimorgname" {
  default = "EY"
}

variable "apimsku" {
  default = "Developer"
}

variable "apimSkuCount" {
  default = "1"
}

variable "omsworkspace" {
  default = "bcomsdev1sdsd"
}

variable "autoaccname" {
  default = "autoaccdev1"
}

variable "vmuser" {
  default = "bcadmin"
}

variable "vmpassword" {
  default = "DH~a{Nn:26e%vv"
}

# public key of the runtime environment to be store in created VMs
variable "terra-runtime-pub-key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDB8Q9q/Vv0S0z3QtU0lVxkWBGJaihAdHiY9EKQHACCellb+xVaRqHri768niwLvZDKgUyRtJNcETsx47pvsiTGp2lNDKlhANuzS76RNzquGVoRB9Yh205i53NREO1uJ7WLyMO6oaY3ukl4/ZMG9dWEP9qbK4vt9CnhJisz9ONYEMpNojmh7BY4MJvtebQ+pdOupao6yea3tROGzyncnQvZgtikeFtpmIw3Y0MFnY5eiv+EgJ3+yvv5NVg0FAGqnloU55yk9JIxLRyNEjB5T9r+pE2W+vMk/bR0Q6pAikLaVb1dXUeEHnOsttDsdu6OEKoJc9yXzmEkiGEiU4ouMBJd terrauser01@Terraform-runtime-RHEL"
}

