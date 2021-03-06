simple-amt
==========
simple-amt is a microframework for working with [Amazon's Mechanical Turk](http://www.mturk.com) (AMT). It was designed with the following three principles in mind:

- Abstract away the details of AMT to let you focus on your own task.
- Place no restrictions on the structure of your AMT tasks.
- Lightweight and easy to understand.

# Quick start guide
Follow these steps to set up simple-amt and run a simple HIT on AMT.

### Check out the codebase and set up a virtualenv
```
git clone https://github.com/lxieyang/simple-amt.git
cd simple-amt
virtualenv .env
source .env/bin/activate
pip install -r requirements.txt
```

### Configure your Amazon account
To use AMT, you'll need an Amazon AWS account. To interact with Amazon, simple-amt needs
an access key and corresponding secret key for your Amazon account. You can find these 
[here](https://console.aws.amazon.com/iam/home?#security_credential). Once you have these,
place then in a file called config.json for simple-amt:
```
cp config.json.example config.json
# edit config.json; fill out the "aws_access_key" and "aws_secret_key" fields.
```
**WARNING**: Your AWS keys provide full access to your AWS account, so be careful about where you store your config.json file!

### Launch some HITs
We've included a sample HIT that asks workers to write sentences to describe images. To launch a couple of these HITs on the AMT sandbox, run the following:
```
python launch_hits.py \
  --html_template=image_sentence.html \
  --hit_properties_file=hit_properties/image_sentence.json \
  --input_json_file=hit_operations/image_sentence/example_input.txt \
  --hit_ids_file=hit_operations/image_sentence/hit_ids.txt
```
This is the most complicated command that you will need to run; let's break it down:
- The file `image_sentence.html` is a simple [jinja2](http://jinja.pocoo.org/) template that defines the UI of the HIT;
you can find it in `hit_templates/image_sentence.html`.
- The file `hit_properties/image_sentence.json` defines the properties of the HIT: title, keywords, price, etc.
- The file `hit_operations/image_sentence/example_input.txt` contains inputs for the HITs that you want to create. The input to each HIT is a JSON object, and the input file contains one such JSON object per line. One HIT is created for each line of the input file.
- The IDs of the created HITs are written to the file `hit_operations/image_sentence/hit_ids.txt`. You will use this file as input to other commands in order to operate on the batch of HITs that you just created.

*Note*: You may be seeing an error message scrolling repeatedly if you're setting up AMT for the first time, asking you to "Please log in to [https://requestersandbox.mturk.com/](https://requestersandbox.mturk.com/) and complete registration." You have to register on that URL first and then run again.

### Do your HITs
Your HITs should now be live on the [Mechanical Turk sandbox](https://workersandbox.mturk.com/mturk/findhits).
Open the sandbox and sort by "HIT creation data (newest first)".
You should see a HIT with the title "*Write sentences to describe images*" in the first page or two of results.
Complete one of the HITs.

The HIT can sometimes take several seconds to appear. You can double check that the HIT is up and available by going to the [requester sandbox](https://requestersandbox.mturk.com/) page and clicking *manage -> manage hits individually*.

Also note that you may not satisfy the qualifications of your own HIT. In this case you can edit the file `hit_properties/image_sentence.json` and erase the lines corresponding to `hits_approved` and `percept_approved`. Remember to bring down the HITs you've launched (see below), and then re-launch the HIT (see above).

### Check HIT progress
You can check the status of your in-progress HITs by running the following command:
```
python show_hit_progress.py --hit_ids_file=hit_operations/image_sentence/hit_ids.txt
```

### Get HIT results
You can fetch the results of your completed HITs by running the following command:
```
python get_results.py \
  --hit_ids_file=hit_operations/image_sentence/hit_ids.txt \
  > hit_operations/image_sentence/results.txt
```
The results of all completed HITs are now stored as in the file `hit_operations/image_sentence/results.txt`.
Each line of the file contains a JSON blob with the results from a single assignment.

### Approve work
If you are satisfied with the results that you have gotten, you can approve all completed assignments from your HIT batch by running the following command:
```
python approve_assignments.py --hit_ids_file=hit_operations/image_sentence/hit_ids.txt
```

### Reject work
If you are not satisfied with the results that you have gotten, you can reject assignments according to your HIT ids by running the following command:
```
python reject_assignments.py --hit_ids_file=hit_operations/image_sentence/hit_ids.txt
```

### Generating approve or reject id files
You can run your results against your own evaluation system (for me, I wrote the whole system in MATLAB) and generate the approve ids file and reject ids file according to your own criteria. You can find sample evaluation system for the 20151203 project in the revelant hit_evaluation folder.
Then, you can run the above commands with minor changes:
Upon approval:
```
python approve_assignments.py --hit_ids_file=hit_operations/image_sentence/approve_hit_ids.txt
```
Upon rejection:
```
python reject_assignments.py --hit_ids_file=hit_operations/image_sentence/reject_hit_ids.txt
```

### Delete HITs
Once your HITs are completed and you have saved the results, you can delete the HITs from Amazon's database with the following command:
```
python disable_hits.py --hit_ids_file=hit_operations/image_sentence/hit_ids.txt
```
**WARNING:** After running this command, your HITs will no longer be visible to workers, and you will no longer be able to retrieve HIT results from Amazon. Make sure that you have saved the HIT results before running this command.

### Running on the production site
To run your HITs on the production AMT site, simply append a `--prod` flag to each of the above commands.

**WARNING:** Running HITs on sandbox is free, but running HITs on the production site is not. In order to launch HITs your Mechanical Turk account must have sufficient funds to pay for all HITs; these funds will be held in escrow by Amazon once you
launch HITs, and will be paid to workers when you approve assignments. 

### More sophisticated example of locating objects in an image (just for your reference)
The current project I'm working on is marked as 20151203_locating_two_objects_v_1.0 across the project. I implemented a task that allows workers to circle out two objects in a particular image wit the handy built-in polygon tool. I also added an instruction part to guide the workers throuhgout the whole process. The rest of the work are basically the same. Note that I marked all the files and shell scripts used for testing on the sandbox as `SANDBOX`, and the ones need for the production site as `REAL` to make your life easier, which fortunately, also saves my time and effort.

### More mTurk related operations
More mTurk related operations will be added to this README file once I figured those out. These features include showing your account balance and possibly others. The python program has already been uploaded so you could also figure them out by yourself.


# Creating your own HITs
To create your own HITs, you'll need to do the following:

1. Create HTML template for HIT UI
2. Create HIT properties file
3. Prepare input file

We'll walk through each of these steps in more detail.

## Build HIT UI
Building the UI is typically the most time-consuming step in creating a new type of HIT. You will have to do most of the work yourself, but simple-amt can still help. As a running example, we will use the UI defined in `hit_templates/simple.html`. This is a very basic HIT that asks workers to write an example of a category, like a type of dog or a flavor of ice cream.

If you look at `hit_templates/simple.html`, you'll notice that it looks like regular HTML except for the line
```
{% include "simpleamt.html" %}
```
This includes the file `hit_templates/simpleamt.html`, which does two things:

1. Sets up DOM elements where HIT input and output will be stored; the only one of these that you need to know is the submit button, which has the ID `#submit-btn`.
2. Sets up a global Javascript object called `simpleamt` that defines functions for working with Mechanical Turk on the frontend.

The Javascript `simpleamt` object provides the following functions:

- `simpleamt.getInput(default_input)`: Attempts to get and parse the input JSON blob to this HIT. If this succeeds, the input JSON blob is returned as a Javascript object. If the input blob cannot be read (either during development when there is no input blob or if it cannot be parsed as valid JSON) then `default_input` is returned instead. If `default_input` is not passed to `getInput` then it defaults to `null`.
- `simpleamt.setOutput(output)`: Store the output JSON blob for this HIT. `output` should be a Javascript object that can be serialized to JSON.
- `simpleamt.isPreview()`: Check to see if this HIT is in preview mode. Amazon uses a url parameter called `assignmentId` to indicate whether a HIT is being previewed. If the parameter does not exist (such as during development) then `simpleamt.isPreview` returns `false`.
- `simpleamt.setupSubmit()`: This performs a bit of bookkeeping to make it possible to submit results to Amazon. You **must** call this before the submit button is clicked; if you don't then Amazon will report an error when the user tries to submit the HIT.

To see a minimal example of these functions in action, look at the file `hit_templates/simple.html`.

While developing a HIT template, you will need to render the template to produce a valid HTML page that you can view in a browser. You can do this using the `render_template.py` script. Use it like this:

```
python render_template.py --html_template=simple.html
```

The rendered template will be stored in a directory called `rendered_templates` (you can change this by editing your config file). Whenever you change your HIT template you will need to rerender to see your changes.

To actually view the rendered template in a web browser, you will need to run a local HTTP server so that protocol-relative URLs resolve properly. Python makes this very easy; just run

```
python -m SimpleHTTPServer 8080
```

then point your web browser at http://127.0.0.1:8080/.

**WARNING:** Although it seems like you could finish the above procedures off-line, you `HAVE` to have Internet access while you render and view your html template on your local machine.

## Create HIT properties file
To launch HITs, you need both an HTML template defining the UI for the HIT and a JSON file storing properties of the HIT. An example JSON file is `hit_properties/simple.json`. A HIT properties JSON file has the following fields (some are required and some are optional):

- `title`: Required. Must be a string. The title of your HIT. This will be the first part of your HIT that workers see, so it should be short and descriptive.
- `description`: Required. Must be a string. If a worker is intrigued by your HIT title, they can click on it to see the description. This should be a couple of sentences at most, giving a brief description of the HIT.
- `keywords`: Required. Must be a string of words separated by commas. These keywords are used by Mechanical Turk's search function. From my experience the Mechanical Turk search function isn't very smart, so it can help to explicitly conjugate verbs, include both singular and plural versions of nouns, and be creative to think of words that could be relevant. Picking good keywords for your HIT is a basically a small SEO problem.
- `reward`: Required. Must be a number. This is the amount of money (in US dollars) that will be paid to workers per assignment. Keep in mind that Amazon charges the greater of 20% or 0.1 cents as a commission fee, so your actual cost per HIT will be slightly higher than the reward. You should also always pay at least 5 cents per HIT to avoid paying unnecessary commission fees to Amazon.
- `duration`: Required. Must be an integer. This is the number of time (in seconds) that each worker has to complete the HIT before it expires. You should probably make this about 2 to 3 times the actual amount of time that you expect workers to spend on each assignment.
- `frame_height`: Required. Must be an integer. When you HIT is displayed, Amazon renders the HIT content inside of an iframe. The height of the iframe is `frame_height` pixels. You should pick a number that is larger than your actual HIT content; if you don't then your HIT will be ugly and have nested scroll bars.
- `max_assignments`: Required. Must be an integer. The number of assignments to create for each input. This means that `max_assignments` different workers will give you results for each HIT input.
- `country`: Optional. Must be a string. If you set this, then only workers from the specified country will be allowed to work on your HITs. This must be either a valid [ISO 3166 country code](http://www.iso.org/iso/country_codes/country_codes) or a valid [ISO 3166-2 subdivision code](http://en.wikipedia.org/wiki/ISO_3166-2:US). I usually just use "US".
- `hits_approved`: Optional. Must be an integer. If you set this, then only workers who have had at least this many HITs approved on Mechanical Turk will be allowed to work on your assignments.
- `percent_approved`: Optional. Must be an integer. If you set this, then only workers who have had at least this percent of their submitted HITs approved will be allowed to work on your HITs.
