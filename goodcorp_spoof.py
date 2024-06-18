from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html', company_name='GoodCorp')

@app.route('/about')
def about():
    return render_template('about.html', company_name='GoodCorp')

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        message = request.form['message']
        # Here, you would handle the form submission, e.g., save it to a database or send an email
        return redirect(url_for('home'))
    return render_template('contact.html', company_name='GoodCorp')

if __name__ == '__main__':
    app.run(debug=True)
