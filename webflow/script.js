const ENV_ALL = {
    "dev": {
        "endpoint": "http://localhost:8081"
    },
    "stg": {
        "endpoint": "https://stg-assessment-284609972807.us-central1.run.app"
    },
    "pro": {
        "endpoint": "https://pro-assessment-284609972807.us-central1.run.app"
    },
};
const env = ENV_ALL["stg"];

function configureContactUsForm() {
    const parentForm = document.getElementById('contact-us-form');
    if (!parentForm) {
        return;
    }

    const form = parentForm.querySelector("form");
    if (!form) {
        return;
    }

    form.addEventListener("submit", async (e) => {
        e.preventDefault();

        const formData = new FormData(form);
        const formDataFields = Object.fromEntries(formData.entries());
        const payload = {
            //debug: 1,
            source: "bucket-private",
            body: {
                to: ["edgar.jose.fernando.delgado@gmail.com"],
                //template: "/assets/templates/mails/test.html",
                template: "email/contact_us.html",
                subject: "This is my subject",
                params: {
                    data: {
                        title: "This is my title",
                        content: "This is my content"
                    },
                    form: formDataFields,
                },
            }
        };

        try {
            const res = await fetch(`${env.endpoint}/srv/email/send`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(payload),
            });

            console.log(res);

            if (!res.ok) throw new Error("Request failed");

            // Show Webflow success message
            form.style.display = "none";
            document.querySelector(".w-form-done").style.display = "block";
        } catch (err) {
            document.querySelector(".w-form-fail").style.display = "block";
            console.error(err);
        }
    });
}

document.addEventListener("DOMContentLoaded", () => {
    configureContactUsForm();
});