Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9602A506D
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Nov 2020 20:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgKCTtl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Nov 2020 14:49:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbgKCTtk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Nov 2020 14:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604432979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s/naU2ZtWmoQQ4u1KyO7Kz3ObX4/tYr8s5lUe1lj3fE=;
        b=giE/MOl2LojDAP/VbyDMR6g/FXCE49muWnAStI9elT8dFg23t4Tje95JftKa+HQ6DcRyJe
        Py73ieTbS05XOpxD1MsUZGq9s9DeR5yZfp/hoTJ30wWjLZf064gPAy323HbIcKw8iA7NAk
        ieaZuHMMzJDClfsuoeSx+8Uu3xr86A8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-_b3Q23hSNIGhAM9tIkWMEg-1; Tue, 03 Nov 2020 14:49:37 -0500
X-MC-Unique: _b3Q23hSNIGhAM9tIkWMEg-1
Received: by mail-il1-f197.google.com with SMTP id c8so13690906ilh.9
        for <ceph-devel@vger.kernel.org>; Tue, 03 Nov 2020 11:49:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/naU2ZtWmoQQ4u1KyO7Kz3ObX4/tYr8s5lUe1lj3fE=;
        b=aZC0ApSV+VN+B45LriLlfG12TPPEBzZHWovLAeP4MDGiiI6YYEBbxOk8S/UuB+NaYp
         dGW/39JwVrQNQrj31oVdO8+A5bqKp22LXSYBfftndK7YnxmErXgNM+fPmdx0Q1kDyiKh
         YqbjxjPBB1kGyVmbnZphNC0gyeRCnUPLRMgH1mwvnSqxPYK1ZkIXZD0DlgQMp3MXeZfh
         41qKN4PoGzMj/37KSmKhqvbOhDZu0qKpkmdCWkkiPBLE2ZBArPhoFuv3izvv3NG57mkk
         LUDElIZ2q3VlDBTWHn3/ZnhM17kDtGaL/hZ96c2v0jV0T/QvKhkB6csDTf+o8OGqKnm7
         lpEg==
X-Gm-Message-State: AOAM533J3LoXBG22TqufYOVwKOqj641QYIeBTRR0Ixzf0SLllsQI+HDN
        rHx31xQoSB2BOIc5jAJoEAwtzp1MtCKsTsl6pB03MAw+c6DL1/BQaOH3A2q3IUPwPF6P1mMw/kL
        OvYHQ8//Gd7ZdtbFRQ29wl0CV78szFByqcKuDrg==
X-Received: by 2002:a92:d3ce:: with SMTP id c14mr15506057ilh.157.1604432975800;
        Tue, 03 Nov 2020 11:49:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQgoT+b2Y9xKjmW4tjVdCW1U5agIbH+i3EniQgqt5uCJUXW1/bm9s1iaA0PMkZvnJu6lIvF3AddYXX7tdIJYY=
X-Received: by 2002:a92:d3ce:: with SMTP id c14mr15506049ilh.157.1604432975555;
 Tue, 03 Nov 2020 11:49:35 -0800 (PST)
MIME-Version: 1.0
References: <20201103191058.1019442-1-jlayton@kernel.org>
In-Reply-To: <20201103191058.1019442-1-jlayton@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 3 Nov 2020 11:49:09 -0800
Message-ID: <CA+2bHPb1gY1wwYx+vnRq4f1nO+k3vdEx1WkTexx6xacaskGsZg@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: acquire Fs caps when getting dir stats
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 3, 2020 at 11:11 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> We only update the inode's dirstats when we have Fs caps from the MDS.
>
> Declare a new VXATTR_FLAG_DIRSTAT that we set on all dirstats, and have
> the vxattr handling code acquire Fs caps when it's set.
>
> URL: https://tracker.ceph.com/issues/48104
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/xattr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 197cb1234341..0fd05d3d4399 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -42,6 +42,7 @@ struct ceph_vxattr {
>  #define VXATTR_FLAG_READONLY           (1<<0)
>  #define VXATTR_FLAG_HIDDEN             (1<<1)
>  #define VXATTR_FLAG_RSTAT              (1<<2)
> +#define VXATTR_FLAG_DIRSTAT            (1<<3)
>
>  /* layouts */
>
> @@ -347,9 +348,9 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
>         XATTR_LAYOUT_FIELD(dir, layout, object_size),
>         XATTR_LAYOUT_FIELD(dir, layout, pool),
>         XATTR_LAYOUT_FIELD(dir, layout, pool_namespace),
> -       XATTR_NAME_CEPH(dir, entries, 0),
> -       XATTR_NAME_CEPH(dir, files, 0),
> -       XATTR_NAME_CEPH(dir, subdirs, 0),
> +       XATTR_NAME_CEPH(dir, entries, VXATTR_FLAG_DIRSTAT),
> +       XATTR_NAME_CEPH(dir, files, VXATTR_FLAG_DIRSTAT),
> +       XATTR_NAME_CEPH(dir, subdirs, VXATTR_FLAG_DIRSTAT),
>         XATTR_RSTAT_FIELD(dir, rentries),
>         XATTR_RSTAT_FIELD(dir, rfiles),
>         XATTR_RSTAT_FIELD(dir, rsubdirs),
> @@ -837,6 +838,8 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>                 int mask = 0;
>                 if (vxattr->flags & VXATTR_FLAG_RSTAT)
>                         mask |= CEPH_STAT_RSTAT;
> +               if (vxattr->flags & VXATTR_FLAG_DIRSTAT)
> +                       mask |= CEPH_CAP_FILE_SHARED;
>                 err = ceph_do_getattr(inode, mask, true);
>                 if (err)
>                         return err;

Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>


-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

