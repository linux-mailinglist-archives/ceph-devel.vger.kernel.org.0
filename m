Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E531141B61
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jun 2019 06:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbfFLEwE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jun 2019 00:52:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42555 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbfFLEwD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jun 2019 00:52:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so17243430qtk.9
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jun 2019 21:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=clnkHYfsdeD5Ei8c2gdpUlL4eOVMMbC1ZIG1irxeXaM=;
        b=jfouZZ0kkCU4n30YayhnrQNzX6vX02YmlLeScUXC2LN6tSqoHjeOT8Y9FNYfF/qpvF
         leMIQRHayGl3rr1njZkjer245f1ZGTUrrHf9ErliJT6cYs7sM30pLzUelojeq9RwCoWh
         bC4Y1qzZlKNMQR5yIWCPQsqLNWyOUqE9/7sI6aG8YGEEg4c5+rNsnWsjAtOX/sQ7g6Kg
         +EtbJFcUm0y4et0e35sUB7l8FVggP04kpLflFwWnxlCaxlWPoifmHdMVlsA/lL/5oWZn
         ieCK8+7MrF4jbcoLqe7bGAwcEupIx9FaZc1cvu6JCXyPT6TifkxCkROuxZ3YT3L9XCgW
         0Xyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=clnkHYfsdeD5Ei8c2gdpUlL4eOVMMbC1ZIG1irxeXaM=;
        b=iR29vJtqZ4i1OZNoeJdVEzjRp9ADAmzXwob58YIuYAEbOdcE/uZ30I9jq0LpTpbI/M
         0aqvV9gDfS2F1XgTgE9EHcDYTnHpOZdaRqufeOIqHLYK3nU2aBN59hxhetxlFAd8OtY0
         7uiB5PyZw9ZuVG6pTRmsh6NV2EglJekBD3x+rsQ44M10fqjklFwo7gepBe1I/a/lxa8X
         YjuqR9TtJqbExWEh1NJEAtJQrrewTVAzWzj6AXE+vV9Yt6ioqDi5xhSpvIPd8EXFegJ9
         TQCGbv8/Vth0Z8FidVkZtjlyWBHeU3pwKYw/wvg7F+w+/lxKdBzJwwm3QJDsjRYCqRjA
         r5Kg==
X-Gm-Message-State: APjAAAVewH8vxb8hOLXDsxehpZ8om2SQctbLsDe42uJ5Go1TXV3C4ybQ
        Wi9xe4SWUttWVG6iJjlW9mShL+B9ID+kVJjQuwA=
X-Google-Smtp-Source: APXvYqyuZsdnWtK31jS5FOENaxQRCoVW7q5GQgUxTDkkK7ii5/DGsmbLnZP//UZdVXA8cXI1nV8fYSYKPZSjbeAlZYI=
X-Received: by 2002:ac8:5158:: with SMTP id h24mr21085417qtn.82.1560315122496;
 Tue, 11 Jun 2019 21:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <CADRKj5TsnRdjuV+01Lhv2hNbB4sv4UXxo_m--pnhdiTJ60GAvQ@mail.gmail.com>
In-Reply-To: <CADRKj5TsnRdjuV+01Lhv2hNbB4sv4UXxo_m--pnhdiTJ60GAvQ@mail.gmail.com>
From:   Kyle Bader <kyle.bader@gmail.com>
Date:   Tue, 11 Jun 2019 21:51:51 -0700
Message-ID: <CAFMfnwoPGxUWk+Q8vi3S3xD+noypTc-gYA-6TQk93xAOpzJrcA@mail.gmail.com>
Subject: Re: S3 Select
To:     Yehuda Sadeh-Weinraub <yehuda@redhat.com>
Cc:     Karan Singh <karan@redhat.com>, "Bader, Kyle" <kbader@redhat.com>,
        "Weil, Sage" <sweil@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Originally S3 select only supported csv/json, optionally compressed.
Due to overwhelming customer demand, support for Parquet was
added in very short order.

The main projects I'm aware of that support S3 select are the S3A
filesystem client (used by many big data tools), Presto, and Spark.

https://issues.apache.org/jira/browse/HADOOP-15364
https://prestodb.github.io/docs/current/connector/hive.html

https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-spark-s3select.html
https://github.com/minio/spark-select

Even if a tool leverages S3A, the underlying engine needs to know
how to do projection and predicate pushdowns. Spark falls into this
category. I could see S3 select also being useful for lighter weight
applications, perhaps knative functions or similar?

The csv/json/parquet files are usually part of a larger database, often
with schema stored in a Hive metastore, at least for the data
warehousing use case. Tables can be partitioned, and each partition
can have any number of files. Database engines typically have
cost-based optimizers that use statistics about tables and partitions
in order to only read files that are relevant. Perhaps you partition
by a time and datestamp and your query is only trying to determine the
sales for last month (form of projection pushdown). With a columnar
format like parquet, the data is striped into row groups and each row
group stores the columns together, the parquet metadata keeps
information about offsets and the number of rows, etc. So now the
database engine can do further predicate pushdowns by eliminating
unnecessary row groups, and projection pushdowns by eliminating
unnecessary columns. The way this works absent S3 Select is the
database engine will do a ranged GET for the parquet metadata, then do
range GET requests for the columns of relevant row groups. We've seen
that this is kind of annoying for RGW, because most engines rudely use
the starting offset, and then slam the connection closed once they've
got what they want (perhaps because the metadata only contains
starting offsets and not ending offsets). Basically the RGW is busily
requesting chunks of the range requested object from RADOS only to
throw some of them away because the client closed the connection. It's
not clear to me  if there is a way to make this happen down in RADOS
with object classes, since the files we're acting on are likely going
to cross a striping boundary. Especially since the metadata to data
overhead of small files is going to be obviously worse.

Now, with S3 Select, instead of having the Parquet reader for these
engines do their own predicate / projection pushdowns by examining
file metadata and only reading necessary ranges of a particular
object, the engine can skip the Parquet reader and simply send a
predicate / pushdown select statement to the object store. That means
our strategies to process parquet files should be informed by those
utilized by Parquet readers that have been developed in different
database engines.

This blog post provides some inspiration on various optimizations:

https://eng.uber.com/presto/


On Mon, Jun 3, 2019 at 3:05 PM Yehuda Sadeh-Weinraub <yehuda@redhat.com> wrote:
>
> Hi Karan, Kyle, ceph-devel,
>
> I'm looking into a potential implementation of s3 select, and trying
> to gather some information about current use of this feature. Karan,
> is there any specific use case that you have in mind?
> Anyone else that has any experience with this feature and what users
> expect exactly from it please feel free to chime in. The different
> directions we can take implementing it vary a lot, and there are
> likely different trade offs that we need to consider. Any light shed
> into it could be really useful.
>
> Thanks,
> Yehuda
