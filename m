Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1036930627
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 03:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfEaBSP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 21:18:15 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35706 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfEaBSO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 May 2019 21:18:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id l128so5265704qke.2
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 18:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+pfNVkny3ljThzWfAME7L3xUXyuxgcYdb8jm3SJY+q8=;
        b=Xtw06TJBsZMInxIL+yt3TB61jy2IOHibcFyQpHTtPllynQdl09tl8zvhbx0TdH4tRW
         v/KHDFveJ68iskWEzZpY4kpTS/QTnE7u5yy/O78wTB7LJdwgLgSGCddVmFVCCPoblmYw
         sV/2RkQcu7VXkidxzqlJxAFZpJ5j+c1kxSDa1ag7lZoZ6X2W2CFTWw9pVOh8hIDjUJVH
         OT0U9W3cvrub+cBUdpKfCzMPGfGXs1r5SVZbWpYhbD1u43ilEWENAvcLmrsGL/u7fotJ
         hmkZQhVjPLoCKufjqzNoDE/K7k32hrR7rTqjheLTWAm8ZGrzOZ/1fhucCEytBzzw5HUd
         +AAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+pfNVkny3ljThzWfAME7L3xUXyuxgcYdb8jm3SJY+q8=;
        b=nJVpNxHw6naRmwCW0EoCAjfbPbF37l9A+pxVNJFk7dEh/rNoiXkS8vh76GHfLF+Vi4
         FyJeU6A6VN6ZZ8mO/o/Ha7xIvcjp/5o+3UDSi2aDKK4ron73wDSSbfnmae2xcMYR5Wfj
         B8M8yMhg4bXkwGsFeJMzZB4fBEZHBY0hPgycPDON5/o9MvN95L8TdqHhaZe7/ATPzzpR
         UF46Ju0gLEYPNOVBXn8bL5fIW7j1uxohRwjxziCnRk0HPS3r1kO4JgQyWBO27lBkaRKQ
         iTtElc4KnyrEbIgXXFdjA2YkyfcXoXstKKdLBAtKOsz/YN/mXa2x7++qHKiYDwZ4Zfl5
         ij7w==
X-Gm-Message-State: APjAAAVyRNEJZVpQzStsIKp/rvrA0R7X6ut/9/asOaXCIVRuKZ2gnv6+
        +/8E9RBJH/sUf81eyFF4Kg4ykeLbW4X+0LUaeGQBIi9hb6w=
X-Google-Smtp-Source: APXvYqwfiQC5Nl46y+OT3ib5xqbrMU+cjTi9BL1V0bSV1dPdWBNjqAJh/60Mtl8y1leYgJY0VWdCG0tAUSCZvzu6aVQ=
X-Received: by 2002:a37:a91:: with SMTP id 139mr6183703qkk.301.1559265493804;
 Thu, 30 May 2019 18:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1905301402170.29218@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1905301402170.29218@piezo.novalocal>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 31 May 2019 09:18:02 +0800
Message-ID: <CAAM7YA=PCJ1sfiuKRvuFC_5NBTZT18V0DVsZYYCG3OM91=+ARw@mail.gmail.com>
Subject: Re: SnapServer::check_osd_map() and is_removed_snap()
To:     Sage Weil <sweil@redhat.com>
Cc:     Zheng Yan <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 30, 2019 at 10:13 PM Sage Weil <sweil@redhat.com> wrote:
>
> Hi Zheng-
>
> I'm trying to get rid of the removed_snaps member from pg_pool_t as this
> is a scaling problem for aged clusters with lots of removed snapshots.
> I'm down to a handful of users: rados cache tiered pools, and
> SnapServer::check_osd_map().  I'm not entirely following what the
> code is doing with all_purge vs all_purged.. do you mind taking a look?
>

all_purge are snaps in need_to_purge set , which really need to purge.
all_purged are snaps in need_to_purge, which have already been purged.

> If we can get away with not using the OSDMap's removed_snaps (and by
> extension is_removed_snap()) at all, that would be ideal.  If the MDS
> really *does* need to know which snaps have been purged from the
> rados pool, then we can instead switch to using the new_removed_snaps
> OSDMap member instead.  The difference is that new_removed_snaps includes
> the snaps that were removed in the current epoch only, so in order to
> reliably capture all removed snaps, the MDS would need to examine every
> OSDMap epoch (not just the latest map).
>
> It looks to me like the MDS basically needs an ack that it's attempt to
> remove a snap has succeeded from the mon, and it's doing that by examining
> the resulting OSDMap.  The mon actually has a durable record for all
> deleted snaps, though, so I suspect the best fix for this is just
> to change the mds <-> mon protocol so that MRemoveSnaps gets an ack back
> after the snap is deleted (or has already been deleted).  Otherwise it
> will be a real challenge for the MDS to ensure that it finds out about
> deleted snaps in the fact of MDS restarts and possible gaps in the osdmap
> history...
>
> Does that seem reasonable?
>

ACK approach should work. MDS just needs to call
SnapServer::do_server_update() for the ACK.

Regards
Yan, Zheng

> Thanks!
> sage
