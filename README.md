# ecs-cicd-demo
This demo is to demonstrate how to use Codepipeline to create a pipeline for services on ECS.

Clarification of the files

```
.
├── Dockerfile      # Docker file
├── LICENSE
├── README.md
├── api.py          # Demo App
└── buildspec.yml    # CodeBuild use this to instruct its build steps
```

## Prepare your environment

### Setup your github repo
```bash
git clone <this repo>
cp * <your dir>
git push <your repo>
```
### Setup your docker runtime

### Setup ECR
#### make sure you can login ECR
```
$(aws ecr get-login --no-include-email --region us-west-2)
```

#### build your images
```bash
docker build -t <YOUR_ECR_URL>/apidemo80:1 .
docker push  <YOUR_ECR_URL>/apidemo80:1
```

### Setup Task definition
In ***Add container***  step, make sure you *specify the image & image tag, NOT ':latest'*, it named your container, the name will be used in CodeBuild

### Setup ECS cluster
Choose either Fargate or EC2

### Setup ALB for ECS service

* Before setup ECS service, create an ALB & target group without target group targets
* Setup a proper health check intervals and other timing parameters, otherwise the service update process could be very long.

### Setup ECS service

* Specify ***Task definition*** defined in previous step
* For Fargate,  ***dynamic port mapping*** for ALB is not available, container port & service port should be the same, make sure you set the correct container port in DockerFile.

#### Ensure ECS service works
```bash
curl <ALB entry>
```
#### Ensure ECS service update works
##### build a new image
```bash
#update api.py to another version
#build a new images with new tag
docker build -t 211752457047.dkr.ecr.us-west-2.amazonaws.com/apidemo80:2 .
docker push 211752457047.dkr.ecr.us-west-2.amazonaws.com/apidemo80:2
```
##### define a new task definition
update *task definition* with new container definition
click update service and point to another *task definition*

### Create a pipeline
#### Source
Choose github and follow the instructions
#### Build
Choose CodeBuild

For **buildspec** file, set use the *buildspec.yml* in the repo root dir.
Pay attention to the variables in *buildspec.yml*
Configure **Advanced options**
Setup environment variables
```
AWS_ACCOUNT_ID	e.g. 211752457047
AWS_DEFAULT_REGION    e.g. us-west-2
IMAGE_REPO_NAME    e.g. apidemo80
CONTAINER_NAME    e.g. apidemo80(you defined it in *Task definition*)
```

By CodeBuild create a role for you automatically, however this role does not have permission to access ECR. **Add AmazonEC2ContainerRegistryFullAccess** policy to this role manually.


#### Deploy
##### Choose *Amazon ECS*
For image file, use *imagedefinitions.json*, it is defined in the *buildspec.yml*, in this line,
```
printf '[{"name":"$CONTAINER_NAME","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json*
```

### Test run
It would run the pipeline automatically right after you create the pipeline.
If encounter any error, refer to the error message and details for troubleshooting.
After that, update the version attribute in ***api.py*** then push

## License
This library is licensed under the MIT-0 License. See the LICENSE file.