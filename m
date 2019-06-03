Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618AC33750
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 19:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfFCRyq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 13:54:46 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:51419 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfFCRyq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 13:54:46 -0400
Received: by mail-it1-f193.google.com with SMTP id m3so29009757itl.1
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 10:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y6+lZ6POigniyvUQGuxc11zprJBScus2p3XQx3eXLGg=;
        b=d4y1TL+M5SIVXOJ2PyIomSSwrLjiO4tuTnOEwfm2yPxERo6vKaPfqdrOmR51zDGNDF
         9QUIxFWPbfi2LvjsbFgoij7Kcuzq99L6W/f0brMWtuMUZZCp8LKhTq8okPx9C5UE06xj
         fLpbZK3iHi+f28LNtJ3pOzUGB8OiUM7MqhOrkf83QTV3rVzPOoZ144fJ8eYTztL9sUfD
         SLqErOpwOL4PegBDFhIrkp6jbGzx+tllYMRErxRID+PB5P4matwTAadykgsr0SBJT/+n
         6sb0E5zC+egha3tKPFhO27cbjUNE08h7vJLEGv0r5+RvWHNEkjbfjuIw1IxIzTJ3tFp4
         eQvg==
X-Gm-Message-State: APjAAAVtOkGBHlLwNBRq5o5qMjXsgA0DXzEqiajSMnmuiBXjLgQ9/rDR
        HeFrjv4NlgOWzsyUUBaMoIwz3WRxAroQG8P3canG1Q==
X-Google-Smtp-Source: APXvYqx+N4z/dWcZOiRoORfWEhZLFbMXhEguZsHwUVDerranAG4c3C5Q6UpGAcpDRawU3Cy626cPUrMM6UN4kgB8YNc=
X-Received: by 2002:a02:ad17:: with SMTP id s23mr10057260jan.137.1559584485280;
 Mon, 03 Jun 2019 10:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com> <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
In-Reply-To: <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 3 Jun 2019 10:54:01 -0700
Message-ID: <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 6:51 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Fri, May 31, 2019 at 10:20 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Fri, May 31, 2019 at 2:30 PM Yan, Zheng <zyan@redhat.com> wrote:
> > >
> > > echo force_reconnect > /sys/kernel/debug/ceph/xxx/control
> > >
> > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> >
> > Hi Zheng,
> >
> > There should be an explanation in the commit message of what this is
> > and why it is needed.
> >
> > I'm assuming the use case is recovering a blacklisted mount, but what
> > is the intended semantics?  What happens to in-flight OSD requests,
> > MDS requests, open files, etc?  These are things that should really be
> > written down.
> >
> got it
>
> > Looking at the previous patch, it appears that in-flight OSD requests
> > are simply retried, as they would be on a regular connection fault.  Is
> > that safe?
> >
>
> It's not safe. I still thinking about how to handle dirty data and
> in-flight osd requests in the this case.

Can we figure out the consistency-handling story before we start
adding interfaces for people to mis-use then please?

It's not pleasant but if the client gets disconnected I'd assume we
have to just return EIO or something on all outstanding writes and
toss away our dirty data. There's not really another option that makes
any sense, is there?
-Greg

>
> Regards
> Yan, Zheng
>
> > Thanks,
> >
> >                 Ilya
