# Dotter link non forced
link *args:
    cd areas/external && dotter {{ args }}
# Dotter link forced
link-force *args:
    cd areas/external && dotter -f {{ args }}
# Dotter remove symlinks
undeploy *args:
    cd areas/external && dotter undeploy {{ args }}
# Switch system via nh
switch:
    nh os switch .
# Boot-switch system via nh
boot:
    nh os boot .
# Switch home manager via nh
home:
    nh home switch .
# Switch both system and home-manager
all:
    nh os switch . && nh home switch .
# Deep clean via nh
clean:
    nh clean all
