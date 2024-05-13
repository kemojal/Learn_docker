from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/products')
def get_products():
    products = [
        {'id': 1, 'name': 'Product A'},
        {'id': 2, 'name': 'Product B'}
    ]
    return jsonify(products)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
