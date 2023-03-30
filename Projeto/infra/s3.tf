resource "aws_s3_bucket" "opus-matheus-silva-webapp" {
    bucket = "opus-matheus-silva-webapp"
}

resource "aws_s3_bucket_acl" "opus-matheus-silva-webapp-acl" {
  bucket = "opus-matheus-silva-webapp"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "blockPublicAccess" {
  bucket = "opus-matheus-silva-webapp"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Cria um fileset com todo o conteudo de webapp e  armazena no objeto
resource "aws_s3_object" "object1" {
    for_each = fileset("../infra/webapp/", "*")
    key = each.value
    bucket = "opus-matheus-silva-webapp"
    source = "../infra/webapp/${each.value}"
    etag = filemd5("../infra/webapp/${each.value}")
    depends_on = [
        aws_s3_bucket.opus-matheus-silva-webapp
    ]
}

resource "aws_s3_bucket" "public-opus-matheus-silva-webapp" {
    bucket = "public-opus-matheus-silva-webapp"
    object_lock_enabled = false
}
# Cria um fileset com todo o conteudo de webapp e  armazena no objeto
resource "aws_s3_object" "object2" {
    key = "opuslogo.png"
    bucket = "public-opus-matheus-silva-webapp"
    source = "../infra/webapp/opuslogo.png"
    etag = filemd5("../infra/webapp/opuslogo.png")
    depends_on = [
        aws_s3_bucket.public-opus-matheus-silva-webapp
    ]
    acl = "public-read"
}
