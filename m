Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB37B72F51
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 14:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfGXM45 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 08:56:57 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:34635 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfGXM45 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Jul 2019 08:56:57 -0400
Received: by mail-yb1-f195.google.com with SMTP id q5so5128482ybp.1
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 05:56:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=e1ZQ5REdTmHZsqBo+0gHrm1lr43naCKKCu0Dz3JX80I=;
        b=XYpcKY6/KBWPh1g018Qq02Jbr5zFgyU6wLPFwv4mTd3FXLoWDYU9+aNGpAhrZaWkUw
         rmy5SaZ2D17BpFkPS3dt51hoegIH8IYAqsGAoeIYKGrA9FD/BAiTpgmrzEvMtjKKIry7
         qn5lE1dWA7fug2iTtJwI2OWSajcjQXJc7j5QgGj4N2w+8cojjqtsjBBUdv6LHVU3e+5v
         iVXcXkeO2sjyXmOJp6ObjBr2+cSNlnHxJtEDLC62AVfkvS4WgjngQxglnHgQytWJcn86
         AZsXLMA/wfTEvketG/ECgZHvafVL/5msZPyoP0rb5KFeOApaex2R4ncd2/POhupY9zBu
         NkuA==
X-Gm-Message-State: APjAAAVlShbofm6FK92HOQrtrIjwgOW+wgvI1+RFWsbjDsrKzDPuYnDn
        99C2IkimNFqAwKRKnj5+xnKYjxuYClI=
X-Google-Smtp-Source: APXvYqzRPfp0z7OAYrAWD6Px76t6W63OYYTZE336GjC70tEA7nbykzUdQG/npnKcUM9rOwjTLrE69Q==
X-Received: by 2002:a25:85:: with SMTP id 127mr52857009yba.186.1563973016286;
        Wed, 24 Jul 2019 05:56:56 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-62B.dyn6.twc.com. [2606:a000:1100:37d::62b])
        by smtp.gmail.com with ESMTPSA id v144sm10765136ywv.17.2019.07.24.05.56.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 05:56:55 -0700 (PDT)
Message-ID: <0db845ac61f98157e8dbe3e23fea90996fdc69fb.camel@redhat.com>
Subject: Re: [PATCH 0/9 v2] ceph: auto reconnect after blacklisted
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Wed, 24 Jul 2019 08:56:54 -0400
In-Reply-To: <20190724122120.17438-1-zyan@redhat.com>
References: <20190724122120.17438-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-07-24 at 20:21 +0800, Yan, Zheng wrote:
> This series add support for auto reconnect after blacklisted.
> 
> Auto reconnect is controlled by recover_session=<clean|no> mount option.
> So far only clean mode is supported and it is the default mode. In this
> mode, client drops any dirty data/metadata, invalidates page caches and
> invalidates all writable file handles. After reconnect, file locks become
> stale because MDS lose track of them. If an inode contains any stale file
> lock, read/write on the indoe are not allowed until all stale file locks
> are released by applications.
> 
> v2: remove force_remount mount option
>     no enabled auto reconnect by default
>     remove unfinished recover_session=brute code
> 

I've looked over the set and I think this looks reasonable modulo a few
small nits that can be cleaned up during or after merging.

I don't see the knob that forces a reconnect in this set any longer. Did
you decide that that wasn't needed or are you planning to add it in a
later set?


> Yan, Zheng (9):
>   libceph: add function that reset client's entity addr
>   libceph: add function that clears osd client's abort_err
>   ceph: allow closing session in restarting/reconnect state
>   ceph: track and report error of async metadata operation
>   ceph: pass filp to ceph_get_caps()
>   ceph: add helper function that forcibly reconnects to ceph cluster.
>   ceph: return -EIO if read/write against filp that lost file locks
>   ceph: invalidate all write mode filp after reconnect
>   ceph: auto reconnect after blacklisted
> 
>  Documentation/filesystems/ceph.txt | 10 ++++
>  fs/ceph/addr.c                     | 37 ++++++++----
>  fs/ceph/caps.c                     | 93 +++++++++++++++++++++---------
>  fs/ceph/file.c                     | 50 +++++++++-------
>  fs/ceph/inode.c                    |  2 +
>  fs/ceph/locks.c                    |  8 ++-
>  fs/ceph/mds_client.c               | 89 ++++++++++++++++++++++------
>  fs/ceph/mds_client.h               |  6 +-
>  fs/ceph/super.c                    | 45 ++++++++++++++-
>  fs/ceph/super.h                    | 21 +++++--
>  include/linux/ceph/libceph.h       |  1 +
>  include/linux/ceph/messenger.h     |  1 +
>  include/linux/ceph/mon_client.h    |  1 +
>  include/linux/ceph/osd_client.h    |  2 +
>  net/ceph/ceph_common.c             |  8 +++
>  net/ceph/messenger.c               |  5 ++
>  net/ceph/mon_client.c              |  7 +++
>  net/ceph/osd_client.c              | 24 ++++++++
>  18 files changed, 324 insertions(+), 86 deletions(-)
> 

-- 
Jeff Layton <jlayton@redhat.com>

