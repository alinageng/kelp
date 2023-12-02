from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

reviews = Blueprint('reviews', __name__)

# Get all restaurant and menu reviews from the DB
@reviews.route('/reviews', methods=['GET'])
def get_reviews():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM RestaurantReview UNION SELECT * FROM MenuItemReview')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get all restaurant reviews for the given restaurant
@reviews.route('/reviews/<restaurant_id>', methods=['GET'])
def get_restaurant_reviews (restaurant_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM RestaurantReview WHERE restaurant_id = ' + str(restaurant_id))
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


# Post a new restaurant review 
@reviews.route('/reviews/<restaurant_id>', methods=['POST'])
def add_new_restaurant_review():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    customer_id = the_data['customer_id']
    restaurant_id = the_data['restaurant_id']
    description = the_data['description']
    rating = the_data['rating']

    # Constructing the query
    query = 'insert into RestaurantReview (customer_id, restaurant_id, description, rating) values ("'
    query += str(customer_id) + '", "'
    query += str(restaurant_id) + '", "'
    query += description + '", '
    query += str(rating) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

# Update the restaurant review with the given restaurant_id
@reviews.route('/reviews/<restaurant_id>', methods=['PUT'])
def update_restaurant_review(restaurant_id):
    try:
        # Get data from the request
        data = request.json
        current_app.logger.info(data)

        customer_id = data['customer_id']
        restaurant_id = data['restaurant_id']
        description = data['description']
        rating = data['rating']

        # Find the review by ID
        review = db.RestaurantReview.query.get(restaurant_id)

        # Check if the review exists
        if review:
            # Update the review with new data
            if customer_id is not None:
                review.customer_id = customer_id
            if restaurant_id is not None:
                review.restaurant_id = restaurant_id
            if description is not None:
                review.description = description
            if rating is not None:
                review.rating = rating

            # Commit the changes to the database
            db.session.commit()

            return jsonify({'message': 'Review updated successfully'}), 200
        else:
            return jsonify({'error': 'Review not found'}), 404
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# Delete the restaurant review with the given restaurant_id
@reviews.route('/reviews/<restaurant_id>', methods=['DELETE'])
def delete_restaurant_review(restaurant_id):
    try:
        # Find the restaurant review by ID
        review = db.RestaurantReview.query.get(restaurant_id)

        # Check if the review exists
        if review:
            # Delete the review from the database
            db.session.delete(review)
            db.session.commit()

            return jsonify({'message': 'Restaurant review deleted successfully'}), 200
        else:
            return jsonify({'error': 'Restaurant review not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
# MENU REVIEWS #################################################################################################

# Get all reviews for the given menu item
@reviews.route('/reviews/<menu_item_id>', methods=['GET'])
def get_menu_item_reviews (menu_item_id):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM MenuItemReview WHERE menu_item_id = ' + str(menu_item_id))
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)


# Post a new menu item review 
@reviews.route('/reviews/<menu_item_id>', methods=['POST'])
def add_new_menu_item_review():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    menu_item_id = the_data['menu_item_id']
    customer_id = the_data['customer_id']
    restaurant_id = the_data['restaurant_id']
    description = the_data['description']
    rating = the_data['rating']

    # Constructing the query
    query = 'insert into MenuItemReview (menu_item_id, customer_id, restaurant_id, description, rating) values ("'
    query += str(menu_item_id) + '", "'
    query += str(customer_id) + '", "'
    query += str(restaurant_id) + '", "'
    query += description + '", '
    query += str(rating) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

# Update the menu item review with the given menu_item_id
@reviews.route('/reviews/<menu_item_id>', methods=['PUT'])
def update_menu_item_review(menu_item_id):
    try:
        # Get data from the request
        data = request.json
        current_app.logger.info(data)

        menu_item_id = data['menu_item_id']
        customer_id = data['customer_id']
        restaurant_id = data['restaurant_id']
        description = data['description']
        rating = data['rating']

        # Find the menu item review by ID
        review = db.MenuItemReview.query.get(menu_item_id)

        # Check if the review exists
        if review:
            # Update the review with new data
            if menu_item_id is not None:
                review.menu_item_id = menu_item_id
            if customer_id is not None:
                review.customer_id = customer_id
            if restaurant_id is not None:
                review.restaurant_id = restaurant_id
            if description is not None:
                review.description = description
            if rating is not None:
                review.rating = rating

            # Commit the changes to the database
            db.session.commit()

            return jsonify({'message': 'Menu item review updated successfully'}), 200
        else:
            return jsonify({'error': 'Menu item review not found'}), 404
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# Delete the menu item review with the given menu_item_id
@reviews.route('/reviews/<menu_item_id>', methods=['DELETE'])
def delete_menu_item_review(menu_item_id):
    try:
        # Find the restaurant review by ID
        review = db.MenuItemReview.query.get(menu_item_id)

        # Check if the review exists
        if review:
            # Delete the review from the database
            db.session.delete(review)
            db.session.commit()

            return jsonify({'message': 'Menu Item review deleted successfully'}), 200
        else:
            return jsonify({'error': 'Menu Item review not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500