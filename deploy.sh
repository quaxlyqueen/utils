# Deploy script for use in CI/CD pipeline for multiple projects.

PROJECT=$1
IMAGE=""
CONTAINER=""
PORT=""
getProject $PROJECT

function getProject {
  case "$1" in
    "portfolio-client")
      $IMAGE="portfolio-c"
      $CONTAINER="portfolio-container"
      $PORT="3000"

      cd portfolio/client
      update
      buildAndDeploy
    ;;
    "portfolio-server")
      $IMAGE="portfolio-s"
      $CONTAINER="portfolio-server"
      $PORT="3001"
      
      cd portfolio/server
      update
      buildAndDeploy
    ;;
    "cs2440")
      cd cs2440
      update
    ;;
    *)
      echo "Project not setup for CI/CD."
    ;;
  esac
}

function update {
  ssh git@github.com
  git switch main
  git fetch origin
  git reset --hard origin/main
  git clean -fd
}

function buildAndDeploy {
  docker stop $CONTAINER
  docker build -t $IMAGE:latest
  docker run -p $PORT:$PORT -d --name $CONTAINER $IMAGE
}
