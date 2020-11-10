Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CF42ADB0A
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 16:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgKJP7b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 10:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbgKJP7b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Nov 2020 10:59:31 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068F4C0613CF
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 07:59:30 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id m13so1663847ioq.9
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 07:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LOWCr9AtWkJ8at2cQwuS1p1eis8OEmhz9ZWb3tsmujw=;
        b=RBAoq5bSZqsQy5/y7WwZUxR7hXE/gP0dP8srir5SV4Rai72pJsGdzAxfO0MFj1U2Pd
         VcCj+5fSqQYmFltZmrkSi7FX0JQ2aT1Ej8nriAyyGRFIDRcySDWkYJ6XC05cuafCfkG2
         wfWo56q22kmXfElD51gTgu/cF+QpXvjXmiYtOLW3EjNwBGSDy6xFR6OuFguEn16FAerz
         ezA3+rfD4NSWAMebw+nfyeMeAvRpp43u9zTfdbKrB/1ywk9Bsxbom2TpoV8xEv3ZqUPj
         +1afUaWBWE0Dbyk0F1FKRf1e+R8kvAWM83LrjE9Z4u0QsySm6v/6msEBEB+ShVWN552L
         iy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LOWCr9AtWkJ8at2cQwuS1p1eis8OEmhz9ZWb3tsmujw=;
        b=uj4beGoYXgVcJTU8Wg/Mau2FUz7LRRhp59y2nhB6qQ7qljmRSLJPJPNRz8J+uVKM0H
         p9+xBvizY3BgwhQ0HsMKNpG3VUykG1hjaaRPrpoxKJcrYUHkHOkSAL0gpFbcyCF2+iYl
         SWZWBHFhaXNk7ZDBukLyEF5YqdtsmJXitJSBYPVIHmQRtAfvvXhJqO+fh+SSqQ2Z3o04
         Z8PeU16YR9jkASFdF64e7d3Nsuc9Lt31QtRrEYvyzo7FM6q6xE6DU+apFQe4KFYJsNhi
         HH7aYp/AjtHLtm82U8wIptd3W1IX11DN7oJAEnRbrwlyig7CbFpkmgFK+dnslJPcOE4X
         Iq5w==
X-Gm-Message-State: AOAM533yDOtNZbN88UQkePET7WXwJBrb0eyVsnA53HHoX9kh62qhy+/O
        7TlJnnp2k82NqfoNnLs6sbKeKiu3Nr4Ql++RfnE=
X-Google-Smtp-Source: ABdhPJxSKAL19tUkA4o/VoLogWl9YW0h3UTMIsRV2Dr+g5iX8qdJ1zsDfBub/s7fJNqfddFqwAAH+x+clhBA4PrqqnI=
X-Received: by 2002:a05:6602:235b:: with SMTP id r27mr15096586iot.123.1605023970359;
 Tue, 10 Nov 2020 07:59:30 -0800 (PST)
MIME-Version: 1.0
References: <20201110141703.414211-1-xiubli@redhat.com> <20201110141703.414211-3-xiubli@redhat.com>
In-Reply-To: <20201110141703.414211-3-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Nov 2020 16:59:30 +0100
Message-ID: <CAOi1vP-JQbVYdAFfebKWLXPpVSgXFq=5s2_4knWbV9_J9ubxKA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ceph: add ceph.{clusterid/clientid} vxattrs suppport
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 3:17 PM <xiubli@redhat.com> wrote:
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
> index 0fd05d3d4399..4a41db46e191 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
>                                 ci->i_snap_btime.tv_nsec);
>  }
>
> +static ssize_t ceph_vxattrcb_clusterid(struct ceph_inode_info *ci,
> +                                      char *val, size_t size)
> +{
> +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> +
> +       return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
> +}
> +
> +static ssize_t ceph_vxattrcb_clientid(struct ceph_inode_info *ci,
> +                                     char *val, size_t size)
> +{
> +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> +
> +       return ceph_fmt_xattr(val, size, "client%lld",
> +                             ceph_client_gid(fsc->client));
> +}
> +
>  #define CEPH_XATTR_NAME(_type, _name)  XATTR_CEPH_PREFIX #_type "." #_name
>  #define CEPH_XATTR_NAME2(_type, _name, _name2) \
>         XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> @@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
>         { .name = NULL, 0 }     /* Required table terminator */
>  };
>
> +static struct ceph_vxattr ceph_vxattrs[] = {
> +       {
> +               .name = "ceph.clusterid",

I think this should be "ceph.cluster_fsid"

> +               .name_size = sizeof("ceph.clusterid"),
> +               .getxattr_cb = ceph_vxattrcb_clusterid,
> +               .exists_cb = NULL,
> +               .flags = VXATTR_FLAG_READONLY,
> +       },
> +       {
> +               .name = "ceph.clientid",

and this should be "ceph.client_id".  It's easier to read, consistent
with "ceph fsid" command and with existing rbd attributes:

  static DEVICE_ATTR(client_id, 0444, rbd_client_id_show, NULL);
  static DEVICE_ATTR(cluster_fsid, 0444, rbd_cluster_fsid_show, NULL);

Thanks,

                Ilya
