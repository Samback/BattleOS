package com.ekreative.battleosandroid.fragments;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ToggleButton;

import com.actionbarsherlock.app.SherlockFragment;
import com.ekreative.battleosandroid.R;

public class FragmentFight extends SherlockFragment implements OnClickListener{
	private int attackState;
	private int defenceState0, defenceState1;//[] = new int[2];
	private ToggleButton btnDef0, btnDef1;
	
		ToggleButton btnHeadMy, btnBodyMy, btnLeftHandMy, btnRightHandMy, btnLeftFootMy, btnRightFootMy,
			btnHeadOpponent, btnBodyOpponent, btnLeftHandOpponent, btnRightHandOpponent, btnLeftFootOpponent, btnRightFootOpponent;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View v = (View) inflater.inflate(R.layout.fragment_fight, null);
		btnHeadMy = (ToggleButton)v.findViewById(R.id.btnHeadMy);	
		btnBodyMy = (ToggleButton)v.findViewById(R.id.btnBodyMy);
		btnLeftHandMy = (ToggleButton)v.findViewById(R.id.btnLeftHandMy);
		btnRightHandMy = (ToggleButton)v.findViewById(R.id.btnRightHandMy); 
		btnLeftFootMy = (ToggleButton)v.findViewById(R.id.btnLeftFootMy); 
		btnRightFootMy = (ToggleButton)v.findViewById(R.id.btnRightFootMy);

		btnHeadOpponent = (ToggleButton)v.findViewById(R.id.btnHeadOpponent);	
		btnBodyOpponent = (ToggleButton)v.findViewById(R.id.btnBodyOpponent);
		btnLeftHandOpponent = (ToggleButton)v.findViewById(R.id.btnLeftHandOpponent);
		btnRightHandOpponent = (ToggleButton)v.findViewById(R.id.btnRightHandOpponent); 
		btnLeftFootOpponent = (ToggleButton)v.findViewById(R.id.btnLeftFootOpponent); 
		btnRightFootOpponent = (ToggleButton)v.findViewById(R.id.btnRightFootOpponent);
		
		
		btnHeadMy.setOnClickListener(this);
		btnBodyMy.setOnClickListener(this);
		btnLeftHandMy.setOnClickListener(this);
		btnRightHandMy.setOnClickListener(this);
		btnLeftFootMy.setOnClickListener(this);
		btnRightFootMy.setOnClickListener(this);
		
		
		btnHeadOpponent.setOnClickListener(this);
		btnBodyOpponent.setOnClickListener(this);
		btnLeftHandOpponent.setOnClickListener(this);
		btnRightHandOpponent.setOnClickListener(this);
		btnLeftFootOpponent.setOnClickListener(this);
		btnRightFootOpponent.setOnClickListener(this);
		btnHeadOpponent.toggle();
		attackState = 0;
		
		btnHeadMy.toggle();
		btnDef0 = btnHeadMy;
		btnBodyMy.toggle();
		btnDef1 = btnBodyMy; 
		defenceState0 = 0;
		defenceState1 = 1;		
		return v;
	}

	public int getDefenceState0() {
		return defenceState0;
	}

	public int getDefenceState1() {
		return defenceState1;
	}

	public int getAttackState() {
		return attackState;
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.btnHeadMy:
				if ((defenceState0 == 0) || (defenceState1 == 0 )){
					btnHeadMy.setChecked(true);
				}else{
					btnDef0.setChecked(false);
					defenceState0 = defenceState1;
					defenceState1 = 0;
					btnDef0 = btnDef1;
					btnDef1 = btnHeadMy;
				}
				break;
			case R.id.btnBodyMy:
				if ((defenceState0 == 1) || (defenceState1 == 1 )){
					btnBodyMy.setChecked(true);
				}else{
					btnDef0.setChecked(false);
					defenceState0 = defenceState1;
					defenceState1 = 1;
					btnDef0 = btnDef1;
					btnDef1 = btnBodyMy;
				}
				break;
			case R.id.btnLeftHandMy:
				if ((defenceState0 == 2) || (defenceState1 == 2 )){
					btnLeftHandMy.setChecked(true);
				}else{
					btnDef0.setChecked(false);
					defenceState0 = defenceState1;
					defenceState1 = 2;
					btnDef0 = btnDef1;
					btnDef1 = btnLeftHandMy;
				}
				break;
			case R.id.btnRightHandMy:
				if ((defenceState0 == 3) || (defenceState1 == 3 )){
					btnRightHandMy.setChecked(true);
				}else{
					btnDef0.setChecked(false);
					defenceState0 = defenceState1;
					defenceState1 = 3;
					btnDef0 = btnDef1;
					btnDef1 = btnRightHandMy;
				}
				break;
			case R.id.btnLeftFootMy:
				if ((defenceState0 == 4) || (defenceState1 == 4 )){
					btnLeftFootMy.setChecked(true);
				}else{
					btnDef0.setChecked(false);
					defenceState0 = defenceState1;
					defenceState1 = 4;
					btnDef0 = btnDef1;
					btnDef1 = btnLeftFootMy;
				}
				break;
			case R.id.btnRightFootMy:
				if ((defenceState0 == 5) || (defenceState1 == 5 )){
					btnRightFootMy.setChecked(true);
				}else{
					btnDef0.setChecked(false);
					defenceState0 = defenceState1;
					defenceState1 = 5;
					btnDef0 = btnDef1;
					btnDef1 = btnRightFootMy;
				}
				break;	
			case R.id.btnHeadOpponent:
					if (attackState == 0)
						btnHeadOpponent.setChecked(true);					
					btnBodyOpponent.setChecked(false);
					btnLeftHandOpponent.setChecked(false);
					btnRightHandOpponent.setChecked(false);
					btnLeftFootOpponent.setChecked(false);
					btnRightFootOpponent.setChecked(false);
					attackState = 0;
				break;
			case R.id.btnBodyOpponent:
					if (attackState == 1)
						btnBodyOpponent.setChecked(true);					
					btnHeadOpponent.setChecked(false);
					btnLeftHandOpponent.setChecked(false);
					btnRightHandOpponent.setChecked(false);
					btnLeftFootOpponent.setChecked(false);
					btnRightFootOpponent.setChecked(false);
					attackState = 1;
				break;
			case R.id.btnLeftHandOpponent:
					if (attackState == 2)
						btnLeftHandOpponent.setChecked(true);					
					btnHeadOpponent.setChecked(false);
					btnBodyOpponent.setChecked(false);
					btnRightHandOpponent.setChecked(false);
					btnLeftFootOpponent.setChecked(false);
					btnRightFootOpponent.setChecked(false);
					attackState = 2;
				break;
			case R.id.btnRightHandOpponent:
					if (attackState == 3)
						btnRightHandOpponent.setChecked(true);					
					btnHeadOpponent.setChecked(false);
					btnBodyOpponent.setChecked(false);
					btnLeftHandOpponent.setChecked(false);
					btnLeftFootOpponent.setChecked(false);
					btnRightFootOpponent.setChecked(false);
					attackState = 3;
				break;
			case R.id.btnLeftFootOpponent:
					if (attackState == 4)
						btnLeftFootOpponent.setChecked(true);					
					btnHeadOpponent.setChecked(false);
					btnBodyOpponent.setChecked(false);
					btnLeftHandOpponent.setChecked(false);
					btnRightHandOpponent.setChecked(false);
					btnRightFootOpponent.setChecked(false);
					attackState = 4;
				break;
			case R.id.btnRightFootOpponent:
					if (attackState == 5)
						btnRightFootOpponent.setChecked(true);					
					btnHeadOpponent.setChecked(false);
					btnBodyOpponent.setChecked(false);
					btnLeftHandOpponent.setChecked(false);
					btnRightHandOpponent.setChecked(false);
					btnLeftFootOpponent.setChecked(false);
					attackState = 5;
				break;
			default:
				break;
		}
	}	
}