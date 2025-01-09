const express = require("express"); //importing same like flutter
const mongoose = require("mongoose");

//IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");
const userRouter = require("./routes/user");
const groupRouter = require("./routes/group")

//INIT
const PORT = 3000;
const DB =
  "mongodb+srv://globalmohsinpatel786:80kuEChp527sQ6DT@cluster0.2xjhclh.mongodb.net/";
const app = express();

//MIDDLEWARE
app.use(express.json()); //it passes incoming requests with json payloads
app.use(authRouter);
app.use(userRouter);
app.use(groupRouter);

//Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
