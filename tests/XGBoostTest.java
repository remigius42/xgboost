import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ml.dmlc.xgboost4j.java.Booster;
import ml.dmlc.xgboost4j.java.DMatrix;
import ml.dmlc.xgboost4j.java.XGBoostError;

public class XGBoostTest {

	private static final float MISSING_VALUE = Float.NaN;

	public static void main(String[] args) throws XGBoostError {

		XGBoostTest xgboostTest = new XGBoostTest();
		xgboostTest.test();
	}

	private void test() throws XGBoostError {
		BigDecimal[][] trainingData = new BigDecimal[][] { 
			{ new BigDecimal("10.5"), new BigDecimal("15.5") },
				{ new BigDecimal("15.5"), new BigDecimal("14.78") },
				{ new BigDecimal("100000"), new BigDecimal("-455") }, 
				{ new BigDecimal("13"), new BigDecimal("20.3") },
				{ new BigDecimal("12.4"), new BigDecimal("13.88") },
				{ new BigDecimal("5000"), new BigDecimal("-43") } };
		boolean[] labels = new boolean[] { false, false, true, false, false, true };

		Booster booster = train(trainingData, labels);

		BigDecimal[] positiveExample = new BigDecimal[] { new BigDecimal("10000"), new BigDecimal("-500") };
		BigDecimal[] negativeExample = new BigDecimal[] { new BigDecimal("14"), new BigDecimal("12.66") };
		BigDecimal prediction1 = predict(booster, positiveExample);
		BigDecimal prediction2 = predict(booster, negativeExample);
		System.out.println("Prediction 1: " + prediction1);
		System.out.println("Prediction 2: " + prediction2);
	}

	private Booster train(BigDecimal[][] trainingData, boolean[] labels) throws XGBoostError {
		int numberOfRows = trainingData.length;
		int numberOfColumns = trainingData.length == 0 ? 0 : trainingData[0].length;

		float[][] floatTrainingData = new float[numberOfRows][];
		float[] floatLabels = new float[numberOfRows];
		float[] floatWeigths = new float[numberOfRows];
		for (int i = 0; i < numberOfRows; i++) {
			BigDecimal[] row = trainingData[i];
			boolean positiveExample = labels[i];
			floatTrainingData[i] = toFloatArray(row);
			floatLabels[i] = positiveExample ? 1 : 0;
			floatWeigths[i] = positiveExample ? 2 : 1;
		}

		int numberOfRounds = 55;

		Map<String, Object> parameters = new HashMap<>();
		parameters.put("eta", Double.valueOf(0.08));
		parameters.put("max_depth", Integer.valueOf(6));
		parameters.put("silent", Integer.valueOf(1));
		parameters.put("objective", "binary:logistic");
		parameters.put("min_child_weight", Integer.valueOf(1));

		DMatrix trainingMatrix = new DMatrix(toVector(floatTrainingData), numberOfRows, numberOfColumns, MISSING_VALUE);
		trainingMatrix.setLabel(floatLabels);
		trainingMatrix.setWeight(floatWeigths);

		Booster booster = ml.dmlc.xgboost4j.java.XGBoost.train(trainingMatrix, parameters, numberOfRounds,
				new HashMap<String, DMatrix>(), null, null);

		return booster;
	}

	private BigDecimal predict(Booster booster, BigDecimal[] features) throws XGBoostError {
		DMatrix input = mapFeatureValuesToDMatrix(features);
		float[][] prediction = booster.predict(input);

		System.out.println("Predictions by XGBoost: " + Arrays.toString(prediction[0]));
		return BigDecimal.valueOf(prediction[0][0]);
	}
	
	private static DMatrix mapFeatureValuesToDMatrix(BigDecimal[] features) throws XGBoostError {
		float[] featureValues = toFloatArray(features);
		return new DMatrix(featureValues, 1, featureValues.length, MISSING_VALUE);
	}
	
	private static float[] toFloatArray(BigDecimal[] features) {
		float[] floats = new float[features.length];

		for (int i = 0; i < features.length; i++) {
			if (features[i] != null) {
				floats[i] = Float.valueOf(features[i].floatValue());
			} else {
				floats[i] = MISSING_VALUE;
			}
		}

		return floats;
	}

	private static float[] toVector(float[][] matrix) {
		List<Float> vector = new ArrayList<>();
		for (int i = 0; i < matrix.length; i++) {
			for (int j = 0; j < matrix[i].length; j++) {
				vector.add(Float.valueOf(matrix[i][j]));
			}
		}

		float[] result = new float[vector.size()];
		for (int i = 0; i < vector.size(); i++) {
			result[i] = vector.get(i).floatValue();
		}

		return result;
	}
}
