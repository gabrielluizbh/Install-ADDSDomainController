# Script para criação de um Controlador de Domínio do Active Directory pelo Powershell - Créditos Gabriel Luiz - www.gabrielluiz.com #

# Instalação da função ADDS ( Active Directory Domain Services).

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

<#

Explicação do comando: Install-WindowsFeature -Name AD-Domain-Services - IncludeManagementTools

Install-WindowsFeature - Este comando permitirá instalar a função do Windows, os serviços de função ou o recurso do Windows no servidor local ou remoto. É semelhante ao uso do gerenciador de servidores do Windows para instalá-los.

-Name AD-Domain-Services - Nome da função a ser instalada, neste exemplo será o Active Directory Domain Services.

-IncludeManagementTools - Isso instalará as ferramentas de gerenciamento para o serviço de função selecionado.

#>

# Executa os pré-requisitos somente para instalar um controlador de domínio no Active Directory.


Test-ADDSDomainControllerInstallation -InstallDns -DomainName "gabrielluiz.lan"

<#

Explicação do comando: Test-ADDSDomainControllerInstallation -InstallDns -DomainName "gabrielluiz.lan"

Este comando executa os pré-requisitos para determinar se a instalação de um controlador de domínio juntamente com o servidor DNS no domínio gabrielluiz.lan. 

O comando também solicita ao usuário que entre e confirme a senha do DSRM.

#>



# Instala um novo Controlador de Domínio do Active Directory.


Install-ADDSDomainController -CreateDnsDelegation:$false -CriticalReplicationOnly:$false -DatabasePath "C:\Windows\NTDS" -DomainName "gabrielluiz.lan" -InstallDNS:$true -LogPath "C:\Windows\NTDS" -SiteName "Default-First-Site-Name" -SYSVOLPath "C:\Windows\SYSVOL" -Force:$true


<# 

Explicação do comando: Install-ADDSDomainController -CreateDNSDelegation -Credential (Get-Credential) -CriticalReplicationOnly:$false -DatabasePath "C:\Windows\NTDS" -DomainName "gabrielluiz.lan" -InstallDNS:$true -LogPath "C:\Windows\NTDS" -SiteName "Default-First-Site-Name" -SYSVOLPath "C:\Windows\SYSVOL" -Force:$true


Install-ADDSDomainController - Este comando permitirá instalar um novo controlador de domínio do Active Directory.


-CreateDnsDelegation:$false - O uso desse parâmetro pode definir se a delegação DNS deve fazer referência ao DNS integrado ao Active Directory.


-CriticalReplicationOnly:$false - Indica que o comando executa apenas a replicação crítica antes da reinicialização e continua durante a operação de instalação do AD DS. Esse parâmetro ignora a parte não crítica e potencialmente longa da replicação. A replicação não crítica ocorre após a conclusão da instalação e a reinicialização do computador. Por padrão, o cmdlet executa partes críticas e não críticas da replicação.


-DatabasePath "C:\Windows\NTDS" - Este parâmetro será usado para definir o caminho da pasta para armazenar o arquivo de banco de dados do Active Directory (Ntds.dit).


-DomainName "gabrielluiz.lan" - Este parâmetro define o FQDN para o domínio do Active Directory.


-InstallDns:$true - Este parâmetro especificará se a função DNS precisa ser instalada com o controlador de domínio do Active Directory. Para uma nova floresta, é requisito padrão defini-la como $true.


-LogPath "C:\Windows\NTDS" - O caminho do log pode ser usado para especificar o local para salvar os arquivos de log do domínio.


-SiteName "Default-First-Site-Name" - Especifica o nome de um site existente onde você pode colocar o novo controlador de domínio. O valor padrão depende do tipo de instalação. Para uma nova floresta, o padrão é Default-First-Site-Name. Para todas as outras instalações, o padrão é o site associado à sub-rede que inclui o endereço IP desse servidor. Se esse site não existir, o padrão será o site do controlador de domínio de origem de replicação.


-SysvolPath "C:\Windows\SYSVOL" - Isso é para definir o caminho da pasta SYSVOL. O local padrão para ele será C:\Windows.


-Force:$true - Por padrão, o sistema reiniciará o servidor após a configuração do controlador de domínio. usar este comando pode impedir a reinicialização automática do sistema.


#>


# Validação do novo controlador de domínio do Active Directory.


# Este comando verfica dos serviços devem estar em execução.

Get-Service adws,kdc,netlogon,dns


# Este comando listará todos os detalhes de configuração do controlador de domínio.


Get-ADDomainController


# Este comando listará os detalhes sobre o domínio do Active Directory.


Get-ADDomain gabrielluiz.lan


# Este comando listará os detalhes da floresta do Active Directory.


Get-ADForest gabrielluiz.lan


# Este comando mostrará se o controlador de domínio está compartilhando a pasta SYSVOL.


Get-smbshare SYSVOL


# Este comando mostrará se o controlador de domínio está localizado no site AD correto, seu endereço de IP, seu hostname.

Get-ADDomainController -Discover



# Recurso de compatibilidade de aplicativo do Server Core sob demanda (FOD) (Opcional)


Add-WindowsCapability -Online -Name ServerCore.AppCompatibility~~~~0.0.1.0 # Instala o Recurso de compatibilidade de aplicativo do Server Core sob demanda (FOD) usando o Windows Update.


# Mais informações: https://github.com/gabrielluizbh/FOD-WS-2019


<#

Referências:


https://learn.microsoft.com/en-us/powershell/module/servermanager/install-windowsfeature?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsdomaincontroller?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/addsdeployment/test-addsdomaincontrollerinstallation?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-service?view=powershell-7.2&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-addomaincontroller?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-addomain?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-adforest?view=windowsserver2022-ps&WT.mc_id=5003815

https://learn.microsoft.com/en-us/powershell/module/smbshare/get-smbshare?WT.mc_id=5003815


#>