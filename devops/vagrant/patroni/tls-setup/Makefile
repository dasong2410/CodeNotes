.PHONY: cfssl ca req clean

CFSSL	= ./bin/cfssl
JSON	= ./bin/cfssljson

all:  ca req

cfssl:
	HTTPS_PROXY=127.0.0.1:12639 go get -u -tags nopkcs11 github.com/cloudflare/cfssl/cmd/cfssl
	HTTPS_PROXY=127.0.0.1:12639 go get -u github.com/cloudflare/cfssl/cmd/cfssljson
	HTTPS_PROXY=127.0.0.1:12639 go get -u github.com/mattn/goreman

ca:
	mkdir -p certs
	$(CFSSL) gencert -initca config/ca-csr.json | $(JSON) -bare certs/ca

req:
	mkdir -p certs/${infra0}
	mkdir -p certs/${infra1}
	mkdir -p certs/${infra2}

	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/req-csr.json | $(JSON) -bare certs/${infra0}/${infra0}
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/req-csr.json | $(JSON) -bare certs/${infra1}/${infra1}
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/req-csr.json | $(JSON) -bare certs/${infra2}/${infra2}
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/req-csr.json | $(JSON) -bare certs/${infra0}/peer-${infra0}
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/req-csr.json | $(JSON) -bare certs/${infra1}/peer-${infra1}
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/req-csr.json | $(JSON) -bare certs/${infra2}/peer-${infra2}

clean:
	rm -rf certs
