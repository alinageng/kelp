from flask import Blueprint, request, jsonify, make_response, current_app
import json
from .. import db

reviews = Blueprint('reviews', __name__)

# Get all reviews from the DB
@reviews.route('/reviews', methods=['GET'])
def get_reviews():
    cursor = db.get_db().cursor()
    # cursor.execute('SELECT company, last_name,\
    #     first_name, job_title, business_phone FROM customers')
    cursor.execute('SELECT  FROM customers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@reviews.route('/reviews/<id>', methods=['DELETE'])
def delete_a_review(id):
    query = 'DELETE FROM RestaurantReview WHERE restaurant_review_id = ' + str(id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

@reviews.route('/reviews/<id>', methods=['GET'])
def get_a_review(id):
    output = []
    cursor = db.get_db().cursor()
    cursor.execute('SELECT rr.restaurant_review_id, restaurant_id, description, rating, date, first_name, last_name \
                    FROM RestaurantReview rr JOIN Customer c on rr.customer_id = c.customer_id \
                    WHERE rr.restaurant_review_id = ' + str(id))

    review_row_headers = [x[0] for x in cursor.description]
    reviews = cursor.fetchall()
    for review_row in reviews:
        menu_item_reviews_json = []
        restaurant_review_id = review_row[0]
        cursor.execute(
            'SELECT description, rating, menu_item_review_id, name FROM MenuItemReview NATURAL JOIN MenuItem WHERE review_id = ' + str(
                restaurant_review_id))

        menu_item_review_row_headers = [x[0] for x in cursor.description]
        menu_item_reviews = cursor.fetchall()
        for menu_item_review_row in menu_item_reviews:
            menu_item_reviews_json.append(dict(zip(menu_item_review_row_headers, menu_item_review_row)))

        review_row_headers.append("menu_item_reviews")
        review_row = review_row + (menu_item_reviews_json,)
        output.append(dict(zip(review_row_headers, review_row)))

    the_response = make_response(jsonify(output[0]))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@reviews.route('/reviews/<id>', methods=['PUT'])
def edit_a_review(id):
    the_data = request.json
    print("EDITN A REVIEW", flush=True)
    print(the_data,flush=True)

    # insert into reviews
    rating = the_data['rating']
    description = the_data['description']

    query = ("UPDATE RestaurantReview SET description = '{}', rating = {} WHERE restaurant_review_id={}".format(description, rating, id))
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    # retrieve id of review we just inserted
    cursor.execute("SELECT LAST_INSERT_ID()")

    menu_item_reviews = the_data['menu_item_reviews']
    for mi_review in menu_item_reviews:
        mi_rating = mi_review['rating']
        mi_description = mi_review['description']
        menu_item_review_id = mi_review['menu_item_review_id']

        query = ("UPDATE MenuItemReview SET description = '{}', rating = {} \
                 WHERE menu_item_review_id={}".format(mi_description, mi_rating, menu_item_review_id))
        current_app.logger.info(query)
        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

    the_response = make_response(jsonify(the_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response