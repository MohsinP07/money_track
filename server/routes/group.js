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

module.exports = groupRouter;
