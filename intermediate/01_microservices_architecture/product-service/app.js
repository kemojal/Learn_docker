const express = require('express');
const app = express();
const port = 8000;

// Mock data for products
const products = [
    { id: 1, name: 'Product A' },
    { id: 2, name: 'Product B' }
];

// Route to get all products
app.get('/products', (req, res) => {
    res.json(products);
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
