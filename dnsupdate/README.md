- Stack Settings -> Use custom Chef cookbooks: Yes

- Stack Settings -> Repository type: Git

- Stack Settings -> Repository URL: https://github.com/user/repo.git

- Stack Settings -> Custom JSON:

```

{
  "dns_forward_zone_id"      : "<private forward zone id>",
  "dns_reverse_zone_id"      : "<private reverse zone id>"
}

```


- Layer Settings -> Recipes -> Custom Chef Recipes -> Configure:

```
  dnsupdate::add

```


- IAM -> Roles -> aws-opsworks-ec2-role -> Create Role Policy:

```

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:GetHostedZone",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/<private forward zone id>",
                "arn:aws:route53:::hostedzone/<private reverse zone id>"
            ]
        }
    ]
}

```