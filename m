Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33506341B
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2019 12:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfGIKS2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Jul 2019 06:18:28 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41139 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfGIKS2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Jul 2019 06:18:28 -0400
Received: by mail-yw1-f67.google.com with SMTP id i138so5414439ywg.8
        for <ceph-devel@vger.kernel.org>; Tue, 09 Jul 2019 03:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ivuZwJlxHpsBU41KitD8EPH63eatXoolHPJky5+WNSc=;
        b=rOabf3jDEp3d9ExLmQquolC9s4n5dE+qFTGSmLejJ5s5EjEGDMj2Z9lgIA8SOsXb5D
         LnGTvrvC5zPudzEI4s51kSK335w8rWj43DuCig/Ub7+1B6IsTic1B0yXqASecCzfNg4K
         6v1f3cB7Fa1M3siqusSidR2Gp2vpzQ0+9YpPqJhGR981UMt0M5QCzz6xSZl7ImB+07n1
         M4zoqWfemgoTlxF6qMM0sZ5AwYtX16zcPaUwqt8BknLibwxprZELEbSJ4PF60MmFgq0f
         GjUkMOoHYPW9kKw/NsRJCU2cyb7qYSxmric4bZovAATt/edmT/Ca22ETgbTjRHW1P6Z0
         lqPw==
X-Gm-Message-State: APjAAAVGmp+/jaKgz7933p/s37fXusbNreQ5YpYNb3FYm83aJ4KFLFUF
        lrrUnd4sepoAED4xOBiUfx8lRQuKdBA=
X-Google-Smtp-Source: APXvYqyLPMci0PRCv+exnX4SO2ZgJQeaOvH7jG1buElx2PspIjybiGatxPeNScBs/yH9lt4rvQUrOQ==
X-Received: by 2002:a0d:c5c6:: with SMTP id h189mr10367862ywd.274.1562667506795;
        Tue, 09 Jul 2019 03:18:26 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-43E.dyn6.twc.com. [2606:a000:1100:37d::43e])
        by smtp.gmail.com with ESMTPSA id 143sm2989599ywi.81.2019.07.09.03.18.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 03:18:26 -0700 (PDT)
Message-ID: <0109e8b80ef562095be8b1b4afe0076319dfc531.camel@redhat.com>
Subject: Re: [PATCH 0/9] ceph: auto reconnect after blacklisted
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Date:   Tue, 09 Jul 2019 06:18:25 -0400
In-Reply-To: <CAAM7YA=GWm41zCUmj_aUjQ6xuT0C_QCkSfrUJNcdO53daXO4KQ@mail.gmail.com>
References: <20190703124442.6614-1-zyan@redhat.com>
         <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
         <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com>
         <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
         <CAAM7YAmPrUvP=cnSG33utodvoveuaL5wJCBGrncXbrbEj8bCPg@mail.gmail.com>
         <ec097fd85e1890d904f1dd542b70649b917d4118.camel@redhat.com>
         <CAAM7YA=4=mC1kOVyWbuZ94xzJTb2M63f72MeyT1EdZxfTtRt+Q@mail.gmail.com>
         <f38b809b01839e3719acebaa3d5d3280eec71b81.camel@redhat.com>
         <CAAM7YAk8iEfWDg_ZvJNSkkMQr2ZFxMieZ_oUEZGYwteeH8GpOw@mail.gmail.com>
         <bd9569f6d4c91e3fdda1e86b10372150d0c606fa.camel@redhat.com>
         <CAAM7YAkR5cjLQc4uS-Nsq7vchV76w7WwQqWXsxuJfnDeJswOrA@mail.gmail.com>
         <f9aba1c6bb58f6cd4d9bce8012be78dadfb5d7bb.camel@redhat.com>
         <CAAM7YAn2tNxwyk1+p9kJppNb8RC4UER3B+BLfD1HBeAMVFDF1g@mail.gmail.com>
         <8f530be7babafdd280586a1529a7ee5eafaaccfd.camel@redhat.com>
         <CAAM7YA=GWm41zCUmj_aUjQ6xuT0C_QCkSfrUJNcdO53daXO4KQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-07-09 at 10:14 +0800, Yan, Zheng wrote:
> On Mon, Jul 8, 2019 at 9:45 PM Jeff Layton <jlayton@redhat.com> wrote:
> > On Mon, 2019-07-08 at 19:55 +0800, Yan, Zheng wrote:
> > > On Mon, Jul 8, 2019 at 7:43 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > On Mon, 2019-07-08 at 19:34 +0800, Yan, Zheng wrote:
> > > > > On Mon, Jul 8, 2019 at 6:59 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > On Mon, 2019-07-08 at 16:43 +0800, Yan, Zheng wrote:
> > > > > > > On Fri, Jul 5, 2019 at 9:22 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > On Fri, 2019-07-05 at 19:26 +0800, Yan, Zheng wrote:
> > > > > > > > > On Fri, Jul 5, 2019 at 6:16 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > > On Fri, 2019-07-05 at 09:17 +0800, Yan, Zheng wrote:
> > > > > > > > > > > On Thu, Jul 4, 2019 at 10:30 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > > > > On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > > On 7/4/19 12:01 AM, Jeff Layton wrote:
> > > > > > > > > > > > > > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > > > > This series add support for auto reconnect after blacklisted.
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > > > > > > > > > > > > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > > > > > > > > > > > > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > > > > > > > > > > > > > file handles continue to work and caches are dropped if necessary.
> > > > > > > > > > > > > > > If an inode contains any lost file lock, read and write are not allowed.
> > > > > > > > > > > > > > > until all lost file locks are released.
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > Just giving this a quick glance:
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > Based on the last email discussion about this, I thought that you were
> > > > > > > > > > > > > > going to provide a mount option that someone could enable that would
> > > > > > > > > > > > > > basically allow the client to "soldier on" in the face of being
> > > > > > > > > > > > > > blacklisted and then unblacklisted, without needing to remount anything.
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > This set seems to keep the force_reconnect option (patch #7) though, so
> > > > > > > > > > > > > > I'm quite confused at this point. What exactly is the goal of here?
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > 
> > > > > > > > > > > > > because auto reconnect can be disabled, force_reconnect is the manual
> > > > > > > > > > > > > way to fix blacklistd mount.
> > > > > > > > > > > > > 
> > > > > > > > > > > > 
> > > > > > > > > > > > Why not instead allow remounting with a different recover_session= mode?
> > > > > > > > > > > > Then you wouldn't need this option that's only valid during a remount.
> > > > > > > > > > > > That seems like a more natural way to use a new mount option.
> > > > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > > you mean something like 'recover_session=now' for remount?
> > > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > No, I meant something like:
> > > > > > > > > > 
> > > > > > > > > >     -o remount,recover_session=brute
> > > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > This is confusing. user may just want to change auto reconnect mode
> > > > > > > > > for backlist event in the future, does not want to force reconnect.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Why do we need to allow the admin to manually force a reconnect? If you
> > > > > > > > (hypothetically) change the mode to "brute" then it should do it on its
> > > > > > > > own when it detects that it's in this situation, no?
> > > > > > > > 
> > > > > > > 
> > > > > > > First, auto reconnect is limited to once every 30 seconds. Second,
> > > > > > > client may fail to detect that itself is blacklisted. So I think we
> > > > > > > still need a way to force client to reconnect
> > > > > > > 
> > > > > > 
> > > > > > How does it detect that it has been blacklisted? Does it do that by
> > > > > > looking at the OSD maps? I'd like to better understand how the client
> > > > > > would recognize this automatically and why it might miss it.
> > > > > > 
> > > > > 
> > > > > By checking osd request reply and session reject message from mds.
> > > > > 
> > > > 
> > > > Ok, so is the issue is that the client may become blacklisted and
> > > > unblacklisted before it sends anything to either server?
> > > > 
> > > 
> > > No. The issue is that old version mds does not send session reject
> > > message or no 'error_str=blacklisted' in session reject message.
> > 
> > Is that the only way to detect that this has happened? What if we were
> > to simply force a reconnect on any remount? Would that break anything?
> > 
> 
> why?  reconnect causes all sorts of integrity issues
> 

Care to elaborate?

My understanding was that the fact that the MDS journaled everything
meant that the client would be able to reclaim all of its state if the
MDS crashed and restarted, or we had a momentary loss of connection. Is
that not the case?

Either way, remounts should be _very_ rare events, almost always
performed manually by an administrator. I suggested this under the
assumption that an immediate reconnection might just be a small blip in
performance. If there are data integrity issues when this occurs then
that seems like a bigger problem.
-- 
Jeff Layton <jlayton@redhat.com>

