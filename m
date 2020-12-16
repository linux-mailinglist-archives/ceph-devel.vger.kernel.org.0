Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC4C2DC325
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Dec 2020 16:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgLPPcZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 10:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPPcY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 10:32:24 -0500
Message-ID: <6a870de44a66a6163c8f9a1d7fa5da308b9f8b30.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608132703;
        bh=ZoqixGjzVMB/w9G+vpDpyxm/x1PJmarQGMUx2TRiva0=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=J8LkpNiJqJrwXB+w5UQnuw7uSZCpEi2L6TUTjEfhjnmBgRB104EjDRJJ5Az5FvWMY
         /w5f2ZFXFmP58bTF+KxpiZYlIUvj3G15gwB9awXjUCYa2MKpa8ka9MevXbNRt6iODL
         t3OgY4qMyXlYZopG22jVgafK+BRYlwi27rrgnSR8DdKTrqN5cMyn+XwHBA7ywNS9D+
         xkMgnLn82BDWCuN+kqfLj9UFVsNBYRwpv+/x8dC2zMhw8Cghxsjpv22rj0LItlUJhZ
         4+UoW+xNyIrKNpbvbhMVKOURlsg1N3AXn2Kkn+qsPJ+nefennFCi9GnPd8cNBInuPH
         a3NLYkggaxaMg==
Subject: Re: wip-msgr2
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 16 Dec 2020 10:31:42 -0500
In-Reply-To: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-12-14 at 14:43 +0100, Ilya Dryomov wrote:
> Hello,
> 
> I've pushed wip-msgr2 and opened a dummy PR in ceph-client:
> 
>   https://github.com/ceph/ceph-client/pull/22
> 
> This set has been through a over a dozen krbd test suite runs with no
> issues other than those with the test suite itself.  The diffstat is
> rather big, so I didn't want to spam the list.  If someone wants it
> posted, let me know.  Any comments are welcome!
> 
>  drivers/block/rbd.c                |    8 +-
>  fs/ceph/mds_client.c               |  106 +-
>  fs/ceph/mdsmap.c                   |   21 +-
>  include/linux/ceph/auth.h          |   68 +-
>  include/linux/ceph/ceph_features.h |   11 +-
>  include/linux/ceph/ceph_fs.h       |   11 +
>  include/linux/ceph/decode.h        |    8 +
>  include/linux/ceph/libceph.h       |   10 +-
>  include/linux/ceph/mdsmap.h        |    2 +-
>  include/linux/ceph/messenger.h     |  285 ++-
>  include/linux/ceph/msgr.h          |   57 +-
>  include/linux/ceph/osdmap.h        |    4 +-
>  net/ceph/Kconfig                   |    3 +
>  net/ceph/Makefile                  |    3 +-
>  net/ceph/auth.c                    |  408 ++++-
>  net/ceph/auth_none.c               |    5 +-
>  net/ceph/auth_x.c                  |  298 +++-
>  net/ceph/auth_x_protocol.h         |    3 +-
>  net/ceph/ceph_common.c             |   63 +
>  net/ceph/ceph_strings.c            |   28 +
>  net/ceph/crypto.h                  |    3 +
>  net/ceph/decode.c                  |  101 ++
>  net/ceph/messenger.c               | 2252 +++++------------------
>  net/ceph/messenger_v1.c            | 1506 ++++++++++++++++
>  net/ceph/messenger_v2.c            | 3443 ++++++++++++++++++++++++++++++++
>  net/ceph/mon_client.c              |  320 +++-
>  net/ceph/osd_client.c              |  111 +-
>  net/ceph/osdmap.c                  |   45 +-
>  28 files changed, 7027 insertions(+), 2156 deletions(-)
>  create mode 100644 net/ceph/messenger_v1.c
>  create mode 100644 net/ceph/messenger_v2.c
> 
> Thanks,
> 
>                 Ilya

FWIW, I see these warnings when building with this series with W=1:

./include/linux/ceph/msgr.h:37:24: warning: ‘CEPH_MSGR2_FEATUREMASK_REVISION_1’ defined but not used [-Wunused-const-variable=]
   37 |  static const uint64_t CEPH_MSGR2_FEATUREMASK_##name =            \
      |                        ^~~~~~~~~~~~~~~~~~~~~~~
./include/linux/ceph/msgr.h:43:1: note: in expansion of macro ‘DEFINE_MSGR2_FEATURE’
   43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
      | ^~~~~~~~~~~~~~~~~~~~
./include/linux/ceph/msgr.h:36:24: warning: ‘CEPH_MSGR2_FEATURE_REVISION_1’ defined but not used [-Wunused-const-variable=]
   36 |  static const uint64_t CEPH_MSGR2_FEATURE_##name = (1ULL << bit); \
      |                        ^~~~~~~~~~~~~~~~~~~
./include/linux/ceph/msgr.h:43:1: note: in expansion of macro ‘DEFINE_MSGR2_FEATURE’
   43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
      | ^~~~~~~~~~~~~~~~~~~~

It's probably easy to fix, but I haven't looked in detail yet.
-- 
Jeff Layton <jlayton@kernel.org>

