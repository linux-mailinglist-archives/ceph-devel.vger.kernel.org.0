Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEEA39454
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 20:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfFGS3B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 14:29:01 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43309 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729794AbfFGS3A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 Jun 2019 14:29:00 -0400
Received: by mail-qk1-f193.google.com with SMTP id m14so1850766qka.10
        for <ceph-devel@vger.kernel.org>; Fri, 07 Jun 2019 11:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FR27HUDKOhQq1g+RyNtJhQa6B/I3QoP2RmCS7tms1lg=;
        b=eLSIOTpm9M0IXHN+/FrodG1h1PjRY8dXIVczHsWsbgKjXbx4vPjTBjFfq6KwYv2gnX
         XVmWSCsmuNzuYN/d3+qeILQXcGBTtKedkf79HbPW05sFyk4D+3AvlVLJ4fKOPrcinM2r
         6VbcHk5/jLXntIrsJUdsD6e91K24NEkxcL8ZH3uTIZB870NewfTDgJHY5huFgx2rJB2M
         im7bzpZAdJ7n+pDhc/NWBl+453CFIo7GC++0GaEcCMhY4R/b9WpVpL9lUint8bCgSXfe
         YrdQg7A5Jy4mREwMzvKGsDs/VRUv9pTsHsWiWa5+wVAmgy2IRiaiO+4wkZ9aDc9gtb/7
         +qDQ==
X-Gm-Message-State: APjAAAWQzLalnXR64g/NRf7hD6+0dDyuPUibN1aEx/+e5YaojbuFerVK
        IARZ8YDqqAh9y5bw7DO55iowo87oiMvy/wxXAkCLtw==
X-Google-Smtp-Source: APXvYqw2Qk4qbA018oHYk2uVaWQ8JKjRB0e+upiCeGlg2onA6dC/i3YIKRCYagA3EnCd4552EwomBdOtwUxmaB86DUo=
X-Received: by 2002:ae9:ed0a:: with SMTP id c10mr44030193qkg.207.1559932139663;
 Fri, 07 Jun 2019 11:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190607181050.28085-1-jlayton@kernel.org>
In-Reply-To: <20190607181050.28085-1-jlayton@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 7 Jun 2019 11:28:33 -0700
Message-ID: <CA+2bHPYGQAgp1WKc+DR0qpwZrZtvEYqXnjjy+ZeoYT3gcyA_UA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix getxattr return values for vxattrs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io,
        Tomas Petr <tpetr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 7, 2019 at 11:11 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> We have several virtual xattrs in cephfs which return various values as
> strings. xattrs don't necessarily return strings however, so we need to
> include the terminating NULL byte in the length when we return the
> length.
>
> Furthermore, the getxattr manpage says that we should return -ERANGE if
> the buffer is too small to hold the resulting value. Let's start doing
> that here as well.
>
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=1717454
> Reported-by: Tomas Petr <tpetr@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/xattr.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 6621d27e64f5..57f1bd83c21c 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -803,8 +803,14 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>                 if (err)
>                         return err;
>                 err = -ENODATA;
> -               if (!(vxattr->exists_cb && !vxattr->exists_cb(ci)))
> -                       err = vxattr->getxattr_cb(ci, value, size);
> +               if (!(vxattr->exists_cb && !vxattr->exists_cb(ci))) {
> +                       /* Make sure result will fit in buffer */
> +                       if (size > 0) {
> +                               if (size < vxattr->getxattr_cb(ci, NULL, 0) + 1)
> +                                       return -ERANGE;
> +                       }
>
> +                       err = vxattr->getxattr_cb(ci, value, size) + 1;

I don't think it's really necessary to call getxattr_cb twice here
when size>0. Otherwise LGTM.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
