pipeline {
	agent any
	stages {
		stage('build') {
			steps {
				withMaven(jdk: '1.8', maven: '3.5.2') {
					sh "mvn package"
				}
			}
		}
		stage('packer') {
			environment {
				PACKER_HOME = tool name: 'packer-1.1.3', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
				PACKER_SUBSCRIPTION_ID = "fcc1ad01-b8a5-471c-812d-4a42ff3d6074"
				PACKER_CLIENT_ID = "7d68a4b4-e3f1-4bf7-80ee-50a821728ce5"
				PACKER_CLIENT_SECRET = credentials('9b631bcf-6c95-4e73-b497-f5b1964dade0')
				PACKER_LOCATION="westeurope"
				PACKER_TENANT_ID="787717a7-1bf4-4466-8e52-8ef7780c6c42"
				PACKER_OBJECT_ID="56e89fa0-e748-49f4-9ff0-0d8b9e3d4057"
			}
			steps {
				wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
					sh "${PACKER_HOME}/packer validate packer/packer.json"
					sh "${PACKER_HOME}/packer build packer/packer.json"
				}
			}
		}
		stage('terraform') {
			environment {
				TERRAFORM_HOME = tool name: 'terraform-0.11.3'
				ARM_SUBSCRIPTION_ID="fcc1ad01-b8a5-471c-812d-4a42ff3d6074"
				ARM_CLIENT_ID="7d68a4b4-e3f1-4bf7-80ee-50a821728ce5"
				ARM_CLIENT_SECRET="4a3801bb-bef8-44d1-8f1e-8b368e20e90e"
				ARM_TENANT_ID="787717a7-1bf4-4466-8e52-8ef7780c6c42"
				ARM_ENVIRONMENT="public"
			}
			steps {
				dir('terraform') {
					sh "${TERRAFORM_HOME}/terraform init"
					sh "${TERRAFORM_HOME}/terraform plan -out vm-lb-plan"
					sh "${TERRAFORM_HOME}/terraform apply vm-lb-plan"
				}
			}
		}
	}
}