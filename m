Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88675E84C
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfGCQBN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 12:01:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40628 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfGCQBN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 12:01:13 -0400
Received: by mail-qt1-f195.google.com with SMTP id a15so4060776qtn.7
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 09:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MCQulyz0bDDztcXVIvOt6gQeDDxuyD5ikKOgwYNQu1g=;
        b=joo5625WT8eDlY65H53VL4VtODD1S2JJYdyEA3qyp7BP/40YFuyUiJ5DvqysJv8WWj
         08eu66yWHsa4+d9c5B/DNmkqpV+QK/A4RykwghYbza3r2oTXncLgQci9pg0+S+94ZNAs
         sZY+0F1OIuCo4f0MOgLmBXkENJLcdqnyuLbAZlTc6R2HLLmJLfIrbw5OTCqkYoE8vacR
         /6P+RXtnwcs/kBTktYXF0ibW2LhGj7sLa0QuMGixklPkqKGwYd2XWpYWL3iNvDSUbs2R
         xvi9ka2na/i8y7dKuFUN8cV6fhSK1ldzCEBzEtjEgb84NY7nNDqKQzEDKlYEzx+Koy15
         3bEQ==
X-Gm-Message-State: APjAAAW2brjyNOx0I28rvqcYaHyjhs3OfGCSHchbxE5tk1Sf+6PFSTyL
        g7l0mlBr3+SKkTGqosjCx7pEEw==
X-Google-Smtp-Source: APXvYqyYtp4uUXVbt1zsezQ/Mo3OAOsQs3becnUX/4XcqnKttTaybjB3mb4qka1t1xggu42MNeoR8w==
X-Received: by 2002:a81:9850:: with SMTP id p77mr21418168ywg.365.1562169671991;
        Wed, 03 Jul 2019 09:01:11 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-E37.dyn6.twc.com. [2606:a000:1100:37d::e37])
        by smtp.gmail.com with ESMTPSA id e20sm998805ywe.95.2019.07.03.09.01.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 09:01:11 -0700 (PDT)
Message-ID: <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
Subject: Re: [PATCH 0/9] ceph: auto reconnect after blacklisted
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Wed, 03 Jul 2019 12:01:10 -0400
In-Reply-To: <20190703124442.6614-1-zyan@redhat.com>
References: <20190703124442.6614-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> This series add support for auto reconnect after blacklisted.
> 
> Auto reconnect is controlled by recover_session=<clean|no> mount option.
> Clean mode is enabled by default. In this mode, client drops dirty date
> and dirty metadata, All writable file handles are invalidated. Read-only
> file handles continue to work and caches are dropped if necessary.
> If an inode contains any lost file lock, read and write are not allowed.
> until all lost file locks are released.

Just giving this a quick glance:

Based on the last email discussion about this, I thought that you were
going to provide a mount option that someone could enable that would
basically allow the client to "soldier on" in the face of being
blacklisted and then unblacklisted, without needing to remount anything.

This set seems to keep the force_reconnect option (patch #7) though, so
I'm quite confused at this point. What exactly is the goal of here?

There's also nothing in the changelogs or comments about
recover_session=brute, which seems like it ought to at least be
mentioned.

At this point, I'm going to say NAK on this set until there is some
accompanying documentation about how you intend for this be used and by
whom. A patch for the mount.ceph(8) manpage would be a good place to
start.

> Yan, Zheng (9):
>   libceph: add function that reset client's entity addr
>   libceph: add function that clears osd client's abort_err
>   ceph: allow closing session in restarting/reconnect state
>   ceph: track and report error of async metadata operation
>   ceph: pass filp to ceph_get_caps()
>   ceph: return -EIO if read/write against filp that lost file locks
>   ceph: add 'force_reconnect' option for remount
>   ceph: invalidate all write mode filp after reconnect
>   ceph: auto reconnect after blacklisted
> 
>  fs/ceph/addr.c                  | 30 +++++++----
>  fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
>  fs/ceph/file.c                  | 50 ++++++++++--------
>  fs/ceph/inode.c                 |  2 +
>  fs/ceph/locks.c                 |  8 ++-
>  fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
>  fs/ceph/mds_client.h            |  6 +--
>  fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
>  fs/ceph/super.h                 | 23 +++++++--
>  include/linux/ceph/libceph.h    |  1 +
>  include/linux/ceph/messenger.h  |  1 +
>  include/linux/ceph/mon_client.h |  1 +
>  include/linux/ceph/osd_client.h |  2 +
>  net/ceph/ceph_common.c          | 38 +++++++++-----
>  net/ceph/messenger.c            |  5 ++
>  net/ceph/mon_client.c           |  7 +++
>  net/ceph/osd_client.c           | 24 +++++++++
>  17 files changed, 365 insertions(+), 100 deletions(-)
> 

-- 
Jeff Layton <jlayton@redhat.com>

