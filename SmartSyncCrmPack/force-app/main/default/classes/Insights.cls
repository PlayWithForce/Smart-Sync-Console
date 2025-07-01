/**
 * @description Apex-defined class for Flow input, used to stage insights.
 */
global class Insights {
    @InvocableVariable(required=true)
    public Id Id;

    @InvocableVariable
    public String Name;

    @InvocableVariable
    public SObject entireResource;
}