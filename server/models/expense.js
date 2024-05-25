const mongoose = require('mongoose');

const expenseSchema = mongoose.Schema({

    name: {
        type: String,
        required: true,
        trim: true
    },

    description: {
        type: String,
        required: true,
        trim: true
    },

    amount: {
        type: String,
        required: true
    },
   
    date: {
        type: Date,
        required: true,
    },

    category: {
        type: String,
        require: true
    },

    expenserId: {
        type: String,
    },

    expenserName: {
        type: String,
    },

    

});

const Expense = mongoose.model('Expense', expenseSchema);
module.exports = { Expense, expenseSchema };