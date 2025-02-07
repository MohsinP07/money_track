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

groupRouter.get("/group/get-group-expenses/:groupId", async (req, res) => {
  try {
    const { groupId } = req.params;

    const group = await Group.findById(groupId);

    if (!group) {
      return res.status(404).json({ error: "Group not found" });
    }

    res.json({ groupExpenses: group.groupExpenses });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


module.exports = groupRouter;
