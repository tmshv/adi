package ru.gotoandstop.adi.registration.tuning{
	import ru.gotoandstop.adi.character.CharType;
	import ru.gotoandstop.adi.command.ICommand;
	import ru.gotoandstop.adi.command.IMacroCommand;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.registration.RegisterCommand;
	import ru.gotoandstop.adi.command.MacroCommand;
	import ru.gotoandstop.adi.states.ActivateStateCommand;
	import ru.gotoandstop.adi.values.IntValue2;
	import ru.gotoandstop.adi.values.StringValue;
	
	import flash.display.DisplayObject;
	import ru.gotoandstop.adi.informers.ValueInformer;
	import ru.gotoandstop.adi.informers.NameInformer;
	import ru.gotoandstop.adi.informers.AvailablePointsInformer;
	import ru.gotoandstop.adi.tuning.DecreaseCommand;
	import ru.gotoandstop.adi.tuning.IncreaseCommand;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class TuningController extends BaseController{
		private var clip:Tuning;
		
		private var s:IntValue2;
		private var a:IntValue2;
		private var ac:IntValue2;
		private var n:StringValue;
		private var t:StringValue;
		
		private var defaultCommand:DefaultCommand;
		
		//private var pointsInConfig:uint;
		private var confirm:Invoker;
		
		public function TuningController(context:Context, confirm:ICommand){
			super(null, context);
			this.init(confirm);
		}
		
		private function init(confirm:ICommand):void{
			const config:XML = super.context.configXML;
			var s_xml:XML = config.userParam.(@name=='strength')[0];
			var ag_xml:XML = config.userParam.(@name=='agility')[0];
			var ac_xml:XML = config.userParam.(@name=='accuracy')[0];
			
//			trace('tuning controller init')
//			trace(super.context.configXML.value.(@name='availablePoints'))
			
			var available_points:uint = super.context.configXML.value.(@name='availablePoints')[0];
			//var available_points:uint = super.context.owner.paramsPoints.value;
			var start_strength:uint = 1;
			var start_agility:uint = 1;
			var start_accuracy:uint = 1;
			var max_strength:uint = s_xml.@maxValue;
			var max_agility:uint = ag_xml.@maxValue;
			var max_accuracy:uint = ac_xml.@maxValue;
			var nick:String = '';
			
			var available:IntValue2 = new IntValue2(0, available_points);
			available.setValue(available_points);	
			
			var strength:IntValue2 = new IntValue2(start_strength, max_strength);
			var agility:IntValue2 = new IntValue2(start_agility, max_agility);
			var accuracy:IntValue2 = new IntValue2(start_accuracy, max_accuracy);
			var name:StringValue = new StringValue(nick);
			this.s = strength;
			this.a = agility;
			this.ac = accuracy;
			this.n = name;
			this.t = new StringValue('');
			
			this.defaultCommand = new DefaultCommand(strength, agility, accuracy, available, start_strength, start_agility, start_accuracy, available_points);
			var def:Invoker = new Invoker(this.defaultCommand);
			
			var reg:IMacroCommand = new MacroCommand();
			reg.addCommand(new RegisterCommand(this.n, this.t, this.s, this.a, this.ac, super.context.owner));
			reg.addCommand(confirm);
			this.confirm = new Invoker(reg);
			
			this.clip = new Tuning(
				this.confirm,
				def,
				new Invoker(new IncreaseCommand(strength, available)),
				new Invoker(new DecreaseCommand(strength, available)),
				new Invoker(new IncreaseCommand(agility, available)),
				new Invoker(new DecreaseCommand(agility, available)),
				new Invoker(new IncreaseCommand(accuracy, available)),
				new Invoker(new DecreaseCommand(accuracy, available))
			);
			this.clip.addInformer(new AvailablePointsInformer(available, this.clip.availableField));
			this.clip.addInformer(new NameInformer(name, this.clip.nickField));
			this.clip.addInformer(new ValueInformer(strength, this.clip.strengthLine, this.clip.strengthField));
			this.clip.addInformer(new ValueInformer(agility, this.clip.agilityLine, this.clip.agilityField));
			this.clip.addInformer(new ValueInformer(accuracy, this.clip.accuracyLine, this.clip.accuracyField));
			
			def.executeCommand();
		}
		
		public function getClip():DisplayObject{
			return this.clip;
		}
		
		public function getValues():Array{
			return [this.s.value, this.a.value, this.ac.value];
		}
		
		public function update(name:String, type:String):void{
			this.n.value = name;
			this.t.value = type;
			
			const config:XML = super.context.configXML;
			const char:XML = config.char.(@name==type)[0];
			
			var s:uint = char.@strength;
			var av:int = super.context.owner.paramsPoints.value;
			var ag:uint = char.@agility;
			var ac:uint = char.@accuracy;
			
			av -= s;
			av -= ag;
			av -= ac;
			av = av < 0 ? 0 : av;
			
			this.defaultCommand.strength = s;
			this.defaultCommand.availablePoints = av;
			this.defaultCommand.agility = ag;
			this.defaultCommand.accuracy = ac;
			this.defaultCommand.execute();
		}
	}
}