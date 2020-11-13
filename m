Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56AA2B24B6
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Nov 2020 20:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgKMTks (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Nov 2020 14:40:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgKMTks (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 14:40:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605296447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s2pN2bjWqs6FTI/XOha1vzQHbU4fWq0EUGNlMQdkzZ0=;
        b=T5cvCuECvXjqG3vvx0o9/n6Uvs8YvKvb/Pt8eaGmraytb5vkSvqOqvsxwaj9RkKE141nyp
        TZF0AjPsr6hrhIjL9Dsc8LFDHldnp3GtPWh2UWmo4knIpOylh8CiURkYEN5hZQmU1dUiPJ
        auKKo6GR4T/GTo2c7F/daHmT7ueR7pQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-yDToPq_JMXiocBzZ6Wi2nA-1; Fri, 13 Nov 2020 14:40:42 -0500
X-MC-Unique: yDToPq_JMXiocBzZ6Wi2nA-1
Received: by mail-io1-f72.google.com with SMTP id i19so7176734ioa.19
        for <ceph-devel@vger.kernel.org>; Fri, 13 Nov 2020 11:40:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s2pN2bjWqs6FTI/XOha1vzQHbU4fWq0EUGNlMQdkzZ0=;
        b=cSSuXPzXjL3uO1NKcUxorx8EUcHFPpEJJTjHO2MvNNEJQD6jRPik07a7DuLWofCtCR
         SGKiimyhgFy1i+teu7SHMK4uopJxl9cUfcd7yqalAS9D/80xWZQuNwvtRgauX8aeEk1x
         D0Kt+U+sohXf52DWAdwvZ6va5LkL2z7qPV3OIPNK7AgSBQCn3iHqKcLjWk7KqMHMILS4
         iF1IXN0c1WwqWVHLivxbwWVgfl/PpZxS07RP4RiuhbGkrR9I+5f8wk7U4PPKpSTFk3wV
         ticS8j/ZPTroJ4fhev3bLxGNeQ2AVALqwQ9/Zl4r1/sWbd2BtEyOWuEOSX8wzadfqECQ
         hOrQ==
X-Gm-Message-State: AOAM5308PUxPWhyKd5i58cqeLGnWpbXHQHYALzUsMnDDDoty5NybM/EZ
        gfjpOAW/nkTVfV03H2qB4TiTBXWMMyuMv6POEEcHN6lwfQlYaBg6S7VqombxHTTxs3WHo8RH1F0
        Q8EY0FSsaUyBKGD7x4gkEQSnLpwjfL1I4g5bK6A==
X-Received: by 2002:a92:dd91:: with SMTP id g17mr1092198iln.180.1605296441482;
        Fri, 13 Nov 2020 11:40:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxz7Ph8Ym9hAi45DpVObwdsyx1ABOqKcgSOHUGl9+wTHj13VkVh3xMfdSPmKwaOQW/hJ5GRU+87XCgFZS7HnYk=
X-Received: by 2002:a92:dd91:: with SMTP id g17mr1092186iln.180.1605296441213;
 Fri, 13 Nov 2020 11:40:41 -0800 (PST)
MIME-Version: 1.0
References: <20201111012940.468289-1-xiubli@redhat.com> <20201111012940.468289-3-xiubli@redhat.com>
In-Reply-To: <20201111012940.468289-3-xiubli@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 13 Nov 2020 11:40:15 -0800
Message-ID: <CA+2bHPZuXcVw6Mwpz0wkg-SDsUc7XZqK0_m2eVQsQOEsQkZiGw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ceph: add ceph.{cluster_fsid/client_id} vxattrs suppport
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 5:29 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> These two vxattrs will only exist in local client side, with which
> we can easily know which mountpoint the file belongs to and also
> they can help locate the debugfs path quickly.
>
> URL: https://tracker.ceph.com/issues/48057
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/xattr.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 0fd05d3d4399..e89750a1f039 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
>                                 ci->i_snap_btime.tv_nsec);
>  }
>
> +static ssize_t ceph_vxattrcb_cluster_fsid(struct ceph_inode_info *ci,
> +                                         char *val, size_t size)
> +{
> +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> +
> +       return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
> +}
> +
> +static ssize_t ceph_vxattrcb_client_id(struct ceph_inode_info *ci,
> +                                      char *val, size_t size)
> +{
> +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> +
> +       return ceph_fmt_xattr(val, size, "client%lld",
> +                             ceph_client_gid(fsc->client));
> +}

Let's just have this return the id number. The caller can concatenate
that with "client" however they require. Otherwise, parsing it out is
needlessly troublesome.

>  #define CEPH_XATTR_NAME(_type, _name)  XATTR_CEPH_PREFIX #_type "." #_name
>  #define CEPH_XATTR_NAME2(_type, _name, _name2) \
>         XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> @@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
>         { .name = NULL, 0 }     /* Required table terminator */
>  };
>
> +static struct ceph_vxattr ceph_common_vxattrs[] = {
> +       {
> +               .name = "ceph.cluster_fsid",
> +               .name_size = sizeof("ceph.cluster_fsid"),
> +               .getxattr_cb = ceph_vxattrcb_cluster_fsid,
> +               .exists_cb = NULL,
> +               .flags = VXATTR_FLAG_READONLY,
> +       },

I would prefer just "ceph.fsid".

> +       {
> +               .name = "ceph.client_id",
> +               .name_size = sizeof("ceph.client_id"),
> +               .getxattr_cb = ceph_vxattrcb_client_id,
> +               .exists_cb = NULL,
> +               .flags = VXATTR_FLAG_READONLY,
> +       },
> +       { .name = NULL, 0 }     /* Required table terminator */
> +};
> +
>  static struct ceph_vxattr *ceph_inode_vxattrs(struct inode *inode)
>  {
>         if (S_ISDIR(inode->i_mode))
> @@ -429,6 +464,13 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
>                 }
>         }
>
> +       vxattr = ceph_common_vxattrs;
> +       while (vxattr->name) {
> +               if (!strcmp(vxattr->name, name))
> +                       return vxattr;
> +               vxattr++;
> +       }
> +
>         return NULL;
>  }

Please also be sure to wire up the same vxattrs in the userspace Client.


-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

