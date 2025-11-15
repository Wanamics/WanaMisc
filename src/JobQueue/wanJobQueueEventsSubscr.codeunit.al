codeunit 87064 "wan JobQueue Events Subscr."
{
    trigger OnRun()
    begin
        Error('Trigger Job Queue Error');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue Error Handler", OnAfterLogError, '', false, false)]
    local procedure OnAfterLogError(var JobQueueEntry: Record "Job Queue Entry")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit "Email";
        SubjectLbl: Label 'WARNING : Job queue "%1" error';
        User: Record User;
    begin
        User.SetCurrentKey("User Name");
        User.SetRange("User Name", JobQueueEntry."User ID");
        if not User.FindFirst() or (User."Contact Email" = '') then
            exit;
        EmailMessage.Create(User."Contact Email", StrSubstNo(SubjectLbl, JobQueueEntry.Description), JobQueueEntry."Error Message");
        Email.Send(EmailMessage); //, "Email Scenario"::"Job Queue")
    end;
}
