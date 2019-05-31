# lambda-rust-sam-example

This is a 'hello world' example for a serverless app written in
[Rust](https://www.rust-lang.org/) that runs in 
[AWS Lambda](https://aws.amazon.com/lambda/).

It's designed for easy use with the
[AWS Serverless Application Model](https://github.com/awslabs/serverless-application-model)
and the [SAM CLI tools](https://github.com/awslabs/aws-sam-cli).

## Contents

```bash
.
├── build.ps1                   <-- Build script for Windows
├── build.sh                    <-- Build script for Linux (TODO)
├── Dockerfile                  <-- Docker image for Rust compilation
├── event.json                  <-- Example event for Lambda function
├── lambda-rust-app             <-- Rust lambda function source code
│   ├── Cargo.lock              <-- Rust dependency version file   
│   ├── Cargo.toml              <-- Rust project metadata file
│   └── src                 
│       └── main.rs             <-- Lambda function code
├── README.md                   <-- This instructions file
├── rustbuild.sh                <-- Script to compile the Rust code
└── template.yaml               <-- CloudFormation SAM template
```

## Requirements

For local development and testing:
* [Docker installed](https://www.docker.com/community-edition)

Additionally, For deployment to AWS:
* [AWS CLI](https://aws.amazon.com/cli/)

## Usage

We'll build the Docker image and then compile the Rust code within
that Docker image for the Lambda target environment. This allows
the creation of Lambda-compatible binaries on any machine that runs
Docker.

On Windows:

```powershell
.\build.ps1
```

On Linux (TODO):

```bash
./build.sh
```

This results in a `bootstrap` binary, which Lambda will run for
you when you set the `runtime` to `provided` (see `template.yaml`)

If you change the Rust code, run the build script again to recompile.
If you modify `rustbuild.sh` you should delete the `rustlambdabuild`
image before rebuilding.

### Local testing

```bash
sam local invoke HelloWorldFunction --event event.json
```

This will execute your Rust code locally via the SAM CLI tools,
in a Docker container that simulates the Lambda runtime environment.
The contents of `event.json` will be passed in as an event.

You can use `sam local generate-event` to create more interesting
test events.

### Packaging and deployment

To run your Rust code via Lambda, you'll need to package the
compiled binary, upload it to an S3 bucket, and then create
a Lambda function from that package.  

This process is made easier using the included SAM template
(template.yaml) and the AWS/SAM CLI tools. See the
[SAM CLI](https://github.com/awslabs/aws-sam-cli)
documentation for detailed guidance on how to do this.
