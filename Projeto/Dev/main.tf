module "aws-dev" {
    source = "../infra"
    instancia = "t2.micro"
    regiao_aws = "us-west-2"
    chave = "projetoAWS-keypairEC2"
}