import apwidgets.*;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;

PWidgetContainer FWidgetContainer; 
PEditText FIPField;
PEditText FPortField;
PButton FOKButton;
PCheckBox FStickySlider;
PCheckBox FShowModifier;
PCheckBox FShowLabels;
PCheckBox FShowValues;
PCheckBox FSendTouches;
PCheckBox FSendAcceleration;
PCheckBox FSendOrientation;
PCheckBox FSendMagneticField;

boolean FMenuVisible = false;
boolean FTargetChanged = true;

void initMenu()
{
  int col2x = width - 245;
  FWidgetContainer = new PWidgetContainer(this);

  FIPField = new PEditText(col2x, 90, 230, 70);
  FIPField.setText("192.168.0.255");
  FIPField.setImeOptions(EditorInfo.IME_ACTION_DONE);
  FIPField.setCloseImeOnDone(true);
  FWidgetContainer.addWidget(FIPField); 
  
  FPortField = new PEditText(col2x, 160, 150, 70);
  FPortField.setText("4444");
  FPortField.setInputType(InputType.TYPE_CLASS_NUMBER);
  FPortField.setImeOptions(EditorInfo.IME_ACTION_DONE);
  FPortField.setCloseImeOnDone(true);
  FWidgetContainer.addWidget(FPortField); 
 
  FStickySlider = new PCheckBox(15, 250, "Sticky Slider");
  FWidgetContainer.addWidget(FStickySlider);
  
  FShowModifier = new PCheckBox(col2x, 250, "Show Modifier");
  FWidgetContainer.addWidget(FShowModifier);
  
  FShowLabels = new PCheckBox(15, 320, "Show Labels");
  FShowLabels.setChecked(true);
  FWidgetContainer.addWidget(FShowLabels);
  
  FShowValues = new PCheckBox(col2x, 320, "Show Values");
  FShowValues.setChecked(true);
  FWidgetContainer.addWidget(FShowValues);
 
  FSendTouches = new PCheckBox(15, 410, "Send Touches");
  FSendTouches.setChecked(true);
  FWidgetContainer.addWidget(FSendTouches);
  
  FSendAcceleration = new PCheckBox(15, 480, "Send Acceleration");
  FWidgetContainer.addWidget(FSendAcceleration);
  
  FSendOrientation = new PCheckBox(15, 550, "Send Orientation");
  FWidgetContainer.addWidget(FSendOrientation);
  
  FSendMagneticField = new PCheckBox(15, 620, "Send Magnetic Field");
  FWidgetContainer.addWidget(FSendMagneticField);

  FOKButton = new PButton(15, height - 90, 150, 70, "OK");
  FWidgetContainer.addWidget(FOKButton);
  FWidgetContainer.hide();
}

void onClickWidget(PWidget widget)
{
  if(widget == FOKButton)
  {
    saveSettings();
    toggleMenu();  
  }
  else if (widget == FIPField)
    FTargetChanged = true;
  else if (widget == FPortField)
    FTargetChanged = true;
  else if (widget == FShowModifier)
  {
    if (FShowModifier.isChecked())
      GValueTop = CModifierPanelHeight;
    else
      GValueTop = 0;
  }
}

void toggleMenu()
{
  if (FMenuVisible)
  {
    FWidgetContainer.hide();
    FMenuVisible = false;
    if (FTargetChanged)
    {
      initNetwork();
      FTargetChanged = false;
    }
    reset();
  }
  else
  {
    FWidgetContainer.show();
    FMenuVisible = true;
  }
}

void drawMenu()
{
  fill(255);
  textAlign(LEFT);
  textFont(fontB, 48);
  text("Kontrolleur", 15, 50); 
  
  textFont(fontA, 24);
  text("Target IP Address", 15, 130); 
  textFont(fontA, 24);
  text("Target UDP Port", 15, 200); 
}

void reset()
{
  println("-----update-----");
  
  OscBundle bundle = new OscBundle();
  OscMessage message = new OscMessage("/k/reset");
  bundle.add(message);
  sendBundle(bundle);

  synchronized(this)
  {
    FRemoteValues.clear();
  }
}
