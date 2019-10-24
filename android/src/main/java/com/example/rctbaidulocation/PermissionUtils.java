package com.example.rctbaidulocation;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;

import com.facebook.react.modules.core.PermissionAwareActivity;
import com.facebook.react.modules.core.PermissionListener;

import java.util.ArrayList;
import java.util.List;

public final class PermissionUtils {

    private static int mRequestCode = -1;

    private static OnPermissionListener mOnPermissionListener;

    public interface OnPermissionListener {

        void onPermissionGranted();

        void onPermissionDenied(String[] deniedPermissions);
    }

    public abstract static class RationaleHandler {
        private Context context;
        private int requestCode;
        private String[] permissions;

        protected abstract void showRationale();

        void showRationale(Context context, int requestCode, String[] permissions) {
            this.context = context;
            this.requestCode = requestCode;
            this.permissions = permissions;
            showRationale();
        }

        @TargetApi(Build.VERSION_CODES.M)
        public void requestPermissionsAgain() {
            ((Activity) context).requestPermissions(permissions, requestCode);
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    public static void requestPermissions(Context context, int requestCode
            , String[] permissions, OnPermissionListener listener) {
        requestPermissions(context, requestCode, permissions, listener, null);
    }

    @TargetApi(Build.VERSION_CODES.M)
    public static void requestPermissions(Context context, int requestCode
            , String[] permissions, OnPermissionListener listener, RationaleHandler handler) {
        if (context instanceof Activity) {
            mRequestCode = requestCode;
            mOnPermissionListener = listener;
            String[] deniedPermissions = getDeniedPermissions(context, permissions);
            if (deniedPermissions.length > 0) {
                boolean rationale = shouldShowRequestPermissionRationale(context, deniedPermissions);
                if (rationale && handler != null) {
                    handler.showRationale(context, requestCode, deniedPermissions);
                } else {
                    ((Activity) context).requestPermissions(deniedPermissions, requestCode);
                }
            } else {
                if (mOnPermissionListener != null)
                    mOnPermissionListener.onPermissionGranted();
            }
        } else {
            throw new RuntimeException("Context must be an Activity");
        }
    }

    /**
     * 请求权限结果，对应Activity中onRequestPermissionsResult()方法。
     */
    public static void onRequestPermissionsResult(Activity context, int requestCode, String[] permissions, int[]
            grantResults) {
        if (mRequestCode != -1 && requestCode == mRequestCode) {
            if (mOnPermissionListener != null) {
                String[] deniedPermissions = getDeniedPermissions(context, permissions);
                if (deniedPermissions.length > 0) {
                    mOnPermissionListener.onPermissionDenied(deniedPermissions);
                } else {
                    mOnPermissionListener.onPermissionGranted();
                }
            }
        }
    }

    /**
     * 获取请求权限中需要授权的权限
     */
    private static String[] getDeniedPermissions(final Context context, final String[] permissions) {
        List<String> deniedPermissions = new ArrayList<>();
        for (String permission : permissions) {
            if (android.support.v4.content.ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_DENIED) {
                deniedPermissions.add(permission);
            }
        }
        return deniedPermissions.toArray(new String[deniedPermissions.size()]);
    }

    /**
     * 是否彻底拒绝了某项权限
     */
    public static boolean hasAlwaysDeniedPermission(final Context context, final String... deniedPermissions) {
        for (String deniedPermission : deniedPermissions) {
            if (!shouldShowRequestPermissionRationale(context, deniedPermission)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 是否有权限需要说明提示
     */
    private static boolean shouldShowRequestPermissionRationale(final Context context, final String... deniedPermissions) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return false;
        boolean rationale;
        for (String permission : deniedPermissions) {
            rationale = android.support.v4.app.ActivityCompat.shouldShowRequestPermissionRationale((Activity) context, permission);
            if (rationale) return true;
        }
        return false;
    }

    /**
     * 检查权限，未授权则发起申请
     * @param activity
     * @param requiredPermissions
     * @param listener
     */

    public static void permissionsCheck(final Activity activity, String[] requiredPermissions,final OnPermissionListener listener) {
        final String[] missingPermissions = getDeniedPermissions(activity, requiredPermissions);
        if (missingPermissions.length > 0) {
            ((PermissionAwareActivity) activity).requestPermissions(missingPermissions, 1, new PermissionListener() {
                @Override
                public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
                    if (requestCode == 1) {

                        for (int grantResult : grantResults) {
                            if (grantResult == PackageManager.PERMISSION_DENIED) {
                                if (listener != null) {
                                    listener.onPermissionDenied(missingPermissions);

                                }
                                return true;
                            }
                        }

                        if (listener != null) {
                            listener.onPermissionGranted();
                        }

                    }

                    return true;
                }
            });

            return;
        }

        // all permissions granted
        if (listener != null) {
            listener.onPermissionGranted();
        }

    }

}
