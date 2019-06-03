Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECE433882
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 20:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfFCSq4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 14:46:56 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37464 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFCSq4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 14:46:56 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so1608234eds.4
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 11:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=D/hqlWFC6XJ3X3h8RGmPqugbFsT7tOYxbtXKnSiD+Rw=;
        b=tDPcXaPWwYq5T4FQp4D9VBeR7EiwepGCjP5JqTmuu9fCSBEyPs/+LpMssXQB1OaRHq
         weWEfA9lH8XsoIrGuaC21uXEHl+Y4N0LaBlQzuvdV9i1zDpNyxUVuw+T7o0w5wh2oRK7
         NxxCOBDyObCHcSY9lvX+Ohf0clYv83GCeWBMTO6v99NIIXtLoGJEHbHbokf35AlyAq4u
         6Eh7IeB/JPYVFdAidSeP/yfw95Msr8PKk3QzKMNKTMLXalP471s8f8M6VycjsV32Jdll
         cIIWtmt3eA04+ldGYe12z0cVTzNcx73lbFTjLPnm8BheixPpTRN48hePO8rRIE0cfDBd
         7MiA==
X-Gm-Message-State: APjAAAWRx/HBe3QvwMUXt45xKoTV0PNtxojNsVloZPM4FKW+LnMv42hF
        bBrZ7OJ2zhfwOhaxpy9UXsYTec1OJUw+6/fLFrJEng==
X-Google-Smtp-Source: APXvYqwlXT2LvtEs27HFL1t9wgjWZL7topTXxuXrrTBvxXmG54nICL3d03I8eN3B9wnfmHt7/6JrNCx2Wy2cHeipCHk=
X-Received: by 2002:a17:906:1f44:: with SMTP id d4mr15376156ejk.195.1559587615004;
 Mon, 03 Jun 2019 11:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal>
 <CAOi1vP8kUzBGw2L2XqdOhTM41zeyVxxHutHbSnhr4BG53aN-hQ@mail.gmail.com>
 <alpine.DEB.2.11.1906031641210.22596@piezo.novalocal> <CAOi1vP-jV8gD7DjkAHf05YAfTc549O1q7mxdVCVdXg=AnPYD1w@mail.gmail.com>
 <1402d595-3139-ba43-2503-f8e339d9c478@redhat.com> <CAJ4mKGYepinQ8_83MJrVh-rJubPKcmVwfy9vOqoyYEKsOUw61w@mail.gmail.com>
In-Reply-To: <CAJ4mKGYepinQ8_83MJrVh-rJubPKcmVwfy9vOqoyYEKsOUw61w@mail.gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Mon, 3 Jun 2019 14:46:43 -0400
Message-ID: <CA+aFP1Au9FnF35Wfv_nnLipgp2zWe_z5APSLPzm924xRJbd-6A@mail.gmail.com>
Subject: Re: ANNOUNCE: moving the ceph-devel list to ceph.io
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Mark Nelson <mnelson@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sage Weil <sweil@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 2:45 PM Gregory Farnum <gfarnum@redhat.com> wrote:
>
> ceph-dev@ceph.io
> ceph-develop@ceph.io
> dev@ceph.io (doesn't confuse autocomplete)

+1 to dev@ceph.io or devel@ceph.io since the ceph.io DNS name provides
the context that it's for Ceph-related matters.

>
> On Mon, Jun 3, 2019 at 11:07 AM Mark Nelson <mnelson@redhat.com> wrote:
> >
> >
> > On 6/3/19 12:07 PM, Ilya Dryomov wrote:
> > > On Mon, Jun 3, 2019 at 6:45 PM Sage Weil <sweil@redhat.com> wrote:
> > >> On Mon, 3 Jun 2019, Ilya Dryomov wrote:
> > >>> On Mon, Jun 3, 2019 at 4:34 PM Sage Weil <sweil@redhat.com> wrote:
> > >>>> Why are we doing this?
> > >>>>
> > >>>> 1 The new list is mailman and managed by the Ceph community, which means
> > >>>>    that when people have problems with subscribe, mails being lost, or any
> > >>>>    other list-related problems, we can actually do something about it.
> > >>>>    Currently we have no real ability to perform any management-related tasks
> > >>>>    on the vger list.
> > >>>>
> > >>>> 2 The vger majordomo software also has some frustrating
> > >>>>    features/limitations, the most notable being that it only accepts
> > >>>>    plaintext email; anything with MIME or HTML formatting is rejected.  This
> > >>>>    confuses many users.
> > >>>>
> > >>>> 3 The kernel development and general Ceph development have slightly
> > >>>>    different modes of collaboration.  Kernel code review is based on email
> > >>>>    patches to the list and reviewing via email, which can be noisy and
> > >>>>    verbose for those not involved in kernel development.  The Ceph userspace
> > >>>>    code is handled via github pull requests, which capture both proposed
> > >>>>    changes and code review.
> > >>> I agree on all three points, although at least my recollection is that
> > >>> we have had a lot of bouncing issues with ceph-users and no issues with
> > >>> ceph-devel besides the plain text-only policy which some might argue is
> > >>> actually a good thing ;)
> > >>>
> > >>> However it seems that two mailing lists with identical names might
> > >>> bring new confusion, particularly when searching through past threads.
> > >>> Was a different name considered for the new list?
> > >> Sigh... we didn't discuss another name, and the confusion with
> > >> searching archives in particular didn't occur to me.  :(  If we're going
> > >> to use a different name, now is the time to pick one.
> > >>
> > >> I'm not sure what is better than ceph-devel, though...
> > > Perhaps just ceph@ceph.io?  Make it clear in the description that
> > > it is a development list and direct users to ceph-users@ceph.io.
> >
> >
> > Not perfect, but how about ceph-devel2?
> >
> >
> > Mark
> >
> >
> > >
> > >> Maybe making a new ceph-kernel@vger.kernel.org and aliasing the old
> > >> ceph-devel to either ceph-kernel or the (new) ceph-devel would be the
> > >> least confusing end state?
> > > I think the old list has to stay intact (i.e. continue as ceph-devel)
> > > for archive's sake.  vger doesn't provide a unified archive service so
> > > it's hard as it is...
> > >
> > > Thanks,
> > >
> > >                  Ilya



-- 
Jason
