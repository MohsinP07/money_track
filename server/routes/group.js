const express = require("express");
const auth = require("../middleware/auth");
const Group = require("../models/group");
const User = require("../models/user");

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

    const group = await Group.findById(groupId);

    if (!group) {
      return res.status(404).json({ error: "Group not found" });
    }

    const expenseExists = group.groupExpenses.some(
      (expense) => expense._id === expenseId
    );

    if (!expenseExists) {
      return res.status(404).json({ error: "Expense not found" });
    }

    group.groupExpenses = group.groupExpenses.filter(
      (expense) => expense._id !== expenseId
    );

    await group.save();

    res.json({ msg: "Expense deleted successfully", group });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

groupRouter.put("/group/remove-member", async (req, res) => {
  try {
    const { groupId, memberId } = req.body;

    if (!groupId || !memberId) {
      return res.status(400).json({ error: "groupId and memberId are required" });
    }

    const group = await Group.findById(groupId);

    if (!group) {
      return res.status(404).json({ error: "Group not found" });
    }

    group.members = group.members.filter((member) => member !== memberId);

    await group.save();

    res.json({ msg: "Member removed successfully", group });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

groupRouter.put("/group/add-members", async (req, res) => {
  try {
    const { groupId, memberEmails } = req.body;
    console.log(groupId);
    console.log(memberEmails);
    if (!groupId || !Array.isArray(memberEmails) || memberEmails.length === 0) {
      return res.status(400).json({ error: "groupId and memberEmails array are required" });
    }

    const group = await Group.findById(groupId);
    if (!group) {
      return res.status(404).json({ error: "Group not found" });
    }

    const users = await User.find({ email: { $in: memberEmails } });
    if (users.length === 0) {
      return res.status(404).json({ error: "No users found for provided emails" });
    }

    const newMemberEmails = memberEmails.filter(email => !group.members.includes(email));

    group.members.push(...newMemberEmails);
    await group.save();


    res.json({
      msg: `${users.length} member(s) added (duplicates skipped if any)`,
      addedMembers: users.map(user => user.email),
      group,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


module.exports = groupRouter;
