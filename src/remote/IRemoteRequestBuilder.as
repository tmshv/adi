package remote{
	/**
	 *
	 * @author Timashev Roman
	 */
	public interface IRemoteRequestBuilder{
		function createSocial():ISocialAPI;
		function createGame():IGameAPI;
	}
}