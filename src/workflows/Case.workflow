<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>NotifyPhaseChange</fullName>
        <apiVersion>42.0</apiVersion>
        <endpointUrl>https://legacy-ws.herokuapp.com/casePhaseChange</endpointUrl>
        <fields>AccountId</fields>
        <fields>CaseNumber</fields>
        <fields>ClosedDate</fields>
        <fields>Id</fields>
        <fields>OwnerId</fields>
        <fields>ParentId</fields>
        <fields>Phase__c</fields>
        <fields>Product__c</fields>
        <fields>Status</fields>
        <fields>Subject</fields>
        <fields>Type</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>jotraverso.demo01@gmail.com</integrationUser>
        <name>NotifyPhaseChange</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ProcessPhase</fullName>
        <actions>
            <name>NotifyPhaseChange</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Phase__c )  &amp;&amp; NOT(ISBLANK(Phase__c)) &amp;&amp; NOT($Setup.ProcessMode__c.ProcessWithQueueable__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
