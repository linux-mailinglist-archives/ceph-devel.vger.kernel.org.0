Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BC1145A8A
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jan 2020 18:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAVREs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jan 2020 12:04:48 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46771 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVREs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Jan 2020 12:04:48 -0500
Received: by mail-qt1-f195.google.com with SMTP id e25so60660qtr.13
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jan 2020 09:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O2RdDvevr6e3EPrdVvDHPPiBCKTgDCf+AI9wVqtrn4Y=;
        b=d91ia+DPya/52orv2hc9NGBDdjY+kJ3P55jDjC22+jiayemCCdoadh5CLp5wZ4GfPV
         5NcfuUMsVvtzkK0KatDLdUB373ucq/0Fu2NzjThQAyPOLm6sTykBjo6DSYPhMZkWNiES
         y3288aCzo26Q28bH9cgErPxX17qJynAk6jhd5zwC0rIM8UAZ6SOz8Mlksgk7zmuRz6KH
         vz95gyS99eR7W9ZARIvodeA4jRQBdE+MorWQqRl5GdA3s9mq1bu+tRD1FUayM9Ub/VdR
         oz//0EvbQrGjRv8GtSyeaHTTL7QJtWr/3M29oEjdWBX4EY1ZpgIRB1CqY8d0VVhYjmH1
         zrGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2RdDvevr6e3EPrdVvDHPPiBCKTgDCf+AI9wVqtrn4Y=;
        b=Hsk/dxNl1ICgVwMV5i3aLKWo2bORx64R8iP97uF0El/pUf3n2+aQ3w35B167YazA6r
         lYuSjooTjFZY5xThLQsJ7zHw4n2v21iFHf9vKN8WXTQ9sGjgiZkA/uC94zaVt4HP/TdZ
         XB13Yb+5Yh6iJAt6mfR7pI36HhB4mKaX1+pqyFkOLCMtaYrRmD4k2pkRWggq+8BQhmmg
         7kgklPEnjJmdH+oeRh+VWfUQmYOl86P+te6GpLBJz3WogXdlfgXjD7/NfSTz7B2bL9pi
         EdKu3Jx1BWKmOLzbUOpEKA9qGCcpTplaDhPXN9rgXC/veLEO75rncfeNPB6l5iJ08vrz
         WoZg==
X-Gm-Message-State: APjAAAXwUhO9Szm2L7/Jnso7TGhAjnhaEViMcrtVLCGpONn5LwLye8Ks
        LDZ5TRyfnpmZdod+/brvaXolM+PEb9NCClWfBqE=
X-Google-Smtp-Source: APXvYqzFr2IadgFsfbycUg+2UbU/im2WnhDLPQJlzKtqvsCRrl6ABQsTczffpxf3h8sEVDSfvuYE43VVFHQaXdlNAa8=
X-Received: by 2002:ac8:5513:: with SMTP id j19mr11479963qtq.143.1579712687036;
 Wed, 22 Jan 2020 09:04:47 -0800 (PST)
MIME-Version: 1.0
References: <20200121192928.469316-1-jlayton@kernel.org>
In-Reply-To: <20200121192928.469316-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 23 Jan 2020 01:04:35 +0800
Message-ID: <CAAM7YAnYoCuxu2Oj3vK1ZyWyAgh_vWWTYRxE2ZqEhU9vT+YTKg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/10] ceph: asynchronous file create support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 22, 2020 at 3:31 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> v3:
> - move some cephfs-specific code into ceph.ko
> - present and track inode numbers as u64 values
> - fix up check for dentry and cap eligibility checks
> - set O_CEPH_EXCL on async creates
> - attempt to handle errors better on async create (invalidate dentries
>   and dir completeness).
> - ensure that fsync waits for async create to complete
>
> v2:
> - move cached layout to dedicated field in inode
> - protect cached layout with i_ceph_lock
> - wipe cached layout in __check_cap_issue
> - set max_size of file to layout.stripe_unit
> - set truncate_size to (u64)-1
> - use dedicated CephFS feature bit instead of CEPHFS_FEATURE_OCTOPUS
> - set cap_id to 1 in async created inode
> - allocate inode number before submitting request
> - rework the prep for an async create to be more efficient
> - don't allow MDS or cap messages involving an inode until we get async
>   create reply
>
> Still not quite ready for merge, but I've cleaned up a number of warts
> in the v2 set. Performance numbers still look about the same.
>
> There is definitely still a race of some sort that causes the client to
> try to asynchronously create a dentry that already exists. I'm still
> working on tracking that down.
>
> Jeff Layton (10):
>   ceph: move net/ceph/ceph_fs.c to fs/ceph/util.c
>   ceph: make ceph_fill_inode non-static
>   ceph: make dentry_lease_is_valid non-static
>   ceph: make __take_cap_refs non-static
>   ceph: decode interval_sets for delegated inos
>   ceph: add flag to designate that a request is asynchronous
>   ceph: add infrastructure for waiting for async create to complete
>   ceph: add new MDS req field to hold delegated inode number
>   ceph: cache layout in parent dir on first sync create
>   ceph: attempt to do async create when possible
>
>  fs/ceph/Makefile                     |   2 +-
>  fs/ceph/caps.c                       |  38 +++--
>  fs/ceph/dir.c                        |  13 +-
>  fs/ceph/file.c                       | 240 +++++++++++++++++++++++++--
>  fs/ceph/inode.c                      |  50 +++---
>  fs/ceph/mds_client.c                 | 123 ++++++++++++--
>  fs/ceph/mds_client.h                 |  17 +-
>  fs/ceph/super.h                      |  16 +-
>  net/ceph/ceph_fs.c => fs/ceph/util.c |   4 -
>  include/linux/ceph/ceph_fs.h         |   8 +-
>  net/ceph/Makefile                    |   2 +-
>  11 files changed, 443 insertions(+), 70 deletions(-)
>  rename net/ceph/ceph_fs.c => fs/ceph/util.c (94%)
>
> --
> 2.24.1
>

I realized that there still are two issues:
-  we needs to clear delegated inos when mds failover
- we needs to clear caps for async dir operations when reconnecting to
mds. (see last commit of https://github.com/ceph/ceph/pull/32576)

Regards
Yan, Zheng
