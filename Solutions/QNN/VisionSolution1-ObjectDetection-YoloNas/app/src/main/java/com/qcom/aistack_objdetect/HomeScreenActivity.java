//============================================================================
// Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause-Clear
//============================================================================

package com.qcom.aistack_objdetect;

import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.Spinner;


/**
 * HomeScreenActivity class helps choose runtime from UI through activity_home_screen.xml
 * Passes choice of runtime to MainActivity.
 */
public class HomeScreenActivity extends AppCompatActivity {

    static {
        runtime_var = 'C';
        dlc_name = "libyolo_nas_w8a8.so";
        System.loadLibrary("objectdetectionYoloNas");
    }

    public static char runtime_var;

    public static String dlc_name;

    static String perf_profile = "default";

    RadioGroup rg;

    Spinner optionsSpinner;
    LinearLayout perfRow;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home_screen);

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        optionsSpinner = findViewById(R.id.options_spinner);
        perfRow = findViewById(R.id.perf_row);
        perfRow.setVisibility(View.GONE);
        setupSpinner();

        rg = (RadioGroup) findViewById(R.id.rg1);
        rg.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                if (checkedId == R.id.CPU) {
                    runtime_var = 'C';
                    dlc_name = "libyolo_nas_w8a8.so";
                    perfRow.setVisibility(View.GONE);
                    perf_profile = "default";
                } else if (checkedId == R.id.DSP) {
                    runtime_var = 'D';
                    dlc_name = "libyolo_nas_w8a8_dsp.so";
                    perfRow.setVisibility(View.VISIBLE);
                } else {
                    runtime_var = 'N';
                }
            }
        });
    }

    private void setupSpinner() {
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(
                this,
                R.array.performance_profile,
                android.R.layout.simple_spinner_item
        );
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        optionsSpinner.setAdapter(adapter);

        optionsSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                perf_profile = parent.getItemAtPosition(position).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                perf_profile = "";
            }
        });
    }

    public void startManinCameraActivity(View v) {
        Intent i = new Intent(this, MainActivity.class);
        Bundle args = new Bundle();
        args.putChar("key", runtime_var);
        args.putCharSequence("selected_dlc_name", dlc_name);
        args.putCharSequence("perf_profile", perf_profile);
        i.putExtras(args);
        startActivity(i);
    }
}
