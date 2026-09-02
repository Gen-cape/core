# Dotter
link *args:
    cd areas/external && dotter {{args}}

link-force *args:
    cd areas/external && dotter -f {{args}}

undeploy *args:
    cd areas/external && dotter undeploy {{args}}

switch:
    nh os switch .

boot:
    nh os boot .

home:
    nh home switch .

all:
    nh os switch . && nh home switch .

clean:
    nh clean all
