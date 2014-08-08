using UnityEngine;
using System.Collections;

public class Rotate : MonoBehaviour {
	private bool rotationEnabled = true;

	// Update is called once per frame
	void Update () {
		if (rotationEnabled)
			transform.Rotate (new Vector3(0, 1, 0));

		if (Input.GetKeyDown(KeyCode.Space))
			rotationEnabled = !rotationEnabled;
	}
}
