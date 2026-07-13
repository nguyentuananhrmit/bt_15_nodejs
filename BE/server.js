import express from "express";
import cors from "cors";
import rootRouter from "./src/routes/root.router.js";

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Printest API is running");
});

app.use("/api", rootRouter);

app.listen(3061, () => {
  console.log("Server đang chạy ở 3061");
});