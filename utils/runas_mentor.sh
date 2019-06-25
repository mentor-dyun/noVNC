#!/bin/bash
# ----- change uid/gid of "mentor" user to values
# ----- in $NEWUID and $NEWGID, or 500/500 if they
# ----- are not set, then execute the arguments as
# ----- a command.
#
# ---- usage:
# ----    runas_mentor.sh ls -l .
#
: ${NEWUID=1000}
: ${NEWGID=1000}
#
# ----- we can't change me user to a UID that is
# ----- already in use
#
if [ $(grep -c ":\*:$NEWUID:" /etc/passwd) -gt 0 ]; then
    echo "cannot change me uid to $NEWUID: uid is already in use by:"
    echo $(grep -c ":\*:$NEWUID:")
    exit 1
fi
usermod -u $NEWUID mentor
#
# ----- if a group with GID=$NEWGID already exists
# -----    just switch me to that group, instead
# -----    of changing the GID of the me group
#
if [ $(grep -c ":$NEWGID:" /etc/group) -eq 0 ]; then
    groupmod -g $NEWGID mentor
else
    usermod -g $NEWGID mentor
fi
#
# ---- change the ownership of all of the "me" files to match
# ---- the new UID/GID
# ----- and move the temp $HOME directory to /home/me
# ----- because of the docker weirdness with permissions
#
chown -R mentor:$(id -g mentor)  /home/mentor
usermod --home /home/mentor --move-home mentor
#
# ----- execute the command provides as the "mentor" user
# ----- from the "mentor" home directory
#
cd /home/mentor
exec sudo -E -u mentor "$@"
