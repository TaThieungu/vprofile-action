# ===== STAGE 1: BUILD =====
FROM eclipse-temurin:11-jdk AS BUILD_IMAGE

RUN apt-get update && apt-get install -y maven
WORKDIR /vprofile-project

COPY ./ /vprofile-project
RUN mvn clean install -DskipTests

# ===== STAGE 2: RUNTIME =====
FROM tomcat:9.0-jdk11-temurin
LABEL "Project"="Vprofile"
LABEL "Author"="tathieungu"

# Xoá webapps mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# CHÚ Ý: tên file war phải đúng với file trong target
COPY --from=BUILD_IMAGE /vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
