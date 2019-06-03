Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D1333875
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 20:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfFCSos (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 14:44:48 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:36108 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfFCSos (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 14:44:48 -0400
Received: by mail-it1-f194.google.com with SMTP id e184so28283562ite.1
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 11:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yjkz58romD0waI9vrb1p6IAkTPcHek9CyvsTjhqQ6M0=;
        b=hzDvwV7cCOQOpaOg/+f+LEgkoJ+rkDrHAGTMFuGvZX5EgAxYSiPHzR0V1ZHYHHcVwf
         Tp3DuTDuOuUO6M/0gWxyvmfO3hUma3FcalllARyK/4yDzCmC24FF6PDz6snOPpXqSfMW
         uoGvfOdCNQjRo8B8AjfkEv+g92hB1E6dHeK7Cwjf10T5GI1LKF/3U7ufGuxQ1maMc31q
         ayDPVhHcKPWtjSvXDjvxJbYGL6Gv2t/1YKV4P21pLB9uITzSeCuEjkNh5ac800Y9BvcM
         Dz8I3lSXQ0kIMN2071uUGaWAiC2Uhm6JfqIFP5XpKhlxpEr2nOUrwWxXkCMYne8atS+f
         1ZPg==
X-Gm-Message-State: APjAAAVZYGtLD6whydW/lTkQItSQ5KcYq8eCYD48ednBhb62s3doWctG
        BDzkdVfNnBHnUgPqBIttwWjHk6F5vGJwNAUtXjlaWA==
X-Google-Smtp-Source: APXvYqysKB1kU4J0+X/FJjYCOxPnc2HqRGR/InJE6TvwvA37Ma6CXjUojDXHg3KTekNUxeBQ61n0l0Hvn2dvH0/NDug=
X-Received: by 2002:a02:bb05:: with SMTP id y5mr17591312jan.93.1559587487203;
 Mon, 03 Jun 2019 11:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal>
 <CAOi1vP8kUzBGw2L2XqdOhTM41zeyVxxHutHbSnhr4BG53aN-hQ@mail.gmail.com>
 <alpine.DEB.2.11.1906031641210.22596@piezo.novalocal> <CAOi1vP-jV8gD7DjkAHf05YAfTc549O1q7mxdVCVdXg=AnPYD1w@mail.gmail.com>
 <1402d595-3139-ba43-2503-f8e339d9c478@redhat.com>
In-Reply-To: <1402d595-3139-ba43-2503-f8e339d9c478@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 3 Jun 2019 11:44:03 -0700
Message-ID: <CAJ4mKGYepinQ8_83MJrVh-rJubPKcmVwfy9vOqoyYEKsOUw61w@mail.gmail.com>
Subject: Re: ANNOUNCE: moving the ceph-devel list to ceph.io
To:     Mark Nelson <mnelson@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sweil@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph-dev@ceph.io
ceph-develop@ceph.io
dev@ceph.io (doesn't confuse autocomplete)

On Mon, Jun 3, 2019 at 11:07 AM Mark Nelson <mnelson@redhat.com> wrote:
>
>
> On 6/3/19 12:07 PM, Ilya Dryomov wrote:
> > On Mon, Jun 3, 2019 at 6:45 PM Sage Weil <sweil@redhat.com> wrote:
> >> On Mon, 3 Jun 2019, Ilya Dryomov wrote:
> >>> On Mon, Jun 3, 2019 at 4:34 PM Sage Weil <sweil@redhat.com> wrote:
> >>>> Why are we doing this?
> >>>>
> >>>> 1 The new list is mailman and managed by the Ceph community, which means
> >>>>    that when people have problems with subscribe, mails being lost, or any
> >>>>    other list-related problems, we can actually do something about it.
> >>>>    Currently we have no real ability to perform any management-related tasks
> >>>>    on the vger list.
> >>>>
> >>>> 2 The vger majordomo software also has some frustrating
> >>>>    features/limitations, the most notable being that it only accepts
> >>>>    plaintext email; anything with MIME or HTML formatting is rejected.  This
> >>>>    confuses many users.
> >>>>
> >>>> 3 The kernel development and general Ceph development have slightly
> >>>>    different modes of collaboration.  Kernel code review is based on email
> >>>>    patches to the list and reviewing via email, which can be noisy and
> >>>>    verbose for those not involved in kernel development.  The Ceph userspace
> >>>>    code is handled via github pull requests, which capture both proposed
> >>>>    changes and code review.
> >>> I agree on all three points, although at least my recollection is that
> >>> we have had a lot of bouncing issues with ceph-users and no issues with
> >>> ceph-devel besides the plain text-only policy which some might argue is
> >>> actually a good thing ;)
> >>>
> >>> However it seems that two mailing lists with identical names might
> >>> bring new confusion, particularly when searching through past threads.
> >>> Was a different name considered for the new list?
> >> Sigh... we didn't discuss another name, and the confusion with
> >> searching archives in particular didn't occur to me.  :(  If we're going
> >> to use a different name, now is the time to pick one.
> >>
> >> I'm not sure what is better than ceph-devel, though...
> > Perhaps just ceph@ceph.io?  Make it clear in the description that
> > it is a development list and direct users to ceph-users@ceph.io.
>
>
> Not perfect, but how about ceph-devel2?
>
>
> Mark
>
>
> >
> >> Maybe making a new ceph-kernel@vger.kernel.org and aliasing the old
> >> ceph-devel to either ceph-kernel or the (new) ceph-devel would be the
> >> least confusing end state?
> > I think the old list has to stay intact (i.e. continue as ceph-devel)
> > for archive's sake.  vger doesn't provide a unified archive service so
> > it's hard as it is...
> >
> > Thanks,
> >
> >                  Ilya
