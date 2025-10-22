---
title: "Blog 1"
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# Offline caching with AWS Amplify, Tanstack, AppSync and MongoDB Atlas

In this blog we demonstrate how to create an offline-first application with optimistic UI using [AWS Amplify](https://aws.amazon.com/amplify/), [AWS AppSync](https://aws.amazon.com/appsync/), and [MongoDB Atlas](https://www.mongodb.com/products/platform/atlas-cloud-providers/aws). Developers design offline first applications to work without requiring an active internet connection. Optimistic UI then builds on top of the offline first approach by updating the UI with expected data changes, without depending on a response from the server. This approach typically utilizes a local cache strategy.

Applications that use offline first with optimistic UI provide a number of improvements for users. These include reducing the need to implement loading screens, better performance due to faster data access, reliability of data when an application is offline, and cost efficiency. While implementing offline capabilities manually can take sizable effort, you can use tools that simplify the process.

We provide a [sample to-do application](https://github.com/mongodb-partners/amplify-mongodb-tanstack-offline) that renders results of MongoDB Atlas CRUD operations immediately on the UI before the request roundtrip has completed, improving the user experience. In other words, we implement optimistic UI that makes it easy to render loading and error states, while allowing developers to rollback changes on the UI when API calls are unsuccessful. The implementation leverages [TanStack Query](https://tanstack.com/query/latest/docs/react/overview) to handle the optimistic UI updates along with [AWS Amplify](https://docs.amplify.aws/react/build-a-backend/data/optimistic-ui/). The diagram in Figure 1 illustrates the interaction between the UI and the backend.

TanStack Query is an asynchronous state management library for TypeScript/JavaScript, React, Solid, Vue, Svelte, and Angular. It simplifies fetching, caching, synchronizing, and updating server state in web applications. By leveraging TanStack Query’s caching mechanisms, the app ensures data availability even without an active network connection. AWS Amplify streamlines the development process, while AWS AppSync provides a robust GraphQL API layer, and MongoDB Atlas offers a scalable database solution. This integration showcases how TanStack Query’s offline caching can be effectively utilized within a full-stack application architecture.

![](/images/3-BlogsTranslated/3.1-Blog1/TanstackWithAtlas-793x1024.png)

**Figure 1. Interaction Diagram**

The sample application implements a classic to-do functionality and the exact app architecture is shown in **Figure 2.** The stack consists of:

* MongoDB Atlas for database services.
* AWS Amplify the full-stack application framework.
* AWS AppSync for GraphQL API management.
* AWS Lambda Resolver for serverless computing.
* Amazon Cognito for user management and authentication.

![](/images/3-BlogsTranslated/3.1-Blog1/architecture-1024x557.png)

**Figure 2. Architecture**

### Deploy the Application

To deploy the app in your AWS account, follow the steps below. Once deployed you can create a user, authenticate yourself, and create to-do entries – see Figure 8.

#### Set up the MongoDB Atlas cluster

1. Follow the [link](https://www.mongodb.com/docs/atlas/tutorial/create-atlas-account/) to the setup the [MongoDB Atlas cluster](https://www.mongodb.com/docs/atlas/tutorial/deploy-free-tier-cluster/), Database, [User](https://www.mongodb.com/docs/atlas/tutorial/create-mongodb-user-for-cluster/) and [Network access](https://www.mongodb.com/docs/atlas/security/add-ip-address-to-list/)
2. Set up the user

  1. [Configure User](https://www.mongodb.com/docs/atlas/security-add-mongodb-users/)

#### Clone the GitHub Repository

1. Clone the sample application with the following command

 `git clone https://github.com/mongodb-partners/amplify-mongodb-tanstack-offline`

#### Setup the AWS CLI credentials (optional if you need to debug your application locally)

1. If you would like to test the application locally using a [sandbox environment](https://docs.amplify.aws/react/deploy-and-host/sandbox-environments/setup/), you can setup temporary AWS credentials locally:

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
```

#### Deploy the Todo Application in AWS Amplify

1. Open the AWS Amplify console and Select the Github Option

![](/images/3-BlogsTranslated/3.1-Blog1/fig3-github-1024x317.png)

**Figure 3. Select Github option**

2. Configure the GitHub Repository

![](/images/3-BlogsTranslated/3.1-Blog1/fig4-permissions-1024x254.png)

**Figure 4. Configure repository permissions**

3. Select the GitHub Repository and click Next

![](/images/3-BlogsTranslated/3.1-Blog1/fig5-branch-1024x472.png)

**Figure 5. Select repository and branch**

4. Set all other options to default and deploy

![](/images/3-BlogsTranslated/3.1-Blog1/fig6-deploy-1024x362.png)

**Figure 6. Deploy application**

#### **Configure the Environment Variables**

Configure the Environment variables after the successful deployment

![](/images/3-BlogsTranslated/3.1-Blog1/fig7-envs.png)

**Figure 7. Configure environment variables**

#### Open the application and test

Open the application through the URL provided and test the application.

![](/images/3-BlogsTranslated/3.1-Blog1/fig8-test-1024x521.png)

**Figure 8. Sample todo entries**

MongoDB Atlas Output

![](/images/3-BlogsTranslated/3.1-Blog1/fig9-mongo-914x1024.png)

**Figure 9. Data in Mongo**

### Review the Application

Now that the application is deployed, let’s discuss what happens under the hood and what was configured for us. We utilized Amplify’s git-based workflow to host our full-stack, serverless web application with continuous deployment. Amplify supports various frameworks, including server side rendered (SSR) frameworks like Next.js and Nuxt, single page application (SPA) frameworks like React and Angular, and static site generators (SSG) like Gatsby and Hugo. In this case, we deployed a SPA React based application. We can include feature branches, custom domains, pull request previews, end-to-end testing, and redirects/rewrites. Amplify Hosting provides a Git-based workflow enables atomic deployments ensuring that updates are only applied after the entire deployment is complete.

To deploy our application we used AWS Amplify Gen 2, which is a tool designed to simplify the development and deployment of full-stack applications using TypeScript. It leverages the [AWS Cloud Development Kit](https://aws.amazon.com/cdk/) (CDK) to manage cloud resources, ensuring scalability and ease of use.

Before we conclude, it is important to understand our application’s updates concurrency. We implemented a simple optimistic first-come first-served conflict resolution mechanism. The MongoDB Atlas cluster persists updates in the order it receives them. In case of conflicting updates, the latest arriving update will override previous updates. This mechanism works well in applications where update conflicts are rare. It is important to evaluate how this may or may not suit your production needs, requiring more sophisticated approaches. TanStack provides capabilities for more complex mechanisms to handle various connectivity scenarios. By default, TanStack Query provides an “online” network mode, where Queries and Mutations will not be triggered unless you have network connection. If a query runs because you are online, but you go offline while the fetch is still happening, TanStack Query will also pause the retry mechanism. Paused queries will then continue to run once you re-gain network connection. In order to optimistically update the UI with new or changed values, we can also update the local cache with what we expect the response to be. This is approach works well together with TanStack’s “online” network mode, where if the application has no network connectivity, the mutations will not fire, but will be added to the queue, but our local cache can be used to update the UI. Below is a key example of how our sample application optimistically updates the UI with the expected mutation.

```
const createMutation = useMutation({
    mutationFn: async (input: { content: string }) => {
    // Use the Amplify client to make the request to AppSync
      const { data } = await amplifyClient.mutations.addTodo(input);
      return data;
    },
    // When mutate is called:
    onMutate: async (newTodo) => {
      // Cancel any outgoing refetches
      // so they don't overwrite our optimistic update
      await tanstackClient.cancelQueries({ queryKey: ["listTodo"] });

      // Snapshot the previous value
      const previousTodoList = tanstackClient.getQueryData(["listTodo"]);

      // Optimistically update to the new value
      if (previousTodoList) {
        tanstackClient.setQueryData(["listTodo"], (old: Todo[]) => [
          ...old,
          newTodo,
        ]);
      }

      // Return a context object with the snapshotted value
      return { previousTodoList };
    },
    // If the mutation fails,
    // use the context returned from onMutate to rollback
    onError: (err, newTodo, context) => {
      console.error("Error saving record:", err, newTodo);
      if (context?.previousTodoList) {
        tanstackClient.setQueryData(["listTodo"], context.previousTodoList);
      }
    },
    // Always refetch after error or success:
    onSettled: () => {
      tanstackClient.invalidateQueries({ queryKey: ["listTodo"] });
    },
    onSuccess: () => {
      tanstackClient.invalidateQueries({ queryKey: ["listTodo"] });
    },
  });
```

We welcome any [PRs](https://github.com/mongodb-partners/amplify-mongodb-tanstack-offline/pulls) implementing additional conflict resolution strategies.

* Try out MongoDB Atlas on [AWS MarketPlace](https://aws.amazon.com/marketplace/pp/prodview-pp445qepfdy34).
* Get familiar with [AWS Amplify](https://aws.amazon.com/amplify/), [Amplify Gen2](https://docs.amplify.aws/react/how-amplify-works/) and [AppSync](https://aws.amazon.com/pm/appsync/).
* For detailed instructions on deploying the application, refer to the [deployment section](https://docs.amplify.aws/react/start/quickstart/#deploy-a-fullstack-app-to-aws) of our documentation.
* Submit a PR with your enhancements.
