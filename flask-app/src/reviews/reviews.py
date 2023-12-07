from flask import Blueprint, request, jsonify, make_response
import json
from .. import db

reviews = Blueprint('reviews', __name__)

# Get all reviews from the DB
@reviews.route('/reviews', methods=['GET'])
def get_all_reviews():
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


@reviews.route('/review/<restaurant_review_id>', methods=['GET'])
def get_a_review(restaurant_review_id):
    output = []
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * \
                        FROM RestaurantReview RR \
                       WHERE RR.restaurant_review_id = ' + str(restaurant_review_id))

    review_row_headers = [x[0] for x in cursor.description]
    reviews = cursor.fetchall()
    for review_row in reviews:
        menu_item_reviews_json = []
        restaurant_review_id = review_row[0]
        cursor.execute('SELECT description, rating, menu_item_review_id, name FROM MenuItemReview NATURAL JOIN MenuItem WHERE review_id = ' + str(restaurant_review_id))

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