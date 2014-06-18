while true; do [ -f pom.xml ] && break; cd ..; done; mvn clean generate-sources

gnome-open target/docbkx || open target/docbkx
