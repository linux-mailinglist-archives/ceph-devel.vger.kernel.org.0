Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99D74C68
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391495AbfGYLDC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:03:02 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33151 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388173AbfGYLDC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Jul 2019 07:03:02 -0400
Received: by mail-yw1-f68.google.com with SMTP id l124so19112246ywd.0
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 04:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JOZBIP+UpysMyB3/p8fFxKj+RqJzPeXTl2oxIOjP9/s=;
        b=X92vxcFpVV/5VW8thjhmeoLbpUYxBD6R5ReV83DIYf6c6/8dOOFlR22TLVacTE/P87
         uscGRboekLC02cNht86ZE7QuSqs15R5yIp3cQrvErMkq98YIW9s6PAYfKq0lqEUHXxgh
         QYskGKlD/PK0O00JeFM71yO+iEaiYc7jKZhZ4TQPD3TdDYB8a8zcMQG+fHP5W5g/rYyj
         Wb11zknnItmhP0BymAaZ0UYoNjnMm3wc/SxAwW0eltxx+1Hm6dLIYICrayNmUr1FNzrj
         Cxu2b05bN8CSRRHH1ZF2p2v5nPNqWZNta6Yl4dQ3sOzbI/Z5GGCf2icLkQvgCdqzYDXJ
         iKmw==
X-Gm-Message-State: APjAAAW7h897Xn5SHY2ohee5O/+/gRPObhBGzDayUljqpZGzMkEdJmO0
        RXSAubSB0Lb5f6/mzlfkLFHz7g==
X-Google-Smtp-Source: APXvYqxWVFXGUjhD0VNID5jn4FxO+jbFjpMpsLlXEgcMcYlW0tebwI8PZZw3GouAaucSkdCtv2khJg==
X-Received: by 2002:a81:9c0b:: with SMTP id m11mr50946557ywa.3.1564052581607;
        Thu, 25 Jul 2019 04:03:01 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-43E.dyn6.twc.com. [2606:a000:1100:37d::43e])
        by smtp.gmail.com with ESMTPSA id 200sm12146461ywq.102.2019.07.25.04.03.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 04:03:00 -0700 (PDT)
Message-ID: <f1f85463bfcbfad82c41d9e3915771d6330794ae.camel@redhat.com>
Subject: Re: [PATCH 0/9 v2] ceph: auto reconnect after blacklisted
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Thu, 25 Jul 2019 07:02:59 -0400
In-Reply-To: <d90a1410-16e7-55d1-c681-62c9058f8be8@redhat.com>
References: <20190724122120.17438-1-zyan@redhat.com>
         <0db845ac61f98157e8dbe3e23fea90996fdc69fb.camel@redhat.com>
         <d90a1410-16e7-55d1-c681-62c9058f8be8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-07-25 at 09:31 +0800, Yan, Zheng wrote:
> On 7/24/19 8:56 PM, Jeff Layton wrote:
> > On Wed, 2019-07-24 at 20:21 +0800, Yan, Zheng wrote:
> > > This series add support for auto reconnect after blacklisted.
> > > 
> > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > So far only clean mode is supported and it is the default mode. In this
> > > mode, client drops any dirty data/metadata, invalidates page caches and
> > > invalidates all writable file handles. After reconnect, file locks become
> > > stale because MDS lose track of them. If an inode contains any stale file
> > > lock, read/write on the indoe are not allowed until all stale file locks
> > > are released by applications.
> > > 
> > > v2: remove force_remount mount option
> > >      no enabled auto reconnect by default
> > >      remove unfinished recover_session=brute code
> > > 
> > 
> > I've looked over the set and I think this looks reasonable modulo a few
> > small nits that can be cleaned up during or after merging.
> > 
> > I don't see the knob that forces a reconnect in this set any longer. Did
> > you decide that that wasn't needed or are you planning to add it in a
> > later set?
> 
> add it later
> 
> 

Ok. I went ahead and pushed these to the testing branch, and added a few
small patches on top to clean up the documentation and some sparse
warnings. Let me know if you have issues with any of those.

> > 
> > > Yan, Zheng (9):
> > >    libceph: add function that reset client's entity addr
> > >    libceph: add function that clears osd client's abort_err
> > >    ceph: allow closing session in restarting/reconnect state
> > >    ceph: track and report error of async metadata operation
> > >    ceph: pass filp to ceph_get_caps()
> > >    ceph: add helper function that forcibly reconnects to ceph cluster.
> > >    ceph: return -EIO if read/write against filp that lost file locks
> > >    ceph: invalidate all write mode filp after reconnect
> > >    ceph: auto reconnect after blacklisted
> > > 
> > >   Documentation/filesystems/ceph.txt | 10 ++++
> > >   fs/ceph/addr.c                     | 37 ++++++++----
> > >   fs/ceph/caps.c                     | 93 +++++++++++++++++++++---------
> > >   fs/ceph/file.c                     | 50 +++++++++-------
> > >   fs/ceph/inode.c                    |  2 +
> > >   fs/ceph/locks.c                    |  8 ++-
> > >   fs/ceph/mds_client.c               | 89 ++++++++++++++++++++++------
> > >   fs/ceph/mds_client.h               |  6 +-
> > >   fs/ceph/super.c                    | 45 ++++++++++++++-
> > >   fs/ceph/super.h                    | 21 +++++--
> > >   include/linux/ceph/libceph.h       |  1 +
> > >   include/linux/ceph/messenger.h     |  1 +
> > >   include/linux/ceph/mon_client.h    |  1 +
> > >   include/linux/ceph/osd_client.h    |  2 +
> > >   net/ceph/ceph_common.c             |  8 +++
> > >   net/ceph/messenger.c               |  5 ++
> > >   net/ceph/mon_client.c              |  7 +++
> > >   net/ceph/osd_client.c              | 24 ++++++++
> > >   18 files changed, 324 insertions(+), 86 deletions(-)
> > > 

-- 
Jeff Layton <jlayton@redhat.com>

