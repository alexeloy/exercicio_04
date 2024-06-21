# Indice

- [Sobre](#-sobre)
- [Tecnologia](#-tecnologia)
- [Como baixar](#-como-baixar)

---


### 📋 Sobre

Arquivo de configuração do Terraform para criar um grupo de autoescalonamento no Amazon Web Services (AWS). 
Grupo configurado com uma imagem do Amazon Machine (AMI) mais recente, usando uma zona de disponibilidade específicada
nos arquivos de variáveis e uma política de escalonamento automático para aumentar ou diminuir o número de instâncias
com base na carga do sistema.


### 💻 Tecnologia
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)


### 📝 Como baixar

```bash 
# Clonar o repositório
$ git clone https://github.com/alexeloy/exercicio_04.git

# Variáveis necessárias para fazer o deploy na AWS da infraestrutura descrita (arquivo terraform.tfvars)

aws_access_key = "SEU_AWS_ACCESS_KEY"
aws_secret_key = "SEU_AWS_SECRET_KEY"
subnet_id = "ID_DA_SUBREDE"


```

---
Desenvolvido 🚀 por Alex Eloy