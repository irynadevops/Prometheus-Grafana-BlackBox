##  Script for setup grafana dashboards

##----------------------------------------------------------------------##
##  You can add this file in "startup.sh" to the "/tmp/grafana" folder  ## 
##  and uncomment in docker-compose section a few string (endpoint and  ## 
##  volumes) in grafana service description                             ##
##----------------------------------------------------------------------##

cat << EOF > /tmp/grafana/setup.sh
#!/bin/bash

GRAFANA_URL=${GRAFANA_URL:-http://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@localhost:3000}
#GRAFANA_URL=http://grafana-plain.k8s.playground1.aws.ad.zopa.com
DATASOURCES_PATH=${DATASOURCES_PATH:-/etc/grafana/datasources}
DASHBOARDS_PATH=${DASHBOARDS_PATH:-/etc/grafana/dashboards}

## Funcion for api
grafana_api() {
  local verb=$1
  local url=$2
  local params=$3
  local bodyfile=$4
  local response
  local cmd

  cmd="curl -L -s --fail -H \"Accept: application/json\" -H \"Content-Type: application/json\" -X ${verb} -k ${GRAFANA_URL}${url}"
  [[ -n "${params}" ]] && cmd="${cmd} -d \"${params}\""
  [[ -n "${bodyfile}" ]] && cmd="${cmd} --data @${bodyfile}"
  echo "Running ${cmd}"
  eval ${cmd} || return 1
  return 0
}

wait_for_api() {
  while ! grafana_api GET /api/user/preferences
  do
    sleep 5
  done 
}

## Install datasources
install_datasources() {
  local datasource

  for datasource in ${DATASOURCES_PATH}/*.json
  do
    if [[ -f "${datasource}" ]]; then
      echo "Installing datasource ${datasource}"
      if grafana_api POST /api/datasources "" "${datasource}"; then
        echo "installed ok"
      else
        echo "install failed"
      fi
    fi
  done
}

## Install downloaded dashboards from folder
install_dashboards() {
  local dashboard

  for dashboard in ${DASHBOARDS_PATH}/*.json
  do
    if [[ -f "${dashboard}" ]]; then
      echo "Installing dashboard ${dashboard}"

      echo "{\"dashboard\": `cat $dashboard`}" > "${dashboard}.wrapped"

      if grafana_api POST /api/dashboards/db "" "${dashboard}.wrapped"; then
        echo "installed ok"
      else
        echo "install failed"
      fi

      rm "${dashboard}.wrapped"
    fi
  done
}

## Config grafana
configure_grafana() {
  wait_for_api
  install_datasources
  install_dashboards
}

## Run grafana in background
echo "Running configure_grafana in the background..."
configure_grafana &
/run.sh
exit 0
EOF
