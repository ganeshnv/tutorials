## GIT Tutorials

### Git Installation

- Centos 
  ``` #yum install git ```
- Ubuntu
   ``` #sudo apt-get install git ```

### Git Configuration 

``` #git config --global user.name "user"```
``` #git config --global user.email "user@example.com"```

### Git Branch

- Create Branch
``` #git branch <branch_name>```
- Delete Branch
``` # git branch -d <branch_name> ```
	- ```-D``` Option --force delete if content not commit
	
### Git clone specific folder
$ mkdir pcl-examples
$ cd pcl-examples					\#make a directory we want to copy folders to
$ git init                            			\#initialize the empty local repo
$ git remote add origin -f https://github.com/PointCloudLibrary/pcl.git     \#add the remote origin
$ git config core.sparsecheckout true			\#very crucial. this is where we tell git we are checking out specifics
$ echo "examples/*" >> .git/info/sparse-checkout #recursively checkout examples folder
$ git pull --depth=2 origin master			\#go only 2 depths down the examples directory
 
