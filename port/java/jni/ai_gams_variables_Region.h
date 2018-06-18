/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
#include "gams/GamsExport.h"
/* Header for class ai_gams_variables_Region */

#ifndef _Included_ai_gams_variables_Region
#define _Included_ai_gams_variables_Region
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     ai_gams_variables_Region
 * Method:    jni_Region
 * Signature: ()J
 */
GAMS_EXPORT jlong JNICALL Java_ai_gams_variables_Region_jni_1Region__
  (JNIEnv *, jobject);

/*
 * Class:     ai_gams_variables_Region
 * Method:    jni_Region
 * Signature: (J)J
 */
GAMS_EXPORT jlong JNICALL Java_ai_gams_variables_Region_jni_1Region__J
  (JNIEnv *, jobject, jlong);

/*
 * Class:     ai_gams_variables_Region
 * Method:    jni_freeRegion
 * Signature: (J)V
 */
GAMS_EXPORT void JNICALL Java_ai_gams_variables_Region_jni_1freeRegion
  (JNIEnv *, jclass, jlong);

/*
 * Class:     ai_gams_variables_Region
 * Method:    jni_getName
 * Signature: (J)Ljava/lang/String;
 */
GAMS_EXPORT jstring JNICALL Java_ai_gams_variables_Region_jni_1getName
  (JNIEnv *, jobject, jlong);

/*
 * Class:     ai_gams_variables_Region
 * Method:    jni_init
 * Signature: (JJJLjava/lang/String;)V
 */
GAMS_EXPORT void JNICALL Java_ai_gams_variables_Region_jni_1init
  (JNIEnv *, jobject, jlong, jlong, jlong, jstring);

/*
 * Class:     ai_gams_variables_Region
 * Method:    jni_toString
 * Signature: (J)Ljava/lang/String;
 */
GAMS_EXPORT jstring JNICALL Java_ai_gams_variables_Region_jni_1toString
  (JNIEnv *, jobject, jlong);

/*
 * Class:     ai_gams_variables_Region
 * Method:    jni_getVertices
 * Signature: (J)J
 */
GAMS_EXPORT jlong JNICALL Java_ai_gams_variables_Region_jni_1getVertices
  (JNIEnv *, jobject, jlong);

#ifdef __cplusplus
}
#endif
#endif
