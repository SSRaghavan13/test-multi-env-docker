sudo: required
# install AWS SDK
pip install awscli
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
# docker login -u=${DOCKERHUB_USERNAME} -p=${DOCKERHUB_PASSWORD}

# docker pull ssraghavan13/recipe-app-api:latest

# # build the docker image and push to an image repository
# docker tag ssraghavan13/recipe-app-api:latest 266509442025.dkr.ecr.us-east-2.amazonaws.com/recipe-app-aws:latest
# docker push 266509442025.dkr.ecr.us-east-2.amazonaws.com/recipe-app-aws:latest

# update an AWS ECS service with the new image
ecs-deploy -c recipe-cluster -n recipe-service -i 266509442025.dkr.ecr.us-east-2.amazonaws.com/recipe-app-aws:latest