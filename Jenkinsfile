pipeline{
    agent any 
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-south-1"
    }
    
    stages{
        stage('Checkout SCM') {
            steps {
                script{
                    git branch: 'main', url: 'https://github.com/Devopswithaws58/EKS-Terraform-Jenkins.git'
                }
            }
        }
   }
}