## Introduction

This recipe creates forward and reverse DNS entries in the AWS Route53 Private Hosted Zones.

## Usage

- Create forward and reverse zones for your domain in AWS Route53, if you haven't already done so.

for instance:

```

  example.com   

  30.172.in-addr.arpa

```

Above reverse zone example is for VPCs that have 172.30.0.0/16 network. Create reverse zone with regards to your VPC settings.

Note down the Zone IDs for both of your forward and reverse zones.


- Stack Settings -> Use custom Chef cookbooks: Yes

- Stack Settings -> Repository type: Git

- Stack Settings -> Repository URL: https://github.com/user/repo.git

- Stack Settings -> Custom JSON:

```

{
  "dns_forward_zone_name" : "<example.com>",
  "dns_forward_zone_id"   : "<private forward zone id>",
  "dns_reverse_zone_name" : "<b.a.in-addr.arpa>",
  "dns_reverse_zone_id"   : "<private reverse zone id>"
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
