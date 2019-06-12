Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F7F42806
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jun 2019 15:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436722AbfFLNwJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jun 2019 09:52:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41683 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407647AbfFLNwI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jun 2019 09:52:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id 33so10413359qtr.8
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jun 2019 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t7R2AdIZPH/1VAb0p7kJf0o9N/NRTsF3PdDwmgsXpWY=;
        b=uD2DXOW4t2krhR7hnV6g0sL4o+JglkYenXhx5BLKOR8RAsvre9Bt/coqN71eaZMJA3
         /5W98kPkYX6vR02pUjxQkchq+bG88FL8VvjjCJDUguHHMOaOoCtYgyT3Psoz8Y7RUQfH
         j0e8NZpJCxQUE80Zj+vmiJLxD+4Fz4NWDgBaGEI4dqqdwl1CAhjXCesnXR6/EUxJnre3
         vR8zs18aNXv3RLHf5QusAg4/7pb1srsjn7NRZMDhtlINXmD31khSicnyKVe29jLDeT/g
         /euTmZ3iED60w7YroGP8HKxsMKrD6c0NcRaYBXoFfDjovepJf4y++Hbc242+3sGRNnzg
         Pb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t7R2AdIZPH/1VAb0p7kJf0o9N/NRTsF3PdDwmgsXpWY=;
        b=D7VrY66d2ywiUyh/97udADeoau+y4qRjFAGVjMEDKIJ5Nh1WN2NNtT2HG6FZEMIVf9
         +SpBRAXMTtakJfx1LBFBJUxG2Q+s201LX8EeTMSuyCpAdgLX38xcw9cTp2EyKAycVct0
         bNprn9gD2PwlVWu+adEXZpUXlNS9URMz3BPbVzuhXpnsajTSZGcZC533BqNlLD27srUM
         6GS2l/4JAT52hNvsGUXkRwz/Indc2Qjv6+T7W2mCum+jyc5US7AFJLIuFcT9QbMUuInl
         OTj8P++8+s+AhppVM0K/XI+ypsuZJTHgq79G32p+p2xPofX/o76tV6nMyMtvuf/FNv7r
         DUZA==
X-Gm-Message-State: APjAAAXRQe9AxiLoxCOoAA7n+ybX2DVmVY7M4JEKwMN8/RWE9jb77yBx
        wrNclKO8u14rgdsi6NxpeQSwF6AdNc7g31tDpBI=
X-Google-Smtp-Source: APXvYqxc/L7ElTHj+pMitav5fLnNteBAO2e9pgQq5OsT0Eggo7PIRxDUF6SNfpa6i5cU6vISfo6HLLlAUWYkANqjYg4=
X-Received: by 2002:ac8:87d:: with SMTP id x58mr71151299qth.368.1560347527642;
 Wed, 12 Jun 2019 06:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190607184749.8333-1-jlayton@kernel.org>
In-Reply-To: <20190607184749.8333-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 12 Jun 2019 21:51:56 +0800
Message-ID: <CAAM7YAkicqxUg1V-L=GWpJHt-QfnAC2q65KmS_zUG0=bG0jv9Q@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix getxattr return values for vxattrs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io,
        tpetr@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Jun 8, 2019 at 2:47 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> We have several virtual xattrs in cephfs which return various values as
> strings. xattrs don't necessarily return strings however, so we need to
> include the terminating NULL byte when we return the length.
>
> Furthermore, the getxattr manpage says that we should return -ERANGE if
> the buffer is too small to hold the resulting value. Let's start doing
> that here as well.
>
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=1717454
> Reported-by: Tomas Petr <tpetr@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/xattr.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 6621d27e64f5..2a61e02e7166 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -803,8 +803,15 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>                 if (err)
>                         return err;
>                 err = -ENODATA;
> -               if (!(vxattr->exists_cb && !vxattr->exists_cb(ci)))
> -                       err = vxattr->getxattr_cb(ci, value, size);
> +               if (!(vxattr->exists_cb && !vxattr->exists_cb(ci))) {
> +                       /*
> +                        * getxattr_cb returns strlen(value), xattr length must
> +                        * include the NULL.
> +                        */
> +                       err = vxattr->getxattr_cb(ci, value, size) + 1;

This confuses getfattr. also causes failures of our test cases.

run getfattr without the patch, we get:
[root@kvm2-alpha ceph]# getfattr -n ceph.dir.entries .
# file: .
ceph.dir.entries="1"


with the patch, we get
[root@kvm1-alpha ceph]# getfattr -n ceph.dir.entries .
# file: .
ceph.dir.entries=0sMQA=


> +                       if (size && size < err)
> +                               err = -ERANGE;
> +               }
>                 return err;
>         }
>
> --
> 2.21.0
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io
