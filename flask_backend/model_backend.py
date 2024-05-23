from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# Load the Scikit-learn model
model = joblib.load('flask_backend/crop_recommend_model.pkl')

# Mapping of numeric predictions to crop names
crop_mapping = {
    20: 'rice', 11: 'maize', 3:'chickpea', 9:'kidneybeans', 18:'pigeonpeas',
    13:'mothbeans', 14:'mungbean', 2:'blackgram', 10:'lentil', 19:'pomegranate',
    1:'banana', 12:'mango', 7:'grapes', 21:'watermelon', 15:'muskmelon', 0:'apple',
    16:'orange', 17:'papaya', 4:'coconut', 6:'cotton', 8:'jute', 5:'coffee'
}


@app.route('/predict', methods=['POST'])
def predict_crop():
    try:
        # Get the JSON data from the request
        # data = request.get_json(force=True)
        # features = data['features'] 

        # Get the JSON data from the request
        data = request.json

        # Log the received data for debugging
        app.logger.info(f"Received data: {data}")

        # Validate the received data
        required_keys = ['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall']
        for key in required_keys:
            if key not in data:
                raise KeyError(key)
            # Ensure all values are float
            data[key] = float(data[key])

        # Extract the feature values from the JSON data
        N = data['N']
        P = data['P']
        K = data['K']
        temperature = data['temperature']
        humidity = data['humidity']
        ph = data['ph']
        rainfall = data['rainfall']

        # Create an input array for the model
        input_features = [[N, P, K, temperature, humidity, ph, rainfall]]

        app.logger.info(f"input: {input_features}")

        # Make a prediction using the model
        prediction = model.predict(input_features)

        predicted_class = int(prediction[0])
        predicted_crop = crop_mapping.get(predicted_class, "Unknown crop")
        # predicted_crop = crop_mapping[prediction[0]]

        app.logger.info(f"crop: {predicted_class}, {predict_crop}")

        # Return the prediction as a JSON response
        return jsonify({"predicted_crop": predicted_crop})
    

    except KeyError as e:
        app.logger.error(f"Missing data: {e}")
        return jsonify({"error": f"Missing data: {e}"}), 400
    except Exception as e:
        app.logger.error(f"Missing data: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
