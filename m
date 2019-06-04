Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E2B34319
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 11:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfFDJZv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 05:25:51 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44637 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfFDJZv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 05:25:51 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so9387724iob.11
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 02:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TqT+Y1UwZ8M5cIhN4TkgEItz+Q4CCRViHy/HvwMlws8=;
        b=SbZjN98ZYNqoyivIV4+l1mic5KaKcR/WEE82nnW1y2PXRczeYcRUqqkCgOq0tLMLJf
         WCJ5mKMOlOVCeLxSZnxxfNHetXkvpcVOnuX0xB7VS1sbpdfOeFQy4U6xidKhSmRa3DkB
         5RyLpf9JeWuatnCOMH5wpy2223+55XMbKDcBroVMNKraFOw6jr8BEw3v5rBdZjaT17Qz
         iE8oTHibG3NvaeXMSAhW+jHag1tbriHo3BS7LceqX0w+z14ur5hfO8BnU2SsnGM8aw0n
         NliSTHjOQAw0L7cK+AiClMsztGl6Ki3DcG8kIEAhY4RNbRBr+J3w57MuCRMF1B840yk8
         Zm9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TqT+Y1UwZ8M5cIhN4TkgEItz+Q4CCRViHy/HvwMlws8=;
        b=U7zhD2Y7Z1s41gzE7mLzRVDeynySskUmMQe54/crWmNKFflf2q2wAsW45mBR0mFAsm
         OYOFk3OAK9isEKJ7lXMjpGrKok73mjQ1atTGRJjkM+aAaOA9dZ2T4oCJg4S04E+fLSH4
         +7cO56MfdonfxVtlNd/aNuJjVdJl7+bhnIHWBnQ6UXn9cJRCUlY9AJvOWjrSCMoY8AcR
         PnbbYmsdRr11ms7OncgWS33dLaiKu770cAqhgYUIq7pxLR6mstbWtPjI6rtMCQouBPOe
         O2RACbCTnxSjcnZ2ZRF3N4Xi+hhQUrVp1iJLw3A30geW6s+7hbhQnMii8mV4SVe6BXds
         sbmQ==
X-Gm-Message-State: APjAAAXvvo0Nc06kyyL4YDLiUYW8wfHbMh+J94beAuZz4q/BDFKtXtaG
        S50gj4/oL8puaoom/TAvWrtYWWm+lJT65K1cfMk=
X-Google-Smtp-Source: APXvYqzd3nygeOHAlholV7slOwUq1jO6hIOz6iFzlvcWPdpdDY03MR5W0VBLbA6AYjclJikIitKWSAagoOT/gQitmpo=
X-Received: by 2002:a5d:91cc:: with SMTP id k12mr576440ior.131.1559640350465;
 Tue, 04 Jun 2019 02:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
 <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
 <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
 <CAOi1vP88A7G_7ScstLSNwe-tUZcBUxhK=W5Qdix2tgPEOB9i8g@mail.gmail.com> <CAAM7YAmF4_9ajORX3ENmRGEgQO6Y-H4XNUu67U+bss+D-rt7PA@mail.gmail.com>
In-Reply-To: <CAAM7YAmF4_9ajORX3ENmRGEgQO6Y-H4XNUu67U+bss+D-rt7PA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 4 Jun 2019 11:25:55 +0200
Message-ID: <CAOi1vP_MGaWmytu7QvAttXq7bGftXtr6gWqEh3j1TShzb_kn3w@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     "Yan, Zheng" <ukernel@gmail.com>
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

On Tue, Jun 4, 2019 at 4:10 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Tue, Jun 4, 2019 at 5:18 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Mon, Jun 3, 2019 at 10:23 PM Gregory Farnum <gfarnum@redhat.com> wrote:
> > >
> > > On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > > Can we also discuss how useful is allowing to recover a mount after it
> > > > has been blacklisted?  After we fail everything with EIO and throw out
> > > > all dirty state, how many applications would continue working without
> > > > some kind of restart?  And if you are restarting your application, why
> > > > not get a new mount?
> > > >
> > > > IOW what is the use case for introducing a new debugfs knob that isn't
> > > > that much different from umount+mount?
> > >
> > > People don't like it when their filesystem refuses to umount, which is
> > > what happens when the kernel client can't reconnect to the MDS right
> > > now. I'm not sure there's a practical way to deal with that besides
> > > some kind of computer admin intervention. (Even if you umount -l, that
> > > by design doesn't reply to syscalls and let the applications exit.)
> >
> > Well, that is what I'm saying: if an admin intervention is required
> > anyway, then why not make it be umount+mount?  That is certainly more
> > intuitive than an obscure write-only file in debugfs...
> >
>
> I think  'umount -f' + 'mount -o remount' is better than the debugfs file

Why '-o remount'?  I wouldn't expect 'umount -f' to leave behind any
actionable state, it should tear down all data structures, mount point,
etc.  What would '-o remount' act on?

Thanks,

                Ilya
