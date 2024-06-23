# Bevezetés
    A feladat célja, hogy egy olyan projektet hozzak létre, ami segítségével .csv adatokat tudjunk vizualizálni webes felületen.
    Erre a választáso a Grafana eszközre esett.
    A Grafana eszközt egy Docker konténerben futtato majd.

# Adatforrás
    Az adatforrás a /megosztottmappa könyvtárban található.
    Egy csv file, ami egy város légszennyezési adatait tartamlazza.
    Részlet az adatokból:
    datetime,indicator_name,indicator_dimension,value
    2024-06-02 17:00:00,Temperature,°C,19.63
    2024-06-02 17:00:00,Humidity,%,16.89
    2024-06-02 17:00:00,Pressure,Pa,98227.02
    2024-06-02 17:00:00,NO₂,ppm,0.2463
    2024-06-02 17:00:00,CO,ppm,0.007

# Konténer

## Dockerfile
    - egy Grafana alapú Docker image-et hoznak létre
    - ebben az image-ben telepítek egy specifikus Grafana plugin-t (marcusolsson-csv-datasource)

## docker-compose.yml
    -  két szolgáltatást (service) határoz meg: grafana és myservice

### grafana szolgáltatás:
    - image: grafana/grafana:latest: A hivatalos Grafana Docker image legújabb verzióját használja.
    - ports: A host gép 3000-es portját a konténer 3000-es portjára irányítja, így a Grafana elérhető lesz a host gépen a http://localhost:3000 címen.
    - volumes: Több kötetet definiál:
        - grafana_data: Tartós adat tárolása a Grafana számára, hogy az adatok megmaradjanak a konténer újraindítása után is.
        - C:\Users\bolcsa\Documents\suli\webvis\final\megosztottmappa:/transfer: A host könyvtárat a konténer /transfer könyvtárába mountolja, ahol a CSV fájl található.
        - C:\Users\bolcsa\Documents\suli\webvis\final\dashboardvaros.json:/var/lib/grafana/dashboards/dashboardvaros.json: A host fájl megosztása a konténerrel, hogy a Grafana dashboard konfigurációját betölthesse.
        - ./grafana-provisioning:/etc/grafana/provisioning: Provisioning konfigurációk megosztása, ahol a datasource.yaml is található.
        - ./refresh.sh:/usr/local/bin/refresh.sh: Egy frissítési script hozzáadása a konténerhez, amit induláskor futtat.
    - environment: Környezeti változók beállítása a Grafana számára:
        - GF_PATHS_CONFIG: Az alapértelmezett konfigurációs fájl helye.
        - GF_PATHS_DATA: Az adatok tárolására használt könyvtár.
        - GF_PATHS_HOME: A Grafana home könyvtára.
        - GF_PATHS_LOGS: A log fájlok könyvtára.
        - GF_PATHS_PLUGINS: A pluginok tárolására használt könyvtár.
        - GF_PATHS_PROVISIONING: A provisioning konfigurációk könyvtára.
        - GF_PLUGIN_ALLOW_LOCAL_MODE: Helyi mód engedélyezése a pluginok számára.
        - GF_INSTALL_PLUGINS: A telepítendő pluginok listája, itt a marcusolsson-csv-datasource plugin.
    - entrypoint: Beállítja a belépési pontot, hogy induláskor futtassa a refresh.sh scriptet, majd indítsa el a Grafana alapértelmezett futtatási parancsát (/run.sh).

### myservice szolgáltatás:
    - build: Megadja az építési kontextust és a Dockerfile helyét:
        - context: .: Az aktuális könyvtárat használja építési kontextusként.
        - dockerfile: Dockerfile: Meghatározza a Dockerfile fájl nevét, amely alapján az image épül.
    - volumes: Egy kötetet határoz meg:
        - C:\Users\bolcsa\Documents\suli\webvis\final\megosztottmappa:/transfer: A host könyvtárat a konténer /transfer könyvtárába mountolja.
    - command: Meghatározza, hogy milyen parancsot futtasson a konténer indításakor:
        - sh -c "while :; do sleep 1; done": Egy végtelen ciklust futtat, hogy a konténer folyamatosan futva maradjon.

    volumes:
    - Definiál egy tartós kötetet (grafana_data), amelyet a grafana szolgáltatás használ a Grafana adatok tárolására

# Dashborard
Egy előre definiált dashboardot hasznlál a rendszer, melyet előre elkészítettem, és betöltésre kerül.

![Kép a már definált és futó DB-ról](https://github.com/bolcsa/SopronUNI_WebVis/blob/f1a39cd402b080fcb81752e6c22d7984600a108b/pictures/grafana-keperny%C5%91.png)


