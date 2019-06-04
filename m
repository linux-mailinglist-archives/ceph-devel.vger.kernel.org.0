Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BF333D04
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 04:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfFDCKb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 22:10:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42936 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfFDCKb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 22:10:31 -0400
Received: by mail-qk1-f194.google.com with SMTP id b18so1831436qkc.9
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 19:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gNHUEEc9PtuEwEZgwCf+iVv6BY8mf4/zUluswA16kx4=;
        b=kdv75N4olBg1RBKgneSWPrils05zkdsiK2CilEuiTRugY+WZVV1XvEP+63oOrkQ852
         rXt12D0+b/TtRJeRuAaiYaCtPNAnfUJgrOZqbKXxFN6sEeSQjh1rCiRyV7ErBMNVqYIk
         RifuuOoFc7sVbv89GFdZN1zp2o+LzxOIYG3w5vT6QMmu6W6kC+WXVFL/MEWO78SD/x9O
         sdp94js3slD7m4OYz1cOLlsEeqOEzGf3pST9/JKHFuXZovKp6J7sf1KHq8/hj0s4dqEw
         7z9c1mGjLL2OcMh5iaJglCtNFVSypCcj3v5s1XQOFyoAnpwnLD4bvudrF+kfD3Zy2NYY
         lXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gNHUEEc9PtuEwEZgwCf+iVv6BY8mf4/zUluswA16kx4=;
        b=hQSvDLFqE3AKFUiZqJC2CVZEUn/yWXJfeEcIt/ct453vzCwNbHXdJ4Ms84LGjTLt2x
         H1DjeewjpGlsqA+tlh+JKKPJTGoltCG/vm5xdxcpulWMIemyjHYHTi/InMryl/zNlFVA
         Z5PV2lgroZ00wsyDp24eryQEEUQDaCokuEbHY2s9NFTJjrRyZOivwOI4M/g19HLB+PC4
         jVQqeUv3wOJ5qXShSH0E1/TkF9eAsS0utM1/i0dFqrG3d54yLF4n3RS72AeRyuVW/sqs
         BU5P9VaXAhwFpRoWgVhK+JhnpWzTYUBeUTa1d/9OQssJlkoA+cfnaiHImtN+pLhLYEo0
         pu5w==
X-Gm-Message-State: APjAAAWQ+HQ/feWtKZtcoyv2q9jcQ+qhxopoqaxUQeO/0ysiNz3fpYEj
        gk69P7aLHq9BlK0TtbH7mK6ohvzS01JEi2fYkOw=
X-Google-Smtp-Source: APXvYqwmJRsEgkv9WNlPj9tUd2IiR3HbUrLDrdNT1S0sdxy6mLHvIQgH8Gz7AW7/baWEtBTGa9X33c9NIiQpYeplK9U=
X-Received: by 2002:a05:620a:533:: with SMTP id h19mr25045458qkh.325.1559614230581;
 Mon, 03 Jun 2019 19:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
 <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
 <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com> <CAOi1vP88A7G_7ScstLSNwe-tUZcBUxhK=W5Qdix2tgPEOB9i8g@mail.gmail.com>
In-Reply-To: <CAOi1vP88A7G_7ScstLSNwe-tUZcBUxhK=W5Qdix2tgPEOB9i8g@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 4 Jun 2019 10:10:19 +0800
Message-ID: <CAAM7YAmF4_9ajORX3ENmRGEgQO6Y-H4XNUu67U+bss+D-rt7PA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 4, 2019 at 5:18 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Mon, Jun 3, 2019 at 10:23 PM Gregory Farnum <gfarnum@redhat.com> wrote:
> >
> > On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > Can we also discuss how useful is allowing to recover a mount after it
> > > has been blacklisted?  After we fail everything with EIO and throw out
> > > all dirty state, how many applications would continue working without
> > > some kind of restart?  And if you are restarting your application, why
> > > not get a new mount?
> > >
> > > IOW what is the use case for introducing a new debugfs knob that isn't
> > > that much different from umount+mount?
> >
> > People don't like it when their filesystem refuses to umount, which is
> > what happens when the kernel client can't reconnect to the MDS right
> > now. I'm not sure there's a practical way to deal with that besides
> > some kind of computer admin intervention. (Even if you umount -l, that
> > by design doesn't reply to syscalls and let the applications exit.)
>
> Well, that is what I'm saying: if an admin intervention is required
> anyway, then why not make it be umount+mount?  That is certainly more
> intuitive than an obscure write-only file in debugfs...
>

I think  'umount -f' + 'mount -o remount' is better than the debugfs file


> We have umount -f, which is there for tearing down a mount that is
> unresponsive.  It should be able to deal with a blacklisted mount, if
> it can't it's probably a bug.
>
> Thanks,
>
>                 Ilya
