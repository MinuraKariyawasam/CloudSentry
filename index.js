// File: index.js

const express = require("express");
const nodemon = require('nodemon')
const { MongoClient } = require('mongodb');
const bodyParser = require("body-parser");

const app = express();
const server = app.listen(3000);

process.on("SIGINT", () => {
  console.log("Server is shutting down...");
  server.close(() => {
    console.log("Server has shut down.");
    process.exit(0);
  });
});

process.on('SIGINT', async () => {
  console.log('Closing MongoDB connection');
  await client.close();
  console.log('MongoDB connection closed');
  process.exit();
});

const io = require("socket.io")(server);

const fs = require("fs");
const { exec } = require("child_process");

// Set up MongoDB connection
const uri = 'mongodb+srv://minurakariyawasaminfo:RyQ3jWW2ZbttOFYD@cluster0.nfyfngf.mongodb.net/?retryWrites=true&w=majority';
const client = new MongoClient(uri, { useNewUrlParser: true });

async function connectToMongoDB() {
  try {
    await client.connect();
    console.log('Connected to MongoDB');
  } catch (err) {
    console.error(err);
  }
}
// initialize the connection object
connectToMongoDB();

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

app.use(express.json());
app.use(express.static("public"));

app.get("/", (req, res) => {
  res.sendFile(`${__dirname}/public/index.html`);
});

app.get("/documentation", (req, res) => {
  res.sendFile(`${__dirname}/public/doc.html`);
});

let isRunning = false;

// Create a write stream
const writeStream = fs.createWriteStream("cloudsentry.log", {
  flags: "a",
  encoding: "utf8",
});

writeStream.write("CloudSentry Monitoring Framework. \n");

app.post("/infra-monitor", (req, res) => {
  res.header("Content-Type", "text/html; charset=utf-8");
  if (isRunning) {
    return res.status(400).send({ error: "Command is already running." });
  }
  isRunning = true;
  // Get the updated values from the POST request
  const resource_group_name = req.body.resource_group_name;
  const subscriptionsId = req.body.subscriptionsId;
  const location = req.body.location;
  const log_file_path = req.body.log_file_path;
  // threshhold values
  let scaleset_name = req.body.scaleset_name;
  // ----------------------
  let cpu_operator = req.body.cpu_operator;
  let cpu_threshold = req.body.cpu_threshold;
  let cpu_severity = req.body.cpu_severity;
  let cpu_frequency = req.body.cpu_frequency;
  let cpu_window_size = req.body.cpu_window_size;
  // ----------------------
  let memory_operator = req.body.memory_operator;
  let memory_threshold = req.body.memory_threshold;
  let memory_severity = req.body.memory_severity;
  let memory_frequency = req.body.memory_frequency;
  let memory_window_size = req.body.memory_window_size;
  // ----------------------
  let appgateway_name = req.body.appgateway_name;
  // ----------------------
  let response_status_operator = req.body.response_status_operator;
  let response_status_threshold = req.body.response_status_threshold;
  let response_status_severity = req.body.response_status_severity;
  let response_status_frequency = req.body.response_status_frequency;
  let response_status_window_size = req.body.response_status_window_size;
  // ----------------------
  let unhealthy_host_count_operator = req.body.unhealthy_host_count_operator;
  let unhealthy_host_count_threshold = req.body.unhealthy_host_count_threshold;
  let unhealthy_host_count_severity = req.body.unhealthy_host_count_severity;
  let unhealthy_host_count_frequency = req.body.unhealthy_host_count_frequency;
  let unhealthy_host_count_window_size = req.body.unhealthy_host_count_window_size;
  // ----------------------
  let database_name = req.body.database_name;
  let server_name = req.body.server_name;
  // ----------------------
  let database_cpu_operator = req.body.database_cpu_operator;
  let database_cpu_threshold = req.body.database_cpu_threshold;
  let database_cpu_severity = req.body.database_cpu_severity;
  let database_cpu_frequency = req.body.database_cpu_frequency;
  let database_cpu_window_size = req.body.database_cpu_window_size;
  // ----------------------
  let database_storage_operator = req.body.database_storage_operator;
  let database_storage_threshold = req.body.database_storage_threshold;
  let database_storage_severity = req.body.database_storage_severity;
  let database_storage_frequency = req.body.database_storage_frequency;
  let database_storage_window_size = req.body.database_storage_window_size;

  let scaleset_scopes = `/subscriptions/${subscriptionsId}/resourceGroups/${resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/${scaleset_name}`;
  let appgateway_scopes = `/subscriptions/${subscriptionsId}/resourceGroups/${resource_group_name}/providers/Microsoft.Network/applicationGateways/${appgateway_name}`;
  let database_scopes = `/subscriptions/${subscriptionsId}/resourceGroups/${resource_group_name}/providers/Microsoft.Sql/servers/${server_name}/databases/${database_name}`

  // Read the contents of the ../automation/var/var.tfvars file
  fs.readFile("var/var.tfvars", "utf8", (err, contents) => {
    if (err) {
      console.error(err);
      return res
        .status(500)
        .send({ error: "Could not read var/var.tfvars file" });
    }

    // Replace the relevant values in the file
    const lines = contents.split("\n");

    for (let i = 0; i < lines.length; i++) {
      if (lines[i].startsWith("resource_group_name")) {
        lines[i] = `resource_group_name = "${resource_group_name}"`;
      }
      if (lines[i].startsWith("location")) {
        lines[i] = `location = "${location}"`;
      }
      if (lines[i].startsWith("subscriptionsId")) {
        lines[i] = `subscriptionsId = "${subscriptionsId}"`;
      }
      if (lines[i].startsWith("log_forwarder_url")) {
        lines[i] = `log_forwarder_url = "${log_file_path}"`;
      }
      if (scaleset_name === '') {
        // --------------- Scaleset CPU
        if (lines[i].startsWith("scaleset_scopes")) {
          lines[i] = `#scaleset_scopes = "${scaleset_scopes}"`;
        }
        if (lines[i].startsWith("cpu_operator")) {
          lines[i] = `#cpu_operator = "${cpu_operator}"`;
        }
        if (lines[i].startsWith("cpu_threshold")) {
          lines[i] = `#cpu_threshold = ${cpu_threshold}`;
        }
        if (lines[i].startsWith("cpu_severity")) {
          lines[i] = `#cpu_severity = ${cpu_severity}`;
        }
        if (lines[i].startsWith("cpu_frequency")) {
          lines[i] = `#cpu_frequency = "${cpu_frequency}"`;
        }
        if (lines[i].startsWith("cpu_window_size")) {
          lines[i] = `#cpu_window_size = "${cpu_window_size}"`;
        }
        // --------------- Scaleset Memory
        if (lines[i].startsWith("memory_operator")) {
          lines[i] = `#memory_operator = "${memory_operator}"`;
        }
        if (lines[i].startsWith("memory_threshold")) {
          lines[i] = `#memory_threshold = ${memory_threshold}`;
        }
        if (lines[i].startsWith("memory_severity")) {
          lines[i] = `#memory_severity = ${memory_severity}`;
        }
        if (lines[i].startsWith("memory_frequency")) {
          lines[i] = `#memory_frequency = "${memory_frequency}"`;
        }
        if (lines[i].startsWith("memory_window_size")) {
          lines[i] = `#memory_window_size = "${memory_window_size}"`;
        }
        // --------------- Application gateway response_status
        if (lines[i].startsWith("appgateway_scopes")) {
          lines[i] = `#appgateway_scopes = ["${appgateway_scopes}"]`;
        }
        if (lines[i].startsWith("response_status_operator")) {
          lines[i] = `#response_status_operator = "${response_status_operator}"`;
        }
        if (lines[i].startsWith("response_status_threshold")) {
          lines[i] = `#response_status_threshold = ${response_status_threshold}`;
        }
        if (lines[i].startsWith("response_status_severity")) {
          lines[i] = `#response_status_severity = ${response_status_severity}`;
        }
        if (lines[i].startsWith("response_status_frequency")) {
          lines[i] = `#response_status_frequency = "${response_status_frequency}"`;
        }
        if (lines[i].startsWith("response_status_window_size")) {
          lines[i] = `#response_status_window_size = "${response_status_window_size}"`;
        }
        // --------------- Application gateway unhealthy_host_count
        if (lines[i].startsWith("unhealthy_host_count_operator")) {
          lines[i] = `#unhealthy_host_count_operator = "${unhealthy_host_count_operator}"`;
        }
        if (lines[i].startsWith("unhealthy_host_count_threshold")) {
          lines[i] = `#unhealthy_host_count_threshold = ${unhealthy_host_count_threshold}`;
        }
        if (lines[i].startsWith("unhealthy_host_count_severity")) {
          lines[i] = `#unhealthy_host_count_severity = ${unhealthy_host_count_severity}`;
        }
        if (lines[i].startsWith("unhealthy_host_count_frequency")) {
          lines[i] = `#unhealthy_host_count_frequency = "${unhealthy_host_count_frequency}"`;
        }
        if (lines[i].startsWith("unhealthy_host_count_window_size")) {
          lines[i] = `#unhealthy_host_count_window_size = "${unhealthy_host_count_window_size}"`;
        }
        // --------------- MySQL Database database_cpu
        if (lines[i].startsWith("database_scopes")) {
          lines[i] = `#database_scopes = ["${database_scopes}"]`;
        }
        if (lines[i].startsWith("database_cpu_operator")) {
          lines[i] = `#database_cpu_operator = "${database_cpu_operator}"`;
        }
        if (lines[i].startsWith("database_cpu_threshold")) {
          lines[i] = `#database_cpu_threshold = ${database_cpu_threshold}`;
        }
        if (lines[i].startsWith("database_cpu_severity")) {
          lines[i] = `#database_cpu_severity = ${database_cpu_severity}`;
        }
        if (lines[i].startsWith("database_cpu_frequency")) {
          lines[i] = `#database_cpu_frequency = "${database_cpu_frequency}"`;
        }
        if (lines[i].startsWith("database_cpu_window_size")) {
          lines[i] = `#database_cpu_window_size = "${database_cpu_window_size}"`;
        }
        // --------------- MySQL Database database_storage
        if (lines[i].startsWith("database_storage_operator")) {
          lines[i] = `#database_storage_operator = "${database_storage_operator}"`;
        }
        if (lines[i].startsWith("database_storage_threshold")) {
          lines[i] = `#database_storage_threshold = ${database_storage_threshold}`;
        }
        if (lines[i].startsWith("database_storage_severity")) {
          lines[i] = `#database_storage_severity = ${database_storage_severity}`;
        }
        if (lines[i].startsWith("database_storage_frequency")) {
          lines[i] = `#database_storage_frequency = "${database_storage_frequency}"`;
        }
        if (lines[i].startsWith("database_storage_window_size")) {
          lines[i] = `#database_storage_window_size = "${database_storage_window_size}"`;
        }
        // uncomment part for the code base
      } else {
        if (lines[i].startsWith("#scaleset_scopes")) {
          lines[i] = `scaleset_scopes = "${scaleset_scopes}"`;
        }
        // ---------------
        if (lines[i].startsWith("#cpu_operator")) {
          lines[i] = `cpu_operator = "${cpu_operator}"`;
        }
        if (lines[i].startsWith("#cpu_threshold")) {
          lines[i] = `cpu_threshold = ${cpu_threshold}`;
        }
        if (lines[i].startsWith("#cpu_severity")) {
          lines[i] = `cpu_severity = ${cpu_severity}`;
        }
        if (lines[i].startsWith("#cpu_frequency")) {
          lines[i] = `cpu_frequency = "${cpu_frequency}"`;
        }
        if (lines[i].startsWith("#cpu_window_size")) {
          lines[i] = `cpu_window_size = "${cpu_window_size}"`;
        }
        // ---------------
        if (lines[i].startsWith("#memory_operator")) {
          lines[i] = `memory_operator = "${memory_operator}"`;
        }
        if (lines[i].startsWith("#memory_threshold")) {
          lines[i] = `memory_threshold = ${memory_threshold}`;
        }
        if (lines[i].startsWith("#memory_severity")) {
          lines[i] = `memory_severity = ${memory_severity}`;
        }
        if (lines[i].startsWith("#memory_frequency")) {
          lines[i] = `memory_frequency = "${memory_frequency}"`;
        }
        if (lines[i].startsWith("#memory_window_size")) {
          lines[i] = `memory_window_size = "${memory_window_size}"`;
        }
        // --------------- Application gateway response_status
        if (lines[i].startsWith("#appgateway_scopes")) {
          lines[i] = `appgateway_scopes = ["${appgateway_scopes}"]`;
        }
        if (lines[i].startsWith("#response_status_operator")) {
          lines[i] = `response_status_operator = "${response_status_operator}"`;
        }
        if (lines[i].startsWith("#response_status_threshold")) {
          lines[i] = `response_status_threshold = ${response_status_threshold}`;
        }
        if (lines[i].startsWith("#response_status_severity")) {
          lines[i] = `response_status_severity = ${response_status_severity}`;
        }
        if (lines[i].startsWith("#response_status_frequency")) {
          lines[i] = `response_status_frequency = "${response_status_frequency}"`;
        }
        if (lines[i].startsWith("#response_status_window_size")) {
          lines[i] = `response_status_window_size = "${response_status_window_size}"`;
        }
        // --------------- Application gateway unhealthy_host_count
        if (lines[i].startsWith("#unhealthy_host_count_operator")) {
          lines[i] = `unhealthy_host_count_operator = "${unhealthy_host_count_operator}"`;
        }
        if (lines[i].startsWith("#unhealthy_host_count_threshold")) {
          lines[i] = `unhealthy_host_count_threshold = ${unhealthy_host_count_threshold}`;
        }
        if (lines[i].startsWith("#unhealthy_host_count_severity")) {
          lines[i] = `unhealthy_host_count_severity = ${unhealthy_host_count_severity}`;
        }
        if (lines[i].startsWith("#unhealthy_host_count_frequency")) {
          lines[i] = `unhealthy_host_count_frequency = "${unhealthy_host_count_frequency}"`;
        }
        if (lines[i].startsWith("#unhealthy_host_count_window_size")) {
          lines[i] = `unhealthy_host_count_window_size = "${unhealthy_host_count_window_size}"`;
        }
        // --------------- MySQL Database database_cpu
        if (lines[i].startsWith("#database_scopes")) {
          lines[i] = `database_scopes = ["${database_scopes}"]`;
        }
        if (lines[i].startsWith("#database_cpu_operator")) {
          lines[i] = `database_cpu_operator = "${database_cpu_operator}"`;
        }
        if (lines[i].startsWith("#database_cpu_threshold")) {
          lines[i] = `database_cpu_threshold = ${database_cpu_threshold}`;
        }
        if (lines[i].startsWith("#database_cpu_severity")) {
          lines[i] = `database_cpu_severity = ${database_cpu_severity}`;
        }
        if (lines[i].startsWith("#database_cpu_frequency")) {
          lines[i] = `database_cpu_frequency = "${database_cpu_frequency}"`;
        }
        if (lines[i].startsWith("#database_cpu_window_size")) {
          lines[i] = `database_cpu_window_size = "${database_cpu_window_size}"`;
        }
        // --------------- MySQL Database database_storage
        if (lines[i].startsWith("#database_storage_operator")) {
          lines[i] = `database_storage_operator = "${database_storage_operator}"`;
        }
        if (lines[i].startsWith("#database_storage_threshold")) {
          lines[i] = `database_storage_threshold = ${database_storage_threshold}`;
        }
        if (lines[i].startsWith("#database_storage_severity")) {
          lines[i] = `database_storage_severity = ${database_storage_severity}`;
        }
        if (lines[i].startsWith("#database_storage_frequency")) {
          lines[i] = `database_storage_frequency = "${database_storage_frequency}"`;
        }
        if (lines[i].startsWith("#database_storage_window_size")) {
          lines[i] = `database_storage_window_size = "${database_storage_window_size}"`;
        }
      }
    }

    const updatedContents = lines.join("\n");

    // Write the updated contents back to the file
    fs.writeFile("var/var.tfvars", updatedContents, "utf8", (err) => {
      if (err) {
        (async () => {
          const { default: stripAnsi } = await import("strip-ansi");
          const { default: ansiRegex } = await import("ansi-regex");
          const strippedData = stripAnsi(
            err.toString().replace(ansiRegex(), "")
          );
          const timestamp = new Date().toISOString();
          writeStream.write(`${timestamp} - ${strippedData}\n`);
          console.log(strippedData);
          return res
            .status(500)
            .send({ error: "Could not write to var/var.tfvars file" });
        })();
      }
      console.log("File updated successfully!");
    });

    // Run the Terraform apply command
    const terraform = exec(
      'terraform init && terraform plan -var-file="var/var.tfvars" -input=false'
    );
    io.sockets.emit("log", `Deploying the monitoring solution.`);
    writeStream.write("Deploying the monitoring solution.");
    terraform.stdout.on("data", (data) => {
      (async () => {
        const { default: stripAnsi } = await import("strip-ansi");
        const { default: ansiRegex } = await import("ansi-regex");
        const strippedData = stripAnsi(
          data.toString().replace(ansiRegex(), "")
        );
        const timestamp = new Date().toISOString();
        writeStream.write(`${timestamp} - ${strippedData}\n`);
        try {
          const db = client.db('mydb'); // Replace with your database name
          const result = await db.collection('logs').insertOne({
            timestamp,
            message: strippedData,
            type: 'stdout',
          });
          console.log(`Inserted log with _id: ${result.insertedId}`);
        } catch (err) {
          console.error(err);
        }
        io.sockets.emit("log", strippedData);
      })();
    });

    terraform.stderr.on("data", (data) => {
      (async () => {
        const { default: stripAnsi } = await import("strip-ansi");
        const { default: ansiRegex } = await import("ansi-regex");
        const strippedData = stripAnsi(
          data.toString().replace(ansiRegex(), "")
        );
        const timestamp = new Date().toISOString();
        writeStream.write(`${timestamp} - ${strippedData}\n`);
        try {
          const db = client.db('mydb'); // Replace with your database name
          const result = await db.collection('logs').insertOne({
            timestamp,
            message: strippedData,
            type: 'stderr',
          });
          console.log(`Inserted log with _id: ${result.insertedId}`);
        } catch (err) {
          console.error(err);
        }
        io.sockets.emit("log", strippedData);
      })();
    });

    terraform.on("close", (code) => {
      (async () => {
        const { default: stripAnsi } = await import("strip-ansi");
        const { default: ansiRegex } = await import("ansi-regex");
        const strippedData = stripAnsi(
          code.toString().replace(ansiRegex(), "")
        );
        const timestamp = new Date().toISOString();
        writeStream.write(`${timestamp} - ${strippedData}\n`);
        try {
          const db = client.db('mydb'); // Replace with your database name
          const result = await db.collection('logs').insertOne({
            timestamp,
            message: strippedData,
            type: 'stdout',
          });
          console.log(`Inserted log with _id: ${result.insertedId}`);
        } catch (err) {
          console.error(err);
        }
        io.sockets.emit(
          "log",
          `Terraform process exited with code ${strippedData}`
        );

        writeStream.write("End of the log session. \n");
        writeStream.write(
          "--------------------------------------------------------------- \n"
        );
        if (code === 1) {
          console.log("Terraform process exited with code 1, restarting server with nodemon...");
          nodemon.restart();
          terraform.kill();
          isRunning = false;
        } else {
          process.exit(code);
        }
      })();
    });
  });
});

app.post("/restart-server", (req, res) => {
  // Check if the server is already restarting
  if (isRestarting) {
    io.sockets.emit("log", `Server is already restarting.`);
    writeStream.write("Server is already restarting.");
    return res.status(400).send({ error: "Server is already restarting" });
  }

  // Set the flag to indicate that the server is restarting
  isRestarting = true;

  // Perform any necessary operations to restart the server
  // ...

  // Return a success response
  io.sockets.emit("log", `Server is restarting.`);
  writeStream.write("Server is restarting.");
  return res.status(200).send({ message: "Server is restarting" });
});

app.post("/re-initialize", (req, res) => {
  res.header("Content-Type", "text/html; charset=utf-8");
  if (isRunning) {
    io.sockets.emit("log", `Command is already running.`);
    writeStream.write("Command is already running");
    return res.status(400).send({ error: "Command is already running" });
  }
  isRunning = true;
  // Read the contents of the ../automation/var/var.tfvars file
  fs.readFile("var/var.tfvars", "utf8", (err, contents) => {
    if (err) {
      console.error(err);
      return res
        .status(500)
        .send({ error: "Could not read var/var.tfvars file" });
    }
    // Run the Terraform apply command
    // terraform init && terraform plan -var-file="var/var.tfvars" -auto-approve
    const terraform = exec(
      'terraform init && terraform plan -var-file="var/var.tfvars" -out -input=false'
    );
    io.sockets.emit("log", `Deploying the monitoring solution.`);
    writeStream.write("Deploying the monitoring solution.");
    terraform.stdout.on("data", (data) => {
      (async () => {
        const { default: stripAnsi } = await import("strip-ansi");
        const { default: ansiRegex } = await import("ansi-regex");
        const strippedData = stripAnsi(
          data.toString().replace(ansiRegex(), "")
        );
        const timestamp = new Date().toISOString();
        writeStream.write(`${timestamp} - ${strippedData}\n`);
        try {
          const db = client.db('mydb'); // Replace with your database name
          const result = await db.collection('logs').insertOne({
            timestamp,
            message: strippedData,
            type: 'stdout',
          });
          console.log(`Inserted log with _id: ${result.insertedId}`);
        } catch (err) {
          console.error(err);
        }
        io.sockets.emit("log", strippedData);
      })();
    });

    terraform.stderr.on("data", (data) => {
      (async () => {
        const { default: stripAnsi } = await import("strip-ansi");
        const { default: ansiRegex } = await import("ansi-regex");
        const strippedData = stripAnsi(
          data.toString().replace(ansiRegex(), "")
        );
        const timestamp = new Date().toISOString();
        writeStream.write(`${timestamp} - ${strippedData}\n`);
        try {
          const db = client.db('mydb'); // Replace with your database name
          const result = await db.collection('logs').insertOne({
            timestamp,
            message: strippedData,
            type: 'stderr',
          });
          console.log(`Inserted log with _id: ${result.insertedId}`);
        } catch (err) {
          console.error(err);
        }
        io.sockets.emit("log", strippedData);
      })();
    });

    terraform.on("close", (code) => {
      (async () => {
        const { default: stripAnsi } = await import("strip-ansi");
        const { default: ansiRegex } = await import("ansi-regex");
        const strippedData = stripAnsi(
          code.toString().replace(ansiRegex(), "")
        );
        const timestamp = new Date().toISOString();
        writeStream.write(`${timestamp} - ${strippedData}\n`);
        try {
          const db = client.db('mydb'); // Replace with your database name
          const result = await db.collection('logs').insertOne({
            timestamp,
            message: strippedData,
            type: 'stdout',
          });
          console.log(`Inserted log with _id: ${result.insertedId}`);
        } catch (err) {
          console.error(err);
        }
        io.sockets.emit(
          "log",
          `Terraform process exited with code ${strippedData}`
        );

        writeStream.write("End of the log session. \n");
        writeStream.write(
          "--------------------------------------------------------------- \n"
        );
        if (code === 0) {
          console.log("Terraform process exited with code 1, restarting server with nodemon...");
          nodemon.restart();
          terraform.kill();
          isRunning = false;
        } else {
          process.exit(code);
        }
      })();
    });
  });
});
