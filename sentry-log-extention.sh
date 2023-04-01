# Set the MongoDB connection URI
uri='mongodb+srv://minurakariyawasaminfo:RyQ3jWW2ZbttOFYD@cluster0.nfyfngf.mongodb.net/?retryWrites=true&w=majority'

# Set the name of the database and collection to store logs
database='mydb'
collection='app_logs'

# Set the path to the log file to monitor
log_file='/var/log/test.log'

# Start tailing the log file and sending new data to MongoDB
tail -F $log_file | while read line
do
  # Extract the relevant data from the log line
  date=$(echo $line | awk '{print $1}')
  time=$(echo $line | awk '{print $2}')
  level=$(echo $line | awk '{print $3}')
  message=$(echo $line | awk '{$1=$2=$3=""; print $0}')

  # Build the JSON object to send to MongoDB
  json="{\"date\":\"$date\",\"time\":\"$time\",\"level\":\"$level\",\"message\":\"$message\"}"

  # Send the JSON object to MongoDB using the `mongoimport` command
  echo $json | mongoimport --uri=$uri --collection=$collection --quiet
done