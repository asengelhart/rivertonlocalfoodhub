const url = require('url');
const express = require('express');
const parser = require('body-parser');
const app = express();
const https = require('https');
app.use(parser.json());
app.use(parser.urlencoded( {extended: true }));

app.get('/', function(req,res,next) {
    https.get(
        {host: "https://https://api.squarespace.com/1.0/commerce/orders",
        auth: "Bearer 85d0eca1-fc6a-439f-b743-bd0ba0e18461",
        headers: {
            'Content-Type': "application/json",
            'User-Agent': 'nodejs'
        },
        (resp) => {
            let data = '';

          // A chunk of data has been recieved.
          resp.on('data', (chunk) => {
            data += chunk;
          });

          // The whole response has been received. Print out the result.
            resp.on('end', () => {
                let parsed = JSON.parse(data);
                let response = []
                for(row in parsed.result) {
                    if(row["shippingAddress"]["firstName"] != null) {
                        response.push(row["shippingAddress"]["firstName"] + " " + row["shippingAddress"]["lastName"]);
                    }
                    else if(row["billingAddress"]["firstName"] != null) {
                        response.push(row["billingAddress"]["firstName"] + " " + row["billingAddress"]["lastName"]);
                    }
                }
                res.send(JSON.stringify(response));
            });
        }
              
    });
});

app.listen(5000);