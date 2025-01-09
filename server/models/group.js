const mongoose = require('mongoose');

const groupSchema = mongoose.Schema({

    groupName: {
        required: true,
        type: String,
        trim: true
    },
    groupDescription: {
        required: true,
        type: String,
        trim: true,
    },
    budget: {
        required: true,
        type: String,
    },

    admin:{
        required: false,
        type: String,
    },

    members: {
        required: false,
        type: []
    }

});

const Group = mongoose.model("Group", groupSchema);
module.exports = Group;