Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FBC49AA1
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Jun 2019 09:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfFRHbt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Jun 2019 03:31:49 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46062 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfFRHbt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Jun 2019 03:31:49 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so7885508qkj.12
        for <ceph-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qgstaAcs0jfGEJgkxlLhjagsZ2KOXz31nYSXT8KFsDU=;
        b=Gkle1zuEGPb9PqOV/Q5XrEWmrfJsAxwXc72GmfUCWjkQjUICetYz1uKgxsAPuZDYan
         COEUkMsi1XjZ06H5ddaL2KgGY+Zhm+8CmFKCzYSX3cbboRjArP47jkvctD80n69jqnTE
         JdhP2mC1PBjhV3B2FkQGsvehc71p9b2thzPMKNicsjqRASFOd5vP0amz7Uqfj0HqNor/
         kQTluQOst/r9hZafgZ2s6gAhVlat9ajxAWgXSDNqvOrfzCloAB7Ll1mlqW1rmchkgnNF
         0vI/VEigN+PDEAsEFlH2U5iMz+By9hPJB0kJaKxsP8rsFebMgiRDb2pKO1wL8YMyXWJi
         Ld6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qgstaAcs0jfGEJgkxlLhjagsZ2KOXz31nYSXT8KFsDU=;
        b=dGFVQKqH244aJj3qX5xmZmQivUj8hsTqQ6N+py4T/DHbfyVxiMVOhfBY1IQg23AWHE
         UeErQzdqy4N2e/rsL95k/PCEkZyVVFsdXOyrDeHsb1lNDpkeXzMoGR+16sVr8De3if2B
         XIGGmiHYFhu7eT38KpBw1Ycdhl0miGakZ1KWxmswp4UspXOtZ/gaZMqwNP/L2vGX2nDz
         yOTmVOTQJMvnXaMZVKOxNgExuqrjYQYjKasDdhzM79scJxKpAKbTVQakLHxKwrUL8P9O
         mtU3fJ5zgGNt9TUXNHWEthjV7BPiTkGxKDhaZnxLeSP/TVnRtiRbrumnF40BZfI1jLJV
         VEjg==
X-Gm-Message-State: APjAAAUveQW5M0Z5ciaP5gj78dGHktoH6QWHn4QP3udKrI7SfSd1FSGn
        MCUJECzIh14gtyZA5GVB0Fcoklc1CNBB/doZcz8=
X-Google-Smtp-Source: APXvYqxzon+i9vzkKELf1ZDljAR9l7PzSXoQWk1jpwhnoFW/0bgkavyzLEksYE6KLT2JeuhH1xZJLL8tNh2lAkfl7UI=
X-Received: by 2002:a05:620a:533:: with SMTP id h19mr35764324qkh.325.1560843108065;
 Tue, 18 Jun 2019 00:31:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190617153753.3611-1-jlayton@kernel.org>
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 18 Jun 2019 15:31:36 +0800
Message-ID: <CAAM7YAmK7V=14xXohYauhiKi-Tomwm50dkhQF5uE7tWTFbaLMw@mail.gmail.com>
Subject: Re: [PATCH v2 00/18] ceph: addr2, btime and change_attr support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Zheng Yan <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 11:39 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> v2: properly handle later versions in entity_addr decoder
>     internally track addresses as TYPE_LEGACY instead of TYPE_NONE
>     minor cleanup and log changes
>
> This is the second posting of this set. This one should handle decoding
> later versions of the entity_addr_t struct, should there ever be any
> (thanks, Zheng!).
>
> This also breaks up that decoder into smaller helper functions, and
> changes how we track the addresses internally for better compatibility
> going forward.
>
> Original patch description follows:
>
> ------------------------8<-------------------------
>
> CEPH_FEATURE_MSG_ADDR2 was added to the userland code a couple of years
> ago, but the kclient never got support for it. While addr2 doesn't add a
> lot of new functionality, it is a prerequisite for msgr2 support, which
> we will eventually need, and the feature bit is shared with
> CEPH_FEATURE_FS_BTIME and CEPH_FEATURE_FS_CHANGE_ATTR.
>
> This set adds support for all of three features (necessary since the bit
> is shared). I've also added support for querying birthtime via statx().
>
> I was able to do a cephfs mount and ran xfstests on it, but some of the
> more obscure messages haven't yet been tested. Birthtime support works
> as expected, but I don't have a great way to test the change attribute.
>
> We don't set SB_I_VERSION, so none of the internal kernel users will
> rely on it, and that value is not exposed to userspace via statx (yet).
> Given that, we could leave off the last 4 patches for now.
>
> Jeff Layton (18):
>   libceph: fix sa_family just after reading address
>   libceph: add ceph_decode_entity_addr
>   libceph: ADDR2 support for monmap
>   libceph: switch osdmap decoding to use ceph_decode_entity_addr
>   libceph: fix watch_item_t decoding to use ceph_decode_entity_addr
>   libceph: correctly decode ADDR2 addresses in incremental OSD maps
>   ceph: have MDS map decoding use entity_addr_t decoder
>   ceph: fix decode_locker to use ceph_decode_entity_addr
>   libceph: use TYPE_LEGACY for entity addrs instead of TYPE_NONE
>   libceph: rename ceph_encode_addr to ceph_encode_banner_addr
>   ceph: add btime field to ceph_inode_info
>   ceph: handle btime in cap messages
>   libceph: turn on CEPH_FEATURE_MSG_ADDR2
>   ceph: allow querying of STATX_BTIME in ceph_getattr
>   iversion: add a routine to update a raw value with a larger one
>   ceph: add change_attr field to ceph_inode_info
>   ceph: handle change_attr in cap messages
>   ceph: increment change_attribute on local changes
>
>  fs/ceph/addr.c                     |  2 +
>  fs/ceph/caps.c                     | 37 +++++++------
>  fs/ceph/file.c                     |  5 ++
>  fs/ceph/inode.c                    | 23 ++++++--
>  fs/ceph/mds_client.c               | 21 +++++---
>  fs/ceph/mds_client.h               |  2 +
>  fs/ceph/mdsmap.c                   | 12 +++--
>  fs/ceph/snap.c                     |  3 ++
>  fs/ceph/super.h                    |  4 +-
>  include/linux/ceph/ceph_features.h |  1 +
>  include/linux/ceph/decode.h        | 13 ++++-
>  include/linux/ceph/mon_client.h    |  1 -
>  include/linux/iversion.h           | 24 +++++++++
>  net/ceph/Makefile                  |  2 +-
>  net/ceph/cls_lock_client.c         |  7 ++-
>  net/ceph/decode.c                  | 86 ++++++++++++++++++++++++++++++
>  net/ceph/messenger.c               | 14 ++---
>  net/ceph/mon_client.c              | 21 +++++---
>  net/ceph/osd_client.c              | 20 ++++---
>  net/ceph/osdmap.c                  | 31 ++++++-----
>  20 files changed, 258 insertions(+), 71 deletions(-)
>  create mode 100644 net/ceph/decode.c
>

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>


> --
> 2.21.0
>
