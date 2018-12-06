
```
$ aws acm import-certificate --profile onepoint-lab --certificate file://modules/lb/certificate.pem --private-key file://modules/lb/key.pem --certificate-chain file://modules/lb/certificate.pem
```

```
$ aws acm delete-certificate --certificate-arn ...
```