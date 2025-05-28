FROM python:3.6.10

WORKDIR /path-finder

COPY . .

RUN sed -i s/pyproj/pyproj==2.4.2/g requirements_coord.txt &&\
    pip install -r requirements_coord.txt

# Workaround UnicodeDecodeError issue
RUN for y in $(seq 2012 $(date +"%Y")); do \
        curl -o maps/mmb"$y"v-kp.wpt https://mmb.progressor.ru/mmbfiles/mmb"$y"v-kp.wpt &&\
        curl -o maps/mmb"$y"o-kp.wpt https://mmb.progressor.ru/mmbfiles/mmb"$y"o-kp.wpt \
    ; done &&\
    find maps -maxdepth 1 -type f -exec iconv -f utf-8 -t utf-8 -c '{}' -o '{}' \;

ENV PYTHONWARNINGS=ignore::FutureWarning

CMD [ "python", "top_routes_coord.py" ]