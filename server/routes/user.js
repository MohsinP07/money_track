const express = require('express');
const userRouter = express.Router();
const auth = require('../middleware/auth');
const {Expense} = require('../models/expense');


//Add Expense
userRouter.post("/user/add-expense", auth, async (req, res) => {
    try {
      const { name, description, amount, date, category, expenserId, expenserName } = req.body;
  
      const utcDate = new Date(date); // Ensures date is in UTC
  
      let expense = new Expense({
        name,
        description,
        amount,
        date: utcDate,
        category,
        expenserId,
        expenserName,
      });
  
      expense = await expense.save();
      res.json(expense); // send to client side
      console.log(expense);
    }
    catch (e) {
      res.status(500).json({ error: e.message });
    }
  });


userRouter.get('/user/get-expenses', auth, async (req, res) => {

    try {
        const expenses = await Expense.find({}); //getting all the expenses whatever are available
        res.json(expenses);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }

});

module.exports = userRouter;