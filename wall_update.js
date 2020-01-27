const url = require('url');
const express = require('express');
const parser = require('body-parser');
const app = express();
const https = require('https');
const request = require('request');
const db = require('mysql');

request.debug = true;
const options = {
            url: "https://api.squarespace.com/1.0/commerce/orders/",
            strictSSL: false,
            timeout: 10000,
            headers: {
            'Authorization': "Bearer 85d0eca1-fc6a-439f-b743-bd0ba0e18461",
            'Content-Type': "application/json",
            'User-Agent': 'nodejs'
            }
        }
        
const OLD_ENTRIES = ["Ron Warpness",
                     "Jack Schmidt",
                     "Kyle Trumble",
                     "Lance Goede",
                     "Beth Monteiro",
                     "Brad Tyndall",
                     "Amanda Gaudern",
                     "Elisabeth Lewis",
                     "Kelly Goede",
                     "Cathy Rosenthal",
                     "Karla Borders",
                     "Anna Werner",
                     "Alex Engelhart",
                     "Rebecca Schatza",
                     "Rich Gard",
                     "Tara Carr",
                     "Billie Jo Santee",
                     "Kyle Clement",
                     "Walt Conard",
                     "Ernest Over",
                     "Cindy Gilpatrick",
                     "Julie Frebigen",
                     "Janet Nyberg",
                     "Ernie Schierwagen",
                     "Jamie Purcell"];
app.use(parser.json());
app.use(parser.urlencoded( {extended: true }));

app.get('/', function(req,res,next) {
    console.log("Call received");
    request.get(options, function (err, resp, body) {
        if (err) {
            next(err);}
        if(!err && resp.statusCode == 200) {
            let parsed = JSON.parse(body);
            console.log(parsed);
            let data = [];
            for(let i = 0; i < parsed["result"].length; i++) {
                let row = parsed["result"][i];
                console.log("Row = " + row);
                if(row["shippingAddress"]["firstName"] != null) {
                    let first_name = capitalize(row["shippingAddress"]["firstName"]);
                    let last_name = capitalize(row["shippingAddress"]["lastName"])
                    data.push(first_name + " " + last_name);
                }
                else if(row["billingAddress"]["firstName"] != null) {
                    let first_name = capitalize(row["billingAddress"]["firstName"]);
                    let last_name = capitalize(row["billingAddress"]["lastName"]);
                    data.push(first_name + " " + last_name);
                }
            }
            //going backwards because client-side script reverses result 
            for(let i = OLD_ENTRIES.length - 1; i >= 0; i--) {
                if(data.includes(OLD_ENTRIES[i]) === false) {
                    data.push(OLD_ENTRIES[i]);
                }
            }
            res.set({'Access-Control-Allow-Origin': '*'});
            res.send(JSON.stringify(data));
        }
    });
});

app.post('/offline_members', function(req, res, next){
    let con = db.createConnection({
        host: "ui0tj7jn8pyv9lp6.cbetxkdyhwsb.us-east-1.rds.amazonaws.com",
        user: "qhv7homltu8xavcx",
        password: "qiem5t8lu9w98ppo",
        port: 3306,
        database: "tqzdjgdm43v85qb1"
    });

    let name = req.body.new_member_name;
    let join_date = Date.parse(req.body.join_date);
    con.query('INSERT INTO members (name, join_date) VALUES (?, ?)', [name, join_date], (err, res, fields) => {
        if(err) next(err);
    });
    con.end();
}

app.get('/emails', function(req, res, next){
    request.get(options, function (err, resp, body) {
        if (err) {next(err);}
        if(!err && resp.statusCode == 200) {
            let parsed = JSON.parse(body);
            let data = [];
            for(let i = parsed["result"].length - 1; i >= 0; i--) {
                let row = parsed["result"][i];
                if(row["customerEmail"] != null) {
                    //console.log(row["customerEmail"]);
                    if (getName(row) != null) {
                        console.log(getName(row));
                        data.push(getName(row) + ": " + row["customerEmail"]);
                    }
                }
            }
            res.set({'Access-Control-Allow-Origin': '*'});
            res.send(JSON.stringify(data));
        }
    });
});

function getName(row) {
    if(row["shippingAddress"]["firstName"] != null) {
        let first_name = capitalize(row["shippingAddress"]["firstName"]);
        let last_name = capitalize(row["shippingAddress"]["lastName"])
        return first_name + " " + last_name;
    }
    else if(row["billingAddress"]["firstName"] != null) {
        let first_name = capitalize(row["billingAddress"]["firstName"]);
        let last_name = capitalize(row["billingAddress"]["lastName"]);
        return first_name + " " + last_name;
    }    
    else {return null;}
}
function capitalize(name) {
    let output = "";
    output += name[0].toUpperCase();
    for(let i = 1; i < name.length; i++) {
        if(name[i - 1] === " " || (name[i - 1] === name[i - 1].toLowerCase() && name[i] === name[i].toUpperCase())) {
          output += name[i].toUpperCase();
        }
        else {  
            output += name[i].toLowerCase();
        }
    }
    return output;
}

app.listen(process.env.PORT || 5000, (err) => {
    if(err) {raise (err);};
    console.log("Started");
});