const express = require('express')
const port = process.env.PORT || 8080
const app = express()
app.use(express.json());
app.listen(port, () => console.log(`Sample app is listening on port ${port}!`))

const Sequelize = require('sequelize')
const sequelize = new Sequelize(process.env.DATABASE_URL)
sequelize.authenticate().then(() => {
    console.log('Connection has been established successfully.'); })
    .catch(err => {
    console.error('Unable to connect to the database:', err);
});

const Inventory = sequelize.define('inventory', {
    id: { type: Sequelize.INTEGER, allowNull: false, primaryKey: true }, name: { type: Sequelize.STRING, allowNull: false },
    quantity: { type: Sequelize.INTEGER },
    date: { type: Sequelize.DATEONLY, defaultValue: Sequelize.NOW }
    }, {
    freezeTableName: true, timestamps: false
});
    
app.get('/inventory/:id', async (req, res) => { const id = req.params.id
    try {
    const inventory = await Inventory.findAll({ attributes: ['id', 'name', 'quantity', 'date'], where: {
    id: id }})
    res.json({ inventory }) } catch(error) {
    console.error(error)
}})

app.post('/inventory', async (req, res) => { try {
    const newItem = new Inventory(req.body)
    await newItem.save()
    res.json({ inventory: newItem })
    } catch(error) { console.error(error)
}})