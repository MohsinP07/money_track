const mongoose = require('mongoose');

const groupSchema = mongoose.Schema({
    groupName: {
        required: true,
        type: String,
        trim: true,
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
    admin: {
        required: false,
        type: String,
    },
    members: {
        required: false,
        type: Array,
    },
    groupExpenses: {
        required: false,
        type: [
            {
                _id: {
                    type: String,
                    required: true,
                },
                expenseDate: {
                    type: String,
                    required: true,
                },
                expenseAmount: {
                    type: Number,
                    required: true,
                },
                expenseDescription: {
                    type: String,
                    required: true,
                },
                spendorName: {
                    type: String,
                    required: true,
                },
                spendorEmail: {
                    type: String,
                    required: true,
                },
                spenderGroup: {
                    type: String,
                    required: false,
                },
            },
        ],
    },
});

const Group = mongoose.model('Group', groupSchema);
module.exports = Group;
