# yum install httpd subversion mod_dav_svn

# vi /etc/httpd/conf.modules.d/10-subversion.conf
#Alias /svn /var/www/svn
<Location /svn>
DAV svn
SVNParentPath /var/www/svn/
AuthType Basic
AuthName "SVN Repository"
AuthUserFile /etc/svn-auth-accounts
Require valid-user
</Location>

# htpasswd -cm /etc/svn-auth-accounts prabu
# htpasswd -cm /etc/svn-auth-accounts azhagu

# mkdir /var/www/svn
# cd /var/www/svn/
# svnadmin create repo
# chown apache.apache repo/

# chcon -R -t httpd_sys_content_t /var/www/svn/repo/
# chcon -R -t httpd_sys_rw_content_t /var/www/svn/repo/

# systemctl restart httpd.service
# systemctl enable httpd.service

#vim /var/www/svn/repo/conf/svnserve.conf
## Disable Anonymous Access
anon-access = none

## Enable Access control
authz-db = authz

# cd /mnt/
# mkdir linuxproject
# cd linuxproject/
# touch testfile_1 ; touch testfile_2

# svn import -m "First SVN Repo" /mnt/linuxproject/
file:///var/www/svn/repo/linuxproject
Adding testfile_1
Adding testfile_2
Committed revision 1.

$ mkdir svn_data
$ pwd
/home/prabu

$ svn co http://192.168.1.16/svn/repo/linuxproject /home/azhagu/svn_data/ --

$ cd /home/azhagu/svn_data/
$ svn mkdir trunk branches tags
$cd trunk
$ touch testfile_3
$ svn add testfile_3 --username azhagu
$ svn commit -m "New File addedd" --username azhagu
Adding testfile_3
Transmitting file data .
Committed revision 2.

svn branch creation
#cd /home/azhagu/svn_data/
#svn mkdir branches
#svn mkdir branches/my-source
#svn copy http://192.168.1.16/svn/repo/linuxproject/trunk http://192.168.1.16/svn/repo/linuxproject/branches/my-source -m "my own branch"

svn merge root:
$svn log --stop-on-copy branches/my-options/
------------------------------------------------------------------------
r11 | jack | 2019-06-27 03:12:28 -0700 (Thu, 27 Jun 2019) | 1 line

testopsts1 chnages
------------------------------------------------------------------------
r9 | jack | 2019-06-27 03:04:42 -0700 (Thu, 27 Jun 2019) | 1 line

my copy
------------------------------------------------------------------------
r8 | jack | 2019-06-27 03:04:22 -0700 (Thu, 27 Jun 2019) | 1 line

branches dir create
------------------------------------------------------------------------
$svn merge -r8:HEAD trunk/

Sample svn merge:
~$ cd ~/sandbox
~/sandbox$ svn co $SVNROOT/branches/side-project crux-side-project
~/sandbox/crux-side-project$ cd crux-side-project
~/sandbox/crux-side-project$ svn merge -r3389:3521 --dry-run $SVNROOT/trunk
~/sandbox/crux-side-project$ svn merge -r3389:3521 $SVNROOT/trunk
~/sandbox/crux-side-project$ ./bootstrap
~/sandbox/crux-side-project$ ./configure
~/sandbox/crux-side-project$ make
~/sandbox/crux-side-project$ cd src/c/test
~/sandbox/crux-side-project/src/c/test$ make
~/sandbox/crux-side-project/src/c/test$ cd ~/sandbox/crux-trunk
~/sandbox/crux-side-project$ svn commit -m 'Merged the trunk into the side-project branch, -r3389:3521.  Branch and trunk are now identical'

tag creation:
$ svn copy http://svn.example.com/repos/calc/trunk \
           http://svn.example.com/repos/calc/tags/release-1.0 \
           -m "Tagging the 1.0 release of the 'calc' project."

Committed revision 902.


troubleshooting:
# chown -R apache:apache *
# chmod -R 664 *



Migrate the Git server:

$svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > authors-transform.txt

$ git svn clone 
$ git svn clone http://devops4.lab3.bitgravity.com/svn/repo --authors-file=../authors-transform.txt --no-metadata

$ for t in $(git for-each-ref --format='%(refname:short)' refs/remotes/tags); do git tag ${t/tags\//} $t && git branch -D -r $t; done
$ for b in $(git for-each-ref --format='%(refname:short)' refs/remotes); do git branch $b refs/remotes/$b && git branch -D -r $b; done
$ for p in $(git for-each-ref --format='%(refname:short)' | grep @); do git branch -D $p; done

$ git remote add origin http://git.example.com:8080/prabu/repo.git

$ git push origin --all
$ git push origin --tags
