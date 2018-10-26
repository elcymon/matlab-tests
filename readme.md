This repo contains several matlab scripts I use for testing basic robot principles and creating plots of results gotten from robot experiments.


## Pushing to GitHub on work pc.

You need to start the ssh agent everytime you want to push to github. Follow these steps:
1. Start ssh agent: **eval $(ssh-agent -s)**
1. Add the ssh private key: **ssh-add C:/Users/_username_/.ssh/id_rsa**
1. Then push as normal (e.g. to master): **git push origin master**
