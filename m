Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF52B2D9B8D
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Dec 2020 16:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439190AbgLNP4L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Dec 2020 10:56:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:43634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbgLNPzx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 10:55:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B1629ACE0;
        Mon, 14 Dec 2020 15:55:12 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id ec81c699;
        Mon, 14 Dec 2020 15:55:41 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: wip-msgr2
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
Date:   Mon, 14 Dec 2020 15:55:41 +0000
In-Reply-To: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
        (Ilya Dryomov's message of "Mon, 14 Dec 2020 14:43:26 +0100")
Message-ID: <87wnxk1iwy.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ilya Dryomov <idryomov@gmail.com> writes:

> Hello,
>
> I've pushed wip-msgr2 and opened a dummy PR in ceph-client:
>
>   https://github.com/ceph/ceph-client/pull/22
>
> This set has been through a over a dozen krbd test suite runs with no
> issues other than those with the test suite itself.  The diffstat is
> rather big, so I didn't want to spam the list.  If someone wants it
> posted, let me know.  Any comments are welcome!

That's *awesome*!  Thanks for sharing, Ilya.  Obviously this will need a
lot of time to digest but a quick attempt to do a mount using a v2 monitor
is just showing me a bunch of:

libceph: mon0 (1)192.168.155.1:40898 socket closed (con state V1_BANNER)

Note that this was just me giving it a try with a dummy vstart cluster
(octopus IIRC), so nothing that could be considered testing.  I'll try to
find out what I'm doing wrong in the next couple of days or, worst case,
after EOY vacations.

Cheers,
-- 
Luis

>
>  drivers/block/rbd.c                |    8 +-
>  fs/ceph/mds_client.c               |  106 +-
>  fs/ceph/mdsmap.c                   |   21 +-
>  include/linux/ceph/auth.h          |   68 +-
>  include/linux/ceph/ceph_features.h |   11 +-
>  include/linux/ceph/ceph_fs.h       |   11 +
>  include/linux/ceph/decode.h        |    8 +
>  include/linux/ceph/libceph.h       |   10 +-
>  include/linux/ceph/mdsmap.h        |    2 +-
>  include/linux/ceph/messenger.h     |  285 ++-
>  include/linux/ceph/msgr.h          |   57 +-
>  include/linux/ceph/osdmap.h        |    4 +-
>  net/ceph/Kconfig                   |    3 +
>  net/ceph/Makefile                  |    3 +-
>  net/ceph/auth.c                    |  408 ++++-
>  net/ceph/auth_none.c               |    5 +-
>  net/ceph/auth_x.c                  |  298 +++-
>  net/ceph/auth_x_protocol.h         |    3 +-
>  net/ceph/ceph_common.c             |   63 +
>  net/ceph/ceph_strings.c            |   28 +
>  net/ceph/crypto.h                  |    3 +
>  net/ceph/decode.c                  |  101 ++
>  net/ceph/messenger.c               | 2252 +++++------------------
>  net/ceph/messenger_v1.c            | 1506 ++++++++++++++++
>  net/ceph/messenger_v2.c            | 3443 ++++++++++++++++++++++++++++++++
>  net/ceph/mon_client.c              |  320 +++-
>  net/ceph/osd_client.c              |  111 +-
>  net/ceph/osdmap.c                  |   45 +-
>  28 files changed, 7027 insertions(+), 2156 deletions(-)
>  create mode 100644 net/ceph/messenger_v1.c
>  create mode 100644 net/ceph/messenger_v2.c
>
> Thanks,
>
>                 Ilya

