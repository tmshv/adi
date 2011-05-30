package adiwars.inventory{
	import adiwars.clips.InventoryClip;
	import adiwars.command.ICommand;
	import adiwars.command.Invoker;
	import adiwars.command.MacroCommand;
	import adiwars.core.Context;
	import adiwars.core.mvc.BaseController;
	import adiwars.informers.AvailablePointsInformer;
	import adiwars.informers.ValueInformer;
	import adiwars.tuning.DecreaseCommand;
	import adiwars.tuning.IncreaseCommand;
	import adiwars.ui.ValueDependentButtonController;
	import adiwars.values.IntValue2;
	
	import flash.display.DisplayObject;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class CharTuningController extends BaseController{
		private var view:InventoryView;
		
		private var s:IntValue2;
		private var a:IntValue2;
		private var ac:IntValue2;
		private var buttonsController1:ValueDependentButtonController;
		private var buttonsController2:ValueDependentButtonController;
		private var buttonsController3:ValueDependentButtonController;
		private var confirm:Invoker;
		
		public function CharTuningController(context:Context, clip:InventoryView){
			super(null, context);
			this.view = clip;
			this.init();
		}
		
		private function init():void{
			const config:XML = super.context.configXML;
			var s_xml:XML = config.userParam.(@name=='strength')[0];
			var ag_xml:XML = config.userParam.(@name=='agility')[0];
			var ac_xml:XML = config.userParam.(@name=='accuracy')[0];
			
			var available_points:uint = super.context.owner.paramsPoints.value;
			var start_strength:uint = super.context.owner.char.strength;
			var start_agility:uint = super.context.owner.char.agility;
			var start_accuracy:uint = super.context.owner.char.accuracy;
			var max_strength:uint = s_xml.@maxValue;
			var max_agility:uint = ag_xml.@maxValue;
			var max_accuracy:uint = ac_xml.@maxValue;
			
			var available:IntValue2 = new IntValue2(0, available_points);
			available.setValue(available_points);
			
			var strength:IntValue2 = new IntValue2(start_strength, max_strength);
			var agility:IntValue2 = new IntValue2(start_agility, max_agility);
			var accuracy:IntValue2 = new IntValue2(start_accuracy, max_accuracy);
			this.s = strength;
			this.a = agility;
			this.ac = accuracy;
			
			var send:ICommand = new AddParamsCommand(strength, agility, accuracy, super.context.owner);
			
			var si:MacroCommand = new MacroCommand();
			si.addCommand(new IncreaseCommand(strength, available));
			si.addCommand(send);
			
			var sd:MacroCommand = new MacroCommand();
			sd.addCommand(new DecreaseCommand(strength, available));
			sd.addCommand(send);
			
			var agi:MacroCommand = new MacroCommand();
			agi.addCommand(new IncreaseCommand(agility, available));
			agi.addCommand(send);
			
			var agd:MacroCommand = new MacroCommand();
			agd.addCommand(new DecreaseCommand(agility, available));
			agd.addCommand(send);
			
			var aci:MacroCommand = new MacroCommand();
			aci.addCommand(new IncreaseCommand(accuracy, available));
			aci.addCommand(send);
			
			var acd:MacroCommand = new MacroCommand();
			acd.addCommand(new DecreaseCommand(accuracy, available));
			acd.addCommand(send);
			
			this.view.initCharParamsController(
				new Invoker(si),
				new Invoker(sd),
				new Invoker(agi),
				new Invoker(agd),
				new Invoker(aci),
				new Invoker(acd)
			);
				
			this.view.addInformer(new AvailablePointsInformer(available, this.view.clip.paramsPoints));
			this.view.addInformer(new ValueInformer(strength, this.view.clip.sLine, this.view.clip.sValue));
			this.view.addInformer(new ValueInformer(agility, this.view.clip.agLine, this.view.clip.agValue));
			this.view.addInformer(new ValueInformer(accuracy, this.view.clip.accLine, this.view.clip.accValue));
			
			this.buttonsController1 = new ValueDependentButtonController(available, this.view.clip.sButton);
			this.buttonsController2 = new ValueDependentButtonController(available, this.view.clip.agButton);
			this.buttonsController3 = new ValueDependentButtonController(available, this.view.clip.accButton);
		}
		
		public function getClip():DisplayObject{
			return this.view;
		}
		
		public function getValues():Array{
			return [this.s.value, this.a.value, this.ac.value];
		}
	}
}