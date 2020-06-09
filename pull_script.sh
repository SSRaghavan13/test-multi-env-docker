sudo: required
pip install --user awscli
export PATH=$PATH:$HOME/.local/bin

add-apt-repository ppa:eugenesan/ppa
apt-get update
apt-get install jq -y

before_deploy:

  - 'curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"'

  - 'unzip awscli-bundle.zip'

  - './awscli-bundle/install -b ~/bin/aws'

  - 'export PATH=~/bin:$PATH'

  - 'aws configure'

# install ecs-deploy
curl https://raw.githubusercontent.com/silinternational/ecs-deploy/master/ecs-deploy | \
  sudo tee -a /usr/bin/ecs-deploy
sudo chmod +x /usr/bin/ecs-deploy

eval $(aws ecr get-login --no-include-email --region $AWS_DEFAULT_REGION)


docker-compose -f docker-compose.test.yaml run app sh -c "python manage.py test"
docker build -t ssraghavan13/recipe-app-api .
docker login -u=${DOCKERHUB_USERNAME} -p=${DOCKERHUB_PASSWORD}
docker push ssraghavan13/recipe-app-api:latest

docker tag ssraghavan13/recipe-app-api:latest 266509442025.dkr.ecr.us-east-2.amazonaws.com/recipe-app-aws:latest
docker push 266509442025.dkr.ecr.us-east-2.amazonaws.com/recipe-app-aws:latest