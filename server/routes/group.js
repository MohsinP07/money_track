const express = require("express");
const auth = require("../middleware/auth");
const Group = require("../models/group");

const groupRouter = express.Router();

groupRouter.post("/group/add-group", async (req, res) => {
  try {
    const { groupName, groupDescription, budget, admin, members } = req.body;

    if (!groupName || !groupDescription || !budget || !admin) {
      return res.status(400).json({ error: "All required fields must be filled" });
    }

    const group = new Group({
      groupName,
      groupDescription,
      budget,
      admin,
      members, 
    });

    const savedGroup = await group.save();

    res.json(savedGroup); 
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

groupRouter.get('/group/get-groups', async (req, res) => {

  try {
      const groups = await Group.find({expenserId: req.user }); 
      res.json(groups);
  }
  catch (e) {
      res.status(500).json({ error: e.message });
  }

});

groupRouter.put('/group/edit-group', async (req, res) => {
  try {
      const groupId = req.body.id;
      const { groupName, groupDescription, budget } = req.body; 

      await Group.findByIdAndUpdate(groupId, { groupName, groupDescription, budget});

      res.json({ msg: "Group updated successfully" });
  } catch (e) {
      res.status(500).json({ error: e.message });
  }
});

groupRouter.post('/group/delete-group', async (req, res) => {

  try {
      const { id } = req.body;

      let group = await Group.findByIdAndDelete(id);

      res.json(group);

  }
  catch (e) {
      res.status(500).json({ error: e.message });
  }
});


groupRouter.put('/group/add-group-expense', async (req, res) => {
  try {
    const { id: groupId, groupExpenses } = req.body;

    await Group.findByIdAndUpdate(groupId, {
      $push: { groupExpenses }
    });

    res.json({ msg: "Group Expense Added successfully" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


groupRouter.put('/group/edit-group-expense', async (req, res) => {
  try {
      const { groupId, expenseId, updatedExpense } = req.body;

      console.log(req.body);

      const group = await Group.findById(groupId);

      if (!group) {
          return res.status(404).json({ error: 'Group not found' });
      }

      const expenseIndex = group.groupExpenses.findIndex(
          (expense) => expense._id === expenseId
      );

      if (expenseIndex === -1) {
          return res.status(404).json({ error: 'Expense not found' });
      }

      group.groupExpenses[expenseIndex] = {
          ...group.groupExpenses[expenseIndex],
          ...updatedExpense,
      };

      console.log('Updated Expense:', group.groupExpenses[expenseIndex]);

      await group.save();

      res.json({ msg: 'Expense updated successfully', group });
  } catch (e) {
      console.error(e);
      res.status(500).json({ error: e.message });
  }
});

groupRouter.put('/group/delete-group-expense', async (req, res) => {
  try {
    const { groupId, expenseId } = req.body;

    // Find the group by ID
    const group = await Group.findById(groupId);

    if (!group) {
      return res.status(404).json({ error: "Group not found" });
    }

    // Check if the expense exists in the groupExpenses array
    const expenseExists = group.groupExpenses.some(
      (expense) => expense._id === expenseId
    );

    if (!expenseExists) {
      return res.status(404).json({ error: "Expense not found" });
    }

    // Filter out the expense with the given expenseId
    group.groupExpenses = group.groupExpenses.filter(
      (expense) => expense._id !== expenseId
    );

    // Save the updated group
    await group.save();

    res.json({ msg: "Expense deleted successfully", group });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = groupRouter;
