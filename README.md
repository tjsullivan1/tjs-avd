
# Tim's Azure Virtual Desktop Scripts and Tools

Supporting infrastructure and automation for Azure Virtual Desktop.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Authors

- [Tim Sullivan](https://www.github.com/tjsullivan1)

## Environment Variables

To run this project, you will need to add the following environment variables in your GitHub environment.

## Deployment

### Deploy Azure Virtual Desktop

To deploy AVD, use the templates in ./environment-creation.

### Deploy Session Hosts

There are Bicep files for session host creation in ./session-host-creation. You can also trigger the workflow "new-session-host.yml". There are az cli cmds in that workflow.

### Create new image

Execute the new-image.ps1 script in./image-creatio.

## Running Tests

Currently, there are no testing suites for these scripts. I would love to have some, so please feel free to open a PR if you have suggestions!
<!-- To run tests, run the following command

```bash
  npm run test
```

   -->

## Roadmap

- Windows 11 Support

## FAQ

<!-- #### Question 1

Answer 1

#### Question 2

Answer 2 -->

## Feedback

If you have any feedback, please reach out to me via email.

## Contributing

Contributions are always welcome!

See `contributing.md` for ways to get started.

Please adhere to this project's `code of conduct`.

## Acknowledgements

- [Dean Cefola](https://github.com/DeanCefola/Azure-WVD)
- [The Virtual Desktop Team](https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool)

## Appendix

Any additional information goes here

### Related

Here are some related projects
<!-- 
[Awesome README](https://github.com/matiassingers/awesome-readme) 
-->

### Lessons Learned

What did you learn while building this project? What challenges did you face and how did you overcome them?

### Tech Stack

For this project, we leverage:

- Azure Virtual Desktop
- Bicep
- GitHub Actions
- Azure Image Builder
- Azure Shared Image Gallery
