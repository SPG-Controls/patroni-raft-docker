if [ $# -eq 2 ]
  then
    echo Running version $1 with stack name: $2
    env VERSION=$1 docker stack deploy -c docker-compose.yml $2
  else
    echo "Usage: ./run.sh <version> <stack_name>"
fi