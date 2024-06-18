# Alap image a hivatalos Grafana image
FROM grafana/grafana:latest

# Pluginok telepítése a Grafana CLI használatával
RUN grafana-cli plugins install marcusolsson-csv-datasource