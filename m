Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB19344BF
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 12:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfFDKvC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 06:51:02 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36051 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfFDKvB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 06:51:01 -0400
Received: by mail-yb1-f193.google.com with SMTP id y2so7787595ybo.3
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 03:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Gbz6Kw4Y/MVzdljaUhHZp0/Jeinqt2LDdu2lyCkgUrc=;
        b=GigTRL8brGzK2g8yOSOTyETTGqq+Eq6hJgMUjppoYAm75EGHeEYpiNRSD52KSn1tOY
         FqiVWh/isYjATE1dpcwzcgi/tyiY9cqTVMmdRmdUDJp5w3XoEamj+clDV+PqUB1ERsa7
         EBgHC3BxyCo8m1Zbx+ijAs8BypF0vK868YknZzvnrF8yhwagaEJ6JYAPx6BslsGpmNRO
         rj0aOj5h2SCrREa8mJ32KY27NX93Luc6xRh8/4P069+g9s9xKIbeowFdliQ3X7WoRTv4
         3WNzqTCXZseJxs0itCfGGwr9mo/NE4s+BsIjM1PajcqpZ4/s0fJy0LL0fV62tmYACHJ7
         iIZA==
X-Gm-Message-State: APjAAAWP/HztqFsJg6xYCdSImj9wQxl+UNgDDRVP7Stzmpl/n8TGpXMN
        sd8fbi8EEW87LRqcaZOwBEdjgA==
X-Google-Smtp-Source: APXvYqy9HkN2P+VjlkBz0ugejBAtu9fAEbvNWcocdhSJVK5ETsXXLVn1l5dvDhkm0Lot3//O8GZ3MA==
X-Received: by 2002:a25:358b:: with SMTP id c133mr14258376yba.296.1559645460817;
        Tue, 04 Jun 2019 03:51:00 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-2AF.dyn6.twc.com. [2606:a000:1100:37d::2af])
        by smtp.gmail.com with ESMTPSA id j65sm859644ywd.36.2019.06.04.03.50.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 03:51:00 -0700 (PDT)
Message-ID: <b742f7bf2ad6075468625120623b6c89c259ad0a.camel@redhat.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
From:   Jeff Layton <jlayton@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Date:   Tue, 04 Jun 2019 06:50:59 -0400
In-Reply-To: <CAOi1vP_QNR9u78GhJzxeiUPkq6OT7FVBP3R2u3d02F=uNN1FDw@mail.gmail.com>
References: <20190531122802.12814-1-zyan@redhat.com>
         <20190531122802.12814-2-zyan@redhat.com>
         <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
         <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
         <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
         <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
         <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
         <CA+2bHPboGYSY82Mh73qdSREZhzve72s4GgDVXqhdrdpW9YbC7Q@mail.gmail.com>
         <CAOi1vP_QNR9u78GhJzxeiUPkq6OT7FVBP3R2u3d02F=uNN1FDw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-06-04 at 11:37 +0200, Ilya Dryomov wrote:
> On Mon, Jun 3, 2019 at 11:05 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > On Mon, Jun 3, 2019 at 1:24 PM Gregory Farnum <gfarnum@redhat.com> wrote:
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
> > > some kind of computer admin intervention.
> > 
> > Furthermore, there are often many applications using the mount (even
> > with containers) and it's not a sustainable position that any
> > network/client/cephfs hiccup requires a remount. Also, an application
> 
> Well, it's not just any hiccup.  It's one that lead to blacklisting...
> 
> > that fails because of EIO is easy to deal with a layer above but a
> > remount usually requires grump admin intervention.
> 
> I feel like I'm missing something here.  Would figuring out $ID,
> obtaining root and echoing to /sys/kernel/debug/$ID/control make the
> admin less grumpy, especially when containers are involved?
> 
> Doing the force_reconnect thing would retain the mount point, but how
> much use would it be?  Would using existing (i.e. pre-blacklist) file
> descriptors be allowed?  I assumed it wouldn't be (permanent EIO or
> something of that sort), so maybe that is the piece I'm missing...
> 

I agree with Ilya here. I don't see how applications can just pick up
where they left off after being blacklisted. Remounting in some fashion
is really the only recourse here.

To be clear, what happens to stateful objects (open files, byte-range
locks, etc.) in this scenario? Were you planning to just re-open files
and re-request locks that you held before being blacklisted? If so, that
sounds like a great way to cause some silent data corruption...
-- 
Jeff Layton <jlayton@redhat.com>

