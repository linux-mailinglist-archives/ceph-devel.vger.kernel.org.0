Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DABE03360F
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 19:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfFCRHU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 13:07:20 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:40672 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfFCRHU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 13:07:20 -0400
Received: by mail-it1-f195.google.com with SMTP id h11so27749514itf.5
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 10:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhBcTUJWTwSQ5ZSfdUVI0mRKgDVfaBnKWsq9MZBNLDI=;
        b=pwhdgr65w0Suy05nZG6yRB0vEryFCbPR/LdYmAfuBNXXT5c2UrhJ6zHRdhy5YtkMqI
         2ZN4e5eCfZqnvqlqEl+j/O8jmt60+lxJyTbrHqegbRspx400EhrBregVUYZBpfByBBxN
         yq/fNRwoabFyweDJaymk4SDImTntNEfGtSLYaHp2cw/Mf8wsU5F/jrrEUNJDfc6l2ql9
         IJDd7F1fUzX1DnqNogxUgeW8I2lmJE1ubvnzCfXrp96YdiaxITgabiO+weJDfisoZQw+
         ChecJAOj8PG9RDqQguf/AuVBKNZCkSuXgp6L/CPMkt82yBk1sHtwVP9TDNmgOABld8v8
         MKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhBcTUJWTwSQ5ZSfdUVI0mRKgDVfaBnKWsq9MZBNLDI=;
        b=UuGbq0A+U/7/FOIz6IQVDmnLTWK1UGxbHloH0kcz/Ew/XjFeJV/zsNpmaXuItKmIb5
         5nw4iBWHscrRabGBSZvgX9/pNrpyxnQGzvb3mCD0hfGi4AZKtSdoEQI5KGjd/lR7EmQ5
         FIylhDErEWFT3N0Ai2mfEh/SMWOIHmt4y/mYs+/hJ+MUMv5aEWvtBf6ImKqrZMLxlpfO
         IOS8+WMLdd1BwPy80DVz7xPERMATtkY2q8F+pCWt3P7crLD9KZTbj5zdTqxMbusIm84u
         yBwVahwXGytFiVdTdJ3Fo2vRUAm0tf89J36VbmvcCOFWdLAE6FnHi4FHPnxr6lcl+kmc
         Ratg==
X-Gm-Message-State: APjAAAUnkdfoshRZuLrakHX/8QCU73asSSEaUiNwP5PPafnO5LXQHTcj
        aaqyW3si7EhFdUxQS7SecGSwNVoY/gMzgIQ3GVX3Y8up
X-Google-Smtp-Source: APXvYqxeXUoJW/5x0gMiwYlhbkS1KC0deGxLHlGtLtSj/XFOrMO+9labe7UJ0FlA5kyIE/SmY+AgJb2YP7YC5oa92Qc=
X-Received: by 2002:a24:6ecd:: with SMTP id w196mr4763367itc.104.1559581639479;
 Mon, 03 Jun 2019 10:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal>
 <CAOi1vP8kUzBGw2L2XqdOhTM41zeyVxxHutHbSnhr4BG53aN-hQ@mail.gmail.com> <alpine.DEB.2.11.1906031641210.22596@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906031641210.22596@piezo.novalocal>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Jun 2019 19:07:23 +0200
Message-ID: <CAOi1vP-jV8gD7DjkAHf05YAfTc549O1q7mxdVCVdXg=AnPYD1w@mail.gmail.com>
Subject: Re: ANNOUNCE: moving the ceph-devel list to ceph.io
To:     Sage Weil <sweil@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 6:45 PM Sage Weil <sweil@redhat.com> wrote:
>
> On Mon, 3 Jun 2019, Ilya Dryomov wrote:
> > On Mon, Jun 3, 2019 at 4:34 PM Sage Weil <sweil@redhat.com> wrote:
> > > Why are we doing this?
> > >
> > > 1 The new list is mailman and managed by the Ceph community, which means
> > >   that when people have problems with subscribe, mails being lost, or any
> > >   other list-related problems, we can actually do something about it.
> > >   Currently we have no real ability to perform any management-related tasks
> > >   on the vger list.
> > >
> > > 2 The vger majordomo software also has some frustrating
> > >   features/limitations, the most notable being that it only accepts
> > >   plaintext email; anything with MIME or HTML formatting is rejected.  This
> > >   confuses many users.
> > >
> > > 3 The kernel development and general Ceph development have slightly
> > >   different modes of collaboration.  Kernel code review is based on email
> > >   patches to the list and reviewing via email, which can be noisy and
> > >   verbose for those not involved in kernel development.  The Ceph userspace
> > >   code is handled via github pull requests, which capture both proposed
> > >   changes and code review.
> >
> > I agree on all three points, although at least my recollection is that
> > we have had a lot of bouncing issues with ceph-users and no issues with
> > ceph-devel besides the plain text-only policy which some might argue is
> > actually a good thing ;)
> >
> > However it seems that two mailing lists with identical names might
> > bring new confusion, particularly when searching through past threads.
> > Was a different name considered for the new list?
>
> Sigh... we didn't discuss another name, and the confusion with
> searching archives in particular didn't occur to me.  :(  If we're going
> to use a different name, now is the time to pick one.
>
> I'm not sure what is better than ceph-devel, though...

Perhaps just ceph@ceph.io?  Make it clear in the description that
it is a development list and direct users to ceph-users@ceph.io.

>
> Maybe making a new ceph-kernel@vger.kernel.org and aliasing the old
> ceph-devel to either ceph-kernel or the (new) ceph-devel would be the
> least confusing end state?

I think the old list has to stay intact (i.e. continue as ceph-devel)
for archive's sake.  vger doesn't provide a unified archive service so
it's hard as it is...

Thanks,

                Ilya
