#!/usr/bin/env bash

REPO_LINK=https://github.com/opstree/spring3hibernate.git
git clone $REPO_LINK
DIR_NAME=$(echo "$REPO_LINK" | sed -E 's|.*/(.*)\.git$|\1|')            # project name to cd into that folder

cd "$DIR_NAME" || exit
if [ $REPO_LINK == "https://github.com/opstree/spring3hibernate.git" ];then     # this project requires java 11
    #install openjdk11
    sudo apt update
    sudo apt install openjdk-11-jdk -y
    sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java
    sudo update-alternatives --set javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac
    sudo apt install maven -y
fi

usage() {
    echo "Usage:"
    echo "-a : Generate Artifact"
    echo "-i : Install artifact to local repo"
    echo "-s <tool> : Static analysis (checkstyle|pmd|findbugs)"
    echo "-t <test_tool> : Unit testing (surefire|jacoco)"
    echo "-d : Deploy to Tomcat"
    exit 1
}

while getopts "ais:t:d" opt; do
    case $opt in 
        a)  
            echo "Generating Artifact..."
            mvn clean package 
            ;;
        i)  
            echo "Installing Artifact to local repo..."
            mvn install 
            ;;
        s)
            tool=$OPTARG
            case $tool in
                checkstyle) 
                    echo "Running Checkstyle..."
                    mvn checkstyle:check
                ;;
                pmd)
                    echo "Running PMD..."
                    mvn pmd:check
                ;;
                findbugs)
                    echo "Running findbugs..."
                    mvn findbugs:check
                ;;
                *)
                    echo "Invalid tool"
                    ;;
            esac    
            ;;
        t)
            test_tool=$OPTARG
            echo "Running $test_tool..."
            case $test_tool in 
                surefire)
                    mvn test
                    ;;
                jacoco)
                    mvn test jacoco:report
                ;;
                *)
                    echo "Invalid test tool"
                ;;
            esac
            ;;
        d)
            echo "Deploying to Tomcat..."
            sudo apt update
            sudo apt install tomcat9 -y
            sudo systemctl start tomcat9
            sudo systemctl enable tomcat9
            sleep 5

            if systemctl is-active --quiet tomcat9; then           
                echo "Tomcat 9 is running!"
            else
                echo "Tomcat 9 failed to start."
                exit 1
            fi

            TOMCAT_WEBAPPS="/var/lib/tomcat10/webapps"
            mvn package -DskipTests
            
            WAR_FILE=$(find target -name "*.war" | head -n 1)

            if [ -f "$WAR_FILE" ]; then
                sudo rm -rf "$TOMCAT_WEBAPPS/ROOT"
                sudo rm -f "$TOMCAT_WEBAPPS/ROOT.war"
                sudo cp "$WAR_FILE" "$TOMCAT_WEBAPPS/ROOT.war"
                sudo chown tomcat:tomcat $TOMCAT_WEBAPPS/ROOT.war
                echo "Deployment successful! Access it at http://localhost:8080/"
            else 
                echo "WAR file not found"
                exit 1
            fi
            ;;
        \?)
            usage
            ;;
    esac

done
