from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Minha esteira está no ar!!!"

if __name__ == "__main__":
    app.run(host='0.0.0.0')
