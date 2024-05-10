from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, Docker multi container apps!'

if __name__ == '__main__':
    port = 5000
    app.run(host='0.0.0.0', port=port)
    print(f"Server is running on http://0.0.0.0:{port}")
