import react, * as React from "react";
import { Page, Grid } from "tabler-react";
import SiteWrapper from "./SiteWrapper.react";
import { Button, Form, FormGroup, Label, Input } from 'reactstrap';
import { withFormik } from 'formik';

const AttendanceForm = ({ values, handleChange, handleSubmit, errors, touched, isSubmitting }) => {
  return (
    <SiteWrapper>
      <Page.Card
            title="Employee Registration"
        ></Page.Card>
        <Grid.Col md={6} lg={6} className="align-self-center">
        <Form onSubmit={handleSubmit}>
          <FormGroup>
            {touched.id && errors.id && <p className="red">{errors.id}</p>}
            <Label for="id">Employee ID</Label>
            <Input 
              type="number" 
              name="id"
              value={values.id}
              onChange={handleChange}
              id="id" 
              placeholder="Employee ID" 
            />
          </FormGroup>
          <FormGroup>
            {touched.status && errors.status && <p className="red">{errors.status}</p>}
            <Label for="status">Status</Label>
            <Input type="select" name="status" id="status" value={values.status} onChange={handleChange}>
              <option>Select Status</option>
              <option>Present</option>
              <option>Absent</option>
            </Input>
          </FormGroup>

          <FormGroup>
            {touched.date && errors.date && <p className="red">{errors.date}</p>}
            <Label for="date">Date</Label>
            <Input
              type="date"
              name="date"
              id="date"
              placeholder="datetime placeholder"
              value={values.date} 
              onChange={handleChange}
            />
          </FormGroup>
          <Button color="primary" disabled={isSubmitting}>Submit</Button>
        </Form>
    </Grid.Col>
    </SiteWrapper>
  );
}

const FormikApp = withFormik({
  mapPropsToValues() {
    return {
      id: "",
      status: "",
      date: ""
    };
  },
  handleSubmit(values, { props, resetForm, setErrors, setSubmitting }) {
    const payload = {
      ...values,
      id: parseInt(values.id) || 0
    };
    console.log(JSON.stringify(payload));
    fetch('/attendance/create', {
      method: 'POST',
      body: JSON.stringify(payload),
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Failed to record attendance');
      }
      return response.json();
    })
    .then(data => {
      console.log('Attendance recorded successfully:', data);
      resetForm();
    })
    .catch(error => {
      console.error('Error recording attendance:', error);
    });
  }
})(AttendanceForm);

export default FormikApp
