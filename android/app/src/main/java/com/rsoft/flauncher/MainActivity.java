package com.rsoft.flauncher;

import android.app.WallpaperManager;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.Bitmap;


import org.json.JSONArray;
import org.json.JSONException;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.rsoft.flauncher/launcher";

    private byte[] wallpaperData = null;
//    private PluginRegistry.Registrar registrar;
//
//    public MainActivity(Registrar registrar) {
//        this.registrar = registrar;
//    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getWallpaper")) {
                                get_wallpaper();
                                result.success(wallpaperData);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private void get_wallpaper() {
//        if(wallpaperData != null) {
//            result.success(wallpaperData);
//            return null;
//        }

        WallpaperManager wallpaperManager = WallpaperManager.getInstance(getContext());
        Drawable wallpaperDrawable = wallpaperManager.getDrawable();
        if(wallpaperDrawable instanceof BitmapDrawable) {
            wallpaperData = convertToBytes(((BitmapDrawable)wallpaperDrawable).getBitmap(),
                    Bitmap.CompressFormat.JPEG, 100);
//            result.success(wallpaperData);
        }
    }

    public static byte[] convertToBytes(Bitmap image, Bitmap.CompressFormat compressFormat, int quality) {
        ByteArrayOutputStream byteArrayOS = new ByteArrayOutputStream();
        image.compress(compressFormat, quality, byteArrayOS);
        return byteArrayOS.toByteArray();
    }
}
