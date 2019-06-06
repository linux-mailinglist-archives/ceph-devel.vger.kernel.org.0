Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A384368D9
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 02:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfFFAsz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 20:48:55 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40029 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFFAsz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 20:48:55 -0400
Received: by mail-oi1-f194.google.com with SMTP id w196so388331oie.7
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 17:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rFUh8mG9UZI7+BwJC5QteWKpy5/hr7Aj1JsLVFj8IDE=;
        b=im3dv47Lvj1MJLf+0mUAjyjhBeB/1zmnd1ulf+p9bR/iOH5WxtwT2BvKKqomOfvgT2
         ky/gKQVR8DqEA6NIB/XBRRdchBjKvoEKPSLqi9Hg54pEicMM08Hs+IvyXNwjlKlfWVMq
         aDIknziVyHtCRD/AMZpExroEAR29GZZpQxetFcpIX8+lhm5zFL9M9rPudmwg3dV5JQyS
         iLfax0XMkFxbTQbKPvKm7pteaUdgqOxQsuSZejKHtawYZe6bCrXOC+/4OEZx95QvsDP4
         /b/Z3zhaCWx+5vGdngmOE+wa3oMeOf0v7txFJtTdUzLKwjm2RyaUFkn+zd/FFhphOd5s
         jdwA==
X-Gm-Message-State: APjAAAWddXkwDjKf4oHZHKuLP2hioNe6/5l4HZM3S2e4FB24m9WAi9bl
        CiTsGW4F7R5BtquTLHzRlRiNeQc/ie3U/jHWM6hi2Q==
X-Google-Smtp-Source: APXvYqxeV6CD60jlj4snoIYg5vYo6q63M/kg2yq0zpmpBdYwR5kiTAwCZjR2WQefsobQPsvTV6rb4bV6WyXAS83Ty+4=
X-Received: by 2002:aca:4a97:: with SMTP id x145mr9890424oia.120.1559782134700;
 Wed, 05 Jun 2019 17:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906041512530.22596@piezo.novalocal> <CAKPXa=amArp-MWzTvuRS13H78GkmO8WZ2G6Ho7Ekq-hv6N1xJQ@mail.gmail.com>
In-Reply-To: <CAKPXa=amArp-MWzTvuRS13H78GkmO8WZ2G6Ho7Ekq-hv6N1xJQ@mail.gmail.com>
From:   Vasu Kulkarni <vakulkar@redhat.com>
Date:   Wed, 5 Jun 2019 17:48:44 -0700
Message-ID: <CAKPXa=Y7zage9mfojMS0b-YKEMRRmQ_G=2=+uJkntxk_BmV6rA@mail.gmail.com>
Subject: Re: ANNOUNCE (take 2): dev@ceph.io and ceph-devel list split
To:     Sage Weil <sweil@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 5, 2019 at 5:41 PM Vasu Kulkarni <vakulkar@redhat.com> wrote:
>
> On Tue, Jun 4, 2019 at 8:18 AM Sage Weil <sweil@redhat.com> wrote:
> >
> > Hi everyone,
> >
> > We are splitting the ceph-devel@vger.kernel.org list into two:
> >
> > - dev@ceph.io
> >
> >   This will be the new general purpose Ceph development discussion list.
> >   We encourage all subscribers to the current ceph-devel@vger.kernel.org
> >   to subscribe to this new list.
> >
> >   Subscribe to the new ceph-devel list now at:
> >
> >     https://lists.ceph.io/postorius/lists/dev.ceph.io/
> After registration, email is not being sent(checked all folders too),
> Anyone else seeing this?
Sorry ignore please, It just arrived :)
>
> >
> >   (We were originally going to call this list ceph-devel@ceph.io, but are
> >   going with dev@ceph.io instead to avoid the confusion of having two
> >   'ceph-devel's, particularly when searching archives.)
> >
> > - ceph-devel@vger.kernel.org
> >
> >   The current list will continue to exist, but its role will shift to
> >   Linux kernel-related traffic, including kernel patches and discussion of
> >   implementation details for the kernel client code.
> >
> >   At some point in the future, when all non-kernel discussion has shifted
> >   to the new list, you might want to unsubscribe from the old list.
> >
> > For the next week or two, please direct discussion at both lists.  Once a
> > bit of time has passed and most active developers have subscribed to the
> > new list, we will focus discussion on the new list only.
> >
> > We will send several more emails to the old list to remind people to
> > subscribe to the new list.
> >
> > Why are we doing this?
> >
> > 1 The new list is mailman and managed by the Ceph community, which means
> >   that when people have problems with subscribe, mails being lost, or any
> >   other list-related problems, we can actually do something about it.
> >   Currently we have no real ability to perform any management-related tasks
> >   on the vger list.
> >
> > 2 The vger majordomo setup also has some frustrating features/limitations,
> >   the most notable being that it only accepts plaintext email; anything
> >   with MIME or HTML formatting is rejected.  This confuses many users.
> >
> > 3 The kernel development and general Ceph development have slightly
> >   different modes of collaboration.  Kernel code review is based on email
> >   patches to the list and reviewing via email, which can be noisy and
> >   verbose for those not involved in kernel development.  The Ceph userspace
> >   code is handled via github pull requests, which capture both proposed
> >   changes and code review.
> >
> > Thanks!
