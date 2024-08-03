const app = require('./app');
const db = require('./config/db');
const userModel = require('./model/user.model');
const TodoModel = require('./model/todo.model');
const port = 3000;
app.get('/', (req, res) => { res.send("hallo world!!") }); //creating a route
app.listen(port, () => { console.log(`server listen on port http://localhost:${port}`); });