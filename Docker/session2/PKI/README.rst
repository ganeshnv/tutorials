OpenSSL cert:
--------------

# mkdir /root/ca

# cd /root/ca

# mkdir certs crl newcerts private

# chmod 700 private

# touch index.txt

# echo 1000 > serial

<place the ca-openssl.cnf file into /root/ca/openssl.cnf>

**Generate CA KEY**

# openssl genrsa -aes256 -out private/ca.key.pem 4096

> Give the ROOT CA KEY PASSWD

# chmod 400 private/ca.key.pem

**Generate CA cert** 

# openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem

# chmod 444 certs/ca.cert.pem

**Verify CA**
# openssl x509 -noout -text -in certs/ca.cert.pem

**Intermediate CA Cert**

# mkdir /root/ca/intermediate

# cd /root/ca/intermediate

# mkdir certs crl csr newcerts private

# chmod 700 private

# touch index.txt

# echo 1000 > serial

# echo 1000 > /root/ca/intermediate/crlnumber

<Paste the in-ca-openssl.cnf into /root/ca/intermediate/openssl.cnf>

**Generate Intermediate Cert Request**

# cd /root/ca

# openssl genrsa -aes256 -out intermediate/private/intermediate.key.pem 4096

<Give the Strong Intermediate CA KEY Password>

# chmod 400 intermediate/private/intermediate.key.pem

**Generate intermediate ca cert**

# openssl req -config intermediate/openssl.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -out intermediate/csr/intermediate.csr.pem

**Sing intermediate CA cert with Root cert**

# openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in intermediate/csr/intermediate.csr.pem -out intermediate/certs/intermediate.cert.pem
< Enter the Root CA KEY password>

# chmod 444 intermediate/certs/intermediate.cert.pem 

**verify intermedia CA cert**

# openssl x509 -noout -text -in intermediate/certs/intermediate.cert.pem

# openssl verify -CAfile certs/ca.cert.pem intermediate/certs/intermediate.cert.pem

**Generate the Chain CA certificate**

# cat intermediate/certs/intermediate.cert.pem erts/ca.cert.pem > intermediate/certs/ca-chain.cert.pem

# chmod 444 intermediate/certs/ca-chain.cert.pem

**Generate the Client KEY cert**

# openssl genrsa -out intermediate/private/docker1.example.com.key.pem 4096 

# openssl req -config intermediate/openssl.cnf -key intermediate/private/docker1.example.com.key.pem -new -sha256 -out intermediate/csr/docker1.example.com.csr.pem

**Sing Client cert with intermediate CA private key**

# openssl ca -config intermediate/openssl.cnf -extensions server_cert -days 375 -notext -md sha256 -in intermediate/csr/docker1.example.com.csr.pem -out intermediate/certs/docker1.example.com.cert.pem
<Give the intermedia CA KEY password>

# chmod 444 intermediate/certs/docker1.example.com.cert.pem

**Verify the Client Cert**

# openssl verify -CAfile intermediate/certs/ca-chain.cert.pem intermediate/certs/docker1.example.com.cert.pem

**Copy into Docker Server**

# scp intermediate/certs/ca-chain.cert.pem intermediate/certs/docker1.example.com.cert.pem intermediate/private/docker1.example.com.key.pem root@docker1.example.com:/root/docker/cert.d/

**Configre Docker daemon**

# vi /etc/docker/daemon.json

{
  "debug": true,
  "tls": true,
  "tlsverify": true,
  "tlscacert": "/etc/docker/cert.d/ca-chain.cert.pem",
  "tlscert": "/etc/docker/cert.d/docker1.example.com.cert.pem",
  "tlskey": "/etc/docker/cert.d/docker1.example.com.key.pem",
  "hosts": ["tcp://0.0.0.0:2376"]
}

**Extra PKI configuration**

**Create CRL**

# cd /root/ca

# openssl ca -config intermediate/openssl.cnf -gencrl -out intermediate/crl/intermediate.crl.pem

**Check the CRL**

# openssl crl -in intermediate/crl/intermediate.crl.pem -noout -text
<No Revoked Certificates>

**Revoke the Certificate**

# openssl ca -config intermediate/openssl.cnf -revoke intermediate/certs/docker1.example.com.cert.pem
<Enter the intermediate CA Key Password>

More Info: https://jamielinux.com/docs/openssl-certificate-authority/certificate-revocation-lists.html
