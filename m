Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7F710813
	for <lists+ceph-devel@lfdr.de>; Wed,  1 May 2019 14:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfEAM5w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 May 2019 08:57:52 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45992 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfEAM5w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 May 2019 08:57:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id d5so10082630qko.12
        for <ceph-devel@vger.kernel.org>; Wed, 01 May 2019 05:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FaMMkKAP5buFkqB1dRjhT5+dGB6W7HCbbUghWuIOXZ0=;
        b=exhv6G6Ri9nUyv7qZ6jzHLe/dshbwEVETlqJOXe3XzQlt9sSZ8NRaMTIHZFJtwfNPc
         KEfGaEDwWB5yTLeEbyGww6AUhmO8INgQcZMi2YO5OHUOyXwlHVjyOPxWFlLlB0HxhqqE
         LV6bcvs/7MwRuncYkv7lqNMBlLuQyijX6LvyuPJp+xawE4yJkkWBjW6dC9gq9cnbJmee
         iyuODuH0b/A6oWmQTB4ZT6NyCgFJGDc0VLaM0ecE2nra1gXdePsmissk+PLDk+f0B+Uq
         lN3YIfVLV4bLs8t3B0ZS4Klr7AsPTnF35glPNPuxwofA+Kz5e38GoI+MXP5R3+VpluUX
         k/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FaMMkKAP5buFkqB1dRjhT5+dGB6W7HCbbUghWuIOXZ0=;
        b=kviKeJQXoiLlRY5dFJE0k9aUkeMet5toQ501mOI2oieY+fFvUG1fcpQK5QPDxFC+Bk
         fiva6Tlzqlq2Mkd2AyED2bDAlLm/WNGuoIFsupghY+ngJVsUK/Rmh+74GIcJH8CPllGY
         6JJhGCzjUaEZflBbS8bH6dJE3j+HieBURMnf2DK4jm8XeWh5qxo29cekIPxh2JuoALA4
         O8iJJ0Fepj/il+wtZKCq2VjAzpQAXtB5to0lhGKGdcXgWmNpfZ2/bJVg08J53mmIVNkY
         x7HrVf43WcdPSfcP8sz34lMvkHkpzpt8hHGgHRIjIe3BqZH0Bakb/o+XTo8t/OL2QprN
         ZHbw==
X-Gm-Message-State: APjAAAVbzVewIw2Vhg77z4auwzqoMb94bWpVAh5zhHSy/XUWaoogQQUy
        1Y6rhFTMHnNVAm+XqxD4mQ3OMUN2uI4ENv1R/SQ=
X-Google-Smtp-Source: APXvYqxclFz9sL5quZzzrmw6DQTLdqrZHDGvABmNkX2++8Dd4XNAoh36q0Kx1q0IUkS86vcy7dm4LGS1a95ILqc8/hk=
X-Received: by 2002:a37:7b05:: with SMTP id w5mr52842937qkc.354.1556715471003;
 Wed, 01 May 2019 05:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190430112236.14162-1-jlayton@kernel.org>
In-Reply-To: <20190430112236.14162-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 1 May 2019 20:57:39 +0800
Message-ID: <CAAM7YAkqDX5oqUncmds2P4bh_Ejvi8ZVFff7XqPR6KVd6OfFDw@mail.gmail.com>
Subject: Re: [PATCH] ceph: print inode number in __caps_issued_mask debugging messages
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Zheng Yan <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 30, 2019 at 7:25 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> To make it easier to correlate with MDS logs.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 9e0b464d374f..72f8e1311392 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -892,8 +892,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>         int have = ci->i_snap_caps;
>
>         if ((have & mask) == mask) {
> -               dout("__ceph_caps_issued_mask %p snap issued %s"
> -                    " (mask %s)\n", &ci->vfs_inode,
> +               dout("__ceph_caps_issued_mask ino 0x%lx snap issued %s"
> +                    " (mask %s)\n", ci->vfs_inode.i_ino,
>                      ceph_cap_string(have),
>                      ceph_cap_string(mask));
>                 return 1;
> @@ -904,8 +904,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>                 if (!__cap_is_valid(cap))
>                         continue;
>                 if ((cap->issued & mask) == mask) {
> -                       dout("__ceph_caps_issued_mask %p cap %p issued %s"
> -                            " (mask %s)\n", &ci->vfs_inode, cap,
> +                       dout("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s"
> +                            " (mask %s)\n", ci->vfs_inode.i_ino, cap,
>                              ceph_cap_string(cap->issued),
>                              ceph_cap_string(mask));
>                         if (touch)
> @@ -916,8 +916,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>                 /* does a combination of caps satisfy mask? */
>                 have |= cap->issued;
>                 if ((have & mask) == mask) {
> -                       dout("__ceph_caps_issued_mask %p combo issued %s"
> -                            " (mask %s)\n", &ci->vfs_inode,
> +                       dout("__ceph_caps_issued_mask ino 0x%lx combo issued %s"
> +                            " (mask %s)\n", ci->vfs_inode.i_ino,
>                              ceph_cap_string(cap->issued),
>                              ceph_cap_string(mask));
>                         if (touch) {
> --

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>

> 2.20.1
>
