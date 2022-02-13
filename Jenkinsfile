#!/usr/bin/groovy

pipeline {
    agent any 

    options {
        disableConcurrentBuilds()
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'whaledemo-docker'
    }

    stages {
        stage("Build") {
            steps { buildApp() }
		}

        stage("Push") {
            steps { 
               dockerLogin()
               pushApp() }
		}

        stage("Deploy - Dev") {
            steps { deploy('dev') }
		}

	stage("Test - UAT Dev") {
            steps { runUAT(8888) }
		}

        stage("Deploy - Stage") {
            steps { deploy('stage') }
		}

	stage("Test - UAT Stage") {
            steps { runUAT(88) }
		}

        stage("Approve") {
            steps { approve() }
		}

        stage("Deploy - Live") {
            steps { deploy('live') }
		}

	stage("Test - UAT Live") {
            steps { runUAT(80) }
		}

	}
}


// steps
def buildApp() {
        sh "docker build . --file Dockerfile --tag $DOCKERHUB_CREDENTIALS_USR/$REPO_NAME:${BUILD_NUMBER} --tag $DOCKERHUB_CREDENTIALS_USR/$REPO_NAME:latest"
}

def dockerLogin() {
        sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
}

def pushApp() {
        sh "docker push $DOCKERHUB_CREDENTIALS_USR/$REPO_NAME --all-tags"
}

def deploy(environment) {

	def containerName = ''
	def port = ''

	if ("${environment}" == 'dev') {
		containerName = "app_dev"
		port = "8888"
	} 
	else if ("${environment}" == 'stage') {
		containerName = "app_stage"
		port = "88"
	}
	else if ("${environment}" == 'live') {
		containerName = "app_live"
		port = "80"
	}
	else {
		println "Environment not valid"
		System.exit(0)
	}

	sh "docker ps -f name=${containerName} -q | xargs --no-run-if-empty docker stop"
	sh "docker ps -a -f name=${containerName} -q | xargs -r docker rm"
	sh "docker run -d -p ${port}:80 --name ${containerName} $DOCKERHUB_CREDENTIALS_USR/$REPO_NAME:${BUILD_NUMBER}"

}


def approve() {

	timeout(time:1, unit:'DAYS') {
		input('Do you want to deploy to live?')
	}

}

def runUAT(port) {
	sh "tests/runUAT.sh ${port}"
}
