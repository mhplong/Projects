#!/bin/bash

echo 'Deploying Angular Website'
cd ~/GitHub/Projects/angular

npm run-script build.prod

cd ~/GitHub/Deploy/
rm -drf angular
mv ~/GitHub/Projects/angular/dist/angular .

cp angular/index.html 404.html
