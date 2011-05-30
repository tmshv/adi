package ru.gotoandstop.adi.menu{
	import ru.gotoandstop.adi.command.ICommand;
	import ru.gotoandstop.adi.command.IMacroCommand;
	import ru.gotoandstop.adi.command.Invoker;
	import ru.gotoandstop.adi.command.MacroCommand;
	import ru.gotoandstop.adi.core.Context;
	import ru.gotoandstop.adi.core.mvc.BaseController;
	import ru.gotoandstop.adi.informers.AvailablePointsInformer;
	import ru.gotoandstop.adi.tuning.DecreaseCommand;
	import ru.gotoandstop.adi.tuning.IncreaseCommand;
	import ru.gotoandstop.adi.informers.ValueInformer;
	import ru.gotoandstop.adi.user.Owner;
	import ru.gotoandstop.adi.values.IntValue;
	import ru.gotoandstop.adi.values.IntValue2;
	import ru.gotoandstop.adi.values.StringValue;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class LevelUpController extends BaseController{
		private var _view:LevelUpView;
		public function get view():LevelUpView{
			return this._view;
		}
		
		private var s:IntValue2;
		private var a:IntValue2;
		private var ac:IntValue2;
		private var t:StringValue;
		
		public function LevelUpController(context:Context, close:ICommand){
			super(null, context);
			const owner:Owner = context.owner;
			const config:XML = context.configXML;
			var s_xml:XML = config.userParam.(@name=='strength')[0];
			var ag_xml:XML = config.userParam.(@name=='agility')[0];
			var ac_xml:XML = config.userParam.(@name=='accuracy')[0];
			
			var available_points:uint = owner.paramsPoints.value;////this.pointsInConfig;
			var start_strength:uint = owner.char.strength;
			var start_agility:uint = owner.char.agility;
			var start_accuracy:uint = owner.char.accuracy;
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
			this.t = new StringValue('');
			
			var confirmation:IMacroCommand = new MacroCommand();
			confirmation.addCommand(new SendCharParamsCommand(strength, agility, accuracy, owner));
			confirmation.addCommand(close);
			
			this._view = new LevelUpView(
				new Invoker(confirmation),
				new Invoker(new IncreaseCommand(strength, available)),
				new Invoker(new DecreaseCommand(strength, available)),
				new Invoker(new IncreaseCommand(agility, available)),
				new Invoker(new DecreaseCommand(agility, available)),
				new Invoker(new IncreaseCommand(accuracy, available)),
				new Invoker(new DecreaseCommand(accuracy, available))
			);
			
			this.view.addInformer(new AvailablePointsInformer(available, this.view.availableField));
			this.view.addInformer(new ValueInformer(strength, this.view.strengthLine, this.view.strengthField));
			this.view.addInformer(new ValueInformer(agility, this.view.agilityLine, this.view.agilityField));
			this.view.addInformer(new ValueInformer(accuracy, this.view.accuracyLine, this.view.accuracyField));
		}
		
		public function dispose():void{
			
		}
	}
}