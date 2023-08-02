import express, { Request, Response } from "express";
import getFromAddress from "./networkController"


// ${SERVER_PORT}
const PORT = 3000;

const app = express();
app.get("/", (req, res) => {
  new Promise(r => setTimeout(r, 1000));
  res.send("Request processed!");
});

app.listen(PORT, () => {
  console.log(`Running on ${PORT}`);
});
