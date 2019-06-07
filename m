Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E8939541
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 21:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbfFGTEi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 15:04:38 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43109 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729456AbfFGTEi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 Jun 2019 15:04:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id z24so3513480qtj.10
        for <ceph-devel@vger.kernel.org>; Fri, 07 Jun 2019 12:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwtWlPzjHrZ/+RYwit1/I7mnqDOWya2PAuPPum6wePs=;
        b=UDrqx1F4NaD+rAwZTXS4ya+ui6kIr6Gb5b4y6dLEupxhr0WhUqg+Mi3DCkwjt4Ttv1
         8gmkEy+dLgAxRN16EmPUMiWbqVZLEVUwu+srsyDceJD9ShamKnUXNa833O66PDLy+T5o
         ao7O437C1V8OB6tqlwlUNV0vWMT5iahwPCn7AvQapniXv/rcKPSnzjJHofpeAKHAQ/5w
         A6AN+e8wgMh0KRCpdw46RJyzeTckvxYsUKyq8+VhneziLZ9n85DxhvebafiDDIvrbKbE
         9rQg5W32jyl8VzLPMyWZtQYTePFqsPUzGNiNt+bMGVQxQWvbOHxNbpt+nr7neU7t34s0
         EIpg==
X-Gm-Message-State: APjAAAWhVRWWzmGYOY+iQQ9PmzEOeHTjwFkADUif0Ymzjgu4e4LrUYo7
        6TaQjo5eDZpxnKf6Y5MftpI5+AjNzDCzqM6xO6+WlQ==
X-Google-Smtp-Source: APXvYqz7Ec9DBlJhO1DweJO8s20+FZsuP8cFOfqKPPUbZq3Wlv56dmGT8TFbatkdBxtaFcWAsi81pa+LCMXe7yTYS0k=
X-Received: by 2002:ac8:25d9:: with SMTP id f25mr46840992qtf.256.1559934276882;
 Fri, 07 Jun 2019 12:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190607184749.8333-1-jlayton@kernel.org>
In-Reply-To: <20190607184749.8333-1-jlayton@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 7 Jun 2019 12:04:10 -0700
Message-ID: <CA+2bHPYo4pmp0V3HkEVp3dy8YKu-iu-OPUqvjXhFth1y1L0QYA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix getxattr return values for vxattrs
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

On Fri, Jun 7, 2019 at 11:48 AM Jeff Layton <jlayton@kernel.org> wrote:
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
> +                       if (size && size < err)
> +                               err = -ERANGE;
> +               }
>                 return err;
>         }

Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
