#!/bin/bash

set -e

OPENSEARCH_VERSION="${opensearch_version}"
ADMIN_PASSWORD="${admin_password}"

echo "====================================="
echo "Updating packages"
echo "====================================="
sudo apt-get update -y

echo "====================================="
echo "Installing dependencies"
echo "====================================="
sudo apt-get install -y \
    openjdk-17-jdk \
    wget \
    curl \
    apt-transport-https

echo "====================================="
echo "Downloading OpenSearch"
echo "====================================="
wget -q -O /tmp/opensearch.deb \
https://artifacts.opensearch.org/releases/bundle/opensearch/$${OPENSEARCH_VERSION}/opensearch-$${OPENSEARCH_VERSION}-linux-x64.deb

echo "====================================="
echo "Installing OpenSearch"
echo "====================================="
sudo env OPENSEARCH_INITIAL_ADMIN_PASSWORD="$${ADMIN_PASSWORD}" \
dpkg -i /tmp/opensearch.deb

echo "====================================="
echo "Configuring OpenSearch"
echo "====================================="

sudo tee /etc/opensearch/opensearch.yml >/dev/null <<'OSCFG'
cluster.name: opensearch-cluster
node.name: node-1

network.host: 0.0.0.0
http.port: 9200

discovery.type: single-node

plugins.security.ssl.transport.pemcert_filepath: esnode.pem
plugins.security.ssl.transport.pemkey_filepath: esnode-key.pem
plugins.security.ssl.transport.pemtrustedcas_filepath: root-ca.pem

plugins.security.ssl.http.enabled: true
plugins.security.ssl.http.pemcert_filepath: esnode.pem
plugins.security.ssl.http.pemkey_filepath: esnode-key.pem
plugins.security.ssl.http.pemtrustedcas_filepath: root-ca.pem

plugins.security.allow_default_init_securityindex: true
plugins.security.allow_unsafe_democertificates: true

plugins.security.authcz.admin_dn:
  - "CN=kirk,OU=client,O=client,L=test,C=de"

plugins.security.nodes_dn:
  - "CN=localhost,OU=OpenSearch,O=OpenSearch,L=Test,C=DE"
OSCFG

echo "====================================="
echo "Removing old cluster metadata"
echo "====================================="
sudo systemctl stop opensearch || true
sudo rm -rf /var/lib/opensearch/nodes

echo "====================================="
echo "Starting OpenSearch"
echo "====================================="
sudo systemctl daemon-reload
sudo systemctl enable opensearch
sudo systemctl restart opensearch

echo "Waiting for OpenSearch startup..."
sleep 60

echo "====================================="
echo "OpenSearch Status"
echo "====================================="
sudo systemctl --no-pager -l status opensearch || true

echo "====================================="
echo "Downloading Dashboards"
echo "====================================="
wget -q -O /tmp/opensearch-dashboards.deb \
https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/$${OPENSEARCH_VERSION}/opensearch-dashboards-$${OPENSEARCH_VERSION}-linux-x64.deb

echo "====================================="
echo "Installing Dashboards"
echo "====================================="
sudo dpkg -i /tmp/opensearch-dashboards.deb

echo "====================================="
echo "Configuring Dashboards"
echo "====================================="

sudo tee /etc/opensearch-dashboards/opensearch_dashboards.yml >/dev/null <<DBCFG
server.host: "0.0.0.0"

opensearch.hosts: ["https://localhost:9200"]

opensearch.username: "admin"
opensearch.password: "$${ADMIN_PASSWORD}"

opensearch.ssl.verificationMode: none
DBCFG

echo "====================================="
echo "Starting Dashboards"
echo "====================================="
sudo systemctl enable opensearch-dashboards
sudo systemctl restart opensearch-dashboards

echo "Waiting for Dashboards..."
sleep 30

echo "====================================="
echo "Testing OpenSearch"
echo "====================================="
curl -k -u "admin:$${ADMIN_PASSWORD}" \
https://localhost:9200

echo
echo "====================================="
echo "Service Status"
echo "====================================="
sudo systemctl --no-pager status opensearch | head -20
sudo systemctl --no-pager status opensearch-dashboards | head -20

PUBLIC_IP=$$(curl -s http://checkip.amazonaws.com)

echo
echo "====================================="
echo "ACCESS DETAILS"
echo "====================================="
echo "Dashboard URL : https://$${PUBLIC_IP}:5601"
echo "Username      : admin"
echo "Password      : $${ADMIN_PASSWORD}"
echo "====================================="
