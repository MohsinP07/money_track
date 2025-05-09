const mongoose = require('mongoose');

const userSchema = mongoose.Schema({

    name: {
        required: true,
        type: String,
        trim: true
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value) => {
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: "Please enter the valid email address",
        }
    },
    password: {
        required: true,
        type: String,
    },

    phone:{
        required: false,
        type: String,
    },

    groups: {
        required: false,
        type: []
    }

});

const User = mongoose.model("User", userSchema);
module.exports = User;