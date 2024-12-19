BASTION_HOST="ec2-user@107.23.11.114"
PRIVATE_HOST="10.0.8.121"
LOCAL_PORT="5432"
REMOTE_PORT="5432"
DB_USER="event_ehr"
DB_NAME="event_ehr_dev_db"
SSH_KEY="path/event_ehr.pem"

# Start the SSH tunnel
echo "Establishing SSH tunnel to the private database..."
ssh -i ${SSH_KEY} -fN -L ${LOCAL_PORT}:${PRIVATE_HOST}:${REMOTE_PORT} ${BASTION_HOST}

if [ $? -ne 0 ]; then
echo "Failed to establish SSH tunnel. Please check your SSH and network configurations."
exit 1
fi
echo "SSH tunnel established. Connecting to the database..."

# Connect to the database
psql -h 127.0.0.1 -p ${LOCAL_PORT} -U ${DB_USER} -d ${DB_NAME}
# Use the following for MySQL instead of PostgreSQL:
# mysql -h 127.0.0.1 -P ${LOCAL_PORT} -u ${DB_USER} -p ${DB_NAME}
# Clean up after exiting
echo "Closing the SSH tunnel..."
ssh -O exit ${BASTION_HOST}
echo "Connection closed."
echo "Connection closed."