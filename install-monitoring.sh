#!/usr/bin/env bash

set -euo pipefail

PROM_VERSION="${PROM_VERSION:-2.53.3}"
NODE_EXPORTER_VERSION="${NODE_EXPORTER_VERSION:-1.8.2}"
ARCH="linux-amd64"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

log() { echo -e "\n\033[1;32m==> $*\033[0m"; }

[[ $EUID -eq 0 ]] || { echo "Запускать от root"; exit 1; }

log "Базовые пакеты"
apt-get update -qq
apt-get install -y -qq curl wget tar adduser libfontconfig1 musl ca-certificates gnupg

# ---------------------------------------------------------------- node_exporter
log "node_exporter ${NODE_EXPORTER_VERSION}"
id -u node_exporter &>/dev/null || useradd --no-create-home --shell /usr/sbin/nologin node_exporter
wget -qO "$TMP/ne.tar.gz" \
  "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.${ARCH}.tar.gz"
tar -xzf "$TMP/ne.tar.gz" -C "$TMP"
install -o node_exporter -g node_exporter -m 0755 \
  "$TMP/node_exporter-${NODE_EXPORTER_VERSION}.${ARCH}/node_exporter" /usr/local/bin/node_exporter

cat > /etc/systemd/system/node_exporter.service <<'EOF'
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter \
  --collector.systemd \
  --collector.processes \
  --web.listen-address=0.0.0.0:9100
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# ------------------------------------------------------------------- prometheus
log "prometheus ${PROM_VERSION}"
id -u prometheus &>/dev/null || useradd --no-create-home --shell /usr/sbin/nologin prometheus
mkdir -p /etc/prometheus/rules /var/lib/prometheus
wget -qO "$TMP/prom.tar.gz" \
  "https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.${ARCH}.tar.gz"
tar -xzf "$TMP/prom.tar.gz" -C "$TMP"
SRC="$TMP/prometheus-${PROM_VERSION}.${ARCH}"
install -m 0755 "$SRC/prometheus" /usr/local/bin/prometheus
install -m 0755 "$SRC/promtool"   /usr/local/bin/promtool
cp -r "$SRC/consoles" "$SRC/console_libraries" /etc/prometheus/

cat > /etc/prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'nodeexporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
EOF

chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
chmod 0644 /etc/prometheus/prometheus.yml   # файл уже существует — порядок важен

cat > /etc/systemd/system/prometheus.service <<'EOF'
[Unit]
Description=Prometheus Server
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --storage.tsdb.retention.time=200h \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

promtool check config /etc/prometheus/prometheus.yml

# ---------------------------------------------------------------------- grafana
log "grafana"

install_grafana_github() {
  echo "Cтавим .deb с GitHub Releases"
  local url
  url=$(curl -fsSL https://api.github.com/repos/grafana/grafana/releases/latest \
        | grep -o 'https://[^"]*amd64\.deb' | grep -v enterprise | head -n1)
  [[ -n "$url" ]] || { echo "Не удалось определить ссылку на .deb"; exit 1; }
  wget -qO "$TMP/grafana.deb" "$url"
  apt-get install -y -qq "$TMP/grafana.deb"
}


install_grafana_apt || install_grafana_github


mkdir -p /etc/grafana/provisioning/datasources
cat > /etc/grafana/provisioning/datasources/prometheus.yml <<'EOF'
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
    editable: true
EOF
chown -R root:grafana /etc/grafana/provisioning

# --------------------------------------------------------------------- запуск
log "Старт сервисов"
systemctl daemon-reload
systemctl enable --now node_exporter prometheus grafana-server
sleep 5
systemctl --no-pager --lines=0 status node_exporter prometheus grafana-server || true

log "Готово"
echo "Prometheus : http://$(hostname -I | awk '{print $1}'):9090"
echo "Grafana    : http://$(hostname -I | awk '{print $1}'):3000 (admin / admin)"
