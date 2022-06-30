##################################################### Compliant Resources ######################################################################

# Define IAM Support-role assume role Policy
data "aws_iam_policy_document" "assume_role_policy" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  statement {
    actions       = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.user_arn]
    }
  }
}

data "aws_iam_policy" "AWSSupportAccess" {
  count    = var.infra_type == "compliant" ? var.var_count : 0
  arn      = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

# AWS IAM Account Password policy
resource "aws_iam_account_password_policy" "compliant_configuration" {
  count    = var.infra_type == "compliant" ? var.var_count : 0
  minimum_password_length        = 14
  require_lowercase_characters   = true
  password_reuse_prevention      = 3
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

resource "aws_iam_role" "compliant_aws_support_role" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  name               = "${var.env_name}-${var.infra_type}-iam-role-${count.index + 1}"
  path               = "/zs-infra/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[count.index].json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "compliant_role_policy_attach" {
  count                 = var.infra_type == "compliant" ? var.var_count : 0
  role                  = "${aws_iam_role.compliant_aws_support_role[count.index].name}"
  policy_arn            = "${data.aws_iam_policy.AWSSupportAccess[count.index].arn}"
}

# AWS IAM Role Policy for AWS Support
resource "aws_iam_role_policy" "compliant_role_policy_document" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  name               = "${var.env_name}-${var.infra_type}-iam-role-policy-${count.index + 1}"
  role               = aws_iam_role.compliant_aws_support_role[count.index].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_accessanalyzer_analyzer" "example" {
  count              = var.infra_type == "compliant" ? var.var_count : 0
  analyzer_name      = "${var.env_name}-${var.infra_type}-access-analyzer-${count.index + 1}"
  type               = "ACCOUNT"
}

# Compliant IAM Server Certificate
resource "aws_iam_server_certificate" "compliant_server_cert" {
  count    = var.infra_type == "compliant" ? var.var_count : 0
  name = "${var.env_name}-${var.infra_type}-iam-servercert-${count.index + 1}"

  certificate_body = <<EOF
-----BEGIN CERTIFICATE-----
MIID9TCCAt2gAwIBAgIUSZxwDbXTF+S727to5CHhMQ1p0FMwDQYJKoZIhvcNAQEF
BQAwgYkxCzAJBgNVBAYTAklOMRQwEgYDVQQIDAtNQUhBUkFTSFRSQTENMAsGA1UE
BwwEUFVORTEQMA4GA1UECgwHWlNDQUxFUjENMAsGA1UECwwEQ1NQTTEMMAoGA1UE
AwwDQVdTMSYwJAYJKoZIhvcNAQkBFhdiaHVzaGFuYkBjbG91ZG5lZXRpLmNvbTAe
Fw0yMTA3MTUxMzI0NTVaFw0zMTA3MTMxMzI0NTVaMIGJMQswCQYDVQQGEwJJTjEU
MBIGA1UECAwLTUFIQVJBU0hUUkExDTALBgNVBAcMBFBVTkUxEDAOBgNVBAoMB1pT
Q0FMRVIxDTALBgNVBAsMBENTUE0xDDAKBgNVBAMMA0FXUzEmMCQGCSqGSIb3DQEJ
ARYXYmh1c2hhbmJAY2xvdWRuZWV0aS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQCb/NO18+h9Uoo26CFLZqPXqZI1LHgsyHB3aTE6JcrUvNXx65uF
udHq59PITF5qYWfe6/4AJ8yj1xnbCj4RqmoRYcAHwGF5t0ZbuhpmwM5szJV4/jr5
cEB7CdLe18Pvzm+0DoqAxGdhGxdx8YfrcZu6Rn/yfiUHCd3ftQGzn5KkR2LcGsEa
1SGuYL4bPb/1SVsD3MMmiMDuwampslLtH2X1ZeXwJDlwl/dEQSn92Mg4WsWSe+/6
9U2imk+G0BgHI1wp1Q02Gnbp/w8A4liMiTEZz3Po/95EuQEJx6bmTK4x3mIiHxAi
u6YwFd396g3hHPM/hICaVQLlKWQXkP5hZTlVAgMBAAGjUzBRMB0GA1UdDgQWBBQD
o4hfhW0frl1Mf4IxtBiBqby/WzAfBgNVHSMEGDAWgBQDo4hfhW0frl1Mf4IxtBiB
qby/WzAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQBuFkj/TZLl
+QniVay0IX3KDgMkHokq9DY1qIwG+7/jbzsLn3RtkZZ6UC+Lv+B7ZVQekFs3X8be
XN6yLoyaV43nKAnL/ShXwoymxHqz105ieLUMy2kbH/qIBs8hbqLLqSH5V6WCjaFn
S+Qny8rIv1uT0mlzXhT5Yhcoe4L9bh/iLdG29KZu0LEht/4VCvwxQo2JR3wJ5XJu
S3q7JVjwpZyaFDDza8s+8cTAPjX9d29O7KxQuU6ju68KSHaBDOoZpGrUgfxfywVR
kbMrM96naEC/dGfZ74ZaMAQs3lKGOOLH2HUkHAn50ppEr8IWhHTwnWjSTrs0STG0
Krslc0Vr7MLN
-----END CERTIFICATE-----
EOF

  private_key = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAm/zTtfPofVKKNughS2aj16mSNSx4LMhwd2kxOiXK1LzV8eub
hbnR6ufTyExeamFn3uv+ACfMo9cZ2wo+EapqEWHAB8BhebdGW7oaZsDObMyVeP46
+XBAewnS3tfD785vtA6KgMRnYRsXcfGH63GbukZ/8n4lBwnd37UBs5+SpEdi3BrB
GtUhrmC+Gz2/9UlbA9zDJojA7sGpqbJS7R9l9WXl8CQ5cJf3REEp/djIOFrFknvv
+vVNoppPhtAYByNcKdUNNhp26f8PAOJYjIkxGc9z6P/eRLkBCcem5kyuMd5iIh8Q
IrumMBXd/eoN4RzzP4SAmlUC5SlkF5D+YWU5VQIDAQABAoIBAFZdr+Kof2sUDk7E
S9rxo3m++6LRUmCJQiv7ZDQrxJfxTgu6RcvOzLlhTlMyZXxFHjvBMktnvdhhOoGa
tC8Xyc6B7s7b55x6q0wSSJfn3ONEiuYI7SI60pjNIaIcmPHnvNVWz7zoAc00MND3
yCfGKVEDw8fBrEKvZdd84spPaePmfSNVv54zu0aAdPWaapO0wTkFU63vlivtfezQ
Zw0rRLs+3JMv+M1oqyscwGNcgLuhesUzknFXeyZ9VliiqyOsadFCbb6t1ePDI8aW
xmduqY++b/TvH8NIP7k0JVg9lq6v6ZwBpkt0a6SqqVXsBxIgCGIKJi0mT0Vi9RtL
S3UAeoECgYEAzijmlhmgXrR4CvV75cZmLT9AHxuMndMaBKPUcV7am8UjQ3Drpjjb
2B7Lf0WRQZEFTgDiv8KtQE1BmaOeggC4ouiPbeOALdvQeaJ5BwSTNyzJwnpACsOk
m6l8jCiwN7NPXEd5TdR7KuyM91LF+H6W+pDsZYJV5oP/dvvlMZQFljECgYEAwbLN
bOnYJX3P9FX51wklxaMKPkkwAVTxwIV59EEya0tXKo+ADpncQq1a1TucMz9s5rH+
KbVpG8+CMDjyqA4uPLULNqVcjLAlE5X1hhcAc/1cnRN91AX/OUWR2Uf0UfJ7t9b7
7WsdvBBeit0qdE12lnmbXR61ou+TXiDf+VTqeGUCgYBIkXMhcOHXlFURHno/VogO
803B5XOo9m8ZJQYZ5hazcEBKdAwvFaKlP6nIIhfQaZjhbURj1cYgdVFbIJIiFtjn
V09tkgBDpDWNK1jI1J5xdI2MrHWwlE90D8PsnkHxSWftBqe3cszsPhoc0QEoyH6i
srLTxH4yR1J8coyp1/3jcQKBgQCOoFtVJEdtK9vxXVFvfqPaiHglbvyzLloo2d/3
8/3tNXfEtg+kMLUYP8/PjWox7jUBFfVBvvvbZ4vEeFptVqvDNchA/7hLO/TBHD3C
87L4tYn5e32+nn/VKx3+8VW89aEVuG6e3q3xadhDxiDZrKRynq7A/bjfdit8NxbU
4CsaZQKBgAhvjiASQKD9ChCy1lHHyOL7t8KzSD805GSKG1ENezQPd4yC4c500BvT
tYCSncdXUe/gW6fDmt9NLHFE3p6vqZdUxh2JDAy9XkQQdAjLIfRnwFj1SNvXTRBp
kmv2MBYSgiSpL0aBDkSzB52Bc/axQ1Wg3FHpUZp0wol76gEzFUVk
-----END RSA PRIVATE KEY-----
EOF
}

##################################################### Non-Compliant Resources ######################################################################

# Define IAM High Priviledge Access Policy
resource "aws_iam_policy" "non_cmpliant_admin_policy" {
  count              = var.infra_type == "non-compliant" ? var.var_count : 0
  name               = "${var.env_name}-${var.infra_type}-iam-admin-policy-${count.index + 1}"
  path               = "/zs-infra/"
  description        = "Infra Sample IAM Deployment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Non-Compliant IAM Server Certificate
resource "aws_iam_server_certificate" "non_compliant_server_cert" {
  count    = var.infra_type == "non-compliant" ? var.var_count : 0
  name = "${var.env_name}-${var.infra_type}-iam-servercert-${count.index + 1}"

  certificate_body = <<EOF
-----BEGIN CERTIFICATE-----
MIIDpjCCAo4CCQD/ITZTVg/hjDANBgkqhkiG9w0BAQsFADCBlDELMAkGA1UEBhMC
SU4xFDASBgNVBAgMC01haGFyYXNodHJhMQ0wCwYDVQQHDARQdW5lMRMwEQYDVQQK
DApDbG91ZG5lZXRpMQ8wDQYDVQQLDAZEZXZPcHMxFDASBgNVBAMMC0JodXNoYW5C
aGF0MSQwIgYJKoZIhvcNAQkBFhViaGF0Ymh1c2hhbkBnbWFpbC5jb20wHhcNMjIw
NTEyMDk1ODMwWhcNMjIwNTEzMDk1ODMwWjCBlDELMAkGA1UEBhMCSU4xFDASBgNV
BAgMC01haGFyYXNodHJhMQ0wCwYDVQQHDARQdW5lMRMwEQYDVQQKDApDbG91ZG5l
ZXRpMQ8wDQYDVQQLDAZEZXZPcHMxFDASBgNVBAMMC0JodXNoYW5CaGF0MSQwIgYJ
KoZIhvcNAQkBFhViaGF0Ymh1c2hhbkBnbWFpbC5jb20wggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCwjMBNpeOYpAi9+LQ4AnTXHh+LSjB5A+Sn05PCF9QF
d4MVCjS6cLZexDV8CtABAFvDhODI6HLT1olix/aNc3P635anhleub+gSbldt/vg1
OISQfC8gsLNc7n1z1BuYg0X/kBwmh/n8ZAyfLh2Bpbe+ikZaymAo1noZ2Scq7HSK
FdUdrIQwJkjLq22B6/X9O6piTnjRNpAbb84LkVAfh+yGR74pnOcrx5oLE8hDu0qT
Rws9PGthPg9GgjafxA46cfyoryXqZIf1itB+ijFjZshyjrPjgBTE8BRphyaLj2se
CC9IcdTyBPN7U3IHZgbMybN+DJWI1H5u8z2Wb+exthu1AgMBAAEwDQYJKoZIhvcN
AQELBQADggEBAJrKt0yd65AEL/ktCEx/Xg2Dvc/Uc8ehhPHHM4+wTCYSsLXofOhE
3dc4ISpzmG2gbLN+hMzZCnBmguYTmSoQrUq4Ee32e6+8CPMYKYNWOvN/lQdGyQ+9
LCgPnyaq7OU2UUxBF225/j01nhimSwwNMbvkN00spko4arGKxVvlML94WnxZB70Q
CP/MUhN3lnk93rLvAn9xvlXbLp4nJWGC6qVZRiy1921ydWGcbxhrta+OLygW87JU
Zxq4RA/9un6lVdb9NkzAdZMiETIzVTSoyeuHv254DcGeCvgqwqUYnVyYTeOp+xmf
KyMFIWDT1XCFawtbPdwIAhpRMVR8Fci7FmA=
-----END CERTIFICATE-----
EOF

  private_key = <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCwjMBNpeOYpAi9
+LQ4AnTXHh+LSjB5A+Sn05PCF9QFd4MVCjS6cLZexDV8CtABAFvDhODI6HLT1oli
x/aNc3P635anhleub+gSbldt/vg1OISQfC8gsLNc7n1z1BuYg0X/kBwmh/n8ZAyf
Lh2Bpbe+ikZaymAo1noZ2Scq7HSKFdUdrIQwJkjLq22B6/X9O6piTnjRNpAbb84L
kVAfh+yGR74pnOcrx5oLE8hDu0qTRws9PGthPg9GgjafxA46cfyoryXqZIf1itB+
ijFjZshyjrPjgBTE8BRphyaLj2seCC9IcdTyBPN7U3IHZgbMybN+DJWI1H5u8z2W
b+exthu1AgMBAAECggEAdezd+j+HIYrXqAS6Y/sIDjQ5v7FDZWG7VnpVZLzDyw8E
CIazp6Dnv67xRrR2MWUK5jMYbjoNkP/o7olAX0Uxv+2e1LFAWey3p6/6SCeZpPrm
WRgJ5p0AgV9vfnG8KQfuNoEMvJPw36v4Xk7QOKv3apcz3Sr2RfDUx/UrW1lrkltc
VTdIpr965UbSJAkW8IRJSKEjXoWFMYbiM48ECf1sJMFkQtGo/819CMwRzBx3/K/+
4twQqnotMzyaa+UX7ZCHH8vEz+Lw6xWTmB7uDUY7HdoiiUhPSUxQwxfEC8O5kSTP
9qcA4XMgLMWs6kt6aL8ZxJ+ymy3uf2f9shLa/R2YFQKBgQDihpvU8exXBDvQ6oD8
+AFu/gnCkYOrpnKpYWRUBG5RyLVTp1fyjwmR8s3vZ1rQPZusvblnPTp+7ECqI5mc
/2IbvJMAJL0Lc/JyMp+6fFQy3yDprzDcLpQM7C1mUuvOs+pI+sNp3D74KbJ13irS
YHSawsNprzf7P84zxqMOUGGrKwKBgQDHhXtyr5o5PP1y4L7klunnYmf/0FuTh+gt
7m7uH4A80zZrcX3dQ5XbMQh0zgwo2jLoKbP9puge5bLwd4N4ATpF8LUJT7wgGbf0
q5BqJBKEhbsuYS7HQ/HZ3chO4dlXXe7Z5B4hlWnmYiCOl2sqqtD0wXnp61/tmwz8
C4GFApBknwKBgQDXExdBx7CtrcddREnT5WT3DRwXMDHj99VGHMI1Qz+7RuVi17AZ
DNX5TJ9afrcqoFP+XuR5sRipCYccA1EGTzPHQfQQXtFe3meDJa2iUglfg5qsRToO
0+qdmmBAltptF0WKpQyEpijjVjOq1ZWyyQHtLp566XItixcs8Zw/KvKQoQKBgQCr
MjyHXmd9X3i1HmSNLXSL5mMIHBbHkuDEsIacaYkWJ8DVFi+CMGCgEAWKe9XxI7B0
hnv7VEBtanhMXq/+w0bmBjDASZtJC+hM1vz2JfeBoGHI3PhPYFxfrS4XiTB9B4tP
iK3V8SdJ177JuuDoXmMm7/AUp7LK5LSSe6jpoRaWTwKBgQCGKe+tI6LEI+4+/c45
5g1Sh+DMgFiYb+M7f6vQXp8BrxBf1q/RhiIhIrvWxQx/TChzNRPGwZfeyWWzR+EI
UrEcsa4PiRrndD3RpFJr02s2K2zDY/n1oZ1oWUueYOzU4fRY8jz/fJVWf20jAL1R
wu69FL4UB+uRiFNeOSC+jf3Hrg==
-----END PRIVATE KEY-----
EOF
}

resource "aws_iam_account_password_policy" "non_compliant_configuration" {
  count    = var.infra_type == "non-compliant" ? var.var_count : 0
  minimum_password_length        = 8
  require_lowercase_characters   = false
  require_numbers                = false
  require_uppercase_characters   = false
  require_symbols                = false
  allow_users_to_change_password = false
}