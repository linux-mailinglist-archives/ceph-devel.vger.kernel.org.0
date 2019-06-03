Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255EF334CB
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 18:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfFCQVF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 12:21:05 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:40839 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbfFCQVF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 12:21:05 -0400
Received: by mail-io1-f49.google.com with SMTP id n5so14792978ioc.7
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 09:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dfl8WAZ86hQRocp2srQ6u/l1nV5mhjlZtKfssn248WI=;
        b=pkauIkR1jpaKB08haBjYONchrh9uyt9RQX5+a3Y7DP1pCnDqMAu53epL6cRjeZsmks
         k8A63RpPzOtlwtzymwG3cruY26KrHKRtWkC/lbgIbMZkK8top2MrCYDgP5icZko7X4dm
         t6bfskzEc6+C5ERZw+bcImlrOBYmceMiKwhyBjscjTVD90D3gtO9kuM6YLNGRh4s7lHK
         e/Oboglu020RNAyJAbhqq1sB0B7L30XsEEl+RtWYKGDxiDmYKLpZRJlSR/koSbdCaNMM
         aY8E17IaUDPis3WnglkcHJSvvXFh8wl3PS+BEKyOHuIqhXatjoq5sCbGVbk7Qw8B4OnI
         C7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dfl8WAZ86hQRocp2srQ6u/l1nV5mhjlZtKfssn248WI=;
        b=gKPoy/wIduolqbScoJth+N+fYLJCTsGvdE6JL/uz6u65XvFPdr99D5KLQoB03v3/F5
         FO2W6a8YDS9qY6sspzDmK7tlHDrVMLHwvdPWUpD/4I8aMtJBQ2kRcOykCIWhdGsdD7Nx
         Myuakyp5vkhOypAGmlEraeFf+zikpGtFCetVbzW9zjMmuWfJOWm/sP3/0o0bEANn3akF
         Asv7phbMVgBMFmK0sicXdMSrdtPAZbKo0MEWuj01fc+Um1h5F//C4LUQZBkurbqwOywz
         HMyX11VC+guwHLFTkn86tmoANn2YpUXTlV7h1F81yuBR15ToYWA3TDfyKZ4pUVHZxwne
         yIGQ==
X-Gm-Message-State: APjAAAW/Aa6IzFGz+FR/KEhOGo6Z1f8UTYQTTFwoG9cD4rJJOAL3H2et
        e9tsyuqa3Fw4ttF2v8k+7ddf1DbnW/JEny8LyFU=
X-Google-Smtp-Source: APXvYqwZLQy6bTDXJqsqvFcR5Sqy3eMNGEQp72vcwGAzlRzH4bnOxjDpsy1U7bqSP2Hk9G0050ngMIYO77esoWpYSEo=
X-Received: by 2002:a5d:91cc:: with SMTP id k12mr423645ior.131.1559578864652;
 Mon, 03 Jun 2019 09:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Jun 2019 18:21:08 +0200
Message-ID: <CAOi1vP8kUzBGw2L2XqdOhTM41zeyVxxHutHbSnhr4BG53aN-hQ@mail.gmail.com>
Subject: Re: ANNOUNCE: moving the ceph-devel list to ceph.io
To:     Sage Weil <sweil@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 4:34 PM Sage Weil <sweil@redhat.com> wrote:
>
> Hi everyone,
>
> We are splitting the ceph-devel@vger.kernel.org list into two:
>
> - ceph-devel@ceph.io
>
>   This will be the new general purpose Ceph development discussion list.
>   We encourage all subscribers to the current ceph-devel@vger.kernel.org to
>   subscribe to this new list.
>
>   Subscribe to the new ceph-devel list now at:
>
>     https://lists.ceph.io/postorius/lists/ceph-devel.ceph.io/
>
> - ceph-devel@vger.kernel.org
>
>   The current list will continue to exist, but its role will shift to  Linux
>   kernel-related traffic, including kernel patches and discussion of
>   implementation details for the kernel client code.
>
>   At some point in the future, when all non-kernel discussion has shifted
>   to the new list, you might want to unsubscribe from the old list.
>
> For the next week or two, please direct discussion at both lists.  Once a
> bit of time has passed and most active developers have subscribed to the
> new list, we will focus discussion on the new list only.
>
> We will send several more emails to the old list to remind people to
> subscribe to the new list.
>
> Why are we doing this?
>
> 1 The new list is mailman and managed by the Ceph community, which means
>   that when people have problems with subscribe, mails being lost, or any
>   other list-related problems, we can actually do something about it.
>   Currently we have no real ability to perform any management-related tasks
>   on the vger list.
>
> 2 The vger majordomo software also has some frustrating
>   features/limitations, the most notable being that it only accepts
>   plaintext email; anything with MIME or HTML formatting is rejected.  This
>   confuses many users.
>
> 3 The kernel development and general Ceph development have slightly
>   different modes of collaboration.  Kernel code review is based on email
>   patches to the list and reviewing via email, which can be noisy and
>   verbose for those not involved in kernel development.  The Ceph userspace
>   code is handled via github pull requests, which capture both proposed
>   changes and code review.

I agree on all three points, although at least my recollection is that
we have had a lot of bouncing issues with ceph-users and no issues with
ceph-devel besides the plain text-only policy which some might argue is
actually a good thing ;)

However it seems that two mailing lists with identical names might
bring new confusion, particularly when searching through past threads.
Was a different name considered for the new list?

Thanks,

                Ilya
