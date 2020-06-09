# install AWS SDK
pip install --user awscli
export PATH=$PATH:$HOME/.local/bin

# install necessary dependency for ecs-deploy
add-apt-repository ppa:eugenesan/ppa
apt-get update
apt-get install jq -y

# install ecs-deploy
curl https://raw.githubusercontent.com/silinternational/ecs-deploy/master/ecs-deploy | \
  sudo tee -a /usr/bin/ecs-deploy
sudo chmod +x /usr/bin/ecs-deploy

# login AWS ECR
eval $(aws ecr get-login --region us-east-2)

# or login DockerHub
# docker login --username $DOCKER_HUB_USER --password $DOCKER_HUB_PSW

# build the docker image and push to an image repository
docker build -t auto-deploy-aws .
docker tag auto-deploy:latest 266509442025.dkr.ecr.us-east-2.amazonaws.com/recipe-app-aws:latest:latest
docker push 266509442025.dkr.ecr.us-east-2.amazonaws.com/recipe-app-aws:latest:latest

# update an AWS ECS service with the new image
ecs-deploy -c recipe-cluster -n recipe-service -i 266509442025.dkr.ecr.us-east-2.amazonaws.com/recipe-app-aws:latest:latest