docker create \
      --name srllg \
      -e "STORM_TENANT=688301833"  \
      -e "STORM_USERNAME=kristof.goossens@hpe.com" \
      -e "STORM_PASSWORD=Verhuisd1!!" \
      --net=host performancetesting/stormrunner_load_generator
