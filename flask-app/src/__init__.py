# Some set up for the application 

from flask import Flask
from flaskext.mysql import MySQL

# create a MySQL object that we will use in other parts of the API
db = MySQL()

def create_app():
    app = Flask(__name__)

    # secret key that will be used for securely signing the session 
    # cookie and can be used for any other security related needs by 
    # extensions or your application
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'

    # these are for the DB object to be able to connect to MySQL. 
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_root_password.txt').readline().strip()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 3306
    app.config['MYSQL_DATABASE_DB'] = 'kelp_db'

    # app.config['MYSQL_DATABASE_DB'] = 'northwind'  # Change this to your DB name

    # Initialize the database object with the settings above. 
    db.init_app(app)

    # Add the default route
    # Can be accessed from a web browser
    # http://ip_address:port/
    # Example: localhost:8001
    @app.route("/")
    def welcome():
        return "<h1>Welcome to the 3200 boilerplate app</h1>"

    # Import the various Blueprint Objects
    # from .products.products import products
    from .customers.customers import customers
    from .restaurant.restaurants import restaurants
    from .health_inspections.health_inspections import health_inspections
    # from .restaurant.menu import menu
    from .health_inspectors.health_inspectors import health_inspectors
    from .restaurant_owner.restaurant_owner import restaurant_owner
    from .reviews.reviews import reviews


    # Register the routes from each Blueprint with the app object
    # and give a url prefix to each
    # app.register_blueprint(products, url_prefix='/p')
    #TODO review also starts with r
    app.register_blueprint(customers, url_prefix='/c')
    app.register_blueprint(restaurants, url_prefix='/r')
    # app.register_blueprint(menu, url_prefix='/m')
    app.register_blueprint(health_inspections, url_prefix='/hi')
    app.register_blueprint(health_inspectors, url_prefix='/hii')
    app.register_blueprint(restaurant_owner, url_prefix='/ro')
    app.register_blueprint(reviews, url_prefix='/re')

    return app