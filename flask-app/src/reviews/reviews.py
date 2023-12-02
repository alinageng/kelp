from flask import Blueprint, request, jsonify, make_response
import json
from .. import db

reviews = Blueprint('reviews', __name__)

# Get all reviews from the DB
@reviews.route('/reviews', methods=['GET'])
def get_customers():
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
