const express = require('express');
const userRouter = express.Router();
const auth = require('../middleware/auth');
const {Expense} = require('../models/expense');


//Add Expense
userRouter.post("/user/add-expense", auth, async (req, res) => {
    try {
      const { name, description, amount, date, category, expenserId, expenserName, isEdited } = req.body;
  
      const utcDate = new Date(date); // Ensures date is in UTC
  
      let expense = new Expense({
        name,
        description,
        amount,
        date: utcDate,
        category,
        expenserId,
        expenserName,
        isEdited
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
        const expenses = await Expense.find({expenserId: req.user }); //getting all the expenses whatever are available
        res.json(expenses);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }

});

userRouter.post('/user/delete-expense', auth, async (req, res) => {

  try {
      const { id } = req.body;

      let expense = await Expense.findByIdAndDelete(id);

      res.json(expense);

  }
  catch (e) {
      res.status(500).json({ error: e.message });
  }

});

userRouter.put('/user/edit-expense', auth, async (req, res) => {
  try {
      const expenseId = req.body.id; // Assuming you sent the expenseId in the request body
      const { name, description, amount, date, category, isEdited } = req.body; // Get the updated information

      // Update the Expense's information in the database
      await Expense.findByIdAndUpdate(expenseId, { name, description, amount, date, category , isEdited});

      res.json({ msg: "Expense information updated successfully" });
  } catch (e) {
      res.status(500).json({ error: e.message });
  }
});

module.exports = userRouter;