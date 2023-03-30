const express = require('express')
const mysql = require('mysql2')
const cors = require('cors')
const app = express()
// const AWS = require('aws-sdk');


app.use(cors({origin: "http://10.0.1.200:3200"}));

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
})

function getRandomInt(max) {
  return 1 + Math.floor(Math.random() * (max))
}

async function randomId() {
  const [rows] = await pool.promise().query(
    "SELECT COUNT(*) as totalregistros FROM registros"
  )
  const { totalregistros } = rows[0]
  const randomId = getRandomInt(totalregistros)
  return randomId
}

async function getRegistro(id) {
    const [registros] = await pool.promise().query("SELECT * FROM registros WHERE id = ?", [
      id,
    ])
    return registros[0]
}

app.get("/test", (req, res) => {
  res.send("<h1>Aplicação no ar!</h1>")
})

app.get("/registro", async (req, res) => {
    try {
      const id = await randomId()
      const registro = await getRegistro(id)
      res.send(registro)
    } catch (error) {
      res.send(error)
    }
})

const port = process.env.PORT || 8080
app.listen(port, () => console.log(`Listening on port ${port}`))

// app.get("/logo",(req,res)=>
// {
//     AWS.config.update({ accessKeyId: "", secretAccessKey: ""});

//     let s3 = new AWS.S3();

//     async function getImage()
//     {
//         const data =  s3.getObject(
//         {
//               Bucket: 'opus-matheus-silva-webapp',
//               Key: 'opuslogo.png'
//         }

//         ).promise();
//         return data;
//     }

//     function encode(data)
//     {
//         let buf = Buffer.from(data);
//         let base64 = buf.toString('base64');
//         return base64
//     }

//     getImage()
//         .then((img)=>{
//             let image="<img src='data:image/jpeg;base64," + encode(img.Body) + "'" + "/>";
//             let html= image ;
//             res.send(html)
//         }).catch((e)=>{
//                 res.send(e)
//     })

// })
