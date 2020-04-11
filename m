Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9416D1A5258
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Apr 2020 15:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgDKNU5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 11 Apr 2020 09:20:57 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:45056 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgDKNU5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 11 Apr 2020 09:20:57 -0400
Received: by mail-lf1-f49.google.com with SMTP id f8so3174541lfe.12
        for <ceph-devel@vger.kernel.org>; Sat, 11 Apr 2020 06:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IprZB5TFv2RH3PdyBHjx7oSh8Z3Yw/sUCUbBhG/xBBg=;
        b=kMGtA+uyQ29tFIalR7rY1k26hfLFxTLKVw1pdagb+mUjtFqFfy+hWjhTJta74UeRZ1
         uMxmplgNBPODJnmYhOn6/11dS9vFrs+PHwL20EkjLRYvlPH/+h9IDTNIN7Kzk4L6IGln
         2svqK4t82+aGcOYQF6I6qRgBgG3SQCIzPsgF91XOvLq8oWb7nEb02Mq4uSY+/tsoY5Vk
         s6lsB8ckB+DE6LMitHG9qNa40Ye0uwds8moHATM4zOJjLh/iShUiMnBe486EQ6NevHqU
         MyIjBgu3wiD2h5P/aQ+nCBrFMxJBVCkWkZrWJt2SmgsNJJg+gx+GLD1FqgLzzPkZNd2w
         Dg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IprZB5TFv2RH3PdyBHjx7oSh8Z3Yw/sUCUbBhG/xBBg=;
        b=HxD4aSJiaCCVM+707RhlXGU5Vwy04dM3QHfQDZCB/Asq35hAy9qPeZHHBpKBmyTKJ6
         BrKUkLQPa7OiyoPNpqJv1Zj31wB0vL/sDSKDle8lrm11DzHh4JxpzwRnTnoHiTpQewUc
         5FN44Xwq/fBM8uhCsTdDcK4WSpinleWdJxsXhmeDULPjT2sQROsP7cvLEAtocxk5nSgb
         ZN373b66k5nJeQ2tW28hQAX/IbudHy84OKv+p3JdbsE1ahkv0sgOaIzACXa0yTmYPO65
         xLEGa6JGcOhJ2vUTd3iN1XIWC8KYeY+gK4KlVv1+raUiKJlQYabcqtdJoHp1NRs5jSdA
         yJZw==
X-Gm-Message-State: AGi0PuYWPmQeK0gHN9f3rVi/SO8/QPvvkNejSkjuAAAeDGFlG7tExIq1
        oh19x16qT9mwhML1JNAevlT5IlDeEsswFNQE75wMqg==
X-Google-Smtp-Source: APiQypKrbKb7mc/lB1jASFM4QZpuYSqtxj+AIJaFuNGNroyVlqagkLr2jQoUU2M7GaY4EIwQqHtMvRR77xPQmDgkmR8=
X-Received: by 2002:a19:5f4e:: with SMTP id a14mr4299220lfj.57.1586611253212;
 Sat, 11 Apr 2020 06:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
 <CAED-sie+qsrr3yZVAiB=t6cAzWUwX9Y=32srJY2dwyRpSXvgxg@mail.gmail.com>
 <e9c9ffb60265aebdab6edd7ce1565402eb787270.camel@kernel.org>
 <CAED-sicefQuJ3GGWh2bBXz6R=BFr1EQ=h6Sz-W_mh3u+-tO0wA@mail.gmail.com>
 <cbbc31d2041601b3e0d2c9b1e8b657ffa23ed97e.camel@kernel.org>
 <CAED-sic=eDaXz-A6_ejZOYcJYs=-tJtmxXLcONdQRRCod59L_g@mail.gmail.com>
 <25bc975e164a73f18653156d6591dda785c8d0c1.camel@kernel.org>
 <f131fc4a-112d-2bea-f254-ed268579cf7e@ajlc.waterloo.on.ca>
 <CAED-side70b+sXVFS8Tvh+4uPXWGuHC08hcA95p1yXmdpM_-wA@mail.gmail.com> <141990e9-11d4-7440-a8b5-870e2f14010a@ajlc.waterloo.on.ca>
In-Reply-To: <141990e9-11d4-7440-a8b5-870e2f14010a@ajlc.waterloo.on.ca>
From:   Jesper Krogh <jesper.krogh@gmail.com>
Date:   Sat, 11 Apr 2020 15:20:41 +0200
Message-ID: <CAED-sid=npTg95QEQmjrje60c=gik=KCOSFPU_Uj4=VjUVqr-Q@mail.gmail.com>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     Tony Lill <ajlill@ajlc.waterloo.on.ca>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ok, i'll change the mount options and report back in a few days on
that topic. This is fairly reproducible, so I would expect to see the
effect if it works.

On Fri, Apr 10, 2020 at 6:32 PM Tony Lill <ajlill@ajlc.waterloo.on.ca> wrote:
>
>
>
> On 4/10/20 3:13 AM, Jesper Krogh wrote:
> > Hi. What is the suggested change? - is it Ceph that has an rsize,wsize
> > of 64MB ?
> >
>
> Sorry, set rsize and wsize in the mount options for your cephfs to
> something smaller.
>
> My problem with this is that I use autofs to mount my filesystem.
> Starting with 4.14.82, after a few mount/unmount cycles, the mount would
> fail with order 4 allocation error, and I'd have to reboot.
>
> I traced it to a change that doubled CEPH_MSG_MAX_DATA_LEN from 16M to
> 32M. Later in the 5 series kernels, this was doubled again, and that
> caused an order 5 allocation failure. This define is used to set the max
> and default rsize and wsize.
>
> Reducing the rsize and wsize in the mount option fixed the problem for
> me. This may do nothing for you, but, if it clears your allocation issue...
>
>
> > On Fri, Apr 10, 2020 at 12:47 AM Tony Lill <ajlill@ajlc.waterloo.on.ca> wrote:
> >>
> >>
> >>
> >> On 4/9/20 12:30 PM, Jeff Layton wrote:
> >>> On Thu, 2020-04-09 at 18:00 +0200, Jesper Krogh wrote:
> >>>> Thanks Jeff - I'll try that.
> >>>>
> >>>> I would just add to the case that this is a problem we have had on a
> >>>> physical machine - but too many "other" workloads at the same time -
> >>>> so we isolated it off to a VM - assuming that it was the mixed
> >>>> workload situation that did cause us issues. I cannot be sure that it
> >>>> is "excactly" the same problem we're seeing but symptoms are
> >>>> identical.
> >>>>
> >>>
> >>> Do you see the "page allocation failure" warnings on bare metal hosts
> >>> too? If so, then maybe we're dealing with a problem that isn't
> >>> virtio_net specific. In any case, let's get some folks more familiar
> >>> with that area involved first and take it from there.
> >>>
> >>> Feel free to cc me on the bug report too.
> >>>
> >>> Thanks,
> >>>
> >>
> >> In 5.4.20, the default rsize and wsize is 64M. This has caused me page
> >> allocation failures in a different context. Try setting it to something
> >> sensible.
> >> --
> >> Tony Lill, OCT,                     ajlill@AJLC.Waterloo.ON.CA
> >> President, A. J. Lill Consultants               (519) 650 0660
> >> 539 Grand Valley Dr., Cambridge, Ont. N3H 2S2   (519) 241 2461
> >> -------------- http://www.ajlc.waterloo.on.ca/ ---------------
> >>
> >>
> >>
>
> --
> Tony Lill, OCT,                     ajlill@AJLC.Waterloo.ON.CA
> President, A. J. Lill Consultants               (519) 650 0660
> 539 Grand Valley Dr., Cambridge, Ont. N3H 2S2   (519) 241 2461
> -------------- http://www.ajlc.waterloo.on.ca/ ---------------
>
>
>
