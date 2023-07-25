import express, { Request, Response } from "express";

// ${SERVER_PORT}
const PORT = 3000;

const app = express();
app.get("/", (req: Request, res: Response) => {
  new Promise(r => setTimeout(r, 2000));
  res.send("Request processed!");
});

app.listen(PORT, () => {
  console.log(`Running on ${PORT}`);
});
